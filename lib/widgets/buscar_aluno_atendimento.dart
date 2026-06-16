import 'package:flutter/material.dart';
import 'package:neurogest_front/mock/mock_aluno_repository.dart';
import 'package:neurogest_front/models/aluno.dart';

class BuscarAlunoAtendimento extends StatefulWidget {
  final Function(Aluno aluno) onAlunoSelecionado;

  const BuscarAlunoAtendimento({super.key, required this.onAlunoSelecionado});

  @override
  State<BuscarAlunoAtendimento> createState() => _BuscarAlunoAtendimentoState();
}

class _BuscarAlunoAtendimentoState extends State<BuscarAlunoAtendimento> {
  final TextEditingController _controller = TextEditingController();

  List<Aluno> pacientes = [];
  List<Aluno> resultados = [];

  bool mostrarResultados = false;

  Aluno? selecionado;

  @override
  void initState() {
    super.initState();
    carregarPacientes();
  }

  Future<void> carregarPacientes() async {
    pacientes = AlunoRepository().listar();

    setState(() {});
  }

  void pesquisar(String texto) {
    setState(() {
      resultados = pacientes
          .where(
            (item) => item.nome.toLowerCase().contains(texto.toLowerCase()),
          )
          .toList();

      mostrarResultados = texto.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: pesquisar,
          decoration: InputDecoration(
            hintText: "Pesquisar aluno...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),

        const SizedBox(height: 8),

        if (mostrarResultados)
          Container(
            constraints: const BoxConstraints(maxHeight: 250),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: resultados.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Nenhum resultado encontrado"),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: resultados.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = resultados[index];

                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(item.nome),
                        onTap: () {
                          setState(() {
                            selecionado = item;
                            _controller.text = item.nome;
                            mostrarResultados = false;
                          });

                          // RETORNA O ALUNO
                          widget.onAlunoSelecionado(item);

                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
          ),
      ],
    );
  }
}
