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

import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math';

Future<int> subirmasivo9(BuildContext context) async {
  try {
    // 1. Preguntar al usuario si desea subir múltiples archivos
    final bool? quiereMultiples = await _mostrarDialogoSeleccionModo(context);
    if (quiereMultiples == null) return 0; // Usuario canceló

    // 2. Selección de archivos
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: quiereMultiples,
    );

    if (result == null || result.files.isEmpty) {
      await _mostrarDialogo(
          context, 'Aviso', 'No se seleccionó ningún archivo.');
      return 0;
    }

    // 3. Procesamiento con barra de progreso
    final progressDialog = _mostrarDialogoProgreso(
      context,
      quiereMultiples
          ? 'Procesando ${result.files.length} archivos...'
          : 'Procesando archivo...',
    );

    int totalFilasProcesadas = 0;
    int archivosProcesados = 0;
    int archivosConError = 0;

    for (final file in result.files) {
      try {
        progressDialog.updateMessage('Procesando: ${file.name}');

        final fileBytes = file.bytes;
        if (fileBytes == null) {
          archivosConError++;
          continue;
        }

        final excel = Excel.decodeBytes(fileBytes);
        final sheet = excel['Hoja1'] ?? excel[excel.tables.keys.first];

        if (sheet == null) {
          archivosConError++;
          continue;
        }

        // Validación compatible con estructura original
        final validationResult = await _validarExcelDataCompat(context, sheet);
        if (!validationResult.isValid) {
          archivosConError++;
          continue;
        }

        // Subida a Firebase manteniendo estructura original
        final uploadResult = await _subirAFirebaseCompat(
          context,
          validationResult.validData,
        );
        totalFilasProcesadas += uploadResult;
        archivosProcesados++;
      } catch (e) {
        archivosConError++;
      }
    }

    Navigator.of(context, rootNavigator: true).pop();

    // 4. Mostrar resultados
    await _mostrarDialogo(
      context,
      'Proceso completado',
      quiereMultiples
          ? 'Resultados:\n'
              '- Archivos procesados: $archivosProcesados\n'
              '- Archivos con errores: $archivosConError\n'
              '- Total filas subidas: $totalFilasProcesadas'
          : (totalFilasProcesadas > 0
              ? 'Se procesaron $totalFilasProcesadas filas correctamente'
              : 'Error al procesar el archivo'),
    );

    return totalFilasProcesadas;
  } catch (e) {
    await _mostrarDialogo(
        context, 'Error', 'Error inesperado: ${e.toString()}');
    return 0;
  }
}

