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

import 'package:barcode_widget/barcode_widget.dart' as bw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart';

// Importa la biblioteca de códigos de barras
import 'package:barcode_widget/barcode_widget.dart';

Future<void> crearPDF5(List<String> textos1, List<String> textos2) async {
  // Cargar imagen
  final image = pw.MemoryImage(
      (await rootBundle.load('assets/images/huatusco.png'))
          .buffer
          .asUint8List());

  // Crear PDF
  final pdf = pw.Document();

  // Recorrer textos
  for (int i = 0; i < textos1.length; i++) {
    // Agregar página
    pdf.addPage(pw.Page(build: (context) {
      return pw.Center(
          child: pw.Column(children: [
        // Agregar imagen
        pw.Image(image),

        pw.Text("Hoja ${i + 1}"),
        pw.SizedBox(height: 10),

        pw.Text("Texto 1: ${textos1[i]}"),
        pw.SizedBox(height: 10),

        pw.Text("Texto 2: ${textos2[i]}"),

        pw.SizedBox(height: 20),

        // Agregar código QR
        pw.BarcodeWidget(
          data: textos1[i],
          barcode: pw.Barcode.qrCode(),
          width: 100,
          height: 100,
          color: PdfColor(0, 0, 0),
          backgroundColor: PdfColor(255, 255, 255),
          drawText: false,
        ),
      ]));
    }));
  }

  // Convertir a bytes
  final pdfBytes = await pdf.save();

  // Crear blob y url para descarga
  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Crear enlace de descarga
  final anchor = html.AnchorElement(
    href: url,
  )..setAttribute("download", "mi_pdf.pdf");

  // Hacer click en enlace
  anchor.click();

  // Revocar url
  html.Url.revokeObjectUrl(url);
}
