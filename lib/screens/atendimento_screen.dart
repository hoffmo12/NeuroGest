import 'package:flutter/material.dart';
import 'package:neurogest_front/models/atendimento.dart';
import 'package:neurogest_front/models/usuario.dart';
import 'package:neurogest_front/screens/novo_atendimento_screen.dart';
import '../models/aluno.dart';
import '../services/aluno_service.dart';
import '../widgets/neuro_widgets.dart';

class AtendimentoScreen extends StatefulWidget {
  final Usuario usuario;
  const AtendimentoScreen({super.key, required this.usuario});

  @override
  State<AtendimentoScreen> createState() => _AtendimentoScreenState();
}

class _AtendimentoScreenState extends State<AtendimentoScreen> {
  List<Atendimento> _atendimentos = [];
  final _buscaController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _buscar({String? busca}) async {
    setState(() => _carregando = true);
    final service = AlunoService();
    final lista = await service.listarAtendimentos(alunoPesquisado: busca);

    // final lista = await AlunoService.listarAtendimentos(alunoPesquisado: busca);
    setState(() {
      _atendimentos.clear();
      _atendimentos = lista;
      _carregando = false;
    });
  }

  Future<void> _abrirAtendimento({Aluno? aluno}) async {
    // final atualizado = await Navigator.push<bool>(
    //   // context,
    //   // MaterialPageRoute(builder: (_) => AlunoFormScreen(aluno: aluno)),
    // );
    // if (atualizado == true) _carregar();
  }

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
                  Expanded(
                    child: NeuroPanel(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                      child: Column(
                        children: [
                          NeuroTopBar(
                            title: 'Tela de Atendimentos',
                            right: NeuroPillButton(
                              text: 'Voltar ao início',
                              // width: 80,
                              height: 34,
                              fontSize: 11,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── Busca + botão ──
                          Row(
                            children: [
                              Expanded(
                                child: NeuroTextField(
                                  hint: 'BUSCAR ALUNO',
                                  controller: _buscaController,
                                  onEditingComplete: () =>
                                      _buscar(busca: _buscaController.text),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () =>
                                        _buscar(busca: _buscaController.text),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              NeuroPillButton(
                                text: 'NOVO ATENDIMENTO',
                                // width: 120,
                                height: 46,
                                fontSize: 11,
                                onPressed: () async {
                                  final atualizado = await Navigator.push(
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
                                    child: CircularProgressIndicator(),
                                  )
                                : _atendimentos.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Nenhum atendimento encontrado.',
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: _atendimentos.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (_, i) {
                                      final atendimento = _atendimentos[i];
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: NeuroColors.panel,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 3,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    atendimento.nomeAluno
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Profissional: ${atendimento.profissional} · ${atendimento.profissionalCBO}',
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Text(
                                                        dataFormatada(
                                                          atendimento.criadoEm,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            // Editar
                                            InkWell(
                                              onTap: () => _abrirAtendimento(
                                                aluno: null,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              child: Container(
                                                width: 38,
                                                height: 38,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFB0B0B0,
                                                  ),
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
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: NeuroLogo(size: 56),
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

  String dataFormatada(DateTime criadoEm) {
    return '${criadoEm.day.toString().padLeft(2, '0')}/'
        '${criadoEm.month.toString().padLeft(2, '0')}/'
        '${criadoEm.year}';
  }
}
