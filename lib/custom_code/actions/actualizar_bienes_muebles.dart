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

import '/flutter_flow/custom_functions.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

Future<void> actualizarBienesMuebles(
  BuildContext context,
  String? authToken,
  List<dynamic>? editarlistabienesmuebles,
  String? tituladelbien,
  String? depositario,
  String? estatusdelbien,
  String? estadodelvale,
  String? nivel1organizacion,
  String? nivel2direccion,
  String? nivel3jurisdiccion,
  String? foliovale,
  String? ubicacionfisica,
  String? origenbodega,
  String? quienmodifico,
) async {
  if (editarlistabienesmuebles == null || editarlistabienesmuebles.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("No hay bienes seleccionados para mover."),
          backgroundColor: Colors.red),
    );
    return;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Verificar si el usuario actual es Administrador
  // ───────────────────────────────────────────────────────────────────────────
  bool esAdministrador = false;
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();
    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      esAdministrador =
          (userData['permiso'] ?? '').toString().trim() == 'Administrador';
    }
  } catch (e) {
    // Si hay error en la verificación, asumimos que no es administrador
    esAdministrador = false;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Mensaje si no es administrador y se intenta modificar el Nivel 1
  // ───────────────────────────────────────────────────────────────────────────
  if (!esAdministrador &&
      nivel1organizacion != null &&
      nivel1organizacion.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No tienes permisos para modificar el Nivel 1 (Organización). Solo administradores pueden editar este campo. El resto de los datos se actualizarán normalmente.',
        ),
        backgroundColor: Color(0xFF164b2d),
        duration: Duration(seconds: 4),
      ),
    );
  }

  final String baseUrl =
      'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles';
  final DateTime ahora = DateTime.now();
  final String editor = (quienmodifico != null && quienmodifico.isNotEmpty)
      ? quienmodifico
      : 'Sistema';

  // 1. Mapa base con valores provistos (Evita borrar info existente)
  final Map<String, dynamic> baseData = {};
  if (tituladelbien != null) baseData['tituladelbien'] = tituladelbien;
  if (depositario != null) baseData['depositario'] = depositario;
  if (estatusdelbien != null) baseData['estatusdelbien'] = estatusdelbien;
  if (estadodelvale != null) baseData['estadodelvale'] = estadodelvale;

  // Solo si es administrador se incluye nivel1organizacion
  if (esAdministrador && nivel1organizacion != null) {
    baseData['nivel1organizacion'] = nivel1organizacion;
  }

  if (nivel2direccion != null) baseData['nivel2direccion'] = nivel2direccion;
  if (nivel3jurisdiccion != null)
    baseData['nivel3jurisdiccion'] = nivel3jurisdiccion;
  if (foliovale != null) baseData['foliovale'] = foliovale;
  if (ubicacionfisica != null) baseData['ubicacionfisica'] = ubicacionfisica;
  if (origenbodega != null) baseData['origenbodega'] = origenbodega;
  baseData['quienmodifico'] = editor;

  try {
    for (var item in editarlistabienesmuebles) {
      Map<String, dynamic> bien = {};
      if (item is Map) {
        bien = Map<String, dynamic>.from(item);
      } else {
        bien = jsonDecode(item.toString());
      }

      // Identificadores: recordId para la API y valorInventario para Firebase
      String recordId = bien['id']?.toString() ?? '';
      String valorInventario = bien['inventario2025']?.toString() ?? recordId;

      if (valorInventario.isEmpty) continue;

      // 2. Preparar datos para Firebase
      final Map<String, dynamic> bodyDataFirebase = Map.from(baseData);
      bodyDataFirebase['fechademodificacion'] = Timestamp.fromDate(ahora);
      bodyDataFirebase['fechaultimamodificacion'] = Timestamp.fromDate(ahora);

      // --- INICIO CAMBIO FIREBASE ---
      try {
        // Buscamos el documento donde el campo 'inventario2025' coincida
        var querySnapshot = await FirebaseFirestore.instance
            .collection('bienesmuebles')
            .where('inventario2025', isEqualTo: valorInventario)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Actualizamos usando el ID interno de Firestore encontrado
          await FirebaseFirestore.instance
              .collection('bienesmuebles')
              .doc(querySnapshot.docs.first.id)
              .set(bodyDataFirebase, SetOptions(merge: true));
        } else {
          print(
              "No se encontró el inventario2025: $valorInventario en Firebase.");
        }
      } catch (e) {
        print("Error en Firebase para $valorInventario: $e");
      }
      // --- FIN CAMBIO FIREBASE ---

      // 3. Preparar y enviar a FastAPI/PocketBase
      if (recordId.isNotEmpty) {
        final Map<String, dynamic> bodyDataAPI = Map.from(baseData);
        bodyDataAPI['fechademodificacion'] = ahora.toIso8601String();
        bodyDataAPI['fechaultimamodificacion'] = ahora.toIso8601String();

        final response = await http.patch(
          Uri.parse('$baseUrl/$recordId'),
          headers: {
            'Authorization': 'Bearer ${authToken ?? ''}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(bodyDataAPI),
        );

        if (response.statusCode != 200 && response.statusCode != 204) {
          print("FastAPI rechazó el bien $recordId: ${response.body}");
        }
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Bienes actualizados correctamente"),
            backgroundColor: Colors.green),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error interno: $e"), backgroundColor: Colors.red),
      );
    }
  }
}
