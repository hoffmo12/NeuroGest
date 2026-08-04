import 'package:flutter/material.dart';
import '../models/aluno.dart';
import '../models/agendamento.dart';
import '../models/usuario.dart';
import '../services/agendamento_service.dart';
import '../widgets/aluno_selecionado.dart';
import '../widgets/buscar_aluno_atendimento.dart';
import '../widgets/neuro_widgets.dart';

class CalendarioScreen extends StatefulWidget {
  final Usuario usuario;
  const CalendarioScreen({super.key, required this.usuario});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  DateTime _mesAtual = DateTime(DateTime.now().year, DateTime.now().month, 1);

  List<Profissional> _profissionais = [];
  Profissional? _profissionalSelecionado;

  List<Agendamento> _agendamentos = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarProfissionais();
  }

  Future<void> _carregarProfissionais() async {
    final lista = await AgendamentoService.listarProfissionais();
    setState(() {
      _profissionais = lista;
      // Se o usuário logado é um dos profissionais, já vem selecionado
      _profissionalSelecionado = lista
          .where((p) => p.id == widget.usuario.id)
          .cast<Profissional?>()
          .firstWhere((p) => true, orElse: () => null);
    });
    if (_profissionalSelecionado != null) {
      _carregarAgendamentos();
    }
  }

  Future<void> _carregarAgendamentos() async {
    if (_profissionalSelecionado == null) return;
    setState(() => _carregando = true);
    try {
      final lista = await AgendamentoService.listarDoMes(
        idUsuario: _profissionalSelecionado!.id,
        ano: _mesAtual.year,
        mes: _mesAtual.month,
      );
      setState(() => _agendamentos = lista);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar agendamentos: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  List<Agendamento> _agendamentosDoDia(DateTime dia) {
    return _agendamentos.where((a) =>
        a.horario.year == dia.year &&
        a.horario.month == dia.month &&
        a.horario.day == dia.day).toList()
      ..sort((a, b) => a.horario.compareTo(b.horario));
  }

  String _nomeMes(int mes) {
    const meses = [
      '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ];
    return meses[mes];
  }

  Color _corDoChip(Agendamento a) {
    if (a.faltou) return Colors.redAccent;
    if (a.estaPago) return Colors.green;
    return Colors.amber.shade800;
  }

  // ─── Novo agendamento ───────────────────────────────────
  void _abrirNovoAgendamento(DateTime dia) {
    final valorController = TextEditingController();
    TimeOfDay horario = const TimeOfDay(hour: 9, minute: 0);

    showDialog(
      context: context,
      builder: (_) {
        bool pago = false;
        Aluno? alunoSelecionado;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Novo agendamento — ${dia.day}/${dia.month}/${dia.year}',
              ),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuscarAlunoAtendimento(
                        onAlunoSelecionado: (aluno) {
                          setDialogState(() => alunoSelecionado = aluno);
                        },
                      ),
                      if (alunoSelecionado != null)
                        Container(
                          color: Colors.blueAccent.withOpacity(.1),
                          height: 180,
                          child: AlunoSelecionado(aluno: alunoSelecionado!),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Horário:'),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () async {
                              final escolhido = await showTimePicker(
                                context: context,
                                initialTime: horario,
                              );
                              if (escolhido != null) {
                                setDialogState(() => horario = escolhido);
                              }
                            },
                            child: Text(horario.format(context)),
                          ),
                        ],
                      ),
                      TextField(
                        controller: valorController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Valor da consulta',
                          prefixText: 'R\$ ',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Já pagou?'),
                          const SizedBox(width: 16),
                          Switch(
                            value: pago,
                            activeColor: Colors.green,
                            onChanged: (v) => setDialogState(() => pago = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: alunoSelecionado == null
                      ? null
                      : () async {
                          final horarioCompleto = DateTime(
                            dia.year, dia.month, dia.day,
                            horario.hour, horario.minute,
                          );
                          final erro = await AgendamentoService.criar(
                            idAluno: alunoSelecionado!.id,
                            idUsuario: _profissionalSelecionado!.id,
                            horario: horarioCompleto,
                            valorConsulta:
                                double.tryParse(valorController.text.replaceAll(',', '.')) ?? 0,
                            estaPago: pago,
                          );
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          if (erro != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(erro)),
                            );
                          } else {
                            _carregarAgendamentos();
                          }
                        },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ─── Detalhes / atualização de um agendamento ──────────
  void _abrirDetalhes(Agendamento evento) {
    showDialog(
      context: context,
      builder: (_) {
        bool faltou = evento.faltou;
        bool pago = evento.estaPago;

        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Detalhes do agendamento'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aluno: ${evento.nomeAluno}'),
                const SizedBox(height: 4),
                Text(
                  'Data: ${evento.horario.day}/${evento.horario.month}/${evento.horario.year} '
                  'às ${evento.horario.hour.toString().padLeft(2, '0')}:'
                  '${evento.horario.minute.toString().padLeft(2, '0')}',
                ),
                const SizedBox(height: 4),
                Text('Profissional: ${evento.nomeUsuario}'),
                const SizedBox(height: 4),
                Text('Valor: R\$ ${evento.valorConsulta.toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Pago?'),
                    const SizedBox(width: 8),
                    Switch(
                      value: pago,
                      activeColor: Colors.green,
                      onChanged: (v) => setDialogState(() => pago = v),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Faltou?'),
                    const SizedBox(width: 8),
                    Switch(
                      value: faltou,
                      activeColor: Colors.redAccent,
                      onChanged: (v) => setDialogState(() => faltou = v),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final ok = await AgendamentoService.excluir(evento.id);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  if (ok) _carregarAgendamentos();
                },
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
              FilledButton(
                onPressed: () async {
                  final erro = await AgendamentoService.editar(
                    id: evento.id,
                    valorConsulta: evento.valorConsulta,
                    estaPago: pago,
                    faltou: faltou,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  if (erro != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(erro)),
                    );
                  } else {
                    _carregarAgendamentos();
                  }
                },
                child: const Text('Atualizar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primeiroDia = DateTime(_mesAtual.year, _mesAtual.month, 1);
    final inicioCalendario =
        primeiroDia.subtract(Duration(days: primeiroDia.weekday % 7));

    return Scaffold(
      backgroundColor: NeuroColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: NeuroPanel(
                child: Column(
                  children: [
                    NeuroTopBar(
                      title: 'Calendário',
                      right: NeuroPillButton(
                        text: 'Voltar',
                        width: 80,
                        height: 34,
                        fontSize: 11,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Profissional>(
                      initialValue: _profissionalSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Profissional',
                        border: OutlineInputBorder(),
                      ),
                      items: _profissionais
                          .map((p) => DropdownMenuItem(
                              value: p, child: Text('${p.nome} — ${p.cbo}')))
                          .toList(),
                      onChanged: (valor) {
                        setState(() => _profissionalSelecionado = valor);
                        _carregarAgendamentos();
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_profissionalSelecionado == null)
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Selecione um profissional para visualizar o calendário',
                          ),
                        ),
                      )
                    else ...[
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _mesAtual = DateTime(
                                    _mesAtual.year, _mesAtual.month - 1, 1);
                              });
                              _carregarAgendamentos();
                            },
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '${_nomeMes(_mesAtual.month)} ${_mesAtual.year}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: NeuroColors.text,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _mesAtual = DateTime(
                                    _mesAtual.year, _mesAtual.month + 1, 1);
                              });
                              _carregarAgendamentos();
                            },
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 36,
                        decoration:
                            BoxDecoration(color: Colors.grey.shade200),
                        child: const Row(
                          children: [
                            Expanded(child: Center(child: Text('Dom'))),
                            Expanded(child: Center(child: Text('Seg'))),
                            Expanded(child: Center(child: Text('Ter'))),
                            Expanded(child: Center(child: Text('Qua'))),
                            Expanded(child: Center(child: Text('Qui'))),
                            Expanded(child: Center(child: Text('Sex'))),
                            Expanded(child: Center(child: Text('Sáb'))),
                          ],
                        ),
                      ),
                      if (_carregando)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(
                              color: NeuroColors.primary),
                        )
                      else
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context)
                                .copyWith(scrollbars: false),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 42,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 1.1,
                              ),
                              itemBuilder: (_, index) {
                                final dia =
                                    inicioCalendario.add(Duration(days: index));
                                final agendaDoDia = _agendamentosDoDia(dia);
                                final pertenceAoMes =
                                    dia.month == _mesAtual.month;

                                return InkWell(
                                  onTap: () => _abrirNovoAgendamento(dia),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            dia.day.toString(),
                                            style: TextStyle(
                                              color: pertenceAoMes
                                                  ? Colors.black
                                                  : Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Expanded(
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: agendaDoDia.length,
                                            itemBuilder: (_, i) {
                                              final evento = agendaDoDia[i];
                                              return GestureDetector(
                                                onTap: () =>
                                                    _abrirDetalhes(evento),
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .only(bottom: 2),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 2,
                                                      vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color: _corDoChip(evento),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                  child: Text(
                                                    evento.nomeAluno,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
