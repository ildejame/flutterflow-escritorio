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

Future<void> subirmasivo4(BuildContext context) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Aviso'),
          content: Text('No se seleccionó ningún archivo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final fileBytes = result.files.first.bytes;
    final excel = Excel.decodeBytes(fileBytes!);

    final sheet = excel['fechasc'];
    if (sheet == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Aviso'),
          content: Text('No se encontró la hoja "fechasc".'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

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

    int totalRows =
        sheet.rows.length - 1; // Total de filas (excluyendo encabezados)
    int processedRows = 0; // Contador de filas procesadas

    // Mostrar diálogo de progreso
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );

    for (int rowIndex = 1; rowIndex <= totalRows; rowIndex++) {
      final row = sheet.rows[rowIndex];
      if (row == null) continue;

      final Map<String, dynamic> data = {};
      for (int i = 0; i < fieldNames.length; i++) {
        final fieldName = fieldNames[i];
        final cell = row[i];
        var value = cell?.value;

        if (fieldName == 'fechaalta' ||
            fieldName == 'fechaadquisicion' ||
            fieldName == 'fechademodificacion' ||
            fieldName == 'fechadebaja') {
          if (value is String) {
            data[fieldName] =
                Timestamp.fromDate(DateTime.tryParse(value) ?? DateTime.now());
          } else if (value is DateTime) {
            data[fieldName] = Timestamp.fromDate(value);
          } else {
            data[fieldName] = null;
          }
        } else if (fieldName == 'importeinicialbien') {
          data[fieldName] = double.tryParse(value.toString()) ?? 0.0;
        } else if (fieldName == 'escontable') {
          data[fieldName] = value.toString().toLowerCase() == 'true';
        } else if (fieldName == 'aniofiscal') {
          data[fieldName] = int.tryParse(value.toString()) ?? 0;
        } else {
          data[fieldName] = value?.toString().trim() ?? '';
        }
      }

      await FirebaseFirestore.instance.collection('bienesmuebles').add(data);

      // Actualizar progreso
      processedRows++;
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
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
        },
      );
    }

    Navigator.pop(context); // Cerrar el diálogo de progreso
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Éxito'),
        content: Text('Carga masiva completada con éxito.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  } catch (e) {
    Navigator.pop(context); // Cerrar el diálogo de progreso en caso de error
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Error durante la carga masiva: $e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
