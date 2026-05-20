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

Future<dynamic> obtenerOficinas(
  BuildContext context,
  String authToken,
) async {
  // Usamos Sets para evitar nombres duplicados automáticamente
  Set<String> setNombre1 = {};
  Set<String> setNombre2 = {};
  Set<String> setNombre3 = {};

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
        for (var item in items) {
          // Extraemos y limpiamos los datos
          String n1 = item['nombre1']?.toString().trim() ?? '';
          String n2 = item['nombre2']?.toString().trim() ?? '';
          String n3 = item['nombre3']?.toString().trim() ?? '';

          if (n1.isNotEmpty) setNombre1.add(n1);
          if (n2.isNotEmpty) setNombre2.add(n2);
          if (n3.isNotEmpty) setNombre3.add(n3);
        }
        page++;
      }
    }

    // Retornamos un solo objeto con las 3 listas limpias
    return {
      'lista1': setNombre1.toList(),
      'lista2': setNombre2.toList(),
      'lista3': setNombre3.toList(),
    };
  } catch (e) {
    print("Error de conexión: $e");
    return {
      'lista1': [],
      'lista2': [],
      'lista3': [],
    };
  }
}
