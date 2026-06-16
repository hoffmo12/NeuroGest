import 'package:flutter/material.dart';
import 'package:neurogest_front/mock/mock_aluno_repository.dart';
import 'package:neurogest_front/mock/mock_atendimento.dart';
import 'package:neurogest_front/mock/mock_funcionario_repository.dart';
import 'package:neurogest_front/models/atendimento.dart';
import 'package:neurogest_front/models/funcionario.dart';
import 'package:neurogest_front/models/usuario.dart';
import 'package:neurogest_front/screens/novo_atendimento_screen.dart';
import '../models/aluno.dart';
import '../services/aluno_service.dart';
import '../widgets/neuro_widgets.dart';

class AtendimentoScreen extends StatefulWidget {
  final Funcionario funcionario;
  const AtendimentoScreen({super.key, required this.funcionario});

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

    List<Atendimento> atendimentos = [];

    if (busca != null && busca.trim().isNotEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      final aluno = AlunoRepository().buscarPorNome(busca);
      if (aluno != null) {
        atendimentos.addAll(AtendimentoRepository().listarPorAluno(aluno.id));
      }
    }

    setState(() {
      _atendimentos.clear();
      _atendimentos = atendimentos;
      _carregando = false;
    });
  }

  Future<void> _abrirAtendimento({Aluno? aluno}) async {
    //TODO: aqui vai abrir uma nova aba do navegador com o PDF do atendimento
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
                            title: 'Histórico de Atendimentos',
                            right: NeuroPillButton(
                              text: 'Voltar ao início',
                              width: 140,
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
                                  hint: 'BUSCAR HISTÓRICO DE ALUNO',
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
                                        funcionario: widget.funcionario,
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
                                      final aluno = AlunoRepository()
                                          .buscarPorId(atendimento.idAluno)!;
                                      final profissional =
                                          FuncionarioRepository().buscarPorId(
                                            atendimento.idFuncionario,
                                          )!;
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
                                                    aluno.nome.toUpperCase(),
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
                                                        'Profissional: ${profissional.nome} · ${profissional.cbo}',
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Text(
                                                        dataFormatada(
                                                          atendimento
                                                              .dataAtendimento,
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
