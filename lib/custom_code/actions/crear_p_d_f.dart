// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:html' as html;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> crearPDF(String texto1, String texto2) async {
  // Crear un documento PDF
  final pdf = pw.Document();

  // Añadir contenido al PDF
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(texto1),
              pw.SizedBox(height: 20),
              pw.Text(texto2),
            ],
          ),
        );
      },
    ),
  );

  // Guardar el PDF como bytes
  final Uint8List pdfBytes = await pdf.save();

  // Crear un blob con los bytes del PDF
  final html.Blob blob = html.Blob([pdfBytes]);

  // Crear un enlace para descargar el PDF
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..target = 'webpdf'
    ..download = 'archivo.pdf'
    ..click();

  // Liberar recursos
  html.Url.revokeObjectUrl(url);
}
