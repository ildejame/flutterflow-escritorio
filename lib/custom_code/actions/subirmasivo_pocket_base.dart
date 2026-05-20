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

// Importaciones necesarias
import 'package:file_picker/file_picker.dart';
import 'dart:convert'; // Para procesar el CSV
import 'package:csv/csv.dart'; // Librería para manejar CSV
import 'package:pocketbase/pocketbase.dart';

Future<void> subirmasivoPocketBase() async {
  try {
    // Crear una instancia de PocketBase
    final pb = PocketBase('http://189.194.93.56:8090');

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

    // 4. Procesar y guardar los datos en PocketBase
    for (final row in rows) {
      if (row.length != 5) {
        // Validar que tenga exactamente 5 columnas
        print(
            'Error: La cantidad de columnas en la fila no coincide con los campos esperados.');
        continue;
      }

      final Map<String, dynamic> body = {
        "Nombre": row[0].toString(),
        "IDempleado": row[1].toString(),
        "fechamodificacion": row[2].toString(),
        "estatus": row[3].toString(),
        "ubicacion": row[4].toString(),
      };

      try {
        // Crear el registro en PocketBase
        await pb.collection('EMPLEADOS').create(body: body);
      } catch (e) {
        print('Error al guardar el registro en PocketBase: $e');
      }
    }

    print(
        'Los datos del CSV se cargaron y guardaron correctamente en PocketBase.');
  } catch (e) {
    print('Error al cargar el CSV: $e');
  }
}
