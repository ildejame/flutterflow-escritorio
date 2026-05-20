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

Future<List<String>> obtenerNombresEmpleados(
  BuildContext context,
  String authToken,
) async {
  List<String> listaNombres = [];

  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final String collection = 'empleadosPJEV';

  int page = 1;
  const int perPage = 500;
  bool hayMasRegistros = true;

  try {
    while (hayMasRegistros) {
      final url = Uri.parse(
        '$baseUrl/$collection?page=$page&perPage=$perPage',
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
        listaNombres.addAll(
          items.map((item) => item['nombre'].toString()),
        );
        page++;
      }
    }

    return listaNombres;
  } catch (e) {
    print("Error de conexión: $e");
    return [];
  }
}
