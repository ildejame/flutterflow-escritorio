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

Future<List<dynamic>> obtenerDepreciacionesPB(
  BuildContext context,
  String authToken,
) async {
  List<dynamic> listaDepreciaciones = [];

  // URL corregida con el segmento /api/collections/ requerido por PocketBase
  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final String collection = 'depreciacion';

  int page = 1;
  const int perPage = 50;
  bool hayMasRegistros = true;

  try {
    while (hayMasRegistros) {
      // CAMBIO CLAVE: Se usa sort=nombre para que el 511 aparezca antes que el 512, etc.
      final url = Uri.parse(
        '$baseUrl/$collection/?page=$page&perPage=$perPage&sort=nombre',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        print("Error PocketBase: ${response.statusCode}");
        break;
      }

      final data = jsonDecode(response.body);
      final List<dynamic> items = data['items'] ?? [];

      if (items.isEmpty) {
        hayMasRegistros = false;
      } else {
        for (var item in items) {
          // Usamos el campo fechaalta que se ve en tu base de datos
          if (item['fechaalta'] != null) {
            item['fecha_formateada'] =
                formatIsoDate(item['fechaalta'].toString());
          }
        }

        listaDepreciaciones.addAll(items);

        int totalPages = data['totalPages'] ?? 1;
        if (page >= totalPages) {
          hayMasRegistros = false;
        } else {
          page++;
        }
      }
    }

    return listaDepreciaciones;
  } catch (e) {
    print("Error de conexión PocketBase: $e");
    return [];
  }
}

String formatIsoDate(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return '';
  try {
    DateTime dt = DateTime.parse(isoDate);
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  } catch (e) {
    return isoDate.length >= 10 ? isoDate.substring(0, 10) : isoDate;
  }
}
