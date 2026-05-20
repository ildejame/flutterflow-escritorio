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

Future<List<dynamic>> obtenerDepositarios(
  BuildContext context,
  String authToken,
) async {
  List<dynamic> listaEmpleados = [];

  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final String collection = 'empleadosPJEV';

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
        // --- PROCESAMIENTO DE REGISTROS ---
        for (var item in items) {
          // Convertimos la fecha al formato día/mes/año
          if (item['created'] != null) {
            item['created'] = formatIsoDate(item['created'].toString());
          }
        }
        // ---------------------------------

        listaEmpleados.addAll(items);
        page++;
      }
    }

    return listaEmpleados;
  } catch (e) {
    print("Error de conexión: $e");
    return [];
  }
}

/// Función auxiliar para cambiar formato de AAAA-MM-DD a DD/MM/AAAA
String formatIsoDate(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) {
    return '';
  }

  try {
    // Intentamos parsear la fecha (soporta formatos ISO 8601)
    DateTime dt = DateTime.parse(isoDate);

    // Extraemos las partes y añadimos un cero a la izquierda si es necesario
    String dia = dt.day.toString().padLeft(2, '0');
    String mes = dt.month.toString().padLeft(2, '0');
    String anio = dt.year.toString();

    return '$dia/$mes/$anio';
  } catch (e) {
    // Si hay un error en el formato original, devolvemos los primeros 10 caracteres
    // para evitar que la app se detenga.
    return isoDate.length >= 10 ? isoDate.substring(0, 10) : isoDate;
  }
}
