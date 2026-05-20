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
import 'package:syncfusion_flutter_pdf/pdf.dart'; // Biblioteca para generar PDFs
import 'package:intl/intl.dart'; // Manejo de fechas
import 'package:flutter/services.dart'
    show rootBundle; // Para cargar imágenes desde assets

Future<void> generatePdfBienesMuebles3(
    List<BienesmueblesRecord>? bienesMuebles) async {
  bienesMuebles = bienesMuebles ?? [];

  // Crear el documento PDF con orientación horizontal
  final PdfDocument document = PdfDocument();
  document.pageSettings.orientation = PdfPageOrientation.landscape;
  document.pageSettings.size = PdfPageSize.a4;

  PdfPage currentPage = document.pages.add();
  final Size pageSize = currentPage.getClientSize();

  // Cargar el logo desde assets
  final ByteData logoData = await rootBundle.load('assets/images/logopjev.png');
  final Uint8List logoBytes = logoData.buffer.asUint8List();
  final PdfBitmap logo = PdfBitmap(logoBytes);

  // Dibujar el logo en la parte superior izquierda
  currentPage.graphics.drawImage(logo, Rect.fromLTWH(30, 10, 120, 60));

  // Dibujar encabezado con formato específico
  final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 9);
  final PdfFont boldFont =
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
  final PdfFont italicFont =
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.italic);
  final PdfBrush grayBrush = PdfSolidBrush(PdfColor(200, 200, 200));

  // Encabezado central
  final double headerX = 150;
  final double headerWidth = pageSize.width - 350;
  currentPage.graphics.drawString(
    "PODER JUDICIAL DEL ESTADO DE VERACRUZ\nRESGUARDO DE BIENES MUEBLES",
    boldFont,
    bounds: Rect.fromLTWH(headerX, 10, headerWidth, 30),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );
  currentPage.graphics.drawString(
    "301C13001 CONSEJO DE LA JUDICATURA",
    boldFont,
    bounds: Rect.fromLTWH(headerX, 40, headerWidth, 20),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );

  // Encabezado a la derecha
  final double rightX = pageSize.width - 180;
  currentPage.graphics.drawString(
    "Órgano de Administración Judicial\nDirección General de Administración\nSubdirección de Recursos Materiales\nDepartamento de Control de Inventarios",
    italicFont,
    bounds: Rect.fromLTWH(rightX, 10, 160, 60),
    format: PdfStringFormat(alignment: PdfTextAlignment.left),
  );

  // Espaciado antes de la tabla
  double currentY = 80;

  // Dibujar cuadro de información general
  final Rect infoBox = Rect.fromLTWH(30, currentY, pageSize.width - 60, 60);
  currentPage.graphics.drawRectangle(bounds: infoBox, brush: grayBrush);

  currentY += 10;
  currentPage.graphics.drawString(
    "FECHA: 05 DE DICIEMBRE DE 2024",
    boldFont,
    bounds: Rect.fromLTWH(40, currentY, pageSize.width - 80, 12),
    format: PdfStringFormat(alignment: PdfTextAlignment.left),
  );
  currentY += 15;
  currentPage.graphics.drawString(
    "UBICACIÓN: JUZGADO DE PROCESO Y PROCEDIMIENTO PENAL ORAL",
    boldFont,
    bounds: Rect.fromLTWH(40, currentY, pageSize.width - 80, 12),
    format: PdfStringFormat(alignment: PdfTextAlignment.left),
  );
  currentY += 15;
  currentPage.graphics.drawString(
    "DEPOSITARIO: LIC. YANET LÓPEZ CAZARES, 735002 // LIC. HÉCTOR ZAPATA FRANCO, G26204 // LIC. MARIANO CANDELARIO ARAUJO REYES, 1007064",
    font,
    bounds: Rect.fromLTWH(40, currentY, pageSize.width - 80, 12),
    format: PdfStringFormat(alignment: PdfTextAlignment.left),
  );
  currentY += 15;
  currentPage.graphics.drawString(
    "DISTRITO JUDICIAL: VI. TUXPAN, VERACRUZ",
    boldFont,
    bounds: Rect.fromLTWH(40, currentY, pageSize.width - 80, 12),
    format: PdfStringFormat(alignment: PdfTextAlignment.left),
  );

  currentY += 40;

  // Crear la tabla
  final PdfGrid grid = PdfGrid();
  grid.columns.add(count: 12);

  // Ajustar ancho de la primera columna
  grid.columns[0].width = 30;

  // Estilo para encabezados sombreados
  final PdfGridCellStyle headerStyle = PdfGridCellStyle(
    font: boldFont,
    backgroundBrush: grayBrush,
    borders: PdfBorders(
        left: PdfPen(PdfColor(0, 0, 0)),
        right: PdfPen(PdfColor(0, 0, 0)),
        top: PdfPen(PdfColor(0, 0, 0)),
        bottom: PdfPen(PdfColor(0, 0, 0))),
  );

  // Estilo para celdas centradas
  final PdfGridCellStyle cellStyle = PdfGridCellStyle(
    font: font,
  );

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
    header.cells[i].style = headerStyle;
  }

  // Añadir datos dinámicos
  double totalCost = 0;
  for (int i = 0; i < bienesMuebles.length; i++) {
    final PdfGridRow row = grid.rows.add();
    var record = bienesMuebles[i];

    row.cells[0].value = (i + 1).toString();
    row.cells[1].value = record.numeroinventario ?? "Sin información";
    row.cells[2].value = record.numeroinventario ?? "Sin información";
    row.cells[3].value = record.descripciondelbien ?? "Sin información";
    row.cells[4].value = record.marcacomercial ?? "Sin información";
    row.cells[5].value = record.marcacomercial ?? "Sin información";
    row.cells[6].value = record.numeroseriedelbien ?? "Sin información";
    row.cells[7].value =
        "\$ ${record.importeinicialbien?.toStringAsFixed(2) ?? "0.00"}";
    row.cells[8].value = record.estatusdelbien ?? "Sin información";
    row.cells[9].value = record.comentarioadicional ?? "Sin información";
    row.cells[10].value = record.ubicacionfisica ?? "Sin información";
    row.cells[11].value = record.depositario ?? "Sin información";

    totalCost += record.importeinicialbien ?? 0;

    for (int j = 0; j < row.cells.count; j++) {
      row.cells[j].style = cellStyle;
    }

    // Verificar si se necesita agregar una nueva página
    if (currentY + 20 > pageSize.height) {
      currentPage = document.pages.add();
      currentY = 0;
    }
  }

  // Dibujar la tabla en la página
  grid.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
          0, currentY, pageSize.width, pageSize.height - currentY));

  currentY += 40;

  // Dibujar firmas y leyenda final
  final PdfPage finalPage = document.pages.add();

  finalPage.graphics.drawString(
    "DEPOSITARIOS",
    boldFont,
    bounds: Rect.fromLTWH(50, currentY, 200, 15),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );
  finalPage.graphics.drawString(
    "LIC. YANET LÓPEZ CAZARES - LIC. HÉCTOR ZAPATA FRANCO - LIC. MARIANO CANDELARIO ARAUJO REYES",
    font,
    bounds: Rect.fromLTWH(50, currentY + 20, pageSize.width - 100, 15),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );
  finalPage.graphics.drawString(
    "AUXILIARES ADSCRITOS AL JUZGADO DE PROCESO Y PROCEDIMIENTO PENAL ORAL, DEL SEXTO DISTRITO JUDICIAL DE TUXPAN, VERACRUZ",
    font,
    bounds: Rect.fromLTWH(50, currentY + 40, pageSize.width - 100, 15),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );

  finalPage.graphics.drawString(
    "REVISO",
    boldFont,
    bounds: Rect.fromLTWH(pageSize.width - 250, currentY, 200, 15),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );
  finalPage.graphics.drawString(
    "LIC. RODOLFO ROJAS MELGAREJO",
    font,
    bounds: Rect.fromLTWH(pageSize.width - 250, currentY + 20, 200, 15),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );
  finalPage.graphics.drawString(
    "OFICIAL JUDICIAL, ADSCRITO AL DEPARTAMENTO DE CONTROL DE INVENTARIOS",
    font,
    bounds: Rect.fromLTWH(pageSize.width - 250, currentY + 40, 200, 15),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );

  finalPage.graphics.drawString(
    "El Depositario es el responsable del cuidado, uso adecuado de los bienes y de notificar al Departamento de Inventarios, de cualquier modificación que afecte al presente resguardo. Así como de notificar la pérdida, extravió, daño o menoscabo de los bienes enlistados, en observancia a los artículos 5 de la Ley de Responsabilidades Administrativas para el Estado de Veracruz de Ignacio de la Llave; 88, fracción II, 93 de la Ley de Adquisiciones, Arrendamientos, Administración y enajenación de bienes muebles del Estado de Veracruz de Ignacio de la Llave; y 31 del Reglamento Interior de la Dirección de administración del Consejo de Judicatura del Poder Judicial del Estado de Veracruz.”",
    font,
    bounds: Rect.fromLTWH(55, currentY + 90, pageSize.width - 110, 40),
    format: PdfStringFormat(alignment: PdfTextAlignment.left),
  );

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
