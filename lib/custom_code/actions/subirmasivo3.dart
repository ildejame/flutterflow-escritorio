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

// Librerías necesarias
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart'; // Para procesar Excel
import 'dart:convert'; // Para manejar la codificación UTF-8
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para guardar el progreso

Future<void> subirmasivo3() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // 1. Seleccionar el archivo Excel usando File Picker
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'], // Permitimos solo archivos Excel
    );

    if (result == null) {
      print('No se seleccionó ningún archivo.');
      return;
    }

    // 2. Leer el contenido del archivo Excel
    final fileBytes = result.files.first.bytes;
    final excel = Excel.decodeBytes(fileBytes!);

    // 3. Seleccionar la hoja activa
    final sheet = excel['fechasc'];
    if (sheet == null) {
      print('No se encontró la hoja "fechasc" en el archivo.');
      return;
    }

    // 4. Definir los nombres fijos de los campos en el formato deseado
    final fieldNames = [
      'nombre',
      'fechaalta',
      'fechaadquisicion',
      'fechademodificacion',
      'fechadebaja',
      'estatusdelbien',
      'escontable',
      'numeroinventario',
      'depositario',
      'importeinicialbien',
      'tituladelbien',
      'numeroseriedelbien',
      'aniofiscal',
      'ubicacionfisica',
      'factura',
      'nombredelprovedor',
      'cuentacontable',
      'marcacomercial',
      'color',
      'origenrecurso',
      'licitacion',
      'categoria',
      'descripciondeubicacion',
      'distrito',
      'placa',
      'descripciondelbien',
      'comentarioadicional',
    ];

    final totalRows = sheet.rows.length - 1;
    int processedRows = prefs.getInt('lastRowIndex') ?? 1;

    // 5. Procesar cada fila desde donde quedó el progreso
    for (int rowIndex = processedRows; rowIndex <= totalRows; rowIndex++) {
      final row = sheet.rows[rowIndex];
      final Map<String, dynamic> data = {};

      for (int i = 0; i < fieldNames.length; i++) {
        final fieldName = fieldNames[i];
        final cell = row[i];
        var value = cell?.value;

        // Convertir los valores según el tipo esperado
        if (fieldName == 'fechaalta' ||
            fieldName == 'fechaadquisicion' ||
            fieldName == 'fechademodificacion' ||
            fieldName == 'fechadebaja') {
          // Manejar fechas (convertir a Timestamp)
          if (value is String) {
            data[fieldName] = Timestamp.fromDate(
              DateTime.tryParse(value) ?? DateTime.now(),
            );
          } else if (value is DateTime) {
            data[fieldName] = Timestamp.fromDate(value);
          } else {
            data[fieldName] = Timestamp.fromDate(DateTime.now());
          }
        } else if (fieldName == 'importeinicialbien') {
          // Convertir a Double
          data[fieldName] = double.tryParse(value.toString()) ?? 0.0;
        } else if (fieldName == 'escontable') {
          // Convertir a Boolean
          data[fieldName] = value.toString().toLowerCase() == 'true';
        } else if (fieldName == 'aniofiscal') {
          // Convertir a Integer
          data[fieldName] = int.tryParse(value.toString()) ?? 0;
        } else {
          // Convertir a String (y limpiar caracteres extraños)
          data[fieldName] = value.toString().trim();
        }
      }

      // Verificar codificación UTF-8 y limpiar caracteres extraños
      data.forEach((key, value) {
        if (value is String) {
          data[key] = utf8.decode(utf8.encode(value),
              allowMalformed: true); // Forzar UTF-8 limpio
        }
      });

      // Guardar el documento en Firebase
      await FirebaseFirestore.instance.collection('bienesmuebles').add(data);

      // Actualizar el progreso
      processedRows = rowIndex;
      prefs.setInt('lastRowIndex', processedRows);
      print(
          'Progreso: ${(processedRows / totalRows * 100).toStringAsFixed(2)}%');
    }

    // Al finalizar, limpiar el progreso guardado
    prefs.remove('lastRowIndex');
    print('Los datos del archivo Excel se cargaron correctamente.');
  } catch (e) {
    print('Error al procesar el archivo Excel: $e');
  }
}
