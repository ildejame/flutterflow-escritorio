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

Future downloadCollectionAsCSV3(List<EstablecimientosRecord>? promo) async {
  // Add your function code here!

  promo = promo ?? [];

  String fileContent =
      "NombreEstablecimiento, NombrePropietario, Movimiento, GiroDeColeccion, FotoLocal, Fecha, Posicion, CodigoQR";

  promo.asMap().forEach((index, record) => fileContent = fileContent +
      "\n" +
      record.nombreEstablecimiento.toString() +
      "," +
      record.nombrePropietario.toString() +
      "," +
      record.movimiento.toString() +
      "," +
      record.giroDeColeccion.toString() +
      "," +
      record.fotoLocal.toString() +
      "," +
      record.fecha.toString() +
      "," +
      record.posicion.toString() +
      "," +
      record.codigoQR.toString());

  final fileName = "Establecimientos" + DateTime.now().toString() + ".csv";

  // Encode the string as a List<int> of UTF-8 bytes
  var bytes = utf8.encode(fileContent);

  final stream = Stream.fromIterable(bytes);
  return download(stream, fileName);
}
