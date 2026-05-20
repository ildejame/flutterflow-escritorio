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

Future<bool> crearOficinaPJEV(
  BuildContext context,
  String authToken,
  String nombreOficina,
  String organizacion,
  String direccion,
  String jurisdiccion,
) async {
  // 1. Limpieza de espacios en blanco
  final nombreLimpio = nombreOficina.trim();
  final orgLimpia = organizacion.trim();
  final dirLimpia = direccion.trim();
  final jurLimpia = jurisdiccion.trim();

  // 2. Inicializamos la lista de errores
  List<String> errores = [];

  // 3. Validaciones (Agregamos mensajes a la lista si falta algo)
  if (nombreLimpio.isEmpty) {
    errores.add("• El campo 'Nombre de la organización' es obligatorio");
  }

  // 🔴 4. SI HAY ERRORES → SOLO AVISA Y DETIENE
  if (errores.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errores.join("\n")), // Une los errores con salto de línea
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
    return false; // Retorna false para que no se cierre el diálogo (si configuras el flujo así)
  }

  // 🟢 5. SI ES VÁLIDO → EJECUTA EL POST
  final url = 'https://api.servidor-inventarios.xyz/fastapi/oficinasPJEV';

  try {
    final response = await post(
      Uri.parse('$url/'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': nombreLimpio,
        'nombre1': orgLimpia, // Organización
        'nombre2': dirLimpia, // Dirección
        'nombre3': jurLimpia, // Jurisdicción
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Oficina '$nombreLimpio' agregada correctamente"),
          backgroundColor: const Color(0xFF1B5E20), // Verde oscuro
        ),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Error del servidor: ${response.statusCode} - ${response.body}"),
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
