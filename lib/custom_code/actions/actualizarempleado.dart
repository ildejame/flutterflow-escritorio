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
import '/auth/firebase_auth/auth_util.dart';

Future<bool> actualizarempleado(
  BuildContext context,
  String authToken,
) async {
  const Color customGreen = Color(0xFF164b2d);
  final firestore = FirebaseFirestore.instance;
  bool fueActualizadoExitosamente = false;

  // ---------------------------------------------------------
  // 1. DIÁLOGO DE BÚSQUEDA
  // ---------------------------------------------------------
  final TextEditingController searchController = TextEditingController();

  final String? nombreBuscadoRaw = await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: const Text('Buscar Personal por Nombre'),
        content: Autocomplete<String>(
          optionsBuilder: (val) {
            if (val.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return FFAppState()
                .idempleadosAPI
                .where((s) => s.toLowerCase().contains(val.text.toLowerCase()));
          },
          onSelected: (s) => searchController.text = s,
          fieldViewBuilder: (context, ctrl, node, onSub) => TextField(
            controller: ctrl,
            focusNode: node,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Nombre del Trabajador',
              hintText: 'Escriba para buscar...',
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: customGreen, width: 2),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  ctrl.clear();
                  searchController.clear();
                },
              ),
            ),
            onChanged: (v) => searchController.text = v,
            onSubmitted: (value) {
              if (searchController.text.trim().isNotEmpty) {
                Navigator.of(context).pop(searchController.text.trim());
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            style: TextButton.styleFrom(foregroundColor: customGreen),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.trim().isNotEmpty) {
                Navigator.of(context).pop(searchController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: customGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('ACEPTAR'),
          ),
        ],
      );
    },
  );

  if (nombreBuscadoRaw == null || nombreBuscadoRaw.trim().isEmpty) return false;

  final String nombreBuscado = nombreBuscadoRaw.trim();

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
          Expanded(child: Text('Buscando información del trabajador...')),
        ],
      ),
    ),
  );

  QuerySnapshot<Map<String, dynamic>> snapshot;
  try {
    snapshot = await firestore
        .collection('empleadospjev')
        .where('nombre', isEqualTo: nombreBuscado)
        .limit(1)
        .get();
  } catch (e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('❌ Error Firebase: $e')));
    return false;
  }

  Navigator.of(context).pop();

  if (snapshot.docs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            '⚠️ No se encontró el registro del trabajador en la base de datos.')));
    return false;
  }

  final doc = snapshot.docs.first;
  final data = doc.data();

  // ---------------------------------------------------------
  // 3. PREPARAR CONTROLADORES Y DATOS
  // ---------------------------------------------------------
  final TextEditingController nombreController =
      TextEditingController(text: (data['nombre'] ?? '').toString());
  final TextEditingController cargoController =
      TextEditingController(text: (data['cargo'] ?? '').toString());

  final String quienModificoValue =
      (data['quienmodifico'] ?? 'Sin registro').toString();
  final String fechaModificoValue = data['fechaultimamodificacion'] != null
      ? dateTimeFormat(
          'd/M/y H:mm', (data['fechaultimamodificacion'] as Timestamp).toDate())
      : 'Sin fecha';

  // ---------------------------------------------------------
  // 4. DIÁLOGO DE EDICIÓN
  // ---------------------------------------------------------
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Actualizar Información'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MODIFICADO POR: $quienModificoValue',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('ÚLTIMA MODIFICACIÓN: $fechaModificoValue',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 16),
                  const Text('NOMBRE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      hintText: 'Escriba el nombre',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => nombreController.clear(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('CARGO',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  TextField(
                    controller: cargoController,
                    decoration: InputDecoration(
                      hintText: 'Escriba el cargo',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => cargoController.clear(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CANCELAR',
                      style: TextStyle(color: customGreen))),
              ElevatedButton(
                onPressed: () async {
                  bool confirmar = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('¿Confirmar?'),
                          content: const Text(
                              'Se actualizarán los datos en la base de datos.'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('NO')),
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('SÍ')),
                          ],
                        ),
                      ) ??
                      false;

                  if (confirmar) {
                    try {
                      // --- 1. ACTUALIZAR FIREBASE ---
                      await doc.reference.update({
                        'nombre': nombreController.text.trim(),
                        'cargo': cargoController.text.trim(),
                        'quienmodifico': currentUserDisplayName,
                        'fechaultimamodificacion': FieldValue.serverTimestamp(),
                      });

                      // --- 2. BUSCAR ID EN POCKETBASE ---
                      final String empNameEncoded =
                          Uri.encodeComponent(nombreBuscado);
                      final searchUrl =
                          'https://api.servidor-inventarios.xyz/fastapi/empleadosPJEV/?filter=(nombre%3D%22$empNameEncoded%22)';

                      final searchResp = await http.get(
                        Uri.parse(searchUrl),
                        headers: {'Authorization': 'Bearer $authToken'},
                      );

                      if (searchResp.statusCode == 200) {
                        final searchData = jsonDecode(searchResp.body);
                        if (searchData['items'] != null &&
                            searchData['items'].isNotEmpty) {
                          final String realId = searchData['items'][0]['id'];

                          // --- 3. ACTUALIZAR POCKETBASE ---
                          final patchUrl =
                              'https://api.servidor-inventarios.xyz/fastapi/empleadosPJEV/$realId';

                          final patchResp = await http
                              .patch(
                                Uri.parse(patchUrl),
                                headers: {
                                  'Authorization': 'Bearer $authToken',
                                  'Content-Type': 'application/json',
                                },
                                body: jsonEncode({
                                  'nombre': nombreController.text.trim(),
                                  'cargo': cargoController.text.trim(),
                                  'quienmodifico':
                                      currentUserDisplayName ?? 'Sistema',
                                  'fechaultimamodificacion':
                                      DateTime.now().toIso8601String(),
                                }),
                              )
                              .timeout(const Duration(seconds: 15));

                          if (patchResp.statusCode == 200 ||
                              patchResp.statusCode == 204) {
                            fueActualizadoExitosamente =
                                true; // MARCADO COMO ÉXITO
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('✅ Sincronización exitosa'),
                                    backgroundColor: customGreen));
                          } else {
                            throw Exception(
                                "Error PATCH: ${patchResp.statusCode}");
                          }
                        }
                      }
                      Navigator.of(context).pop(); // Cierra diálogo edición
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('❌ Error en actualización: $e')));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white),
                child: const Text('ACTUALIZAR'),
              ),
            ],
          );
        },
      );
    },
  );

  return fueActualizadoExitosamente;
}
