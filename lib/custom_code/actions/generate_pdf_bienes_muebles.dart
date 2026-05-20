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

import 'dart:convert' show utf8;
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart'; // Nueva biblioteca para generar PDFs
import 'package:intl/intl.dart'; // Importa la biblioteca intl
import 'package:flutter/services.dart'
    show rootBundle; // Para cargar imágenes desde assets

Future<void> generatePdfBienesMuebles(
    List<BienesmueblesRecord>? bienesMuebles) async {
  bienesMuebles = bienesMuebles ?? [];

  // Crear el documento PDF
  final PdfDocument document = PdfDocument();
  final PdfPage page = document.pages.add();
  final Size pageSize = page.getClientSize();

  // Cargar el logo desde assets
  final ByteData data = await rootBundle.load('assets/images/logopjev.png');
  final Uint8List logoBytes = data.buffer.asUint8List();
  final PdfBitmap logo = PdfBitmap(logoBytes);

  // Dibujar el logo en la parte superior izquierda
  page.graphics.drawImage(logo, Rect.fromLTWH(0, 0, 100, 50));

  // Dibujar encabezados estáticos
  final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  final PdfFont boldFont =
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

  final List<String> headerContent = [
    "PODER JUDICIAL DEL ESTADO DE VERACRUZ",
    "RESGUARDO DE BIENES MUEBLES",
    "301C13001 CONSEJO DE LA JUDICATURA",
    "Dirección General de Administración",
    "Subdirección de Recursos Materiales",
    "Departamento de Control de Inventarios",
    "FECHA: 05 DE DICIEMBRE DE 2024",
    "UBICACIÓN: JUZGADO DE PROCESO Y PROCEDIMIENTO PENAL ORAL",
    "DEPOSITARIO: LIC. YANET LÓPEZ CAZARES, 735002",
    "DISTRITO JUDICIAL: VI. TUXPAN, VERACRUZ."
  ];

  double currentY = 60; // Posición inicial después del logo
  for (String line in headerContent) {
    page.graphics.drawString(line, font,
        bounds: Rect.fromLTWH(0, currentY, pageSize.width, 20));
    currentY += 20;
  }

  currentY += 10; // Espaciado adicional antes de la tabla

  // Crear la tabla
  final PdfGrid grid = PdfGrid();
  grid.columns.add(count: 12);

  // Añadir encabezados de la tabla
  grid.headers.add(1);
  final PdfGridRow header = grid.headers[0];
  final List<String> tableHeaders = [
    "No.",
    "NÚM. ID.",
    "ID. ANTERIOR",
    "DESCRIPCIÓN DEL BIEN",
    "MARCA",
    "MODELO",
    "SERIE",
    "COSTO INICIAL",
    "ESTADO FÍSICO",
    "CARACTERÍSTICAS U OBSERVACIONES",
    "UBICACIÓN",
    "USUARIO"
  ];

  for (int i = 0; i < tableHeaders.length; i++) {
    header.cells[i].value = tableHeaders[i];
    header.cells[i].style = PdfGridCellStyle(
        font: boldFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));
  }

  // Añadir los datos dinámicos
  for (int i = 0; i < bienesMuebles.length; i++) {
    final PdfGridRow row = grid.rows.add();
    var record = bienesMuebles[i];

    row.cells[0].value = (i + 1).toString(); // Número consecutivo
    row.cells[1].value = record.numeroinventario ?? "Sin información";
    row.cells[2].value =
        record.numeroinventario ?? "Sin información"; // ID anterior (repetido)
    row.cells[3].value = record.descripciondelbien ?? "Sin información";
    row.cells[4].value = record.marcacomercial ?? "Sin información";
    row.cells[5].value =
        record.marcacomercial ?? "Sin información"; // Modelo (repetido)
    row.cells[6].value = record.numeroseriedelbien ?? "Sin información";
    row.cells[7].value = record.importeinicialbien?.toString() ?? "0.0";
    row.cells[8].value = record.estatusdelbien ?? "Sin información";
    row.cells[9].value = record.comentarioadicional ?? "Sin información";
    row.cells[10].value = record.ubicacionfisica ?? "Sin información";
    row.cells[11].value = record.depositario ?? "Sin información";
  }

  // Dibujar la tabla
  grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, currentY, pageSize.width, pageSize.height - currentY));

  // Guardar el documento PDF
  final List<int> rawBytes = document.saveSync();
  final Uint8List bytes = Uint8List.fromList(rawBytes);
  document.dispose();

  // Crear un blob para descargar el PDF
  final blob = html.Blob([bytes], 'application/pdf');

  // Crear una URL para el blob
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Crear un enlace para iniciar la descarga
  final anchor = html.AnchorElement(href: url)
    ..target = 'webbrowser'
    ..download = 'BienesMuebles_${DateTime.now()}.pdf'
    ..click();

  // Liberar la URL
  html.Url.revokeObjectUrl(url);
}
