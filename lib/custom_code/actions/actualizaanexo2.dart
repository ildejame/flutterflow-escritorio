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

// // Automatic FlutterFlow imports

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

Future<bool> actualizaanexo2(
  BuildContext context,
  String authToken,
) async {
  const Color customGreen = Color(0xFF164b2d);
  final firestore = FirebaseFirestore.instance;

  // ---------------------------------------------------------
  // 1. DIÁLOGO DE BÚSQUEDA (FILTROS)
  // ---------------------------------------------------------
  final TextEditingController nivel2Controller = TextEditingController();
  final TextEditingController nivel3Controller = TextEditingController();

  bool procederBusqueda = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Actualización Masiva a NO LOCALIZADOS ANEXO 2',
            style: TextStyle(color: customGreen, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Ingrese la ubicación para buscar los bienes a actualizar. El Nivel 2 es obligatorio.',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 16),

              // CAMPO NIVEL 2 (OBLIGATORIO)
              const Text('NIVEL 2 (DIRECCIÓN) *',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: customGreen)),
              Autocomplete<String>(
                optionsBuilder: (val) => FFAppState().sugerenciasN2.where(
                    (s) => s.toLowerCase().contains(val.text.toLowerCase())),
                onSelected: (s) => nivel2Controller.text = s,
                fieldViewBuilder: (context, ctrl, node, onSub) => TextField(
                  controller: ctrl,
                  focusNode: node,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: customGreen, width: 2),
                    ),
                    hintText: 'Buscar nivel 2 (Obligatorio)...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ctrl.clear();
                        nivel2Controller.clear();
                      },
                    ),
                  ),
                  onChanged: (v) => nivel2Controller.text = v,
                ),
              ),
              const SizedBox(height: 16),

              // CAMPO NIVEL 3 (OPCIONAL)
              const Text('NIVEL 3 (JURISDICCIÓN)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: customGreen)),
              Autocomplete<String>(
                optionsBuilder: (val) => FFAppState().sugerenciasN3.where(
                    (s) => s.toLowerCase().contains(val.text.toLowerCase())),
                onSelected: (s) => nivel3Controller.text = s,
                fieldViewBuilder: (context, ctrl, node, onSub) => TextField(
                  controller: ctrl,
                  focusNode: node,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: customGreen, width: 2),
                    ),
                    hintText: 'Buscar nivel 3 (Opcional)...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ctrl.clear();
                        nivel3Controller.clear();
                      },
                    ),
                  ),
                  onChanged: (v) => nivel3Controller.text = v,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: customGreen),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nivel2Controller.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('⚠️ El Nivel 2 es obligatorio.'),
                    backgroundColor: Colors.red));
                return;
              }
              procederBusqueda = true;
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: customGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('BUSCAR'),
          ),
        ],
      );
    },
  );

  if (!procederBusqueda) return false;

  final String nivel2 = nivel2Controller.text.trim();
  final String nivel3 = nivel3Controller.text.trim();

  // ---------------------------------------------------------
  // 2. CONSULTA A FIREBASE
  // ---------------------------------------------------------
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          SizedBox(width: 20),
          Expanded(child: Text('Consultando base de datos...')),
        ],
      ),
    ),
  );

  QuerySnapshot<Map<String, dynamic>> snapshot;
  try {
    Query<Map<String, dynamic>> query = firestore
        .collection('bienesmuebles')
        .where('nivel2direccion', isEqualTo: nivel2);

    if (nivel3.isNotEmpty) {
      query = query.where('nivel3jurisdiccion', isEqualTo: nivel3);
    }

    snapshot = await query.get();
  } catch (e) {
    Navigator.of(context).pop(); // Cierra el loader
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('❌ Error en consulta: $e')));
    return false;
  }

  Navigator.of(context).pop(); // Cierra el loader

  final int totalBienes = snapshot.docs.length;

  if (totalBienes == 0) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('⚠️ No se encontraron bienes con esos criterios.')));
    return false;
  }

  // ---------------------------------------------------------
  // 3. DIÁLOGO DE CONFIRMACIÓN
  // ---------------------------------------------------------
  bool confirmarActualizacion = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('⚠️ Confirmar Actualización Masiva'),
          content: Text(
            'Se encontraron $totalBienes bienes en:\n\n'
            'Nivel 2: $nivel2\n'
            '${nivel3.isNotEmpty ? 'Nivel 3: $nivel3\n' : ''}\n'
            '¿Deseas cambiar el estado de TODOS estos bienes a "ANEXO 2"?\n\n'
            'Esta acción modificará la base de datos a bienes NO LOCALIZADOS.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text('CANCELAR')),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: customGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('SÍ, ACTUALIZAR TODOS')),
          ],
        ),
      ) ??
      false;

  if (!confirmarActualizacion) return false;

  // ---------------------------------------------------------
  // 4. PROCESO DE ACTUALIZACIÓN MASIVA (BUCLE)
  // ---------------------------------------------------------
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: const [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          SizedBox(width: 20),
          Expanded(
              child: Text('Sincronizando inventario, por favor espera...')),
        ],
      ),
    ),
  );

  int exitosos = 0;
  int errores = 0;

  for (var doc in snapshot.docs) {
    try {
      final data = doc.data();
      final String inventario = (data['inventario2025'] ?? '').toString();

      if (inventario.isEmpty) {
        errores++;
        continue;
      }

      // --- A. ACTUALIZAR FIREBASE ---
      await doc.reference.update({
        'anexo': 'ANEXO 2',
        'quienmodifico': currentUserDisplayName ?? 'Sistema Masivo',
        'fechaultimamodificacion': FieldValue.serverTimestamp(),
      });

      // --- B. BUSCAR ID REAL EN POCKETBASE ---
      final searchUrl =
          'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/?filter=(inventario2025%3D%22$inventario%22)';

      final searchResp = await http.get(
        Uri.parse(searchUrl),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (searchResp.statusCode == 200) {
        final searchData = jsonDecode(searchResp.body);

        if (searchData['items'] != null && searchData['items'].isNotEmpty) {
          final String realId = searchData['items'][0]['id'];

          // --- C. ACTUALIZAR POCKETBASE (vía PATCH) ---
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
                  'anexo': 'ANEXO 2',
                  'quienmodifico': currentUserDisplayName ?? 'Sistema Masivo',
                  'fechaultimamodificacion': DateTime.now().toIso8601String(),
                }),
              )
              .timeout(const Duration(seconds: 15));

          if (patchResp.statusCode == 200 || patchResp.statusCode == 204) {
            exitosos++;
          } else {
            errores++;
          }
        } else {
          // No encontrado en el servidor externo
          errores++;
        }
      } else {
        // Error en la búsqueda GET
        errores++;
      }
    } catch (e) {
      errores++;
      // Continuamos con el siguiente documento en caso de error
    }
  }

  Navigator.of(context).pop(); // Cierra el loader final

  // ---------------------------------------------------------
  // 5. RESUMEN DE RESULTADOS
  // ---------------------------------------------------------
  if (errores == 0) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('✅ Sincronización exitosa: $exitosos bienes actualizados.'),
        backgroundColor: customGreen,
        duration: const Duration(seconds: 4)));
    return true;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            '⚠️ Proceso finalizado: $exitosos actualizados, $errores con errores en servidor externo.'),
        backgroundColor: Colors.orange[800],
        duration: const Duration(seconds: 6)));
    // Retornamos true porque al menos el proceso corrió, aunque haya items fallidos
    return true;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
