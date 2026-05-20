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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'dart:async';

Future<void> bajarlista(
  BuildContext context,
  List<BienesmueblesRecord>? listadebienes,
) async {
  listadebienes = listadebienes ?? [];

  if (listadebienes.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ No hay registros para exportar.')),
    );
    return;
  }

  // Variables para el diálogo de progreso
  String mensajeActual = 'Iniciando proceso...';
  double progreso = 0.0;

  // Mostrar diálogo de progreso dinámico
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.file_download, color: Colors.blue),
            SizedBox(width: 8),
            Text('Generando Excel'),
          ],
        ),
        content: Container(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: progreso,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 16),
              Text(
                mensajeActual,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '${(progreso * 100).toInt()}% completado',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Función para actualizar el progreso
  void actualizarProgreso(String mensaje, double nuevoProgreso) {
    mensajeActual = mensaje;
    progreso = nuevoProgreso;
    // Forzar actualización de UI
    if (context.mounted) {
      (context as Element).markNeedsBuild();
    }
  }

  try {
    await Future.delayed(
        Duration(milliseconds: 100)); // Permitir que se muestre el diálogo

    actualizarProgreso('Analizando ${listadebienes.length} registros...', 0.1);
    await Future.delayed(Duration(milliseconds: 50));

    // Procesar registros en lotes para evitar bloquear la UI
    final Map<String, BienesmueblesRecord> registrosUnicos = {};
    final Set<String> duplicadosEncontrados = {};

    final int batchSize = 1000; // Procesar de 1000 en 1000
    final int totalBatches = (listadebienes.length / batchSize).ceil();

    for (int batchIndex = 0; batchIndex < totalBatches; batchIndex++) {
      final inicio = batchIndex * batchSize;
      final fin = (inicio + batchSize > listadebienes.length)
          ? listadebienes.length
          : inicio + batchSize;

      final lote = listadebienes.sublist(inicio, fin);

      actualizarProgreso(
          'Procesando lote ${batchIndex + 1} de $totalBatches (${lote.length} registros)',
          0.1 + (0.4 * (batchIndex + 1) / totalBatches));

      // Procesar lote actual
      for (var item in lote) {
        final inventarioKey = item.inventario2025?.toString().trim() ?? '';

        if (inventarioKey.isEmpty) {
          debugPrint('⚠️ Registro sin inventario2025 encontrado, saltando...');
          continue;
        }

        if (registrosUnicos.containsKey(inventarioKey)) {
          duplicadosEncontrados.add(inventarioKey);
          debugPrint('🔄 Duplicado encontrado para inventario: $inventarioKey');

          // Mantener el registro más reciente
          final existente = registrosUnicos[inventarioKey]!;
          final existenteFecha = existente.fechademodificacion is Timestamp
              ? (existente.fechademodificacion as Timestamp).toDate()
              : existente.fechademodificacion ?? DateTime(1900);
          final nuevoFecha = item.fechademodificacion is Timestamp
              ? (item.fechademodificacion as Timestamp).toDate()
              : item.fechademodificacion ?? DateTime(1900);

          if (nuevoFecha.isAfter(existenteFecha)) {
            registrosUnicos[inventarioKey] = item;
            debugPrint(
                '✅ Actualizado registro más reciente para: $inventarioKey');
          }
        } else {
          registrosUnicos[inventarioKey] = item;
        }
      }

      // Pausa pequeña para permitir que la UI se actualice
      await Future.delayed(Duration(milliseconds: 10));
    }

    final registrosFinales = registrosUnicos.values.toList();

    actualizarProgreso(
        'Registros procesados: ${registrosFinales.length} únicos de ${listadebienes.length} originales',
        0.5);
    await Future.delayed(Duration(milliseconds: 100));

    debugPrint('📊 Estadísticas:');
    debugPrint('   - Registros originales: ${listadebienes.length}');
    debugPrint('   - Registros únicos: ${registrosFinales.length}');
    debugPrint('   - Duplicados encontrados: ${duplicadosEncontrados.length}');

    // Crear Excel
    actualizarProgreso('Creando archivo Excel...', 0.6);
    await Future.delayed(Duration(milliseconds: 50));

    final excel = Excel.createExcel();
    final sheet = excel['Bienes'];
    final headers = [
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
      'anexo'
    ];

    // Escribir headers
    actualizarProgreso('Escribiendo encabezados...', 0.65);
    await Future.delayed(Duration(milliseconds: 30));

    for (int col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = headers[col];
    }

    // Escribir datos en lotes para evitar bloqueo
    actualizarProgreso('Escribiendo datos al Excel...', 0.7);
    await Future.delayed(Duration(milliseconds: 50));

    final int dataBatchSize = 500; // Escribir de 500 en 500
    final int totalDataBatches =
        (registrosFinales.length / dataBatchSize).ceil();

    for (int batchIndex = 0; batchIndex < totalDataBatches; batchIndex++) {
      final inicio = batchIndex * dataBatchSize;
      final fin = (inicio + dataBatchSize > registrosFinales.length)
          ? registrosFinales.length
          : inicio + dataBatchSize;

      actualizarProgreso(
          'Escribiendo registros ${inicio + 1} a $fin de ${registrosFinales.length}',
          0.7 + (0.2 * (batchIndex + 1) / totalDataBatches));

      for (int i = inicio; i < fin; i++) {
        final doc = registrosFinales[i];
        final row = i + 1; // +1 porque la fila 0 son los headers

        for (int col = 0; col < headers.length; col++) {
          final field = headers[col];
          dynamic value;

          try {
            value = doc.getDocumentField(field);
          } catch (e) {
            debugPrint('⚠️ Error obteniendo campo $field: $e');
            value = '----';
          }

          // Formatear valores especiales
          if (value is Timestamp) {
            value = DateFormat('dd/MM/yyyy').format(value.toDate());
          } else if (value is DateTime) {
            value = DateFormat('dd/MM/yyyy').format(value);
          } else if (value == null || value.toString().trim().isEmpty) {
            value = '----';
          }

          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
              .value = value.toString();
        }
      }

      // Pausa para permitir actualización de UI
      await Future.delayed(Duration(milliseconds: 5));
    }

    // Generar archivo
    actualizarProgreso('Generando archivo final...', 0.9);
    await Future.delayed(Duration(milliseconds: 100));

    final bytes = excel.encode();

    if (bytes == null) throw Exception('Error al codificar Excel.');

    actualizarProgreso('Preparando descarga...', 0.95);
    await Future.delayed(Duration(milliseconds: 50));

    final fileName =
        'BienesMuebles_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';

    // Descargar archivo
    if (kIsWeb) {
      final blob = html.Blob([bytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    }

    actualizarProgreso('¡Completado!', 1.0);
    await Future.delayed(Duration(milliseconds: 200));

    // Cerrar diálogo de progreso
    Navigator.of(context).pop();

    // Mensaje de éxito con estadísticas
    final mensaje = duplicadosEncontrados.isEmpty
        ? '✅ Excel descargado: ${registrosFinales.length} registros'
        : '✅ Excel descargado: ${registrosFinales.length} registros únicos (${duplicadosEncontrados.length} duplicados resueltos)';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );
  } catch (e) {
    Navigator.of(context).pop(); // Cerrar diálogo de progreso
    debugPrint('❌ Error en bajarlista: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Error al generar Excel: $e'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
  }
}

extension _DocHelper on BienesmueblesRecord {
  dynamic getDocumentField(String key) {
    final map = {
      'inventario2025': inventario2025,
      'categoria': categoria,
      'fechademodificacion': fechademodificacion,
      'encargado': encargado,
      'verificavs': verificavs,
      'folioresguardo': folioresguardo,
      'cotejodoc': cotejodoc,
      'numeroinventario': numeroinventario,
      'inventario': inventario,
      'nombre': nombre,
      'marcacomercial': marcacomercial,
      'modelo': modelo,
      'numeroseriedelbien': numeroseriedelbien,
      'importeinicialbien': importeinicialbien,
      'estatusdelbien': estatusdelbien,
      'descripciondelbien': descripciondelbien,
      'ubicacionfisica': ubicacionfisica,
      'depositario': depositario,
      'color': color,
      'fechaadquisicion': fechaadquisicion,
      'licitacion': licitacion,
      'origenrecurso': origenrecurso,
      'tiporecurso': tiporecurso,
      'factura': factura,
      'nombredelprovedor': nombredelprovedor,
      'depreciacion': depreciacion,
      'clasedeactivo': clasedeactivo,
      'aniofiscal': aniofiscal,
      'nivel1organizacion': nivel1organizacion,
      'nivel2direccion': nivel2direccion,
      'nivel3jurisdiccion': nivel3jurisdiccion,
      'inmueble': inmueble,
      'distrito': distrito,
      'zona': zona,
      'cargo': cargo,
      'comentarioadicional': comentarioadicional,
      'serimonitor': serimonitor,
      'serieteclado': serieteclado,
      'seriemouse': seriemouse,
      'placa': placa,
      'tituladelbien': tituladelbien,
      'cargotitular': cargotitular,
      'anexo': anexo,
    };
    return map[key];
  }
}
