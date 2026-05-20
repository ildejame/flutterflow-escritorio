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
import 'package:excel/excel.dart';
import 'package:intl/intl.dart'; // Biblioteca para formateo de fechas

Future<void> generateExcelBienesMuebles4(
    List<BienesmueblesRecord>? bienesMuebles) async {
  bienesMuebles = bienesMuebles ?? [];

  // Crear un libro de Excel
  var excel = Excel.createExcel();
  var sheet = excel['Bienes Muebles'];

  // Configurar encabezados generales
  sheet.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("L1"));
  sheet.cell(CellIndex.indexByString("A1")).value =
      "PODER JUDICIAL DEL ESTADO DE VERACRUZ";
  sheet.cell(CellIndex.indexByString("A1")).cellStyle = CellStyle(
    bold: true,
    fontSize: 14,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );

  sheet.merge(CellIndex.indexByString("A2"), CellIndex.indexByString("L2"));
  sheet.cell(CellIndex.indexByString("A2")).value =
      "RESGUARDO DE BIENES MUEBLES";
  sheet.cell(CellIndex.indexByString("A2")).cellStyle = CellStyle(
    bold: true,
    fontSize: 12,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );

  sheet.merge(CellIndex.indexByString("A3"), CellIndex.indexByString("L3"));
  sheet.cell(CellIndex.indexByString("A3")).value =
      "301C13001 CONSEJO DE LA JUDICATURA";
  sheet.cell(CellIndex.indexByString("A3")).cellStyle = CellStyle(
    bold: true,
    fontSize: 12,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );

  // Información adicional
  sheet.cell(CellIndex.indexByString("A5")).value =
      "FECHA: 05 DE DICIEMBRE DE 2024";
  sheet.cell(CellIndex.indexByString("A6")).value =
      "UBICACIÓN: JUZGADO DE PROCESO Y PROCEDIMIENTO PENAL ORAL";
  sheet.cell(CellIndex.indexByString("A7")).value =
      "DEPOSITARIO: LIC. YANET LÓPEZ CAZARES, 735002 // LIC. HÉCTOR ZAPATA FRANCO, G26204 // LIC. MARIANO CANDELARIO ARAUJO REYES, 1007064";
  sheet.cell(CellIndex.indexByString("A8")).value =
      "DISTRITO JUDICIAL: VI. TUXPAN, VERACRUZ";

  // Encabezado de la tabla
  final List<String> headers = [
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

  // Escribir encabezados en la fila 10
  for (int i = 0; i < headers.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 9)).value =
        headers[i];
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 9))
        .cellStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: "#D9D9D9",
    );
  }

  // Añadir los datos dinámicos
  for (int i = 0; i < bienesMuebles.length; i++) {
    final record = bienesMuebles[i];
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 10 + i))
        .value = i + 1;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 10 + i))
        .value = record.numeroinventario ?? "N/A";
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 10 + i))
        .value = record.numeroinventario ?? "N/A";
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 10 + i))
        .value = record.descripciondelbien ?? "N/A";
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 10 + i))
        .value = record.marcacomercial ?? "N/A";
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 10 + i))
        .value = "Sin información";
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 10 + i))
        .value = record.numeroseriedelbien ?? "N/A";
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 10 + i))
        .value = record.importeinicialbien?.toStringAsFixed(2) ?? "0.00";
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 10 + i))
        .value = record.estatusdelbien ?? "N/A";
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 10 + i))
        .value = record.comentarioadicional ?? "N/A";
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 10 + i))
        .value = record.ubicacionfisica ?? "N/A";
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: 10 + i))
        .value = record.depositario ?? "N/A";
  }

  // Agregar leyenda final
  int lastRow = 10 + bienesMuebles.length + 2;
  sheet.merge(CellIndex.indexByString("A${lastRow}"),
      CellIndex.indexByString("L${lastRow + 1}"));
  sheet.cell(CellIndex.indexByString("A${lastRow}")).value =
      "El Depositario es el responsable del cuidado, uso adecuado de los bienes y de notificar al Departamento de Inventarios...";
  sheet.cell(CellIndex.indexByString("A${lastRow}")).cellStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Left, verticalAlign: VerticalAlign.Top);

  // Ajustar el ancho de las columnas manualmente
  for (int i = 0; i < headers.length; i++) {
    sheet.setColWidth(i, 25.0);
  }

  // Codificar el libro de Excel en una lista de bytes
  var excelBytes = excel.encode();

  // Crear un blob con los datos del libro de Excel
  var blob = html.Blob([excelBytes]);

  // Crear una URL para el blob
  var url = html.Url.createObjectUrlFromBlob(blob);

  // Crear un enlace para iniciar la descarga
  var anchor = html.AnchorElement(href: url)
    ..target = 'webbrowser'
    ..download = 'BienesMuebles_${DateTime.now()}.xlsx'
    ..click();

  // Liberar la URL
  html.Url.revokeObjectUrl(url);
}
