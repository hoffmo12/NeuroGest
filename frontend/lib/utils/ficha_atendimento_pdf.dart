import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/atendimento.dart';

// Gera o PDF da ficha de atendimento já preenchida com os dados
// registrados na consulta.
Future<Uint8List> gerarFichaAtendimentoPdf(Atendimento a) async {
  final doc = pw.Document();

  final corPrimaria = PdfColor.fromInt(0xFF4F7CFE);
  final corMuted = PdfColor.fromInt(0xFF6B7280);

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(32, 28, 32, 28),
      header: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'NEUROGEST',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: corPrimaria,
                ),
              ),
              pw.Text(
                'Ficha de Atendimento #${a.id}',
                style: pw.TextStyle(fontSize: 11, color: corMuted),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Divider(color: corPrimaria, thickness: 1.2),
          pw.SizedBox(height: 12),
        ],
      ),
      footer: (context) => pw.Column(
        children: [
          pw.Divider(color: corMuted, thickness: 0.5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Gerado em ${_formatarDataHora(DateTime.now())}',
                style: pw.TextStyle(fontSize: 8, color: corMuted),
              ),
              pw.Text(
                'Página ${context.pageNumber} de ${context.pagesCount}',
                style: pw.TextStyle(fontSize: 8, color: corMuted),
              ),
            ],
          ),
        ],
      ),
      build: (context) => [
        _secao('Dados gerais', corPrimaria, [
          _linhaCampos([
            _campo('Aluno', a.nomeAluno),
            _campo('Data do atendimento', _formatarData(a.dataAtendimento)),
          ]),
          _linhaCampos([
            _campo('Profissional', a.nomeUsuario),
            _campo('CBO', a.cboUsuario.isEmpty ? '-' : a.cboUsuario),
          ]),
        ]),

        _secao('Motivo da consulta', corPrimaria, [
          _blocoTexto(a.motivoDaConsulta),
        ]),

        _secao('Anamnese', corPrimaria, [_blocoTexto(a.anamnese)]),

        _secao('Exame físico', corPrimaria, [
          _linhaCampos([
            _campo('Peso (kg)', a.peso.toStringAsFixed(1)),
            _campo('Altura (m)', a.altura.toStringAsFixed(2)),
            _campo('IMC', a.imc.toStringAsFixed(1)),
          ]),
          _linhaCampos([
            _campo(
              'Perímetro cefálico (cm)',
              a.perimetroCefalico.toStringAsFixed(1),
            ),
            _campo(
              'Circunf. abdominal (cm)',
              a.circunferenciaAbdominal.toStringAsFixed(1),
            ),
            _campo(
              'Perímetro panturrilha (cm)',
              a.perimetroPanturrilha.toStringAsFixed(1),
            ),
          ]),
          pw.SizedBox(height: 8),
          _blocoTexto(a.exameFisico),
        ]),

        _secao('Diagnóstico', corPrimaria, [_blocoTexto(a.diagnostico)]),

        pw.SizedBox(height: 36),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Column(
              children: [
                pw.Container(width: 240, height: 0.8, color: corMuted),
                pw.SizedBox(height: 4),
                pw.Text(
                  a.nomeUsuario.isEmpty
                      ? 'Assinatura do profissional'
                      : a.nomeUsuario,
                  style: const pw.TextStyle(fontSize: 10),
                ),
                if (a.cboUsuario.isNotEmpty) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(a.cboUsuario, style: const pw.TextStyle(fontSize: 8)),
                ],
              ],
            ),
          ],
        ),
      ],
    ),
  );

  return doc.save();
}

pw.Widget _secao(String titulo, PdfColor cor, List<pw.Widget> children) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 14),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          titulo.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: cor,
          ),
        ),
        pw.SizedBox(height: 6),
        ...children,
      ],
    ),
  );
}

pw.Widget _linhaCampos(List<pw.Widget> campos) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < campos.length; i++) ...[
          if (i > 0) pw.SizedBox(width: 16),
          pw.Expanded(child: campos[i]),
        ],
      ],
    ),
  );
}

pw.Widget _campo(String rotulo, String valor) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        rotulo.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 8,
          color: PdfColor.fromInt(0xFF6B7280),
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.SizedBox(height: 2),
      pw.Text(
        valor.isEmpty ? '-' : valor,
        style: const pw.TextStyle(fontSize: 11),
      ),
    ],
  );
}

pw.Widget _blocoTexto(String texto) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      color: PdfColor.fromInt(0xFFF5F7FA),
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
    ),
    child: pw.Text(
      texto.trim().isEmpty ? 'Não informado.' : texto,
      style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 2),
    ),
  );
}

String _formatarData(DateTime dt) =>
    '${dt.day.toString().padLeft(2, '0')}/'
    '${dt.month.toString().padLeft(2, '0')}/'
    '${dt.year}';

String _formatarDataHora(DateTime dt) =>
    '${_formatarData(dt)} às '
    '${dt.hour.toString().padLeft(2, '0')}:'
    '${dt.minute.toString().padLeft(2, '0')}';
