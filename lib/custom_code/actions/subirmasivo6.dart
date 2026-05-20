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

Future<void> subirmasivo6(BuildContext context) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result == null) {
      _mostrarDialogo(context, 'Aviso', 'No se seleccionó ningún archivo.');
      return;
    }

    final fileBytes = result.files.first.bytes;
    if (fileBytes == null) {
      _mostrarDialogo(
          context, 'Error', 'No se pudieron leer los bytes del archivo.');
      return;
    }

    final excel = Excel.decodeBytes(fileBytes);
    final sheet =
        excel['Hoja1']; // Asegúrate de usar el nombre correcto de la hoja

    if (sheet == null) {
      _mostrarDialogo(context, 'Aviso', 'No se encontró la hoja "Hoja1".');
      return;
    }

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

    int totalRows = sheet.rows.length - 1;
    int processedRows = 0;

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

    for (int rowIndex = 1; rowIndex <= totalRows; rowIndex++) {
      final row = sheet.rows[rowIndex];
      if (row == null) continue;

      final Map<String, dynamic> data = {};
      for (int i = 0; i < fieldNames.length; i++) {
        final fieldName = fieldNames[i];
        final cell = row[i];
        String? cellValue = cell?.value?.toString();

        switch (fieldName) {
          case 'fechademodificacion':
          case 'fechaadquisicion':
            DateTime? parsedDate = _parseDateValue(cellValue);
            data[fieldName] = parsedDate != null
                ? Timestamp.fromDate(parsedDate.add(Duration(hours: 15)))
                : null;
            break;
          case 'importeinicialbien':
          case 'depreciacion':
            data[fieldName] = double.tryParse(cellValue ?? '') ?? 0.0;
            break;
          case 'aniofiscal':
            data[fieldName] = int.tryParse(cellValue ?? '') ?? 0;
            break;
          default:
            data[fieldName] = cellValue?.trim() ?? '';
            break;
        }
      }

      // Agregar fecha y hora actual en el campo "fechaalta"
      data['fechaalta'] = Timestamp.now();

      try {
        await FirebaseFirestore.instance.collection('bienesmuebles').add(data);
      } catch (e) {
        Navigator.pop(context);
        _mostrarDialogo(context, 'Error al subir a Firestore', e.toString());
        return;
      }

      processedRows++;
    }

    Navigator.pop(context); // Cerrar el diálogo de progreso final
    _mostrarDialogo(context, 'Éxito', 'Carga masiva completada con éxito.');
  } catch (e) {
    Navigator.pop(context);
    _mostrarDialogo(context, 'Error general', e.toString());
  }
}

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
    'd/M/yyyy',
    'd-M-yyyy',
    'M/d/yyyy',
    'M-d-yyyy',
    'dd/MMM/yyyy',
    'dd-MMM-yyyy',
    'MMM/dd/yyyy',
    'MMM-dd-yyyy',
  ];
  for (var format in formats) {
    try {
      return DateFormat(format).parseStrict(value);
    } catch (_) {}
  }

  return null;
}

void _mostrarDialogo(BuildContext context, String title, String content) {
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
