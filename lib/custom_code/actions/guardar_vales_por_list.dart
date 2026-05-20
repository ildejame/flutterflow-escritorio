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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> guardarValesPorList(
  String authToken,
  List<dynamic> listaBienes,
  String tipoVale,
  String folioVale,
  String nombreSolicitante,
  String quienRealizaMovimiento,
) async {
  if (listaBienes.isEmpty) {
    print('La lista de bienes está vacía');
    return;
  }

  final String url =
      'https://api.servidor-inventarios.xyz/fastapi/valesmovimientos';
  // --- CAMBIO CLAVE AQUÍ ---
  final DateTime ahora = DateTime.now();
  final String fechaIsoAPI = ahora.toIso8601String(); // Para la API (String)
  final Timestamp fechaTimestampFB =
      Timestamp.fromDate(ahora); // Para Firebase (Timestamp)
  // -------------------------

  int guardadosAPI = 0;
  int guardadosFirebase = 0;

  for (var bien in listaBienes) {
    try {
      // 1. Preparar datos para Firebase (Usando el objeto Timestamp)
      final bodyDataFirebase = {
        'tipovale': tipoVale,
        'fecha': fechaTimestampFB, // Se guarda como objeto de tiempo real
        'foliovale': folioVale,
        'nombresolicitante': nombreSolicitante,
        'quienrealizamovimiento': quienRealizaMovimiento,
        'depositario': bien['tituladelbien']?.toString() ?? '',
        'usuario': bien['depositario']?.toString() ?? '',
        'nivel1': bien['nivel1organizacion']?.toString() ?? '',
        'nivel2': bien['nivel2direccion']?.toString() ?? '',
        'nivel3': bien['nivel3jurisdiccion']?.toString() ?? '',
        'ubicacionfisica': bien['ubicacionfisica']?.toString() ?? '',
        'idbien': bien['inventario2025']?.toString() ?? '',
      };

      // Guardar en Firebase Firestore
      await FirebaseFirestore.instance
          .collection('valesmovimientos')
          .add(bodyDataFirebase);
      guardadosFirebase++;

      // 2. Preparar datos para API FastAPI (Usando el String ISO)
      final bodyDataApi = Map<String, dynamic>.from(bodyDataFirebase);
      bodyDataApi['fecha'] =
          fechaIsoAPI; // Reemplazamos el Timestamp por String para el JSON

      final response = await http.post(
        Uri.parse('$url/'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(bodyDataApi),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        guardadosAPI++;
        print('Vale creado en API para bien: ${bien['inventario2025']}');
      } else {
        print(
            'Error en API para bien ${bien['inventario2025']}: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al procesar el bien ${bien['inventario2025']}: $e');
    }
  }

  print('Proceso finalizado. Firebase: $guardadosFirebase, API: $guardadosAPI');
}
