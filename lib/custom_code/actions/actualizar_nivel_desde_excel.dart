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
import 'dart:async'; // Necesario para procesamiento paralelo
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;

Future<String> actualizarNivelDesdeExcel(BuildContext context) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    // ------------------------------------------------------------------------
    // 1. SELECCIÓN DE ARCHIVO
    // ------------------------------------------------------------------------
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return "Cancelado";
    final excelFile = result.files.first;

    // ------------------------------------------------------------------------
    // 2. UI PROGRESO
    // ------------------------------------------------------------------------
    final processingNotifier = ValueNotifier<String>('Arrancando motor...');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ValueListenableBuilder<String>(
        valueListenable: processingNotifier,
        builder: (context, message, _) => AlertDialog(
          title: const Text('Actualización Rápida (Lotes de 40)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );

    void updateProgress(String message) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        processingNotifier.value = message;
      });
    }

    // ------------------------------------------------------------------------
    // 3. LECTURA EXCEL
    // ------------------------------------------------------------------------
    await Future.delayed(const Duration(milliseconds: 200));
    updateProgress('Leyendo registros...');

    final excel = Excel.decodeBytes(excelFile.bytes!);
    if (excel.tables.keys.isEmpty) {
      Navigator.of(context).pop();
      return "Error: Excel vacío";
    }
    final sheet = excel.tables[excel.tables.keys.first];
    if (sheet == null || sheet.rows.isEmpty) {
      Navigator.of(context).pop();
      return "Error: Hoja vacía";
    }

    // ------------------------------------------------------------------------
    // 4. CONFIGURACIÓN DE ALTA VELOCIDAD
    // ------------------------------------------------------------------------

    // --- CAMBIO APLICADO AQUÍ ---
    const int CHUNK_SIZE = 40; // Bajamos a 40 para evitar saturación de red

    // Variables globales de conteo
    int totalProcesados = 0;
    int updatesBienes = 0;
    int updatesDepre = 0;
    List<String> reporteCsvLines = [
      "ID_Excel,ID_Numerico,Estado,Valor_Intentado"
    ];

    // Preparamos la lista de datos en memoria (más rápido que leer el objeto Excel repetidamente)
    List<Map<String, String>> datosLimpios = [];
    int totalRows = sheet.rows.length;

    updateProgress('Pre-procesando datos...');

    for (int i = 1; i < totalRows; i++) {
      var row = sheet.rows[i];
      if (row.isEmpty) continue;

      var cellId = (row.length > 0) ? row[0] : null;
      var cellNivel = (row.length > 1) ? row[1] : null;

      String idRaw = _obtenerValorString(cellId);
      String nuevoNivel = _obtenerValorString(cellNivel);

      if (idRaw.isNotEmpty && nuevoNivel.isNotEmpty) {
        datosLimpios.add({'idRaw': idRaw, 'nuevoNivel': nuevoNivel});
      }
    }

    int totalData = datosLimpios.length;
    updateProgress(
        'Datos listos: $totalData registros.\nIniciando carga masiva...');

    // ------------------------------------------------------------------------
    // 5. BUCLE PRINCIPAL POR LOTES (CHUNKS)
    // ------------------------------------------------------------------------
    for (int i = 0; i < totalData; i += CHUNK_SIZE) {
      int end = (i + CHUNK_SIZE < totalData) ? i + CHUNK_SIZE : totalData;
      List<Map<String, String>> loteActual = datosLimpios.sublist(i, end);

      // Crear un batch de escritura para este lote
      WriteBatch batch = FirebaseFirestore.instance.batch();
      bool batchHasData = false;

      // --- PARALELISMO: Lanzamos las 40 consultas a la vez ---
      List<Future<void>> futurosDelLote = loteActual.map((item) async {
        String idRaw = item['idRaw']!;
        String nuevoNivel = item['nuevoNivel']!;

        // Limpieza numérica
        String idNumericoStr = idRaw
            .replaceAll(',', '')
            .replaceAll('.', '')
            .replaceAll(' ', '')
            .trim();
        int? idComoNumero = int.tryParse(idNumericoStr);

        bool encontradoEsteItem = false;

        try {
          // Consultas simultáneas para este item
          var futuresQuery = await Future.wait([
            // 1. Texto original
            FirebaseFirestore.instance
                .collection('bienesmuebles')
                .where('inventario2025', isEqualTo: idRaw)
                .get(),
            FirebaseFirestore.instance
                .collection('calculodepreciacion')
                .where('inventario2025', isEqualTo: idRaw)
                .get(),
            // 2. Número (si aplica)
            if (idComoNumero != null) ...[
              FirebaseFirestore.instance
                  .collection('bienesmuebles')
                  .where('inventario2025', isEqualTo: idComoNumero)
                  .get(),
              FirebaseFirestore.instance
                  .collection('calculodepreciacion')
                  .where('inventario2025', isEqualTo: idComoNumero)
                  .get(),
            ]
          ]);

          Set<DocumentReference> docsBienes = {};
          Set<DocumentReference> docsDepre = {};

          for (var snap in futuresQuery) {
            for (var doc in snap.docs) {
              if (doc.reference.path.contains('bienesmuebles'))
                docsBienes.add(doc.reference);
              else
                docsDepre.add(doc.reference);
            }
          }

          if (docsBienes.isNotEmpty) {
            encontradoEsteItem = true;
            for (var ref in docsBienes) {
              batch.update(ref, {'nivel1organizacion': nuevoNivel});
              updatesBienes++;
              batchHasData = true;
            }
          }

          if (docsDepre.isNotEmpty) {
            encontradoEsteItem = true;
            for (var ref in docsDepre) {
              batch.update(ref, {'unidadpresupuestal': nuevoNivel});
              updatesDepre++;
              batchHasData = true;
            }
          }

          if (!encontradoEsteItem) {
            // Guardar error para el reporte CSV
            reporteCsvLines.add(
                '"$idRaw","${idComoNumero ?? ''}","NO ENCONTRADO","$nuevoNivel"');
          }
        } catch (e) {
          reporteCsvLines.add('"$idRaw","ERROR","$e",""');
        }
      }).toList();

      // Esperar a que terminen las 40 consultas
      await Future.wait(futurosDelLote);

      // Guardar el lote en Firebase (1 sola escritura de red para los 40 items)
      if (batchHasData) {
        await batch.commit();
      }

      totalProcesados += loteActual.length;

      // Actualizar UI cada 80-100 registros
      if (totalProcesados % 80 == 0) {
        double porcentaje = (totalProcesados / totalData) * 100;
        updateProgress(
            'Progreso: ${porcentaje.toStringAsFixed(1)}%\n($totalProcesados / $totalData)');
      }
    }

    Navigator.of(context, rootNavigator: true).pop();

    // ------------------------------------------------------------------------
    // 6. DESCARGA CSV ERRORES
    // ------------------------------------------------------------------------
    int totalErrores = reporteCsvLines.length - 1;
    String msgDescarga = "";
    if (totalErrores > 0 && kIsWeb) {
      String csvContent = reporteCsvLines.join("\n");
      final bytes = utf8.encode(csvContent);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "reporte_errores_actualizacion.csv")
        ..click();
      html.Url.revokeObjectUrl(url);
      msgDescarga =
          "\n📥 Se descargó la lista de $totalErrores no encontrados.";
    }

    // ------------------------------------------------------------------------
    // 7. FIN
    // ------------------------------------------------------------------------
    String reporte = """
🚀 PROCESO COMPLETADO
-----------------------
Registros Excel: $totalProcesados
Bienes Actualizados: $updatesBienes
Depre Actualizados: $updatesDepre
-----------------------
NO ENCONTRADOS: $totalErrores
$msgDescarga
""";

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Proceso Terminado'),
        content: Text(reporte),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );

    return reporte;
  } catch (e) {
    if (Navigator.canPop(context)) Navigator.of(context).pop();
    return "Error: $e";
  }
}

// Función auxiliar para obtener string limpio
String _obtenerValorString(Data? cell) {
  if (cell == null || cell.value == null) return '';
  var val = cell.value;
  String result = val.toString();
  if (val is double && val % 1 == 0) result = val.toInt().toString();
  return result.trim();
}
