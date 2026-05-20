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

import 'package:pocketbase/pocketbase.dart';
import 'dart:core'; // Importar DateTime

Future<List<EmpleadosStruct>> getList() async {
  final pb = PocketBase('http://189.194.93.56:8090');

  final records = await pb.collection('EMPLEADOS').getFullList(
        sort: '-created', // Orden descendente
      );

  List<EmpleadosStruct> myList = [];

  records.forEach((record) {
    // Convertir el campo "created" de String a DateTime
    final createdString = record.getStringValue('created');
    DateTime? createdDate;

    if (createdString != null) {
      createdDate = DateTime.tryParse(createdString); // Manejo seguro
    }

    EmpleadosStruct empleado = EmpleadosStruct(
      nombre: record.getStringValue('Nombre'),
      estatus: record.getStringValue('estatus'),
      // created: createdDate, // Aquí asignamos el DateTime convertido
    );

    myList.add(empleado);
  });

  return myList;
}
