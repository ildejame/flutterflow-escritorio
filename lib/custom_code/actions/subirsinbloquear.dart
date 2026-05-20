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

import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

Future<int> subirsinbloquear(BuildContext context) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result == null) {
      _mostrarUnicoDialogo(
          context, 'Aviso', 'No se seleccionó ningún archivo.');
      return 0;
    }

    final fileBytes = result.files.first.bytes;
    if (fileBytes == null) {
      _mostrarUnicoDialogo(
          context, 'Error', 'No se pudieron leer los bytes del archivo.');
      return 0;
    }

    final excel = Excel.decodeBytes(fileBytes);
    final sheet = excel['Hoja1'];
    if (sheet == null) {
      _mostrarUnicoDialogo(context, 'Aviso', 'No se encontró la hoja "Hoja1".');
      return 0;
    }

    final totalRows = sheet.rows.length - 1;
    if (totalRows <= 0) {
      _mostrarUnicoDialogo(
          context, 'Aviso', 'El archivo no tiene datos válidos.');
      return 0;
    }

    final StreamController<String> statusController =
        StreamController<String>();

    // Mostrar progreso en un diálogo persistente
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StreamBuilder<String>(
          stream: statusController.stream,
          initialData: "Preparando...",
          builder: (context, snapshot) {
            return AlertDialog(
              title: Text(snapshot.data ?? "Cargando..."),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(),
                  SizedBox(height: 10),
                  Text(snapshot.data ?? ""),
                ],
              ),
            );
          },
        );
      },
    );

    // Cambia el mensaje a "Analizando archivo..."
    statusController.add("Analizando archivo...");

    final processedData = await compute(
        _procesarExcel, {'sheet': sheet.rows, 'totalRows': totalRows});

    // Cambia el mensaje a "Subiendo datos..."
    statusController.add("Subiendo datos...");

    int processedRows =
        await _subirDatosFirestore(processedData, statusController, totalRows);

    statusController.close();
    Navigator.of(context, rootNavigator: true).pop();

    _mostrarUnicoDialogo(
        context, 'Éxito', 'Se procesaron $processedRows filas exitosamente.');
    return processedRows;
  } catch (e) {
    _mostrarUnicoDialogo(context, 'Error', 'Error general: $e');
    return 0;
  }
}

// Procesamiento en segundo plano
List<Map<String, dynamic>> _procesarExcel(Map<String, dynamic> params) {
  List<List<Data?>> sheet = params['sheet'];
  int totalRows = params['totalRows'];

  final fieldNames = [
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
    'cargotitular'
  ];

  List<Map<String, dynamic>> batchData = [];

  for (int rowIndex = 1; rowIndex <= totalRows; rowIndex++) {
    final row = sheet[rowIndex];
    if (row == null) continue;

    final Map<String, dynamic> data = {};
    for (int i = 0; i < fieldNames.length; i++) {
      final fieldName = fieldNames[i];
      final cell = row[i];
      String? cellValue = cell?.value?.toString();

      switch (fieldName) {
        case 'fechademodificacion':
          data[fieldName] = Timestamp.now();
          break;
        case 'fechaadquisicion':
          DateTime? parsedDate = _parseDateValue(cellValue);
          data[fieldName] =
              parsedDate != null ? Timestamp.fromDate(parsedDate) : null;
          break;
        case 'importeinicialbien':
        case 'depreciacion':
          data[fieldName] = double.tryParse(cellValue ?? '') ?? 0.0;
          break;
        case 'aniofiscal':
          data[fieldName] = int.tryParse(cellValue ?? '') ?? 2000;
          break;
        default:
          data[fieldName] = cellValue?.trim() ?? 'SIN INFORMACION';
          break;
      }
    }
    data['fechaalta'] = Timestamp.now();
    batchData.add(data);
  }

  return batchData;
}

// Subir datos en lotes a Firestore
Future<int> _subirDatosFirestore(List<Map<String, dynamic>> batchData,
    StreamController<String> statusController, int totalRows) async {
  const int batchSize = 500;
  int processedRows = 0;

  for (int start = 0; start < totalRows; start += batchSize) {
    final end = (start + batchSize).clamp(0, totalRows);
    final batch = FirebaseFirestore.instance.batch();

    for (var i = start; i < end; i++) {
      final docRef =
          FirebaseFirestore.instance.collection('bienesmuebles').doc();
      batch.set(docRef, batchData[i]);
    }

    await batch.commit();
    processedRows += (end - start);

    statusController.add(
        "Subiendo datos... ${((processedRows / totalRows) * 100).toStringAsFixed(1)}%");
    await Future.delayed(Duration(milliseconds: 300));
  }

  return processedRows;
}

// Función para parsear fechas
DateTime? _parseDateValue(String? value) {
  if (value == null || value.isEmpty) return null;

  try {
    return DateTime.parse(value);
  } catch (_) {}

  try {
    double? doubleValue = double.tryParse(value);
    if (doubleValue != null) {
      return DateTime.fromMillisecondsSinceEpoch(
          (doubleValue.toInt() - 25569) * 86400000);
    }
  } catch (_) {}

  final formats = [
    'yyyy-MM-dd',
    'dd/MM/yyyy',
    'MM/dd/yyyy',
    'dd-MM-yyyy',
    'MM-dd-yyyy',
    'yyyy/MM/dd'
  ];
  for (var format in formats) {
    try {
      return DateFormat(format).parseStrict(value);
    } catch (_) {}
  }

  return null;
}

// Mostrar mensaje en pantalla
void _mostrarUnicoDialogo(BuildContext context, String title, String content) {
  Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
