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
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'dart:math';
import 'package:image/image.dart' as img;

Future<int> cardex(BuildContext context) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    // Paso 1: Preguntar si se subirá con o sin imagen
    final bool? subirConImagen = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tipo de subida'),
        content: const Text('¿Deseas subir los datos con una imagen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Subir sin imagen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Subir con imagen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (subirConImagen == null) return 0;

    // PASO 2: SELECCIONAR ARCHIVOS EN UN SOLO PASO
    List<String> allowedExtensions = ['xlsx'];
    if (subirConImagen) {
      allowedExtensions.addAll(['jpg', 'jpeg', 'png']);
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: true,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('No se seleccionó ningún archivo.')));
      return 0;
    }

    // Validar y separar los archivos
    PlatformFile? imageFile;
    PlatformFile? excelFile;

    for (var file in result.files) {
      final extension = file.extension?.toLowerCase();
      if (extension == 'xlsx') {
        excelFile = file;
      } else if (['jpg', 'jpeg', 'png'].contains(extension)) {
        imageFile = file;
      }
    }

    if (excelFile == null) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Error: Debes seleccionar un archivo Excel (.xlsx).')));
      return 0;
    }

    if (subirConImagen && imageFile == null) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Error: Debes seleccionar una imagen (.jpg, .png).')));
      return 0;
    }

    // --- A PARTIR DE AQUÍ, TODAS LAS OPERACIONES LARGAS ---
    final processingNotifier = ValueNotifier<String>('Iniciando proceso...');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ValueListenableBuilder<String>(
        valueListenable: processingNotifier,
        builder: (context, message, _) => AlertDialog(
          title: const Text('Procesando'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(message),
            ],
          ),
        ),
      ),
    );

    void updateProgress(String message) {
      processingNotifier.value = message;
    }

    String? imageUrl;

    // Paso 3: Si hay imagen, redimensionar y subirla optimizada
    if (imageFile != null) {
      updateProgress('Redimensionando y optimizando imagen...');

      final originalBytes = imageFile.bytes!;
      final originalImage = img.decodeImage(originalBytes);
      if (originalImage == null) {
        throw Exception('No se pudo leer la imagen seleccionada.');
      }

      // --- Calcular dimensiones nuevas ---
      const maxWidth = 800;
      const maxHeight = 800;
      int newWidth = originalImage.width;
      int newHeight = originalImage.height;

      if (newWidth > maxWidth || newHeight > maxHeight) {
        final aspectRatio = newWidth / newHeight;
        if (aspectRatio > 1) {
          newWidth = maxWidth;
          newHeight = (maxWidth / aspectRatio).round();
        } else {
          newHeight = maxHeight;
          newWidth = (maxHeight * aspectRatio).round();
        }
      }

      final resizedImage = img.copyResize(
        originalImage,
        width: newWidth,
        height: newHeight,
      );

      // --- Comprimir hasta ~50 KB ---
      int quality = 85;
      Uint8List? finalBytes;
      for (int q = quality; q >= 40; q -= 5) {
        final compressed =
            Uint8List.fromList(img.encodeJpg(resizedImage, quality: q));
        if (compressed.lengthInBytes <= 50 * 1024) {
          finalBytes = compressed;
          break;
        }
        if (q == 40) finalBytes = compressed;
      }

      updateProgress('Subiendo imagen optimizada...');
      final now = DateTime.now();
      final timestamp =
          "${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}";

      final fileName = "imagen_$timestamp.jpg";
      final storageRef =
          FirebaseStorage.instance.ref().child('imagenes_bienes/$fileName');
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final uploadTask = await storageRef.putData(finalBytes!, metadata);
      imageUrl = await uploadTask.ref.getDownloadURL();
    }

    // Paso 4: Procesar el Excel
    updateProgress('Leyendo archivo Excel...');
    final excel = Excel.decodeBytes(excelFile.bytes!);
    final sheet = excel.tables[excel.tables.keys.first];

    if (sheet == null || sheet.rows.length <= 1) {
      Navigator.of(context, rootNavigator: true).pop();
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('El archivo Excel está vacío o no es válido.')));
      return 0;
    }

    updateProgress('Procesando filas y subiendo a Firestore...');
    final uploadResult = await _procesarYSubirArchivoCardex(
      sheet,
      (progress, total) {
        updateProgress('Procesando fila $progress de $total...');
      },
      imageUrl,
    );

    Navigator.of(context, rootNavigator: true).pop();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Proceso Completado!'),
        content: Text('Se subieron $uploadResult registros correctamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    return uploadResult;
  } catch (e) {
    Navigator.of(context, rootNavigator: true).pop();
    scaffoldMessenger
        .showSnackBar(SnackBar(content: Text('Error crítico: $e')));
    return 0;
  }
}

