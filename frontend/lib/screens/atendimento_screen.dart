import 'package:flutter/material.dart';
import '../models/atendimento.dart';
import '../models/usuario.dart';
import '../services/atendimento_service.dart';
import '../widgets/neuro_widgets.dart';
import 'ficha_atendimento_screen.dart';
import 'novo_atendimento_screen.dart';

class AtendimentoScreen extends StatefulWidget {
  final Usuario usuario;
  const AtendimentoScreen({super.key, required this.usuario});

  @override
  State<AtendimentoScreen> createState() => _AtendimentoScreenState();
}

class _AtendimentoScreenState extends State<AtendimentoScreen> {
  List<Atendimento> _atendimentos = [];
  final _buscaController = TextEditingController();
  final _scrollController = ScrollController();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _buscar({String? busca}) async {
    setState(() => _carregando = true);
    try {
      List<Atendimento> lista;
      if (busca != null && busca.trim().isNotEmpty) {
        // Busca todos e filtra localmente por nome do aluno
        // (o backend já devolve nomeAluno no DTO)
        final todos = await AtendimentoService.listarTodos();
        final t = busca.trim().toLowerCase();
        lista = todos
            .where((a) => a.nomeAluno.toLowerCase().contains(t))
            .toList();
      } else {
        lista = await AtendimentoService.listarTodos();
      }
      setState(() => _atendimentos = lista);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar atendimentos: $e')),
        );
      }
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _excluir(Atendimento atendimento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir atendimento'),
        content: Text(
          'Deseja excluir o atendimento de ${atendimento.nomeAluno} em ${_dataFormatada(atendimento.dataAtendimento)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final erro = await AtendimentoService.excluir(atendimento.id);
      if (erro == null) {
        _buscar(busca: _buscaController.text);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(erro)),
          );
        }
      }
    }
  }

  String _dataFormatada(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuroColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                children: [
                  const NeuroHeaderTitle(title: 'ATENDIMENTOS'),
                  const SizedBox(height: 18),
                  Expanded(
                    child: NeuroPanel(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                      child: Column(
                        children: [
                          NeuroTopBar(
                            title: 'NEUROGEST',
                            left: NeuroPillButton(
                              text: 'VOLTAR',
                              width: 95, height: 34, fontSize: 11,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── Busca + botão ──
                          Row(
                            children: [
                              Expanded(
                                child: NeuroTextField(
                                  hint: 'BUSCAR POR NOME DO ALUNO',
                                  controller: _buscaController,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () =>
                                        _buscar(busca: _buscaController.text),
                                  ),
                                  onChanged: (v) => _buscar(busca: v),
                                ),
                              ),
                              const SizedBox(width: 12),
                              NeuroPillButton(
                                text: 'NOVO ATENDIMENTO',
                                width: 160, height: 46, fontSize: 11,
                                onPressed: () async {
                                  final atualizado = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NovoAtendimentoScreen(
                                        usuario: widget.usuario,
                                      ),
                                    ),
                                  );
                                  if (atualizado == true) {
                                    _buscar(busca: _buscaController.text);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ── Lista ──
                          Expanded(
                            child: _carregando
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: NeuroColors.primary,
                                    ),
                                  )
                                : _atendimentos.isEmpty
                                    ? const Center(
                                        child: Text(
                                            'Nenhum atendimento encontrado.'),
                                      )
                                    : Scrollbar(
                                        controller: _scrollController,
                                        thumbVisibility: true,
                                        child: ListView.separated(
                                          controller: _scrollController,
                                          itemCount: _atendimentos.length,
                                          separatorBuilder: (_, _) =>
                                              const SizedBox(height: 10),
                                          itemBuilder: (_, i) {
                                            final a = _atendimentos[i];
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: NeuroColors.panel,
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 3,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          a.nomeAluno
                                                              .toUpperCase(),
                                                          style: const TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(height: 3),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                '${a.nomeUsuario} · ${a.cboUsuario.isEmpty ? "Sem CBO" : a.cboUsuario}',
                                                                style: const TextStyle(
                                                                  fontSize: 11,
                                                                  color: NeuroColors
                                                                      .mutedText,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            Text(
                                                              _dataFormatada(
                                                                  a.dataAtendimento),
                                                              style: const TextStyle(
                                                                  fontSize: 11),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  // Visualizar
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              FichaAtendimentoScreen(
                                                            atendimento: a,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            999),
                                                    child: Container(
                                                      width: 38,
                                                      height: 38,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFB0B0B0),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.remove_red_eye,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // Excluir
                                                  InkWell(
                                                    onTap: () => _excluir(a),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            999),
                                                    child: Container(
                                                      width: 38,
                                                      height: 38,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .red.shade300,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: NeuroLogo(size: 56, animated: true),
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
      ),
    );
  }
}