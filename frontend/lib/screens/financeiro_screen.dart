import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neurogest_front/models/aluno.dart';
import 'package:neurogest_front/models/atendimento.dart';
import 'package:neurogest_front/models/lancamento.dart';
import 'package:neurogest_front/models/usuario.dart';
import 'package:neurogest_front/services/aluno_service.dart';
import 'package:neurogest_front/services/atendimento_service.dart';
import 'package:neurogest_front/services/lancamento_service.dart';
import 'package:neurogest_front/services/usuario_service.dart';
import 'package:neurogest_front/widgets/neuro_widgets.dart';

class FinanceiroScreen extends StatefulWidget {
  const FinanceiroScreen({super.key});

  @override
  State<FinanceiroScreen> createState() => _FinanceiroScreenState();
}

class _FinanceiroScreenState extends State<FinanceiroScreen> {
  late int mesSelecionado;
  late int anoSelecionado;

  List<Lancamento> _lancamentos = [];
  ResumoFinanceiro? _resumo;
  List<_ValorMensal> _valoresPorMes = List.generate(
    12,
    (_) => _ValorMensal(recebido: 0, aberto: 0),
  );

  bool _carregando = true;
  bool _carregandoGrafico = false;

  @override
  void initState() {
    super.initState();
    final hoje = DateTime.now();
    mesSelecionado = hoje.month;
    anoSelecionado = hoje.year;
    _carregarDados();
    _carregarGraficoAnual();
  }

  // Carrega lista + resumo do mes selecionado
  Future<void> _carregarDados() async {
    setState(() => _carregando = true);

    final resultados = await Future.wait([
      LancamentoService.listar(mes: mesSelecionado, ano: anoSelecionado),
      LancamentoService.resumo(mes: mesSelecionado, ano: anoSelecionado),
    ]);

    if (!mounted) return;
    setState(() {
      _lancamentos = (resultados[0] as List).cast<Lancamento>();
      _resumo = resultados[1] as ResumoFinanceiro?;
      _carregando = false;
    });
  }

