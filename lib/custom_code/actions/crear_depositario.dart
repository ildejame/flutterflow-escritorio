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
import 'package:http/http.dart';

Future<bool> crearDepositario(
  BuildContext context,
  String authToken,
  String nombre,
  String cargo,
) async {
  final nombreLimpio = nombre.trim();
  final cargoLimpio = cargo.trim();

  List<String> errores = [];

  if (nombreLimpio.isEmpty) {
    errores.add("• El campo 'Nombre' es obligatorio");
  }

  if (cargoLimpio.isEmpty) {
    errores.add("• El campo 'Cargo' es obligatorio");
  }

  // 🔴 SI HAY ERRORES → SOLO AVISA
  if (errores.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errores.join("\n")),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );

    return false; // solo indicador lógico
  }

  // 🟢 SI ES VÁLIDO → AHORA SÍ HACE POST
  final url = 'https://api.servidor-inventarios.xyz/fastapi/empleadosPJEV';

  try {
    final response = await post(
      Uri.parse('$url/'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': nombreLimpio,
        'cargo': cargoLimpio,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Empleado(a) '$nombreLimpio' agregado correctamente"),
          backgroundColor: const Color(0xFF1B5E20),
        ),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${response.statusCode} - ${response.body}"),
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
