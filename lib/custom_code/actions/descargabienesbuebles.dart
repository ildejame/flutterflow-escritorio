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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;

Future<void> descargabienesbuebles(List<BienesmueblesRecord>? records) async {
  records = records ?? [];

  List<String> headers = [
    'inventario2025',
    'categoria',
    'fechademodificacion',
    'encargado',
    'verificavs',
    'folioresguardo',
    'cotejodoc',
    'numeroinventario',
    'inventario',
    'nombre',
    'marcacomercial',
    'modelo',
    'numeroseriedelbien',
    'importeinicialbien',
    'estatusdelbien',
    'descripciondelbien',
    'ubicacionfisica',
    'depositario',
    'color',
    'fechaadquisicion',
    'licitacion',
    'origenrecurso',
    'tiporecurso',
    'factura',
    'nombredelprovedor',
    'depreciacion',
    'clasedeactivo',
    'aniofiscal',
    'nivel1organizacion',
    'nivel2direccion',
    'nivel3jurisdiccion',
    'inmueble',
    'distrito',
    'zona',
    'cargo',
    'comentarioadicional',
    'serimonitor',
    'serieteclado',
    'seriemouse',
    'placa',
    'tituladelbien',
    'cargotitular',
  ];

  List<List<dynamic>> excelData = [headers];

  for (var r in records) {
    excelData.add([
      r.inventario2025 ?? '',
      r.categoria ?? '',
      r.fechademodificacion != null
          ? DateFormat('dd/MM/yyyy').format(r.fechademodificacion!)
          : '',
      r.encargado ?? '',
      r.verificavs ?? '',
      r.folioresguardo ?? '',
      r.cotejodoc ?? '',
      r.numeroinventario ?? '',
      r.inventario ?? '',
      r.nombre ?? '',
      r.marcacomercial ?? '',
      r.modelo ?? '',
      r.numeroseriedelbien ?? '',
      r.importeinicialbien?.toString() ?? '',
      r.estatusdelbien ?? '',
      r.descripciondelbien ?? '',
      r.ubicacionfisica ?? '',
      r.depositario ?? '',
      r.color ?? '',
      r.fechaadquisicion != null
          ? DateFormat('dd/MM/yyyy').format(r.fechaadquisicion!)
          : '',
      r.licitacion ?? '',
      r.origenrecurso ?? '',
      r.tiporecurso ?? '',
      r.factura ?? '',
      r.nombredelprovedor ?? '',
      r.depreciacion?.toString() ?? '',
      r.clasedeactivo ?? '',
      r.aniofiscal ?? '',
      r.nivel1organizacion ?? '',
      r.nivel2direccion ?? '',
      r.nivel3jurisdiccion ?? '',
      r.inmueble ?? '',
      r.distrito ?? '',
      r.zona ?? '',
      r.cargo ?? '',
      r.comentarioadicional ?? '',
      r.serimonitor ?? '',
      r.serieteclado ?? '',
      r.seriemouse ?? '',
      r.placa ?? '',
      r.tituladelbien ?? '',
      r.cargotitular ?? '',
    ]);
  }

  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  var headerStyle = CellStyle(
    bold: true,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );

  for (var i = 0; i < headers.length; i++) {
    var cell =
        sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i));
    cell.value = headers[i];
    cell.cellStyle = headerStyle;
  }

  for (var i = 1; i < excelData.length; i++) {
    sheet.appendRow(excelData[i]);
  }

  final fileName =
      'BienesMuebles_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
  final excelBytes = await excel.encode();

  if (excelBytes == null) {
    print('❌ No se pudieron obtener los bytes del archivo Excel.');
    return;
  }

  if (kIsWeb) {
    final blob = html.Blob([excelBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    try {
      final io.Directory? directory =
          await DownloadsPathProvider.downloadsDirectory;

      if (directory == null) {
        print('❌ No se pudo obtener la carpeta de descargas');
        return;
      }

      final String filePath = '${directory.path}/$fileName';
      final io.File file = io.File(filePath);
      await file.writeAsBytes(excelBytes);
      print('✅ Archivo guardado en: $filePath');
    } catch (e) {
      print('❌ Error al guardar el archivo Excel: $e');
    }
  }
}
