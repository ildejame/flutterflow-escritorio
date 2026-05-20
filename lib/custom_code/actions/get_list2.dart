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
import 'package:flutter/material.dart'; // No lo elimines si usas Material Design

// Asegúrate de tener las clases de backend correctamente importadas (si tienes un modelo)

Future<List<EmpleadosStruct>> getList2() async {
  final pb = PocketBase('http://189.194.93.56:8090');

  // Paso 1: Autenticación
  try {
    // Realizar autenticación con correo y contraseña
    final authData = await pb.collection('users').authWithPassword(
          'ildealcaide@gmail.com', // Reemplaza con tu correo de usuario
          'ildefonsox.1', // Reemplaza con tu contraseña
        );

    // Comprobar si la autenticación fue exitosa
    if (authData.token != null) {
      print("Autenticación exitosa. Token: ${authData.token}");

      // Paso 2: Obtener los registros de la colección 'EMPLEADOS'
      final records = await pb.collection('EMPLEADOS').getFullList(
            sort: '-created', // Orden descendente según la fecha de creación
          );

      List<EmpleadosStruct> myList = [];

      // Iterar sobre cada registro de la colección
      for (var record in records) {
        // Convertir el campo 'created' de String a DateTime de manera segura
        final createdString = record.getStringValue('created');
        DateTime? createdDate;

        if (createdString != null) {
          createdDate = DateTime.tryParse(createdString); // Manejo seguro
        }

        // Crear un objeto EmpleadosStruct y agregarlo a la lista
        EmpleadosStruct empleado = EmpleadosStruct(
          nombre: record.getStringValue('Nombre'),
          estatus: record.getStringValue('estatus'),
          // Si necesitas la fecha, descomenta la siguiente línea
          // created: createdDate,
        );

        myList.add(empleado);
      }

      return myList;
    } else {
      print("No se obtuvo un token de autenticación.");
      return [];
    }
  } catch (e) {
    print("Error durante la autenticación o la obtención de datos: $e");
    return [];
  }
}
