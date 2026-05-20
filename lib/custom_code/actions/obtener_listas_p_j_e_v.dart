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

Future<List<dynamic>> obtenerListasPJEV(
  BuildContext context,
  String authToken,
) async {
  List<dynamic> listaResultados = [];

  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final String collection = 'ListasPJEV';

  int page = 1;
  const int perPage = 500; // Aumentado como en tu código de referencia
  bool hayMasRegistros = true;

  try {
    while (hayMasRegistros) {
      // Ordenamos por nombredeelemento para que aparezcan: Distrito 01, 02, etc.
      final url = Uri.parse(
        '$baseUrl/$collection?page=$page&perPage=$perPage&sort=nombredeelemento',
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
        // --- PROCESAMIENTO DE REGISTROS (IGUAL A TU REFERENCIA) ---
        for (var item in items) {
          // IMPORTANTE: Sobrescribimos 'fechacreacion' para que la UI se actualice sola
          if (item['fechacreacion'] != null) {
            item['fechacreacion'] =
                formatIsoDate(item['fechacreacion'].toString());
          }
        }
        // ---------------------------------

        listaResultados.addAll(items);

        // Verificación de paginación
        int totalPages = data['totalPages'] ?? 1;
        if (page >= totalPages) {
          hayMasRegistros = false;
        } else {
          page++;
        }
      }
    }

    return listaResultados;
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
    // Intenta parsear la fecha ISO (ej: 2027-09-10...)
    DateTime dt = DateTime.parse(isoDate);

    String dia = dt.day.toString().padLeft(2, '0');
    String mes = dt.month.toString().padLeft(2, '0');
    String anio = dt.year.toString();

    return '$dia/$mes/$anio';
  } catch (e) {
    // Si falla el parseo (por el texto en español), devuelve los primeros 10 caracteres
    return isoDate.length >= 10 ? isoDate.substring(0, 10) : isoDate;
  }
}
