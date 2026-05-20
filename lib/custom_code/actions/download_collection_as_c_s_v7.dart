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
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart'; // Importa la biblioteca intl

Future<void> downloadCollectionAsCSV7(
    List<EstablecimientosRecord>? promo) async {
  promo = promo ?? [];

  // Crear una lista para contener los datos CSV
  List<List<dynamic>> csvData = [
    [
      "NombreEstablecimiento",
      "NombrePropietario",
      "Movimiento",
      "GiroDeColeccion",
      "FotoLocal",
      "Fecha",
      "Posicion",
      "CodigoQR"
    ]
  ];

  // Agregar datos a la lista CSV
  promo.forEach((record) {
    // Verificar si la fecha es nula
    var formattedFecha = record.fecha != null
        ? DateFormat('dd/MM/yyyy').format(record.fecha!)
        : '';

    csvData.add([
      record.nombreEstablecimiento,
      record.nombrePropietario,
      record.movimiento,
      record.giroDeColeccion,
      record.fotoLocal,
      formattedFecha, // Usar la fecha formateada o una cadena vacía si es nula
      "${record.posicion!.latitude}|${record.posicion?.longitude}",
      record.codigoQR,
    ]);
  });

  // Crear un libro de Excel
  var excel = Excel.createExcel();

  // Agregar una hoja de trabajo al libro
  var sheet = excel['Sheet1'];

  // Establecer estilos para la fila de encabezado (centrado y en negrita)
  var cellStyle = CellStyle(
    bold: true,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );

  // Agregar la fila de encabezado a la hoja de trabajo con estilos
  for (var i = 0; i < csvData[0].length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).value =
        csvData[0][i];
    sheet
        .cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i))
        .cellStyle = cellStyle;
  }

  // Agregar los datos restantes a la hoja de trabajo
  for (var i = 1; i < csvData.length; i++) {
    sheet.appendRow(csvData[i]);
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
    ..download = 'Establecimientos_${DateTime.now()}.xlsx'
    ..click();

  // Liberar la URL y el enlace
  html.Url.revokeObjectUrl(url);
}
