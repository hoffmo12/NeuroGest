import 'package:flutter/material.dart';
import 'package:neurogest_front/models/aluno.dart';

class AlunoSelecionado extends StatefulWidget {
  final Aluno aluno;
  const AlunoSelecionado({super.key, required this.aluno});

  @override
  State<AlunoSelecionado> createState() => _AlunoSelecionadoState();
}

class _AlunoSelecionadoState extends State<AlunoSelecionado> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FOTO
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, size: 38, color: Colors.grey),
              ),

              const SizedBox(width: 18),

              // INFO PRINCIPAL
              Expanded(
                // flex: 2,
                child: Text(
                  widget.aluno.nome,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),

              // DIVISOR
              Container(
                width: 1,
                height: 90,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.grey.shade300,
              ),

              // INFO LATERAL
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoItem(
                      Icons.calendar_month,
                      "DATA DE NASCIMENTO",
                      widget.aluno.dataNascimentoFormatada,
                    ),
                    const SizedBox(height: 20),
                    infoItem(
                      Icons.favorite,
                      "NOME DA MÃE",
                      widget.aluno.nomeMae ?? 'Não informado',
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoItem(Icons.badge, "CPF / CNS", '${widget.aluno.cpf}'),
                    const SizedBox(height: 20),
                    infoItem(
                      Icons.location_on,
                      "MUNICÍPIO DE RESIDÊNCIA",
                      '${widget.aluno.municipio} - ${widget.aluno.estado!.toUpperCase()}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.male, size: 18, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      widget.aluno.sexo!,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Text(
                '${widget.aluno.idade.toString()} anos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoItem(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
