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

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart';

Future<void> generatePdfBienesMuebles4(
    List<BienesmueblesRecord>? bienesMuebles) async {
  bienesMuebles = bienesMuebles ?? [];

  // Cargar el logo desde assets
  final ByteData logoData = await rootBundle.load('assets/images/logopjev.png');
  final Uint8List logoBytes = logoData.buffer.asUint8List();

  // Crear el documento PDF
  final pdf = pw.Document();

  // Estilos comunes
  final headerTextStyle = pw.TextStyle(
    fontSize: 14,
    fontWeight: pw.FontWeight.bold,
  );

  final tableHeaderStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
  );

  // Dividir registros en páginas si es necesario
  const int rowsPerPage =
      15; // Reducido para aprovechar mejor el espacio horizontal
  final pages = (bienesMuebles.length / rowsPerPage).ceil();

  for (int page = 0; page < pages; page++) {
    final start = page * rowsPerPage;
    final end = (start + rowsPerPage < bienesMuebles.length)
        ? start + rowsPerPage
        : bienesMuebles.length;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape, // Formato horizontal
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(
                    pw.MemoryImage(logoBytes),
                    width: 120,
                    height: 60,
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        "PODER JUDICIAL DEL ESTADO DE VERACRUZ",
                        style: headerTextStyle,
                      ),
                      pw.Text(
                        "RESGUARDO DE BIENES MUEBLES",
                        style: headerTextStyle,
                      ),
                      pw.Text(
                        "ÓRGANO DE ADMINISTRACIÓN JUDICIAL",
                        style: headerTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Información general (solo en la primera página)
              if (page == 0)
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  color: PdfColors.grey300,
                  width: double.infinity,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "FECHA: 05 DE DICIEMBRE DE 2024",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        "UBICACIÓN: JUZGADO DE PROCESO Y PROCEDIMIENTO PENAL ORAL",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text("DEPOSITARIO: LIC. YANET LÓPEZ CAZARES"),
                      pw.Text(
                        "DISTRITO JUDICIAL: VI. TUXPAN, VERACRUZ",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              pw.SizedBox(height: 20),

              // Tabla de bienes muebles
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(1),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(4),
                  4: pw.FlexColumnWidth(2),
                  5: pw.FlexColumnWidth(2),
                  6: pw.FlexColumnWidth(2),
                },
                children: [
                  // Encabezados de tabla
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Text("No.",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("NÚM. ID.",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("ID. ANTERIOR",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("DESCRIPCIÓN DEL BIEN",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("MARCA",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("MODELO",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("SERIE",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                    ],
                  ),
                  // Filas dinámicas
                  for (int i = start; i < end; i++)
                    pw.TableRow(
                      children: [
                        pw.Text("${i + 1}", textAlign: pw.TextAlign.center),
                        pw.Text(
                            bienesMuebles![i].numeroinventario ??
                                "Sin información",
                            textAlign: pw.TextAlign.center),
                        pw.Text(
                            bienesMuebles[i].numeroinventario ??
                                "Sin información",
                            textAlign: pw.TextAlign.center),
                        pw.Text(
                            bienesMuebles[i].descripciondelbien ??
                                "Sin información",
                            textAlign: pw.TextAlign.center),
                        pw.Text(
                            bienesMuebles[i].marcacomercial ??
                                "Sin información",
                            textAlign: pw.TextAlign.center),
                        pw.Text(
                            bienesMuebles[i].marcacomercial ??
                                "Sin información",
                            textAlign: pw.TextAlign.center),
                        pw.Text(
                            bienesMuebles[i].numeroseriedelbien ??
                                "Sin información",
                            textAlign: pw.TextAlign.center),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Leyenda (solo en la última página)
              if (page == pages - 1)
                pw.Text(
                  "El Depositario es el responsable del cuidado...",
                  style: pw.TextStyle(color: PdfColors.red),
                  textAlign: pw.TextAlign.justify,
                ),
            ],
          );
        },
      ),
    );
  }

  // Guardar el documento PDF y descargarlo
  final bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..target = 'webbrowser'
    ..download = 'BienesMuebles_${DateTime.now()}.pdf'
    ..click();
  html.Url.revokeObjectUrl(url);
}
