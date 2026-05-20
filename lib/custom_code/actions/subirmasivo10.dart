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

Future<int> subirmasivo10(BuildContext context) async {
  int totalFilasProcesadas = 0;
  final failedFiles = <String>[];
  final processingNotifier =
      ValueNotifier<String>('Iniciando procesamiento...');
  bool isProcessing = false;

  void showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ValueListenableBuilder<String>(
        valueListenable: processingNotifier,
        builder: (context, message, _) => AlertDialog(
          title: const Text('Procesando archivos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(message),
              const SizedBox(height: 10),
              const Text(
                'Por favor espere, este proceso puede tomar tiempo...',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateProgress(String message) {
    processingNotifier.value = message;
  }

  try {
    final bool? quiereMultiples = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modo de subida'),
        content: const Text('¿Cómo deseas subir los archivos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Un solo archivo'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Múltiples archivos'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (quiereMultiples == null) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Aviso'),
          content: const Text('Operación cancelada por el usuario.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return 0;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: quiereMultiples,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Aviso'),
          content: const Text('No se seleccionó ningún archivo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return 0;
    }

    isProcessing = true;
    showProcessingDialog();
    updateProgress('Preparando ${result.files.length} archivo(s)...');

    for (int fileIndex = 0; fileIndex < result.files.length; fileIndex++) {
      final file = result.files[fileIndex];
      final fileName = file.name;

      updateProgress(
          'Procesando archivo ${fileIndex + 1}/${result.files.length}: $fileName\n'
          'Filas procesadas: $totalFilasProcesadas');

      await Future.delayed(const Duration(milliseconds: 50));

      try {
        final fileBytes = file.bytes;
        if (fileBytes == null || fileBytes.isEmpty) {
          failedFiles.add(fileName);
          continue;
        }

        updateProgress('Leyendo archivo $fileName...');
        final excel = Excel.decodeBytes(fileBytes);
        final sheet = excel.tables[excel.tables.keys.first];

        if (sheet == null || sheet.rows.isEmpty) {
          failedFiles.add(fileName);
          continue;
        }

        final uploadResult =
            await _procesarYSubirArchivo(sheet, (progress, total) {
          updateProgress(
              'Procesando archivo ${fileIndex + 1}/${result.files.length}: $fileName\n'
              'Progreso: $progress/$total filas\n'
              'Total procesadas: $totalFilasProcesadas');
        });

        totalFilasProcesadas += uploadResult;
      } catch (e) {
        failedFiles.add(fileName);
        debugPrint('Error procesando archivo $fileName: $e');
      }
    }

    Navigator.of(context, rootNavigator: true).pop();
    isProcessing = false;

    final resultMessage = failedFiles.isEmpty
        ? '¡Todos los archivos se procesaron correctamente!\n'
            'Total de registros subidos: $totalFilasProcesadas'
        : 'Se procesaron $totalFilasProcesadas registros correctamente.\n'
            '${failedFiles.length} archivos tuvieron problemas.';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(failedFiles.isEmpty ? 'Éxito' : 'Resultado parcial'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(resultMessage),
              if (failedFiles.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Archivos con problemas:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...failedFiles.map((file) => Text('• $file')).toList(),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );

    return totalFilasProcesadas;
  } catch (e) {
    if (isProcessing) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error crítico'),
        content: Text('Ocurrió un error inesperado:\n${e.toString()}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return totalFilasProcesadas;
  }
}

Future<int> _procesarYSubirArchivo(
  Sheet sheet,
  void Function(int progress, int total) onProgress,
) async {
  final List<Map<String, dynamic>> datos = [];
  const batchSize = 100;
  const reportInterval = 10;

  final fieldNames = [
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
    'avaluo',
    'anexo',
    'fechaavaluo' // Campo añadido para fecha de avalúo
  ];

  for (int i = 1; i < sheet.rows.length; i++) {
    final row = sheet.rows[i];
    if (row == null) continue;

    final data = <String, dynamic>{};

    for (int j = 0; j < fieldNames.length; j++) {
      final fieldName = fieldNames[j];
      final cell = j < row.length ? row[j] : null;
      var cellValue = cell?.value?.toString()?.trim();

      switch (fieldName) {
        case 'fechademodificacion':
        case 'fechaadquisicion':
        case 'fechaavaluo': // Manejo especial para fecha de avalúo
          data[fieldName] = _parsearFecha(cellValue);
          break;
        case 'importeinicialbien':
        case 'depreciacion':
        case 'avaluo': // Manejo especial para valores monetarios
          data[fieldName] = _parsearValorMonetario(cellValue);
          debugPrint(
              'Campo $fieldName - Original: $cellValue - Parseado: ${data[fieldName]}');
          break;
        case 'aniofiscal':
          data[fieldName] = int.tryParse(cellValue ?? '') ?? 2000;
          break;
        default:
          data[fieldName] = cellValue ?? '';
          break;
      }
    }

    data['fechaalta'] = FieldValue.serverTimestamp();
    datos.add(data);

    if (i % reportInterval == 0) {
      onProgress(i, sheet.rows.length);
      await Future.delayed(const Duration(milliseconds: 10));
    }

    if (i % batchSize == 0) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  return await _subirDatosFirebase(datos, onProgress);
}

double _parsearValorMonetario(String? value) {
  if (value == null || value.isEmpty) return 0.0;

  try {
    // Eliminar símbolos de moneda y espacios
    String cleaned = value.replaceAll(RegExp(r'[^\d.,-]'), '');

    // Detectar formato
    bool isEuropeanFormat = cleaned.contains(',') &&
        (cleaned.indexOf(',') > (cleaned.indexOf('.') ?? -1));

    // Normalizar formato
    if (isEuropeanFormat) {
      cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
    } else {
      cleaned = cleaned.replaceAll(',', '');
    }

    // Convertir a double
    final result = double.tryParse(cleaned) ?? 0.0;
    debugPrint(
        'Parseo monetario - Original: $value - Limpio: $cleaned - Resultado: $result');
    return result;
  } catch (e) {
    debugPrint('Error parseando valor monetario: $value - Error: $e');
    return 0.0;
  }
}

Future<int> _subirDatosFirebase(
  List<Map<String, dynamic>> datos,
  void Function(int progress, int total) onProgress,
) async {
  if (datos.isEmpty) return 0;

  const batchSize = 200;
  int totalSubidas = 0;
  int totalFilas = datos.length;

  try {
    for (int i = 0; i < datos.length; i += batchSize) {
      final batch = FirebaseFirestore.instance.batch();
      final end = i + batchSize < datos.length ? i + batchSize : datos.length;

      for (int j = i; j < end; j++) {
        final docRef =
            FirebaseFirestore.instance.collection('bienesmuebles').doc();
        batch.set(docRef, datos[j]);
      }

      await batch.commit();
      totalSubidas += end - i;
      onProgress(totalSubidas, totalFilas);
      await Future.delayed(const Duration(milliseconds: 100));
    }
  } catch (e) {
    debugPrint('Error subiendo datos a Firebase: $e');
    return totalSubidas;
  }

  return totalSubidas;
}

DateTime? _parsearFecha(String? value) {
  if (value == null || value.isEmpty) return null;

  try {
    // Intenta parsear directamente como fecha ISO
    if (value.contains('-') || value.contains('/')) {
      return DateTime.parse(value);
    }

    // Intenta parsear como número serial de Excel
    final excelDate = double.tryParse(value);
    if (excelDate != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        ((excelDate - 25569) * 86400000).toInt(),
        isUtc: true,
      );
    }

    return null;
  } catch (e) {
    debugPrint('Error parseando fecha: $value - Error: $e');
    return null;
  }
}
