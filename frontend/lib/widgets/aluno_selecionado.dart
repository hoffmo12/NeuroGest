import 'package:flutter/material.dart';
import '../models/aluno.dart';

class AlunoSelecionado extends StatelessWidget {
  final Aluno aluno;
  const AlunoSelecionado({super.key, required this.aluno});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto
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

              // Nome
              Expanded(
                child: Text(
                  aluno.nome,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),

              // Divisor
              Container(
                width: 1,
                height: 90,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.grey.shade300,
              ),

              // Coluna esquerda
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoItem(
                      Icons.calendar_month,
                      'DATA DE NASCIMENTO',
                      aluno.dataNascimentoFormatada,
                    ),
                    const SizedBox(height: 20),
                    _infoItem(
                      Icons.favorite,
                      'NOME DA MÃE',
                      aluno.nomeMae ?? 'Não informado',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Coluna direita
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoItem(
                      Icons.badge,
                      'CPF / CNS',
                      aluno.cpf ?? 'Não informado',
                    ),
                    const SizedBox(height: 20),
                    _infoItem(
                      Icons.location_on,
                      'MUNICÍPIO DE RESIDÊNCIA',
                      _localidade(aluno),
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
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      aluno.sexo ?? 'Não informado',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${aluno.idade} anos',
                style: const TextStyle(
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

  // Monta "Cidade - UF" ou fallbacks individuais
  String _localidade(Aluno aluno) {
    final cidade = aluno.municipio ?? 'Não informado';
    final uf     = aluno.estado?.toUpperCase();
    return uf != null ? '$cidade - $uf' : cidade;
  }

  Widget _infoItem(IconData icon, String titulo, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}