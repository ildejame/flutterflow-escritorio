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

Future<dynamic> buscarValePorFolio(
  BuildContext context,
  String authToken,
  String folioABuscar,
) async {
  // 🔹 Cambiamos la colección a vales2
  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final String collection = 'vales2';

  try {
    final url = Uri.parse(
      '$baseUrl/$collection?filter=(foliovale=\'$folioABuscar\')&perPage=1',
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
      return null;
    }

    final data = jsonDecode(response.body);
    final List<dynamic> items = data['items'] ?? [];

    if (items.isNotEmpty) {
      for (var item in items) {
        if (item['fecha'] != null) {
          try {
            DateTime fechaParseada = DateTime.parse(item['fecha']);
            String dia = fechaParseada.day.toString().padLeft(2, '0');
            String mes = fechaParseada.month.toString().padLeft(2, '0');
            String anio = fechaParseada.year.toString();

            item['fecha'] = '$dia/$mes/$anio';
          } catch (e) {
            print("Error al formatear fecha: $e");
          }
        }
      }

      return items;
    } else {
      print("No se encontró el folio de vale: $folioABuscar");
      return null;
    }
  } catch (e) {
    print("Error de conexión: $e");
    return null;
  }
}
