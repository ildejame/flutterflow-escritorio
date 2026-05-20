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

import 'dart:html' as html; // Importación específica para la web
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> generarPDF(BuildContext context) async {
  // Crear un documento PDF
  final pdf = pw.Document();

  // Agregar una página al PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Encabezado SNTSS
            pw.Text(
              'SNTSS',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'SECRETARÍA DE ADMISIÓN Y CAMBIOS',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'FOLIO No. 271',
              style: pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 16),

            // Contenido en tres columnas con líneas divisorias
            pw.Row(
              children: [
                // Primera columna (más angosta)
                pw.Expanded(
                  flex: 2, // Ancho relativo
                  child: pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        right: pw.BorderSide(width: 1, color: PdfColors.black),
                      ),
                    ),
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Nombre del Aspirante:',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          'BETHEIXUIX ALEJANDRA OVANDO ESPEIEL',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Zona: ZONA 3',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Categoría:',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          'AUXILIAR EN SOPORTE TÉCNICO EN INFORMATICA',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Teléfono: 2297184746',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Correo Electrónico: mujerlaborar@gmail.com',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          'Nombre del Familiar que recomienda:',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          'MANIBEL ESPEIEL SALAZAR',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Matrícula del Familiar que recomienda: 8498139',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          'Fecha: 12/02/2025',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          'Fotografía',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),

                // Segunda columna (más ancha)
                pw.Expanded(
                  flex: 3, // Ancho relativo
                  child: pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        right: pw.BorderSide(width: 1, color: PdfColors.black),
                      ),
                    ),
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'SINDICATO NACIONAL DE TRABAJADORES DEL SEGURO SOCIAL',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          'SECRETARÍA DE ADMISIÓN Y CAMBIOS',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'XALAPA, VER., A 12 de febrero de 2025',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'C. Representante de la Bolsa de Trabajo\nLomas del Estado S/N\nXalapa, Ver.',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'De acuerdo con lo Cláusula 23 del Contrato Colectivo de Trabajo y su Reglamento de Bolsa de Trabajo vigentes, nos permitimos proponer al portador, cuyos datos incluimos, al fin de que se inicie el proceso de selección.',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'De reunir los requisitos de la categoría y obtener resultados satisfactorios, rogamos a ustedes lo anoten en los registros respectivos y se nos comunique el resultado, de conformidad con lo establecido en la cláusula 8 del propio C.C.T.',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          'Atentamente',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          '"SEGUIRIDAD SOCIAL Y BIENESTAR ECONÓMICO DE LOS TRABAJADORES"',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Secretario General',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          'LIC. JESÚS FELUEL ZAPATA AGUIRRE',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Secretaria de Admisión y Cambios',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          'ENFRA. ANA MARÍA CONTRERAS RUIZ',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tercera columna (más angosta)
                pw.Expanded(
                  flex: 2, // Ancho relativo
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Nota.- Los datos proporcionados deben ser ratificados por los C. C. Representantes.\nEsta propuesta deberá ser entregada en la Bolsa de Trabajo, antes de 30 días.',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'TODOS LOS TRÁMITES DE INGRESO AL INSTITUTO SON GRATUITOS.',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'IMSS',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          'CUALQUIER IRREGULARIDAD FAVOR DE REPORTARLA A LA SECRETARÍA',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  // Convertir el PDF a bytes
  final bytes = await pdf.save();

  // Descargar el PDF en la web
  _descargarPDF(bytes, 'formato_seguro.pdf');
}

// Función para descargar el PDF en la web
void _descargarPDF(List<int> bytes, String fileName) {
  // Crear un Blob con los bytes del PDF
  final blob = html.Blob([bytes], 'application/pdf');

  // Crear un enlace de descarga
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();

  // Liberar el objeto URL
  html.Url.revokeObjectUrl(url);
}
