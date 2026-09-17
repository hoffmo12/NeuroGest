import 'package:flutter/material.dart';
import 'package:neurogest_front/models/usuario.dart';

class AtendimentoInfos extends StatelessWidget {
  final Usuario usuario;
  const AtendimentoInfos({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE8F0FF),
                  child: const Icon(
                    Icons
                        .local_hospital, //TODO: trocar para o do CBO específico
                    color: Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: ListTile(
                    title: Text(
                      usuario.nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    subtitle: Text(
                      "${usuario.cbo} • ${usuario.tipoRegistro}: ${usuario.numRegistro}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
