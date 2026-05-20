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

import '/flutter_flow/custom_functions.dart';
// Imports custom functions

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> buscarBienesYMovimientosPorFolio(
  BuildContext context,
  String authToken,
  String folioABuscar,
) async {
  final String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final headers = {
    'Authorization': 'Bearer $authToken',
    'Content-Type': 'application/json',
  };

  try {
    // 1. PRIMERA CONSULTA: Buscar en valesmovimientos por el foliovale
    final urlVales = Uri.parse(
        '$baseUrl/valesmovimientos?filter=(foliovale=\'$folioABuscar\')');

    final responseVales = await http.get(urlVales, headers: headers);

    if (responseVales.statusCode != 200) {
      print("Error API Vales: ${responseVales.statusCode}");
      return {"items": [], "total_count": 0};
    }

    final dataVales = jsonDecode(responseVales.body);
    final List<dynamic> vales = dataVales['items'] ?? [];

    if (vales.isEmpty) {
      return {"items": [], "total_count": 0};
    }

    // 2. SEGUNDA CONSULTA: Preparar las peticiones a bienesmuebles
    List<Future<http.Response?>> peticionesBienes = [];

    for (var vale in vales) {
      // ⚠️ IMPORTANTE: Aquí asumo que el campo en 'valesmovimientos' se llama 'idbien'.
      // Cámbialo si usas otro nombre en esa colección para guardar el número de inventario.
      String idInventario = vale['idbien']?.toString() ?? '';

      if (idInventario.isNotEmpty) {
        // Buscamos en bienesmuebles usando el campo inventario2025
        final urlBien = Uri.parse(
            '$baseUrl/bienesmuebles?filter=(inventario2025=\'$idInventario\')');
        peticionesBienes.add(http.get(urlBien, headers: headers));
      } else {
        // Si no hay id, agregamos un null para mantener el orden de la lista
        peticionesBienes.add(Future.value(null));
      }
    }

    // Ejecutamos todas las consultas de bienes en paralelo para mayor velocidad
    final responsesBienes = await Future.wait(peticionesBienes);

    // 3. COMBINAR DATOS: Unir la información del vale con la del bien mueble
    List<dynamic> resultadosFinales = [];

    for (int i = 0; i < vales.length; i++) {
      // Creamos un mapa base con los datos del vale
      Map<String, dynamic> itemCombinado = Map<String, dynamic>.from(vales[i]);
      var responseBien = responsesBienes[i];

      if (responseBien != null && responseBien.statusCode == 200) {
        final dataBien = jsonDecode(responseBien.body);
        final List<dynamic> bienes = dataBien['items'] ?? [];

        if (bienes.isNotEmpty) {
          // Tomamos el bien encontrado que coincide con el inventario2025
          var bien = bienes.first;

          // Inyectamos los campos del bien mueble al item final
          bien.forEach((key, value) {
            if (key == 'fecha') {
              // Renombramos la fecha del bien para que no sobrescriba la fecha del vale
              itemCombinado['fecha_bien'] = value;
            } else if (!itemCombinado.containsKey(key)) {
              itemCombinado[key] = value;
            }
          });
        }
      }
      resultadosFinales.add(itemCombinado);
    }

    // Retornamos la lista combinada
    return {
      "items": resultadosFinales,
      "total_count": resultadosFinales.length,
    };
  } catch (e) {
    print("Error de conexión o procesamiento: $e");
    return {"items": [], "total_count": 0};
  }
}
