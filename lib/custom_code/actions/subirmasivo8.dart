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

Future<int> subirmasivo8(BuildContext context) async {
  try {
    // Seleccionar archivo
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'], // Solo permite archivos .xlsx
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

    // Decodificar el archivo Excel
    final excel = Excel.decodeBytes(fileBytes);
    final sheet = excel['Hoja1']; // Buscar la hoja llamada "Hoja1"

    if (sheet == null) {
      _mostrarUnicoDialogo(context, 'Aviso', 'No se encontró la hoja "Hoja1".');
      return 0;
    }

    // Campos obligatorios
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
      'cargotitular',
    ];

    final totalRows = sheet.rows.length - 1; // Número total de filas
    if (totalRows <= 0) {
      _mostrarUnicoDialogo(
          context, 'Aviso', 'El archivo no tiene datos válidos.');
      return 0;
    }

    int processedRows = 0; // Contador de filas procesadas

    // Mostrar progreso inicial
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Subiendo Datos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: 0),
              SizedBox(height: 10),
              Text('Procesando...'),
            ],
          ),
        );
      },
    );

    const int batchSize = 500; // Tamaño del lote
    for (int start = 1; start <= totalRows; start += batchSize) {
      final end = (start + batchSize - 1).clamp(1, totalRows);

      // Crear un lote de datos
      List<Map<String, dynamic>> batchData = [];
      for (int rowIndex = start; rowIndex <= end; rowIndex++) {
        final row = sheet.rows[rowIndex];
        if (row == null) continue;

        final Map<String, dynamic> data = {};
        for (int i = 0; i < fieldNames.length; i++) {
          final fieldName = fieldNames[i];
          final cell = row[i];
          String? cellValue = cell?.value?.toString();

          // Procesar los valores según el tipo
          switch (fieldName) {
            case 'fechademodificacion':
              data[fieldName] = Timestamp.now();
              break;
            case 'fechaadquisicion':
              DateTime? parsedDate = _parseDateValue(cellValue);
              data[fieldName] =
                  parsedDate != null ? Timestamp.fromDate(parsedDate) : null;
              break;
            case 'clasedeactivo':
              data[fieldName] = cellValue?.trim() ?? 'SIN INFORMACION';
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

      // Subir los datos del lote
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in batchData) {
        final docRef =
            FirebaseFirestore.instance.collection('bienesmuebles').doc();
        batch.set(docRef, doc);
      }
      await batch.commit(); // Enviar el lote a Firestore

      processedRows += batchData.length;

      // Actualizar el progreso en la interfaz
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Subiendo Datos'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: processedRows / totalRows),
                SizedBox(height: 10),
                Text('Procesando fila $processedRows de $totalRows'),
              ],
            ),
          );
        },
      );

      // Dar tiempo al sistema para manejar otras tareas
      await Future.delayed(Duration(milliseconds: 500));
    }

    Navigator.of(context, rootNavigator: true).pop();

    // Mostrar mensaje de éxito
    _mostrarUnicoDialogo(
        context, 'Éxito', 'Se procesaron $processedRows filas exitosamente.');

    return processedRows; // Número de filas procesadas
  } catch (e) {
    Navigator.of(context, rootNavigator: true).pop();
    _mostrarUnicoDialogo(context, 'Error', 'Error general: $e');
    return 0;
  }
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
    'yyyy/MM/dd',
  ];
  for (var format in formats) {
    try {
      return DateFormat(format).parseStrict(value);
    } catch (_) {}
  }

  return null;
}

// Función para mostrar un diálogo único
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
