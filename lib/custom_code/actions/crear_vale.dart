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
import 'package:cloud_firestore/cloud_firestore.dart'; // Asegura el acceso a Timestamp

Future<bool> crearVale(
  BuildContext context,
  String authToken,
  String tipovale,
  String quienrealizamovimiento,
  String foliovale,
  String nombresolicitante,
  String estado,
  String pendientebodega,
) async {
  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final String collection = 'vales2';

  // Generamos el momento actual
  final DateTime ahora = DateTime.now();

  try {
    final url = Uri.parse('$baseUrl/$collection/');

    // 1. Guardar en Firebase Firestore usando Timestamp
    // Esto hará que en la consola se vea como "19 de marzo de 2026..."
    await FirebaseFirestore.instance.collection(collection).add({
      'tipovale': tipovale,
      'fecha': Timestamp.fromDate(ahora), // Cambio clave aquí
      'quienrealizamovimiento': quienrealizamovimiento,
      'foliovale': foliovale,
      'nombresolicitante': nombresolicitante,
      'estado': estado,
      'pendientebodega': pendientebodega,
    });

    print("Registro creado en Firebase: $collection");

    // 2. Preparar datos para API FastAPI (JSON prefiere Strings)
    final bodyDataApi = {
      'tipovale': tipovale,
      'fecha': ahora.toIso8601String(),
      'quienrealizamovimiento': quienrealizamovimiento,
      'foliovale': foliovale,
      'nombresolicitante': nombresolicitante,
      'estado': estado,
      'pendientebodega': pendientebodega,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bodyDataApi),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Vale creado exitosamente"),
            backgroundColor: Color(0xFF1B5E20)),
      );
      return true;
    } else {
      throw Exception("Error del servidor: ${response.statusCode}");
    }
  } catch (e) {
    print("Error de conexión o Firebase: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Error al procesar el vale"),
          backgroundColor: Colors.red),
    );
    return false;
  }
}
