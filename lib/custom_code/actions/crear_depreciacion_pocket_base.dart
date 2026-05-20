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

Future<bool> crearDepreciacionPocketBase(
  BuildContext context,
  String nombre,
  double porcentaje,
  int vidaUtil,
  String authToken, // <--- ADD THIS PARAMETER IN FLUTTERFLOW SETTINGS
) async {
  final nombreLimpio = nombre.trim();
  List<String> errores = [];

  if (nombreLimpio.isEmpty) {
    errores.add("• El campo 'Nombre' es obligatorio");
  }

  if (porcentaje <= 0) {
    errores.add("• El porcentaje debe ser mayor a 0");
  }

  if (errores.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errores.join("\n")),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }

  final String url =
      'https://api.servidor-inventarios.xyz/fastapi/depreciacion';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // <--- THIS FIXES THE 401 ERROR
      },
      body: jsonEncode({
        'nombre': nombreLimpio,
        'porcentajedepreciacion': porcentaje,
        'vidautil': vidaUtil,
        'fechaalta': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registro '$nombreLimpio' creado con éxito"),
          backgroundColor: const Color(0xFF1B5E20),
        ),
      );
      return true;
    } else {
      // Logic for handling specific 401/403 errors in the UI
      String errorMsg = response.statusCode == 401
          ? "Sesión expirada o no autorizado"
          : "Error: ${response.statusCode}";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error de conexión: $e"),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }
}
