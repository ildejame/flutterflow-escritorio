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
import 'package:intl/intl.dart'; // Importación necesaria para formatear fechas

Future<dynamic> buscarBienMueble(
  BuildContext context,
  String authToken,
  String numeroInventario,
) async {
  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final String collection = 'bienesmuebles';

  try {
    final url = Uri.parse('$baseUrl/$collection').replace(queryParameters: {
      'filter': '(inventario2025=\'$numeroInventario\')',
      'perPage': '1',
    });

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      print("Error API: ${response.statusCode}");
      return null;
    }

    final data = jsonDecode(response.body);
    final List<dynamic> items = data['items'] ?? [];

    if (items.isNotEmpty) {
      // Obtenemos el primer registro
      Map<String, dynamic> item = Map<String, dynamic>.from(items.first);

      // --- Lógica de formateo de fechas ---
      final DateFormat formatter = DateFormat('dd/MM/yyyy');

      // Formatear fechaadquisicion
      if (item['fechaadquisicion'] != null &&
          item['fechaadquisicion'].toString().isNotEmpty) {
        try {
          DateTime dt = DateTime.parse(item['fechaadquisicion'].toString());
          item['fechaadquisicion'] = formatter.format(dt);
        } catch (e) {
          print("Error al parsear fechaadquisicion: $e");
        }
      }

      // Formatear fechaavaluo
      if (item['fechaavaluo'] != null &&
          item['fechaavaluo'].toString().isNotEmpty) {
        try {
          DateTime dt = DateTime.parse(item['fechaavaluo'].toString());
          item['fechaavaluo'] = formatter.format(dt);
        } catch (e) {
          print("Error al parsear fechaavaluo: $e");
        }
      }
      // ------------------------------------

      return item;
    } else {
      print("No se encontró el inventario: $numeroInventario");
      return null;
    }
  } catch (e) {
    print("Error de conexión: $e");
    return null;
  }
}