// Diálogo para seleccionar modo de subida (corregido null safety)
Future<bool?> _mostrarDialogoSeleccionModo(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text('Modo de subida'),
      content: Text('¿Cómo deseas subir los archivos?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Un solo archivo'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Múltiples archivos'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

// Validación compatible con estructura original
Future<ValidationResult> _validarExcelDataCompat(
    BuildContext context, Sheet sheet) async {
  final QuerySnapshot depreciacionSnapshot =
      await FirebaseFirestore.instance.collection('depreciacion').get();

  final List<String> nombresValidos =
      depreciacionSnapshot.docs.map((doc) => doc['nombre'] as String).toList();

  // Campos obligatorios (idéntico al original)
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
    'cargotitular'
  ];

  // Validar estructura del archivo
  if (sheet.rows.isEmpty || sheet.rows[0].length != fieldNames.length) {
    return ValidationResult(
      isValid: false,
      errorMessage:
          'El archivo debe tener exactamente ${fieldNames.length} columnas.',
      validData: [],
    );
  }

  List<Map<String, dynamic>> validData = [];
  final appState = FFAppState();

  for (int i = 1; i < sheet.rows.length; i++) {
    final row = sheet.rows[i];
    if (row == null) continue;

    final data = <String, dynamic>{};
    bool filaValida = true;

    for (int j = 0; j < fieldNames.length; j++) {
      final fieldName = fieldNames[j];
      final cell = j < row.length ? row[j] : null;
      final cellValue = cell?.value?.toString()?.trim();

      // Procesamiento idéntico al original
      switch (fieldName) {
        case 'fechademodificacion':
          final fecha = _parsearFecha(cellValue);
          data[fieldName] =
              fecha != null ? Timestamp.fromDate(fecha) : Timestamp.now();
          break;

        case 'fechaadquisicion':
          final fecha = _parsearFecha(cellValue);
          if (fecha == null) {
            filaValida = false;
            break;
          }
          data[fieldName] = Timestamp.fromDate(fecha);
          break;

        case 'clasedeactivo':
          if (cellValue == null || !nombresValidos.contains(cellValue)) {
            filaValida = false;
            break;
          }
          data[fieldName] = cellValue;
          break;

        case 'depositario':
          data[fieldName] = _validarCampoLista(
              cellValue, appState.nombreempleadosAE, 'SIN DEPOSITARIO INICIAL');
          break;

        case 'encargado':
          data[fieldName] = _validarCampoLista(
              cellValue, appState.nombreempleadosAE, 'SIN ENCARGADO INICIAL');
          break;

        case 'tituladelbien':
          data[fieldName] = _validarCampoLista(
              cellValue, appState.nombreempleadosAE, 'SIN TITULAR INICIAL');
          break;

        case 'nivel1organizacion':
          data[fieldName] = _validarCampoLista(
              cellValue, appState.ubicacionnivel1, 'SIN INFORMACION');
          break;

        case 'nivel2direccion':
          data[fieldName] = _validarCampoLista(
              cellValue, appState.ubicacionnivel2, 'SIN INFORMACION');
          break;

        case 'nivel3jurisdiccion':
          data[fieldName] = _validarCampoLista(
              cellValue, appState.ubicacionnivel3, 'SIN INFORMACION');
          break;

        case 'numeroinventario':
          data[fieldName] = cellValue?.isNotEmpty == true
              ? cellValue
              : _generarNumeroInventario();
          break;

        case 'importeinicialbien':
        case 'depreciacion':
          data[fieldName] = double.tryParse(cellValue ?? '') ?? 0.0;
          break;

        case 'aniofiscal':
          data[fieldName] = int.tryParse(cellValue ?? '') ?? 2000;
          break;

        default:
          data[fieldName] = cellValue ?? 'SIN INFORMACION';
          break;
      }
    }

    if (filaValida) {
      data['fechaalta'] = Timestamp.now();
      validData.add(data);
    }
  }

  return ValidationResult(
    isValid: validData.isNotEmpty,
    errorMessage: validData.isEmpty ? 'No se encontraron datos válidos' : '',
    validData: validData,
  );
}

// Subida a Firebase compatible
Future<int> _subirAFirebaseCompat(
  BuildContext context,
  List<Map<String, dynamic>> datos,
) async {
  const batchSize = 500;
  int total = 0;

  for (int i = 0; i < datos.length; i += batchSize) {
    final batch = FirebaseFirestore.instance.batch();
    final end = i + batchSize < datos.length ? i + batchSize : datos.length;

    for (int j = i; j < end; j++) {
      final docRef =
          FirebaseFirestore.instance.collection('bienesmuebles').doc();
      batch.set(docRef, datos[j]);
    }

    await batch.commit();
    total += end - i;
    await Future.delayed(Duration(milliseconds: 100));
  }

  return total;
}

// Clase para resultados de validación
class ValidationResult {
  final bool isValid;
  final String errorMessage;
  final List<Map<String, dynamic>> validData;

  ValidationResult({
    required this.isValid,
    required this.errorMessage,
    required this.validData,
  });
}

// Funciones auxiliares
String _generarNumeroInventario() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return List.generate(12, (index) => chars[random.nextInt(chars.length)])
      .join();
}

String _validarCampoLista(
    String? valor, List<String> listaValida, String valorPorDefecto) {
  if (valor == null || valor.isEmpty) return valorPorDefecto;
  return listaValida.contains(valor) ? valor : valorPorDefecto;
}

DateTime? _parsearFecha(String? value) {
  if (value == null || value.isEmpty) return null;

  try {
    return DateTime.parse(value);
  } catch (_) {}

  try {
    final excelDate = double.tryParse(value);
    if (excelDate != null) {
      return DateTime.fromMillisecondsSinceEpoch(
          ((excelDate - 25569) * 86400000).toInt(),
          isUtc: true);
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

class ProgressDialog {
  final BuildContext context;
  late AlertDialog dialog;
  String baseMessage;

  ProgressDialog(this.context, this.baseMessage);

  void show() {
    dialog = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: 0),
          SizedBox(height: 16),
          Text(baseMessage),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => dialog,
    );
  }

  void updateMessage(String newMessage) {
    (dialog.content as Column).children[1] = Text(newMessage);
  }

  void updateProgress(int actual, int total) {
    final progress = actual / total;
    (dialog.content as Column).children[0] =
        LinearProgressIndicator(value: progress);
    (dialog.content as Column).children[1] =
        Text('$baseMessage\nProgreso: $actual/$total');
  }
}

ProgressDialog _mostrarDialogoProgreso(BuildContext context, String message) {
  final dialog = ProgressDialog(context, message);
  dialog.show();
  return dialog;
}

Future<void> _mostrarDialogo(
  BuildContext context,
  String titulo,
  String mensaje,
) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
