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

Future<void> actualizarEstadoVale(
  BuildContext context,
  String? authToken,
  String? valeId,
  String? nuevoEstado,
) async {
  if (valeId == null || valeId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Error: No se encontró el ID del vale."),
          backgroundColor: Colors.red),
    );
    return;
  }

  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi/vales2';
  final String fechaActual = DateTime.now().toUtc().toIso8601String();

  try {
    final bodyData = {
      'fechademodificacion': fechaActual,
      'estado': nuevoEstado ?? '',
    };

    final response = await http.patch(
      Uri.parse('$baseUrl/$valeId'),
      headers: {
        'Authorization': 'Bearer ${authToken ?? ''}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(bodyData),
    );

    if (!context.mounted) return;

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Estado actualizado a $nuevoEstado"),
            backgroundColor: Colors.green),
      );
    } else {
      print("FastAPI rechazó la actualización. Detalles: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error al actualizar: Código ${response.statusCode}"),
            backgroundColor: Colors.red),
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Error interno de la app: $e"),
          backgroundColor: Colors.red),
    );
  }
}
