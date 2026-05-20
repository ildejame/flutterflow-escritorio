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

Future<void> crearPDF2(List<String> textos1, List<String> textos2) async {
  // Asegurarse de que las listas tengan la misma longitud
  if (textos1.length != textos2.length) {
    throw Exception("Las listas deben tener la misma longitud.");
  }

  // Crear un documento PDF
  final pdf = pw.Document();

  // Recorrer las listas y añadir una hoja por cada par de textos
  for (int i = 0; i < textos1.length; i++) {
    final texto1 = textos1[i];
    final texto2 = textos2[i];

    // Añadir contenido al PDF
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text("Hoja ${i + 1}"),
                pw.SizedBox(height: 10),
                pw.Text("Texto 1: $texto1"),
                pw.SizedBox(height: 10),
                pw.Text("Texto 2: $texto2"),
              ],
            ),
          );
        },
      ),
    );
  }

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
