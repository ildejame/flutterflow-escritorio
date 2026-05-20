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

Future<List<dynamic>> oficinas(
  BuildContext context,
  String authToken,
) async {
  // Ahora usamos una lista para guardar todos los objetos completos
  List<dynamic> todosLosRegistros = [];

  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final String collection = 'oficinasPJEV';

  int page = 1;
  const int perPage = 500;
  bool hayMasRegistros = true;

  try {
    while (hayMasRegistros) {
      final url = Uri.parse(
        '$baseUrl/$collection?page=$page&perPage=$perPage&sort=-created',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        print("Error API: ${response.statusCode}");
        break;
      }

      final data = jsonDecode(response.body);
      final List<dynamic> items = data['items'] ?? [];

      if (items.isEmpty) {
        hayMasRegistros = false;
      } else {
        // Agregamos los items tal cual vienen (con todos sus campos) a nuestra lista
        todosLosRegistros.addAll(items);
        page++;
      }
    }

    // Retornamos la lista completa de objetos
    return todosLosRegistros;
  } catch (e) {
    print("Error de conexión: $e");
    return [];
  }
}
