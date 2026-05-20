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

// Nuevas importaciones necesarias
import 'package:file_picker/file_picker.dart';
import 'dart:convert'; // Para procesar el CSV
import 'package:csv/csv.dart'; // Librería para manejar CSVs

// Comienza el código de la acción personalizada
Future<void> cargarCsvBienesMuebles() async {
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

    // Separar encabezados y filas de datos
    final List<String> headers =
        csvTable.first.cast<String>(); // Primera fila como encabezados
    final List<List<dynamic>> rows =
        csvTable.sublist(1); // Resto de filas como datos

    // 4. Procesar y guardar los datos en Firebase
    for (final row in rows) {
      final Map<String, dynamic> data = {};

      // Mapear los valores de cada fila con sus respectivos encabezados
      for (int i = 0; i < headers.length; i++) {
        String header = headers[i];
        dynamic value = row[i];

        // Convertir los datos según el encabezado
        if (header.contains('fecha')) {
          // Convertir a DateTime
          data[header] = DateTime.tryParse(value.toString()) ?? DateTime.now();
        } else if (header == 'importetotalbien' ||
            header == 'numeroseriedelbien') {
          // Convertir a Double
          data[header] = double.tryParse(value.toString()) ?? 0.0;
        } else if (header == 'escontable') {
          // Convertir a Boolean
          data[header] = value.toString().toLowerCase() == 'true';
        } else if (header == 'aniofiscal') {
          // Convertir a Integer
          data[header] = int.tryParse(value.toString()) ?? 0;
        } else {
          // Guardar otros valores como String
          data[header] = value.toString();
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
