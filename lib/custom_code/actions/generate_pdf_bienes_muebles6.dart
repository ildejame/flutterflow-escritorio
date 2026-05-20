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

Future<void> generatePdfBienesMuebles6(
    List<BienesmueblesRecord>? bienesMuebles) async {
  bienesMuebles = bienesMuebles ?? [];

  // Cargar el logo desde assets
  final ByteData logoData = await rootBundle.load('assets/images/logopjev.png');
  final Uint8List logoBytes = logoData.buffer.asUint8List();

  // Crear el documento PDF
  final pdf = pw.Document();

  // Estilos comunes
  final headerTextStyle = pw.TextStyle(
    fontSize: 12,
    fontWeight: pw.FontWeight.bold,
  );

  final tableHeaderStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 8,
  );

  final cellTextStyle = pw.TextStyle(
    fontSize: 7,
  );

  // Configuración de filas por página
  const int rowsFirstPage = 6;
  const int rowsOtherPages = 12;

  // Dividir registros por páginas
  int totalRows = bienesMuebles.length;
  List<List<BienesmueblesRecord>> pages = [];
  if (totalRows > rowsFirstPage) {
    pages.add(bienesMuebles.sublist(0, rowsFirstPage));
    int start = rowsFirstPage;
    while (start < totalRows) {
      int end = (start + rowsOtherPages < totalRows)
          ? start + rowsOtherPages
          : totalRows;
      pages.add(bienesMuebles.sublist(start, end));
      start = end;
    }
  } else {
    pages.add(bienesMuebles);
  }

  for (int page = 0; page < pages.length; page++) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape.copyWith(
          marginLeft: 20,
          marginRight: 20,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment
                    .spaceBetween, // Distribuye el espacio entre los elementos
                children: [
                  // Logo a la izquierda
                  pw.Image(
                    pw.MemoryImage(logoBytes),
                    width: 120,
                    height: 60,
                  ),

                  // Texto 1 en el centro
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment
                        .center, // Centrar el texto horizontalmente
                    children: [
                      pw.Text(
                        "PODER JUDICIAL DEL ESTADO DE VERACRUZ",
                        style: headerTextStyle,
                        textAlign: pw.TextAlign.center, // Centrar el texto
                      ),
                      pw.Text(
                        "RESGUARDO DE BIENES MUEBLES",
                        style: headerTextStyle,
                        textAlign: pw.TextAlign.center, // Centrar el texto
                      ),
                      pw.Text(
                        "301C13001 CONSEJO DE LA JUDICATURA",
                        style: headerTextStyle,
                        textAlign: pw.TextAlign.center, // Centrar el texto
                      ),
                    ],
                  ),

                  // Texto 2 a la derecha
                  pw.Column(
                    crossAxisAlignment:
                        pw.CrossAxisAlignment.end, // Alinear a la derecha
                    children: [
                      pw.Text(
                        "Consejo de la Judicatura",
                        style: headerTextStyle,
                        textAlign:
                            pw.TextAlign.right, // Alinear texto a la derecha
                      ),
                      pw.Text(
                        "Dirección General de Administración",
                        style: headerTextStyle,
                        textAlign:
                            pw.TextAlign.right, // Alinear texto a la derecha
                      ),
                      pw.Text(
                        "Subdirección de Recursos Materiales",
                        style: headerTextStyle,
                        textAlign:
                            pw.TextAlign.right, // Alinear texto a la derecha
                      ),
                      pw.Text(
                        "Departamento de Control de Inventarios",
                        style: headerTextStyle,
                        textAlign:
                            pw.TextAlign.right, // Alinear texto a la derecha
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
                    crossAxisAlignment:
                        pw.CrossAxisAlignment.center, // Centrar el contenido
                    children: [
                      pw.Text(
                        "FECHA: 05 DE DICIEMBRE DE 2024",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center, // Centrar el texto
                      ),
                      pw.Text(
                        "UBICACIÓN: JUZGADO DE PROCESO Y PROCEDIMIENTO PENAL ORAL",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center, // Centrar el texto
                      ),
                      pw.Text(
                        "DEPOSITARIO: LIC. YANET LÓPEZ CAZARES",
                        textAlign: pw.TextAlign.center, // Centrar el texto
                      ),
                      pw.Text(
                        "DISTRITO JUDICIAL: VI. TUXPAN, VERACRUZ",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center, // Centrar el texto
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
                  3: pw.FlexColumnWidth(3),
                  4: pw.FlexColumnWidth(2),
                  5: pw.FlexColumnWidth(2),
                  6: pw.FlexColumnWidth(2),
                  7: pw.FlexColumnWidth(2),
                  8: pw.FlexColumnWidth(2),
                  9: pw.FlexColumnWidth(3),
                  10: pw.FlexColumnWidth(3),
                  11: pw.FlexColumnWidth(3),
                },
                children: [
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
                      pw.Text("COSTO INICIAL",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("ESTADO FÍSICO",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("CARACT. U OBS.",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("UBIC.",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("USUARIO",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                    ],
                  ),
                  for (int i = 0; i < pages[page].length; i++)
                    pw.TableRow(
                      children: [
                        pw.Text(
                            "${i + 1 + (page == 0 ? 0 : rowsFirstPage + (page - 1) * rowsOtherPages)}",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].numeroinventario ??
                                "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].numeroinventario ??
                                "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].descripciondelbien ??
                                "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].marcacomercial ?? "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].marcacomercial ?? "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].numeroseriedelbien ??
                                "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].importeinicialbien?.toString() ??
                                "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].estatusdelbien ?? "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].comentarioadicional ??
                                "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].ubicacionfisica ?? "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(pages[page][i].depositario ?? "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Sección de firmas y leyenda (bloque indivisible)
              if (page == pages.length - 1)
                pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Column(
                          children: [
                            pw.Text("DEPOSITARIO",
                                style: pw.TextStyle(fontSize: 8)),
                            pw.SizedBox(height: 20),
                            pw.Container(
                                width: 150, height: 1, color: PdfColors.black),
                            pw.Text("NOMBRE COMPLETO DEL DEPOSITARIO",
                                style: pw.TextStyle(fontSize: 8),
                                textAlign: pw.TextAlign.center),
                            pw.Text("CARGO DEL DEPOSITARIO",
                                style: pw.TextStyle(fontSize: 8),
                                textAlign: pw.TextAlign.center),
                          ],
                        ),
                        pw.Column(
                          children: [
                            pw.Text("REVISO", style: pw.TextStyle(fontSize: 8)),
                            pw.SizedBox(height: 20),
                            pw.Container(
                                width: 150, height: 1, color: PdfColors.black),
                            pw.Text("NOMBRE COMPLETO DE REVISOR",
                                style: pw.TextStyle(fontSize: 8),
                                textAlign: pw.TextAlign.center),
                            pw.Text("CARGO DEL REVISOR",
                                style: pw.TextStyle(fontSize: 8),
                                textAlign: pw.TextAlign.center),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Container(
                      padding: pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Text(
                        "El Depositario es el responsable del cuidado, uso adecuado de los bienes y de notificar al Departamento de Inventarios, de cualquier modificación que afecte al presente resguardo. Así como de notificar la pérdida, extravío, daño o menoscabo de los bienes enlistados, en observancia a los artículos 5 de la Ley de Responsabilidades Administrativas para el Estado de Veracruz de Ignacio de la Llave; 88, fracción II, 93 de la Ley de Adquisiciones, Arrendamientos, Administración y enajenación de bienes muebles del Estado de Veracruz de Ignacio de la Llave; y 31 del Reglamento Interior de la Dirección de administración del Consejo de Judicatura del Poder Judicial del Estado de Veracruz.",
                        style:
                            pw.TextStyle(fontSize: 8, color: PdfColors.black),
                        textAlign: pw.TextAlign.justify,
                      ),
                    ),
                  ],
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
