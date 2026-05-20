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

import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart' as excel;

Future<void> downloadCollectionAsExcel2(List<PagosAnualesRecord>? promo) async {
  promo = promo ?? [];

  var excelFile = excel.Excel.createExcel();
  var sheet = excelFile['Sheet1'] ?? excelFile[excelFile.tables.keys.first];

  // Header row
  sheet.appendRow([
    "NombreCobrador",
    "Cantidad",
    "Fecha",
    "NombreComercio",
  ]);

  // Data rows
  promo.forEach((record) {
    sheet.appendRow([
      record.nombreCobrador,
      record.cantidad?.round() ?? 0,
      record.fecha,
      record.qRAnualTicket,
    ]);
  });

  var dir = await getExternalStorageDirectory();
  var file = "${dir!.path}/CobrosAnual_${DateTime.now()}.xlsx";

  // Check if there is any data in the Excel file before saving
  if (excelFile.tables.isNotEmpty) {
    // Write data to file only if there is data
    await File(file).writeAsBytes(excelFile.encode()!);
  } else {
    print("No data in the Excel file. File not saved.");
    return;
  }

  // Open the file using the platform's default viewer
  if (await File(file).exists()) {
    await Process.run('open', [file]);
    print("Excel file saved at: $file");
  } else {
    print("File not found: $file");
  }
}
