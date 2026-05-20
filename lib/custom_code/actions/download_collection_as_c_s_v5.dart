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

// Importaciones automáticas de FlutterFlow
import '/custom_code/actions/index.dart'; // Importa otras acciones personalizadas
import '/flutter_flow/custom_functions.dart'; // Importa funciones personalizadas
// Comienza el código de acción personalizado
// ¡NO ELIMINES NI MODIFIQUES EL CÓDIGO SUPERIOR!

import 'dart:convert' show utf8;
import 'package:download/download.dart';

Future downloadCollectionAsCSV5(List<PagosAnualesRecord>? promo) async {
  promo = promo ?? [];

  String limpiarTexto(String texto) {
    return texto
        .toString()
        .replaceAll(",", "|")
        .replaceAll("\n", "|")
        .replaceAllMapped(RegExp(r'[áÁ]'), (match) => 'a')
        .replaceAllMapped(RegExp(r'[éÉ]'), (match) => 'e')
        .replaceAllMapped(RegExp(r'[íÍ]'), (match) => 'i')
        .replaceAllMapped(RegExp(r'[óÓ]'), (match) => 'o')
        .replaceAllMapped(RegExp(r'[úÚ]'), (match) => 'u')
        .replaceAll('ñ', 'n')
        .replaceAll('Ñ', 'N')
        .trim();
  }

  String formatearCoordenadas(double? latitud, double? longitud) {
    return "${latitud ?? 0}|${longitud ?? 0}"
        .replaceAll(",", "|")
        .replaceAll("\n", "|")
        .trim();
  }

  String formatearFecha(DateTime? fecha) {
    return fecha != null ? "${fecha.day}/${fecha.month}/${fecha.year}" : "";
  }

  String contenidoArchivo = "NombreCobrador,Cantidad,Fecha,NombreComercio";

  promo.forEach((record) {
    contenidoArchivo += "\n${limpiarTexto(record.nombreCobrador)},"
        "${record.cantidad?.round().toString() ?? ""}," // Redondea y convierte a cadena
        "${formatearFecha(record.fecha)},"
        "${limpiarTexto(record.qRAnualTicket)},";
  });

  final nombreArchivo = "CobrosAnual${DateTime.now()}.csv";

  var bytes = utf8.encode(contenidoArchivo);
  final stream = Stream.fromIterable(bytes);
  return download(stream, nombreArchivo);
}
