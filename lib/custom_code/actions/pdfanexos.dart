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
import 'package:intl/intl.dart'; // Para formatear la fecha

Future<void> pdfanexos(
  List<BienesmueblesRecord>? bienesMuebles,
  String texto1, // NOMBRE DE ANEXO
  String texto2, // CARGO DEL DEPOSITARIO
  String texto3, // NOMBRE COMPLETO DE REVISOR
  String texto4, // CARGO DEL REVISOR
  String texto5, // UBICACIÓN
  String texto6, // DISTRITO
  String texto7, // AREA
) async {
  bienesMuebles = bienesMuebles ?? [];

  // Cargar el logo desde assets
  final ByteData logoData = await rootBundle.load('assets/images/logopjev.png');
  final Uint8List logoBytes = logoData.buffer.asUint8List();

  // Crear el documento PDF
  final pdf = pw.Document();

  // Estilos comunes
  final headerTextStyle = pw.TextStyle(
    fontSize: 10,
    fontWeight: pw.FontWeight.bold,
  );

  final tableHeaderStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 8,
  );

  final cellTextStyle = pw.TextStyle(
    fontSize: 7,
  );

  final totalRowStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 8,
  );

  // Configuración de filas por página
  const int rowsFirstPage = 6;
  const int rowsOtherPages = 11;

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

  // Calcular la suma total de la columna "COSTO INICIAL"
  double totalCosto = 0;
  for (var bien in bienesMuebles) {
    if (bien.importeinicialbien != null) {
      totalCosto += bien.importeinicialbien!;
    }
  }

  // Formatear el número para mostrar 2 decimales
  final formatoMoneda = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '\$',
    decimalDigits: 2,
  );
  final totalCostoFormateado = formatoMoneda.format(totalCosto);

  // Obtener la fecha actual
  final fechaActual =
      DateFormat("dd 'de' MMMM 'de' yyyy", 'es').format(DateTime.now());

  // Función para construir el footer de página con numeración
  pw.Widget _buildPageNumberFooter(int currentPage, int totalPages) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'Página ${currentPage + 1}/$totalPages',
        style: const pw.TextStyle(fontSize: 8),
      ),
    );
  }

  // Generar páginas con tablas
  for (int page = 0; page < pages.length; page++) {
    final isLastPage = page == pages.length - 1;
    final totalPages = pages.length;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape.copyWith(
          marginLeft: 20,
          marginRight: 20,
          marginBottom: 30, // Margen inferior para el número de página
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado con logo
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
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        "$texto1",
                        style: headerTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        "ÓRGANO DE ADMINISTRACIÓN JUDICIAL",
                        style: headerTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                  pw.SizedBox(width: 120, height: 60),
                ],
              ),
              pw.SizedBox(height: 5),

              // Información general (solo primera página)
              if (page == 0)
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  color: PdfColors.grey300,
                  width: double.infinity,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Fecha: $fechaActual",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Adscripción: $texto5",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Área: $texto7",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      //pw.Text("Depositario: $texto1",
                      //    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("$texto6",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
              pw.SizedBox(height: 10),

              // Tabla de bienes muebles
              pw.Table(
                border: pw.TableBorder(),
                columnWidths: {
                  0: pw.FlexColumnWidth(2), // NÚM. ID.
                  1: pw.FlexColumnWidth(3), // DESCRIPCIÓN DEL BIEN
                  2: pw.FlexColumnWidth(2), // MARCA
                  3: pw.FlexColumnWidth(2), // MODELO
                  4: pw.FlexColumnWidth(2), // SERIE
                  5: pw.FlexColumnWidth(2), // COSTO INICIAL
                  6: pw.FlexColumnWidth(2), // ESTADO FÍSICO
                  7: pw.FlexColumnWidth(3), // UBIC.
                  8: pw.FlexColumnWidth(3), // USUARIO
                },
                children: [
                  // Encabezados de tabla
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                      border: pw.Border.all(),
                    ),
                    children: [
                      pw.Text("ID",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("Descripción",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("Marca",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("Modelo",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("Serie",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("Costo",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("Estado",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("Ubicación",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                      pw.Text("Usuario",
                          style: tableHeaderStyle,
                          textAlign: pw.TextAlign.center),
                    ],
                  ),
                  // Filas de datos
                  for (int i = 0; i < pages[page].length; i++)
                    pw.TableRow(
                      children: [
                        pw.Text(
                            pages[page][i].inventario2025 ?? "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(pages[page][i].nombre ?? "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(
                            pages[page][i].marcacomercial ?? "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(pages[page][i].modelo ?? "Sin información",
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
                            pages[page][i].ubicacionfisica ?? "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                        pw.Text(pages[page][i].depositario ?? "Sin información",
                            textAlign: pw.TextAlign.center,
                            style: cellTextStyle),
                      ],
                    ),
                  // Fila de totales (solo última página)
                  if (isLastPage)
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        border: pw.Border.all(),
                      ),
                      children: [
                        for (int i = 0; i < 4; i++)
                          pw.Container(child: pw.Text("")),
                        pw.Container(
                          alignment: pw.Alignment.centerRight,
                          child:
                              pw.Text("Total depto.: ", style: totalRowStyle),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(totalCostoFormateado,
                              style: totalRowStyle),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.centerRight,
                          child:
                              pw.Text("Total bienes: ", style: totalRowStyle),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text('${bienesMuebles?.length ?? 0}',
                              style: totalRowStyle),
                        ),
                        pw.Container(child: pw.Text("")),
                      ],
                    ),
                ],
              ),

              // Número de página (siempre al final)
              pw.Spacer(),
              _buildPageNumberFooter(page, totalPages),
            ],
          );
        },
      ),
    );
  }

  // Guardar y descargar el PDF
  final bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..target = 'webbrowser'
    ..download = 'BienesMuebles_${DateTime.now()}.pdf'
    ..click();
  html.Url.revokeObjectUrl(url);
}