  // Carrega dados anuais para o grafico de barras
  Future<void> _carregarGraficoAnual() async {
    setState(() => _carregandoGrafico = true);

    final futures = List.generate(
      12,
      (i) => LancamentoService.resumo(mes: i + 1, ano: anoSelecionado),
    );

    final resultados = await Future.wait(futures);

    if (!mounted) return;
    setState(() {
      _valoresPorMes = resultados.map((r) {
        final resumo = r;
        return _ValorMensal(
          recebido: resumo?.totalRecebido ?? 0,
          aberto: resumo?.totalEmAberto ?? 0,
        );
      }).toList();
      _carregandoGrafico = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final resumo = _resumo;
    final totalRecebido = resumo?.totalRecebido ?? 0;
    final totalAberto = resumo?.totalEmAberto ?? 0;
    final totalPrevisto = resumo?.totalPrevisto ?? 0;
    final qtdPagos = resumo?.qtdPagos ?? 0;
    final qtdEmAberto = resumo?.qtdEmAberto ?? 0;

    return Scaffold(
      backgroundColor: NeuroColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1060),
          child: NeuroPanel(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
            child: Column(
              children: [
                NeuroTopBar(
                  title: 'FINANCEIRO',
                  right: NeuroPillButton(
                    text: 'Voltar',
                    width: 90,
                    height: 34,
                    fontSize: 11,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 16),

                // Cards de resumo
                Row(
                  children: [
                    Expanded(
                      child: _ResumoCard(
                        titulo: 'Recebido no mês',
                        valor: _formatarMoeda(totalRecebido),
                        subtitulo: '$qtdPagos pagamentos',
                        cor: const Color(0xff4fd1c5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ResumoCard(
                        titulo: 'Valor em aberto',
                        valor: _formatarMoeda(totalAberto),
                        subtitulo: '$qtdEmAberto débitos pendentes',
                        cor: const Color(0xfff2c14e),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ResumoCard(
                        titulo: 'Valor previsto',
                        valor: _formatarMoeda(totalPrevisto),
                        subtitulo: 'Recebido + pendente',
                        cor: const Color(0xff5d69b3),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Grafico + resumo do mes
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _DashboardCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Relação mensal',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: _carregandoGrafico
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : BarChart(
                                        BarChartData(
                                          borderData: FlBorderData(show: false),
                                          gridData: FlGridData(
                                            show: true,
                                            drawVerticalLine: false,
                                          ),
                                          titlesData: FlTitlesData(
                                            topTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                            ),
                                            rightTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                            ),
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                            ),
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                getTitlesWidget: (value, meta) {
                                                  const meses = [
                                                    'Jan',
                                                    'Fev',
                                                    'Mar',
                                                    'Abr',
                                                    'Mai',
                                                    'Jun',
                                                    'Jul',
                                                    'Ago',
                                                    'Set',
                                                    'Out',
                                                    'Nov',
                                                    'Dez',
                                                  ];
                                                  final index = value.toInt();
                                                  if (index < 0 || index > 11) {
                                                    return const SizedBox();
                                                  }
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 8,
                                                        ),
                                                    child: Text(
                                                      meses[index],
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          barGroups: List.generate(12, (index) {
                                            final recebido =
                                                _valoresPorMes[index].recebido
                                                    .toDouble();
                                            final aberto = _valoresPorMes[index]
                                                .aberto
                                                .toDouble();
                                            return BarChartGroupData(
                                              x: index,
                                              barRods: [
                                                BarChartRodData(
                                                  toY: recebido,
                                                  width: 12,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: const Color(
                                                    0xff4fd1c5,
                                                  ),
                                                ),
                                                BarChartRodData(
                                                  toY: aberto,
                                                  width: 12,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: const Color(
                                                    0xfff2c14e,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _DashboardCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Resumo do mês',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              DropdownButtonFormField<int>(
                                initialValue: mesSelecionado,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xfff6f7fb),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('Janeiro'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('Fevereiro'),
                                  ),
                                  DropdownMenuItem(
                                    value: 3,
                                    child: Text('Março'),
                                  ),
                                  DropdownMenuItem(
                                    value: 4,
                                    child: Text('Abril'),
                                  ),
                                  DropdownMenuItem(
                                    value: 5,
                                    child: Text('Maio'),
                                  ),
                                  DropdownMenuItem(
                                    value: 6,
                                    child: Text('Junho'),
                                  ),
                                  DropdownMenuItem(
                                    value: 7,
                                    child: Text('Julho'),
                                  ),
                                  DropdownMenuItem(
                                    value: 8,
                                    child: Text('Agosto'),
                                  ),
                                  DropdownMenuItem(
                                    value: 9,
                                    child: Text('Setembro'),
                                  ),
                                  DropdownMenuItem(
                                    value: 10,
                                    child: Text('Outubro'),
                                  ),
                                  DropdownMenuItem(
                                    value: 11,
                                    child: Text('Novembro'),
                                  ),
                                  DropdownMenuItem(
                                    value: 12,
                                    child: Text('Dezembro'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() => mesSelecionado = value);
                                  _carregarDados();
                                },
                              ),

                              const SizedBox(height: 16),

                              _LegendaLinha(
                                cor: const Color(0xff4fd1c5),
                                titulo: 'Recebido',
                                valor: _formatarMoeda(totalRecebido),
                              ),

                              const SizedBox(height: 10),

                              _LegendaLinha(
                                cor: const Color(0xfff2c14e),
                                titulo: 'Em aberto',
                                valor: _formatarMoeda(totalAberto),
                              ),

                              const SizedBox(height: 16),

                              Expanded(
                                child: Center(
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        CircularProgressIndicator(
                                          value: totalPrevisto == 0
                                              ? 0
                                              : totalRecebido / totalPrevisto,
                                          strokeWidth: 10,
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                                Color(0xff4fd1c5),
                                              ),
                                        ),
                                        Center(
                                          child: Text(
                                            totalPrevisto == 0
                                                ? '0%'
                                                : '${((totalRecebido / totalPrevisto) * 100).toStringAsFixed(0)}%',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Lista de lancamentos
                Expanded(
                  flex: 2,
                  child: _DashboardCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Lançamentos do mês',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // ElevatedButton.icon(
                            //   onPressed: _abrirModalNovoLancamento,
                            //   icon: const Icon(Icons.add, size: 18),
                            //   label: const Text('Novo lançamento'),
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: const Color(0xff4f73ff),
                            //     foregroundColor: Colors.white,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Expanded(
                          child: _carregando
                              ? const Center(child: CircularProgressIndicator())
                              : _lancamentos.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Nenhum lançamento encontrado neste mês.',
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: _lancamentos.length,
                                  separatorBuilder: (_, _) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final l = _lancamentos[index];
                                    final origem = l.idAtendimento != null
                                        ? 'Atendimento #${l.idAtendimento}'
                                        : l.idAgendamento != null
                                        ? 'Agendamento #${l.idAgendamento}'
                                        : '';
                                    final parcela = l.idLancamentoPai != null
                                        ? 'Parcela #${l.idLancamentoPai}'
                                        : '';
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: l.quitado
                                            ? const Color(0xff4fd1c5)
                                            : const Color(0xfff2c14e),
                                        child: Icon(
                                          l.quitado
                                              ? Icons.check
                                              : Icons.warning_amber_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        l.nomeAluno,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '$origem$parcela · ${_formatarData(l.dataLancamento)}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                _formatarMoeda(l.valorOriginal),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              if (!l.quitado)
                                                Text(
                                                  'Restante: ${_formatarMoeda(l.valorRestante)}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(width: 8),
                                          if (!l.quitado)
                                            TextButton(
                                              onPressed: () =>
                                                  _abrirModalPagamento(l),
                                              child: const Text('Dar baixa'),
                                            ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.redAccent,
                                              size: 20,
                                            ),
                                            tooltip: 'Excluir',
                                            onPressed: () =>
                                                _confirmarExclusao(l),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modal: novo lancamento com dropdowns reais
  void _abrirModalNovoLancamento() async {
    // Carrega alunos e usuarios antes de abrir o modal
    final resultados = await Future.wait([
      AlunoService.listar(),
      UsuarioService.listar(),
    ]);

    if (!mounted) return;

    final alunos = (resultados[0] as List).cast<Aluno>();
    final usuarios = (resultados[1] as List).cast<Usuario>();

    if (alunos.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nenhum aluno encontrado.')));
      return;
    }

    Aluno? alunoSelecionado;
    Usuario? usuarioSelecionado;
    int? atendimentoSelecionadoId;
    List<Atendimento> atendimentosDoAluno = [];
    final valorCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('Novo lançamento'),
          content: SizedBox(
            width: 430,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Aluno
                DropdownButtonFormField<Aluno>(
                  initialValue: alunoSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Aluno',
                    border: OutlineInputBorder(),
                  ),
                  items: alunos
                      .map(
                        (a) => DropdownMenuItem(value: a, child: Text(a.nome)),
                      )
                      .toList(),
                  onChanged: (value) async {
                    setModalState(() {
                      alunoSelecionado = value;
                      atendimentoSelecionadoId = null;
                      atendimentosDoAluno = [];
                    });
                    if (value != null) {
                      final lista = await AtendimentoService.listarPorAluno(
                        value.id,
                      );
                      setModalState(() => atendimentosDoAluno = lista);
                    }
                  },
                ),

                const SizedBox(height: 12),

                // Atendimento (carregado ao selecionar aluno)
                DropdownButtonFormField<int>(
                  initialValue: atendimentoSelecionadoId,
                  decoration: const InputDecoration(
                    labelText: 'Atendimento',
                    border: OutlineInputBorder(),
                  ),
                  items: atendimentosDoAluno
                      .map(
                        (a) => DropdownMenuItem<int>(
                          value: a.id,
                          child: Text(
                            'Atendimento #${a.id} · ${_formatarData(a.dataAtendimento)}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: atendimentosDoAluno.isEmpty
                      ? null
                      : (value) => setModalState(
                          () => atendimentoSelecionadoId = value,
                        ),
                  hint: Text(
                    alunoSelecionado == null
                        ? 'Selecione um aluno primeiro'
                        : atendimentosDoAluno.isEmpty
                        ? 'Nenhum atendimento encontrado'
                        : 'Selecione o atendimento',
                  ),
                ),

                const SizedBox(height: 12),

                // Usuario responsavel
                DropdownButtonFormField<Usuario>(
                  initialValue: usuarioSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Usuário responsável',
                    border: OutlineInputBorder(),
                  ),
                  items: usuarios
                      .map(
                        (u) => DropdownMenuItem(value: u, child: Text(u.nome)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setModalState(() => usuarioSelecionado = value),
                ),

                const SizedBox(height: 12),

                // Valor
                TextField(
                  controller: valorCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Valor original (R\$)',
                    hintText: 'Ex: 150.00',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final valor = double.tryParse(
                  valorCtrl.text.replaceAll(',', '.'),
                );

                if (alunoSelecionado == null ||
                    usuarioSelecionado == null ||
                    atendimentoSelecionadoId == null ||
                    valor == null ||
                    valor <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preencha todos os campos corretamente.'),
                    ),
                  );
                  return;
                }

                Navigator.pop(ctx);

                final erro = await LancamentoService.criar(
                  idAluno: alunoSelecionado!.id,
                  idAtendimento: atendimentoSelecionadoId!,
                  idUsuario: usuarioSelecionado!.id,
                  // valorOriginal: valor,
                );

                if (!mounted) return;
                if (erro != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(erro)));
                } else {
                  await _carregarDados();
                  await _carregarGraficoAnual();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  // Modal: registrar pagamento
  void _abrirModalPagamento(Lancamento lancamento) {
    final valorCtrl = TextEditingController(
      text: lancamento.valorRestante.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Dar baixa - ${lancamento.nomeAluno}'),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Saldo restante: ${_formatarMoeda(lancamento.valorRestante)}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valorCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor a pagar (R\$)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final valor = double.tryParse(
                valorCtrl.text.replaceAll(',', '.'),
              );
              if (valor == null || valor <= 0) return;

              Navigator.pop(ctx);

              final resultado = await LancamentoService.pagar(
                id: lancamento.id,
                valorPago: valor,
              );

              if (!mounted) return;

              if (resultado.erro != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(resultado.erro!)));
              } else {
                if (resultado.novoLancamento != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Pagamento parcial registrado. Novo lancamento criado para o saldo restante.',
                      ),
                    ),
                  );
                }
                await _carregarDados();
                await _carregarGraficoAnual();
              }
            },
            child: const Text('Confirmar pagamento'),
          ),
        ],
      ),
    );
  }

  // Confirmacao de exclusao
  void _confirmarExclusao(Lancamento lancamento) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Atenção'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: Text(
            lancamento.idAgendamento != null
                ? 'Deseja excluir o pagamento de ${lancamento.nomeAluno} '
                      '(${_formatarMoeda(lancamento.valorOriginal)})? '
                      'Ele voltará para os valores "em aberto" e só será removido definitivamente '
                      'ao excluir o agendamento correspondente.'
                : 'Deseja excluir o lançamento de ${lancamento.nomeAluno} '
                      '(${_formatarMoeda(lancamento.valorOriginal)})? '
                      'Esta ação não pode ser desfeita.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final erro = await LancamentoService.excluir(lancamento.id);
              if (!mounted) return;
              if (erro != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(erro)));
              } else {
                await _carregarDados();
                await _carregarGraficoAnual();
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  // Helpers
  String _formatarMoeda(num valor) =>
      'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';

  String _formatarData(DateTime data) =>
      '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}/'
      '${data.year}';
}

// Modelos auxiliares
class _ValorMensal {
  final num recebido;
  final num aberto;

  _ValorMensal({required this.recebido, required this.aberto});
}

// Widgets internos
class _DashboardCard extends StatelessWidget {
  final Widget child;

  const _DashboardCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ResumoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final String subtitulo;
  final Color cor;

  const _ResumoCard({
    required this.titulo,
    required this.valor,
    required this.subtitulo,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Row(
        children: [
          Container(
            width: 12,
            height: 70,
            decoration: BoxDecoration(
              color: cor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitulo,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendaLinha extends StatelessWidget {
  final Color cor;
  final String titulo;
  final String valor;

  const _LegendaLinha({
    required this.cor,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(titulo)),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
