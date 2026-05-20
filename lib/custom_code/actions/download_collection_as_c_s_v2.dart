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

import 'dart:convert' show utf8;
import 'package:download/download.dart';

Future downloadCollectionAsCSV2(List<EstablecimientosRecord>? promo) async {
  promo = promo ?? [];
  String fileContent =
      "NombreEstablecimiento; NombrePropietario; Movimiento; GiroDeColeccion; FotoLocal; Fecha; Posicion; CodigoQR";
  promo.asMap().forEach((index, record) => fileContent = fileContent +
      "\n" +
      record.nombreEstablecimiento
          .toString()
          .replaceAll(",", ";")
          .replaceAll("\n", ";")
          .replaceAllMapped(RegExp(r'[áÁ]'), (match) => 'a')
          .replaceAllMapped(RegExp(r'[éÉ]'), (match) => 'e')
          .replaceAllMapped(RegExp(r'[íÍ]'), (match) => 'i')
          .replaceAllMapped(RegExp(r'[óÓ]'), (match) => 'o')
          .replaceAllMapped(RegExp(r'[úÚ]'), (match) => 'u')
          .replaceAll('ñ', 'n')
          .replaceAll('Ñ', 'N')
          .trim() +
      ";" +
      record.nombrePropietario
          .toString()
          .replaceAll(",", ";")
          .replaceAll("\n", ";")
          .replaceAllMapped(RegExp(r'[áÁ]'), (match) => 'a')
          .replaceAllMapped(RegExp(r'[éÉ]'), (match) => 'e')
          .replaceAllMapped(RegExp(r'[íÍ]'), (match) => 'i')
          .replaceAllMapped(RegExp(r'[óÓ]'), (match) => 'o')
          .replaceAllMapped(RegExp(r'[úÚ]'), (match) => 'u')
          .replaceAll('ñ', 'n')
          .replaceAll('Ñ', 'N')
          .trim() +
      ";" +
      record.movimiento
          .toString()
          .replaceAll(",", ";")
          .replaceAll("\n", ";")
          .trim() +
      ";" +
      record.giroDeColeccion
          .toString()
          .replaceAll(",", "|")
          .replaceAll("\n", ";")
          .replaceAllMapped(RegExp(r'[áÁ]'), (match) => 'a')
          .replaceAllMapped(RegExp(r'[éÉ]'), (match) => 'e')
          .replaceAllMapped(RegExp(r'[íÍ]'), (match) => 'i')
          .replaceAllMapped(RegExp(r'[óÓ]'), (match) => 'o')
          .replaceAllMapped(RegExp(r'[úÚ]'), (match) => 'u')
          .replaceAll('ñ', 'n')
          .replaceAll('Ñ', 'N')
          .trim() +
      ";" +
      record.fotoLocal.toString().replaceAll("\n", ";").trim() +
      ";" +
      record.fecha.toString().replaceAll("\n", ";").trim() +
      ";" +
      "${record.posicion!.latitude}|${record.posicion?.longitude}"
          .replaceAll(",", ";")
          .replaceAll("\n", ";")
          .trim() +
      ";" +
      record.codigoQR
          .toString()
          .replaceAll(",", ";")
          .replaceAll("\n", ";")
          .trim());
  final fileName = "Establecimientos" + DateTime.now().toString() + ".csv";
// Encode the string as a List<int> of UTF-8 bytes
  var bytes = utf8.encode(fileContent);
  final stream = Stream.fromIterable(bytes);
  return download(stream, fileName);
}
