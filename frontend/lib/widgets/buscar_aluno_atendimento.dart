import 'package:flutter/material.dart';
import 'package:neurogest_front/models/aluno.dart';
import 'package:neurogest_front/services/aluno_service.dart'; // Sua service real

class BuscarAlunoAtendimento extends StatefulWidget {
  final Function(Aluno aluno) onAlunoSelecionado;

  const BuscarAlunoAtendimento({super.key, required this.onAlunoSelecionado});

  @override
  State<BuscarAlunoAtendimento> createState() => _BuscarAlunoAtendimentoState();
}

class _BuscarAlunoAtendimentoState extends State<BuscarAlunoAtendimento> {
  final TextEditingController _controller = TextEditingController();

  List<Aluno> resultados = [];
  bool mostrarResultados = false;
  bool carregando = false; 
  Aluno? selecionado;

  /// Faz a chamada assíncrona ao backend usando o método estático listar
  Future<void> pesquisar(String texto) async {
    if (texto.trim().isEmpty) {
      setState(() {
        resultados = [];
        mostrarResultados = false;
        carregando = false;
      });
      return;
    }

    setState(() {
      carregando = true;
      mostrarResultados = true;
    });

    try {
      // Chamando o seu método estático e passando o texto no parâmetro 'busca'
      final listaDoBackend = await AlunoService.listar(busca: texto);

      setState(() {
        resultados = listaDoBackend;
      });
    } catch (e) {
      debugPrint("Erro ao buscar alunos no backend: $e");
    } finally {
      setState(() {
        carregando = false;
      });
    }
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
            suffixIcon: carregando
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
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
            child: resultados.isEmpty && !carregando
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

                          // Retorna o aluno selecionado
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