// --- Las funciones auxiliares ---
Future<int> _procesarYSubirArchivoCardex(
  Sheet sheet,
  void Function(int progress, int total) onProgress,
  String? imageUrl,
) async {
  final List<Map<String, dynamic>> datos = [];

  // 🔹 Se agregaron 'cotejodoc' y 'zona' al final
  const fieldNames = [
    'inventario2025',
    'numeroinventario',
    'verificavs',
    'foliocontable',
    'descripciondelbien',
    'marcacomercial',
    'modelo',
    'color',
    'estatusdelbien',
    'nivel1organizacion',
    'nivel2direccion',
    'nivel3jurisdiccion',
    'clasedeactivo',
    'nombre',
    'tituladelbien',
    'tiporecurso',
    'importeinicialbien',
    'factura',
    'fechaadquisicion',
    'nombredelprovedor',
    'pif',
    'numeroseriedelbien',
    'seriemouse',
    'serieteclado',
    'seriedvd',
    'fechademodificacion',
    'folioresguardo',
    'cotejodoc',
    'zona',
    'foliovale',
  ];

  for (int i = 1; i < sheet.rows.length; i++) {
    final row = sheet.rows[i];
    if (row == null || row.every((cell) => cell?.value == null)) continue;

    final data = <String, dynamic>{};
    for (int j = 0; j < fieldNames.length; j++) {
      final fieldName = fieldNames[j];
      final cell = j < row.length ? row[j] : null;
      final cellValue = cell?.value?.toString()?.trim();

      switch (fieldName) {
        case 'fechaadquisicion':
        case 'fechademodificacion':
          data[fieldName] = _parsearFecha(cellValue);
          break;
        case 'importeinicialbien':
          data[fieldName] = _parsearValorMonetario(cellValue);
          break;
        default:
          data[fieldName] = cellValue ?? '';
          break;
      }
    }

    if (imageUrl != null) {
      data['imagenbien'] = imageUrl;
    }

    data['fechaalta'] = FieldValue.serverTimestamp();
    datos.add(data);
    onProgress(i, sheet.rows.length - 1);
  }

  return await _subirDatosFirebase(datos, onProgress);
}

Future<int> _subirDatosFirebase(
  List<Map<String, dynamic>> datos,
  void Function(int progress, int total) onProgress,
) async {
  if (datos.isEmpty) return 0;
  const batchSize = 500;
  int totalSubidas = 0;
  try {
    for (int i = 0; i < datos.length; i += batchSize) {
      final batch = FirebaseFirestore.instance.batch();
      final end = (i + batchSize < datos.length) ? i + batchSize : datos.length;
      for (int j = i; j < end; j++) {
        final docRef =
            FirebaseFirestore.instance.collection('bienesmuebles').doc();
        batch.set(docRef, datos[j]);
      }
      await batch.commit();
      totalSubidas += (end - i);
      onProgress(totalSubidas, datos.length);
    }
  } catch (e) {
    debugPrint('Error subiendo datos a Firebase: $e');
    throw Exception('Falló la subida de datos a Firestore: $e');
  }
  return totalSubidas;
}

double _parsearValorMonetario(String? value) {
  if (value == null || value.isEmpty) return 0.0;
  try {
    final cleaned = value.replaceAll(RegExp(r'[^\d.,-]'), '');
    final number = double.tryParse(cleaned.replaceAll(',', '.'));
    return number ?? 0.0;
  } catch (_) {
    return 0.0;
  }
}

DateTime? _parsearFecha(String? value) {
  if (value == null || value.isEmpty) return null;
  try {
    return DateTime.parse(value);
  } catch (_) {
    final excelDate = double.tryParse(value);
    if (excelDate != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        ((excelDate - 25569) * 86400000).round(),
        isUtc: true,
      );
    }
    return null;
  }
}
