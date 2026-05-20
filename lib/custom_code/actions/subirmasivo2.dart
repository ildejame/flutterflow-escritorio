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
import 'dart:convert'; // Para procesar el CSV
import 'package:csv/csv.dart'; // Librería para manejar CSV
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> subirmasivo2() async {
  try {
    // 1. Seleccionar el archivo CSV usando File Picker
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) {
      print('No se seleccionó ningún archivo.');
      return;
    }

    // 2. Leer el contenido del archivo CSV
    final fileBytes = result.files.first.bytes;
    final content =
        utf8.decode(fileBytes!); // Decodificar el contenido en UTF-8

    // 3. Parsear el contenido del CSV
    final List<List<dynamic>> csvTable =
        const CsvToListConverter().convert(content);
    if (csvTable.isEmpty) {
      print('El archivo CSV está vacío.');
      return;
    }

    // Separar encabezados y filas de datos (omitimos la primera fila de encabezados)
    final List<List<dynamic>> rows =
        csvTable.skip(1).toList(); // Omitir la primera fila

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

    // 5. Procesar y guardar los datos en Firebase
    for (final row in rows) {
      if (row.length != fieldNames.length) {
        print(
            'Error: La cantidad de columnas en la fila no coincide con los campos esperados.');
        continue;
      }

      final Map<String, dynamic> data = {};

      // Asignar directamente los valores en el orden esperado
      for (int i = 0; i < fieldNames.length; i++) {
        final fieldName = fieldNames[i];
        var value = row[i];

        // Convertir los valores según el tipo esperado
        if (fieldName == 'fechaalta' ||
            fieldName == 'fechaadquisicion' ||
            fieldName == 'fechademodificacion' ||
            fieldName == 'fechadebaja') {
          // Convertir a Timestamp (si es una fecha)
          data[fieldName] = Timestamp.fromDate(
            DateTime.tryParse(value.toString()) ?? DateTime.now(),
          );
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
          // Asignar el valor como String
          data[fieldName] = value.toString();
        }
      }

      // Guardar el documento en Firebase
      await FirebaseFirestore.instance.collection('bienesmuebles').add(data);
    }

    print(
        'Los datos del CSV se cargaron y guardaron correctamente en Firebase.');
  } catch (e) {
    print('Error al cargar el CSV: $e');
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
