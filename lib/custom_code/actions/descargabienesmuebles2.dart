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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:html' as html; // Solo se usa en Web
import 'dart:io' as io; // Solo para móviles y escritorio (ignorado en Web)

Future<void> descargabienesmuebles2(BuildContext context) async {
  try {
    // Mostrar diálogo de carga simple
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Descargando...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Obteniendo registros, por favor espere...'),
          ],
        ),
      ),
    );

    // Obtener TODOS los documentos sin filtros ni orden
    final querySnapshot =
        await FirebaseFirestore.instance.collection('bienesmuebles').get();

    final docs = querySnapshot.docs;
    final total = docs.length;

    if (total == 0) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron registros.')),
      );
      return;
    }

    // Crear nuevo Excel y hoja
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Define los encabezados que quieres exportar
    final List<String> headers = [
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
      'anexo',
    ];

    // Escribir encabezados en la primera fila
    for (var col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = headers[col];
    }

    // Escribir datos fila por fila
    for (var rowIndex = 0; rowIndex < total; rowIndex++) {
      final doc = docs[rowIndex].data();

      for (var colIndex = 0; colIndex < headers.length; colIndex++) {
        final field = headers[colIndex];
        dynamic value = doc[field];

        // Convertir Timestamps a String formato dd/MM/yyyy
        if (value is Timestamp) {
          value = DateFormat('dd/MM/yyyy').format(value.toDate());
        }

        // Convertir null o vacíos a '----'
        if (value == null || (value is String && value.trim().isEmpty)) {
          value = '----';
        }

        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: rowIndex + 1))
            .value = value.toString();
      }

      // Pequeña pausa para no bloquear UI si hay muchos datos
      if (rowIndex % 200 == 0) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
    }

    // Codificar Excel a bytes
    final excelBytes = await excel.encode();

    Navigator.of(context).pop(); // Cerrar diálogo

    final fileName =
        'BienesMuebles_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';

    if (excelBytes == null) {
      throw Exception('Error al codificar el archivo Excel.');
    }

    if (kIsWeb) {
      // Descarga en Web
      final blob = html.Blob([excelBytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Excel descargado exitosamente.')),
      );
    } else {
      // Guarda en dispositivo (móvil/desktop)
      final directory = io.Directory.systemTemp;
      final file = io.File('${directory.path}/$fileName');
      await file.writeAsBytes(excelBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Archivo guardado en: ${file.path}')),
      );
    }
  } catch (e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Error: $e')),
    );
  }
}
