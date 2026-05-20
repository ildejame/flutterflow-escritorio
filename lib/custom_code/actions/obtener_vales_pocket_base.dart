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

Future<List<dynamic>> obtenerValesPocketBase(
  BuildContext context,
  String authToken,
) async {
  List<dynamic> listaVales = [];
  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final String collection = 'vales2';

  int page = 1;
  const int perPage = 500;
  bool hayMasRegistros = true;

  try {
    while (hayMasRegistros) {
      final url = Uri.parse('$baseUrl/$collection'
          '?page=$page'
          '&perPage=$perPage'
          '&sort=-fecha' // Orden descendente por fecha
          );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) break;

      final data = jsonDecode(response.body);
      final List<dynamic> items = data['items'] ?? [];

      if (items.isEmpty) {
        hayMasRegistros = false;
      } else {
        for (var item in items) {
          if (item['fecha'] != null && item['fecha'].toString().isNotEmpty) {
            try {
              DateTime fechaOriginal = DateTime.parse(item['fecha'].toString());

              String dia = fechaOriginal.day.toString().padLeft(2, '0');
              String mes = fechaOriginal.month.toString().padLeft(2, '0');
              String anio = fechaOriginal.year.toString();

              item['fecha'] = "$dia/$mes/$anio";
            } catch (e) {
              print("Error formateando fecha: $e");
            }
          }
        }

        listaVales.addAll(items);
        int totalPages = data['totalPages'] ?? 1;
        if (page >= totalPages) {
          hayMasRegistros = false;
        } else {
          page++;
        }
      }
    }
    return listaVales;
  } catch (e) {
    print("Error: $e");
    return [];
  }
}
