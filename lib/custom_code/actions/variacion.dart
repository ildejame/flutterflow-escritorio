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

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as excel_lib;
import '/auth/firebase_auth/auth_util.dart';

Future<bool> variacion(
  BuildContext context,
  String authToken,
) async {
  const Color customGreen = Color(0xFF164b2d);
  final firestore = FirebaseFirestore.instance;

  // 1. Seleccionar archivo Excel
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx', 'xls'],
    dialogTitle: 'Seleccione el archivo Excel con los cambios',
  );

  if (result == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se seleccionó ningún archivo')),
    );
    return false;
  }

  final bytes = result.files.first.bytes;
  if (bytes == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al leer el archivo')),
    );
    return false;
  }

  // 2. Leer el Excel
  var excel = excel_lib.Excel.decodeBytes(bytes);
  var sheet = excel.tables[excel.tables.keys.first];
  if (sheet == null || sheet.rows.length < 2) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('El archivo está vacío o no tiene datos')),
    );
    return false;
  }

  List<Map<String, String>> updates = [];
  for (int i = 1; i < sheet.rows.length; i++) {
    var row = sheet.rows[i];
    if (row.length < 2) continue;
    String inventario = row[0]?.value?.toString().trim() ?? '';
    String nuevoNivel1 = row[1]?.value?.toString().trim() ?? '';
    if (inventario.isEmpty || nuevoNivel1.isEmpty) continue;
    updates.add({
      'inventario2025': inventario,
      'nivel1organizacion': nuevoNivel1,
    });
  }

  if (updates.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se encontraron filas válidas')),
    );
    return false;
  }

  // 3. Verificar existencia en Firestore
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customGreen),
          ),
          SizedBox(width: 20),
          Expanded(
              child: Text('Verificando inventarios en la base de datos...')),
        ],
      ),
    ),
  );

  Set<String> inventariosSet = updates.map((e) => e['inventario2025']!).toSet();
  List<String> inventariosExistentes = [];
  List<String> inventariosNoEncontrados = [];

  for (String inv in inventariosSet) {
    try {
      var snapshot = await firestore
          .collection('bienesmuebles')
          .where('inventario2025', isEqualTo: inv)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        inventariosExistentes.add(inv);
      } else {
        inventariosNoEncontrados.add(inv);
      }
    } catch (e) {
      inventariosNoEncontrados.add(inv);
    }
  }

  Navigator.of(context).pop();

  // Confirmación
  bool confirm = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirmar actualización masiva'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📊 Total de registros en el archivo: ${updates.length}'),
              Text(
                  '✅ Inventarios encontrados en Firestore: ${inventariosExistentes.length}'),
              Text(
                  '❌ Inventarios NO encontrados: ${inventariosNoEncontrados.length}'),
              const SizedBox(height: 12),
              const Text(
                  'Se actualizará SOLO el campo "nivel1organizacion" en:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('• Firestore (bienesmuebles y calculodepreciacion)'),
              const Text('• API externa (bienesmuebles y calculodepreciacion)'),
              const Text(
                  '⚠️ Los campos "quienmodifico" y "fechaultimamodificacion" NO se modificarán.'),
              const SizedBox(height: 12),
              if (inventariosNoEncontrados.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⚠️ Los siguientes inventarios se omitirán:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    const SizedBox(height: 4),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        child: Text(
                          inventariosNoEncontrados.join(', '),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child:
                  const Text('CANCELAR', style: TextStyle(color: customGreen)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: customGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('CONTINUAR'),
            ),
          ],
        ),
      ) ??
      false;

  if (!confirm) return false;

  // 4. Procesar solo los existentes
  Map<String, String> inventarioToNivel1 = {
    for (var u in updates) u['inventario2025']!: u['nivel1organizacion']!
  };

  int total = inventariosExistentes.length;
  int exitosos = 0;
  List<String> errores = [];

  // Diálogo de progreso
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customGreen),
          ),
          const SizedBox(height: 20),
          Text('Actualizando registros... (0 / $total)'),
        ],
      ),
    ),
  );

  int current = 0;
  void updateProgress(int completed) {
    if (context.mounted) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(customGreen),
              ),
              const SizedBox(height: 20),
              Text('Actualizando registros... ($completed / $total)'),
            ],
          ),
        ),
      );
    }
  }

  for (String inv in inventariosExistentes) {
    String nuevoNivel1 = inventarioToNivel1[inv]!;
    try {
      // --- Firestore: bienesmuebles (solo nivel1organizacion) ---
      QuerySnapshot bienesSnap = await firestore
          .collection('bienesmuebles')
          .where('inventario2025', isEqualTo: inv)
          .limit(1)
          .get();
      if (bienesSnap.docs.isEmpty) {
        errores.add('$inv -> No encontrado en Firestore (contradicción)');
        current++;
        updateProgress(current);
        continue;
      }
      var bienDoc = bienesSnap.docs.first;
      await bienDoc.reference.update({
        'nivel1organizacion': nuevoNivel1,
        // No se actualiza quiénmodifico ni fecha
      });

      // Firestore: calculodepreciacion (solo unidadpresupuestal)
      QuerySnapshot depSnap = await firestore
          .collection('calculodepreciacion')
          .where('inventario2025', isEqualTo: inv)
          .get();
      for (var depDoc in depSnap.docs) {
        await depDoc.reference.update({
          'unidadpresupuestal': nuevoNivel1,
        });
      }

      // --- API externa ---
      // Buscar el bien en API
      final searchUrl =
          'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/?filter=(inventario2025%3D%22$inv%22)';
      final searchResp = await http.get(
        Uri.parse(searchUrl),
        headers: {'Authorization': 'Bearer $authToken'},
      ).timeout(const Duration(seconds: 15));

      if (searchResp.statusCode != 200) {
        errores.add('$inv -> Error GET API: ${searchResp.statusCode}');
        current++;
        updateProgress(current);
        continue;
      }

      final searchData = jsonDecode(searchResp.body);
      if (searchData['items'] == null || searchData['items'].isEmpty) {
        errores.add('$inv -> No encontrado en API externa');
        current++;
        updateProgress(current);
        continue;
      }

      final String realId = searchData['items'][0]['id'];
      final patchUrl =
          'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/$realId';
      final patchResp = await http
          .patch(
            Uri.parse(patchUrl),
            headers: {
              'Authorization': 'Bearer $authToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'nivel1organizacion': nuevoNivel1,
              // No se incluyen quienmodifico ni fechaultimamodificacion
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (patchResp.statusCode != 200 && patchResp.statusCode != 204) {
        errores
            .add('$inv -> Error PATCH bienesmuebles: ${patchResp.statusCode}');
        current++;
        updateProgress(current);
        continue;
      }

      // Actualizar calculodepreciacion en API
      final searchDepUrl =
          'https://api.servidor-inventarios.xyz/fastapi/calculodepreciacion/?filter=(inventario2025%3D%22$inv%22)';
      final searchDepResp = await http.get(
        Uri.parse(searchDepUrl),
        headers: {'Authorization': 'Bearer $authToken'},
      ).timeout(const Duration(seconds: 15));

      if (searchDepResp.statusCode == 200) {
        final searchDepData = jsonDecode(searchDepResp.body);
        if (searchDepData['items'] != null &&
            searchDepData['items'].isNotEmpty) {
          for (var item in searchDepData['items']) {
            final String realIdDep = item['id'];
            final patchDepUrl =
                'https://api.servidor-inventarios.xyz/fastapi/calculodepreciacion/$realIdDep';
            final patchDepResp = await http
                .patch(
                  Uri.parse(patchDepUrl),
                  headers: {
                    'Authorization': 'Bearer $authToken',
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    'unidadpresupuestal': nuevoNivel1,
                  }),
                )
                .timeout(const Duration(seconds: 15));

            if (patchDepResp.statusCode != 200 &&
                patchDepResp.statusCode != 204) {
              errores.add(
                  '$inv -> Error PATCH calculodepreciacion API: ${patchDepResp.statusCode}');
            }
          }
        }
      } else {
        errores.add(
            '$inv -> Error GET calculodepreciacion API: ${searchDepResp.statusCode}');
      }

      exitosos++;
    } catch (e) {
      errores.add('$inv -> Excepción: $e');
    }
    current++;
    updateProgress(current);
  }

  // Cerrar progreso
  Navigator.of(context).pop();

  // Resumen final
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Actualización completada'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('✅ Exitosos: $exitosos de $total'),
          if (errores.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('❌ Errores:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: errores
                      .map((e) => Text(e, style: const TextStyle(fontSize: 12)))
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('CERRAR', style: TextStyle(color: customGreen)),
        ),
      ],
    ),
  );

  return exitosos > 0;
}
