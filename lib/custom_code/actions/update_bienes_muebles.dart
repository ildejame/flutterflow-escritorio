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

Future updateBienesMuebles(
  List<DocumentReference> bienesmueblesList,
  String tituladelbien,
  String depositario,
  String estatusdelbien,
  String estadodelvale,
  String nivel1organizacion,
  String nivel2direccion,
  String nivel3jurisdiccion,
  String foliovale,
  String ubicacionfisica,
  String origenbodega, // 🔹 Nuevo parámetro agregado
) async {
  // Update list of documents in "bienesmuebles" collection with current date
  // and the provided parameters

  // Get the Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get the current date and time
  DateTime currentDateTime = DateTime.now();

  // Loop through the list of document references
  for (DocumentReference docRef in bienesmueblesList) {
    try {
      // Get the document snapshot
      DocumentSnapshot snapshot = await docRef.get();

      // Check if the document exists
      if (snapshot.exists) {
        // Update the document with all the fields
        await docRef.update({
          'fechademodificacion': currentDateTime,
          'tituladelbien': tituladelbien,
          'depositario': depositario,
          'estatusdelbien': estatusdelbien,
          'estadodelvale': estadodelvale,
          'nivel1organizacion': nivel1organizacion,
          'nivel2direccion': nivel2direccion,
          'nivel3jurisdiccion': nivel3jurisdiccion,
          'foliovale': foliovale,
          'ubicacionfisica': ubicacionfisica,
          'origenbodega': origenbodega, // 🔹 Campo nuevo
        });

        print('Bien mueble actualizado exitosamente');
      } else {
        print('El documento no existe');
      }
    } catch (e) {
      print('Error al actualizar el bien mueble: $e');
    }
  }
}
