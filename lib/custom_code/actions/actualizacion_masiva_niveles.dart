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

Future<bool> actualizacionMasivaNiveles(
  BuildContext context,
  String authToken,
) async {
  const Color customGreen = Color(0xFF164b2d);
  final firestore = FirebaseFirestore.instance;

  // ---------------------------------------------------------
  // 1. DIÁLOGO DE BÚSQUEDA (Pedir Nivel 2)
  // ---------------------------------------------------------
  final TextEditingController searchController = TextEditingController();
  final String? nivel2Buscado = await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: const Text('Búsqueda Masiva'),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Nombre del Nivel 2 a buscar',
            hintText: 'Ej. DIRECCIÓN GENERAL...',
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: customGreen, width: 2),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => searchController.clear(),
            ),
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
            child: const Text('BUSCAR'),
          ),
        ],
      );
    },
  );

  if (nivel2Buscado == null || nivel2Buscado.isEmpty) return false;

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
          Expanded(child: Text('Buscando bienes...')),
        ],
      ),
    ),
  );

  QuerySnapshot<Map<String, dynamic>> snapshot;
  try {
    snapshot = await firestore
        .collection('bienesmuebles')
        .where('nivel2direccion', isEqualTo: nivel2Buscado)
        .get();
  } catch (e) {
    Navigator.of(context).pop(); // Cierra loading
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('❌ Error en búsqueda: $e')));
    return false;
  }

  Navigator.of(context).pop(); // Cierra loading

  if (snapshot.docs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('⚠️ No se encontraron bienes con ese Nivel 2.')));
    return false;
  }

  // ---------------------------------------------------------
  // 3. DIÁLOGO DE RESULTADOS (Listado)
  // ---------------------------------------------------------
  final bool avanzar = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Encontré ${snapshot.docs.length} bienes',
                style: const TextStyle(color: customGreen)),
            content: SizedBox(
              width: double.maxFinite,
              height: 300, // Altura fija para la lista
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.docs[index].data();
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${data['inventario2025'] ?? 'N/A'}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Nivel 2: ${data['nivel2direccion'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 12)),
                          Text(
                              'Nivel 3: ${data['nivel3jurisdiccion'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 12)),
                          Text('Ubicación: ${data['ubicacionfisica'] ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text('CANCELAR'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white),
                child: const Text('CAMBIAR NIVELES'),
              ),
            ],
          );
        },
      ) ??
      false;

  if (!avanzar) return false;

  // ---------------------------------------------------------
  // 4. DIÁLOGO DE EDICIÓN MASIVA
  // ---------------------------------------------------------
  final TextEditingController nuevoNivel2Ctrl = TextEditingController();
  final TextEditingController nuevoNivel3Ctrl = TextEditingController();
  final TextEditingController nuevaUbicacionCtrl = TextEditingController();

  final Map<String, String>? nuevosDatos =
      await showDialog<Map<String, String>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ingresar Nuevos Datos'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nuevoNivel2Ctrl,
                decoration: const InputDecoration(
                    labelText: 'Nuevo Nivel 2', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nuevoNivel3Ctrl,
                decoration: const InputDecoration(
                    labelText: 'Nuevo Nivel 3', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nuevaUbicacionCtrl,
                decoration: const InputDecoration(
                    labelText: 'Nueva Ubicación Física',
                    border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nuevoNivel2Ctrl.text.isNotEmpty &&
                  nuevoNivel3Ctrl.text.isNotEmpty) {
                Navigator.of(context).pop({
                  'nivel2': nuevoNivel2Ctrl.text.trim(),
                  'nivel3': nuevoNivel3Ctrl.text.trim(),
                  'ubicacion': nuevaUbicacionCtrl.text.trim(),
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Nivel 2 y 3 son obligatorios')));
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: customGreen, foregroundColor: Colors.white),
            child: const Text('APLICAR A TODOS'),
          ),
        ],
      );
    },
  );

  if (nuevosDatos == null) return false;

  // ---------------------------------------------------------
  // 5. EJECUCIÓN Y SINCRONIZACIÓN MASIVA
  // ---------------------------------------------------------
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          const SizedBox(width: 20),
          Expanded(
              child: Text('Actualizando ${snapshot.docs.length} bienes...')),
        ],
      ),
    ),
  );

  int exitosos = 0;
  int fallidos = 0;

  for (var doc in snapshot.docs) {
    try {
      final data = doc.data();
      final String inventarioActual = (data['inventario2025'] ?? '').toString();

      if (inventarioActual.isEmpty) {
        fallidos++;
        continue;
      }

      // --- A. ACTUALIZAR FIREBASE ---
      await doc.reference.update({
        'nivel2direccion': nuevosDatos['nivel2'],
        'nivel3jurisdiccion': nuevosDatos['nivel3'],
        'ubicacionfisica': nuevosDatos['ubicacion'],
        'quienmodifico': currentUserDisplayName ?? 'Sistema',
        'fechaultimamodificacion': FieldValue.serverTimestamp(),
      });

      // --- B. OBTENER ID REAL DE POCKETBASE ---
      final searchUrl =
          'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/?filter=(inventario2025%3D%22$inventarioActual%22)';
      final searchResp = await http.get(Uri.parse(searchUrl),
          headers: {'Authorization': 'Bearer $authToken'});

      if (searchResp.statusCode == 200) {
        final searchData = jsonDecode(searchResp.body);
        if (searchData['items'] != null && searchData['items'].isNotEmpty) {
          final String realId = searchData['items'][0]['id'];

          // --- C. ACTUALIZAR POCKETBASE (PATCH) ---
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
                  'nivel2direccion': nuevosDatos['nivel2'],
                  'nivel3jurisdiccion': nuevosDatos['nivel3'],
                  'ubicacionfisica': nuevosDatos['ubicacion'],
                  'quienmodifico': currentUserDisplayName ?? 'Sistema',
                  'fechaultimamodificacion': DateTime.now().toIso8601String(),
                }),
              )
              .timeout(const Duration(seconds: 15));

          if (patchResp.statusCode == 200 || patchResp.statusCode == 204) {
            exitosos++;
          } else {
            fallidos++;
          }
        } else {
          fallidos++; // No encontrado en servidor externo
        }
      } else {
        fallidos++; // Error en GET
      }
    } catch (e) {
      fallidos++;
    }
  }

  Navigator.of(context).pop(); // Cierra loading de actualización

  // Mostrar resumen final
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content:
        Text('✅ Proceso terminado. Exitosos: $exitosos | Fallidos: $fallidos'),
    backgroundColor: fallidos > 0 ? Colors.orange : customGreen,
    duration: const Duration(seconds: 5),
  ));

  return exitosos > 0;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
