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
import 'dart:html' as html;

Future<void> descargarBienesDesdeFirebase(BuildContext context) async {
  // Mostrar diálogo de carga con estado inicial
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text('Descargando datos...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Preparando lista de bienes...'),
        ],
      ),
    ),
  );

  try {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('bienesmuebles').get();

    final docs = querySnapshot.docs;
    if (docs.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ No hay registros disponibles.')),
      );
      return;
    }

    // Validación para evitar duplicados por inventario2025
    final Map<String, Map<String, dynamic>> mapa = {};
    for (var doc in docs) {
      final data = doc.data();
      final inv = (data['inventario2025'] ?? '').toString().trim();
      if (inv.isEmpty) continue;
      mapa[inv] = data;
    }

    final registros = mapa.values.toList();

    // Crear Excel
    final excel = Excel.createExcel();
    final sheet = excel['Bienes'];
    final headers = [
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
      'anexo'
    ];

    for (int col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = headers[col];
    }

    // Evitar congelamiento con batches
    for (int row = 0; row < registros.length; row++) {
      final data = registros[row];
      for (int col = 0; col < headers.length; col++) {
        final key = headers[col];
        dynamic value = data[key];

        if (value is Timestamp) {
          value = DateFormat('dd/MM/yyyy').format(value.toDate());
        }
        if (value == null || value.toString().trim().isEmpty) {
          value = '----';
        }

        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1))
            .value = value.toString();
      }

      if (row % 100 == 0) {
        await Future.delayed(const Duration(milliseconds: 5));
      }
    }

    final bytes = excel.encode();
    Navigator.of(context).pop();

    if (bytes == null) {
      throw Exception('Error al codificar el archivo Excel.');
    }

    final fileName =
        'BienesMuebles_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';

    if (kIsWeb) {
      final blob = html.Blob([bytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Excel generado sin duplicados.')),
    );
  } catch (e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Error al generar Excel: \$e')),
    );
  }
}
