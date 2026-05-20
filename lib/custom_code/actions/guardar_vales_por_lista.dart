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

Future<void> guardarValesPorLista(
  String tipoVale,
  String folioVale,
  String nombreSolicitante,
  String quienRealizaMovimiento,
) async {
  try {
    // Obtener la lista de referencias de documentos desde FFAppState
    final List<DocumentReference> listaBienes = FFAppState().listabieneseditar;

    // Verificar que la lista no esté vacía
    if (listaBienes.isEmpty) {
      print('La lista de bienes está vacía');
      return;
    }

    // Get the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Iterar sobre cada referencia de documento en la lista
    for (DocumentReference docRef in listaBienes) {
      try {
        // Get the document snapshot
        DocumentSnapshot snapshot = await docRef.get();

        // Check if the document exists
        if (snapshot.exists) {
          // Get the document data
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          // Crear un nuevo documento en la colección valesmovimientos
          await ValesmovimientosRecord.collection.doc().set(
                createValesmovimientosRecordData(
                  // Campos actuales que ya se guardaban (ahora como parámetros)
                  tipovale: tipoVale,
                  fecha: getCurrentTimestamp,
                  foliovale: folioVale,
                  nombresolicitante: nombreSolicitante,
                  quienrealizamovimiento: quienRealizaMovimiento,

                  // Nuevos campos mapeados desde cada bien de la lista
                  depositario: data['tituladelbien'] ??
                      '', // tituladelbien → depositario
                  usuario: data['depositario'] ?? '', // depositario → usuario
                  nivel1: data['nivel1organizacion'] ??
                      '', // nivel1organizacion → nivel1
                  nivel2:
                      data['nivel2direccion'] ?? '', // nivel2direccion → nivel2
                  nivel3: data['nivel3jurisdiccion'] ??
                      '', // nivel3jurisdiccion → nivel3
                  ubicacionfisica: data['ubicacionfisica'] ??
                      '', // ubicacionfisica → ubicacionfisica
                  idbien:
                      data['inventario2025'] ?? '', // inventarios2025 → idbien
                ),
              );

          print(
              'Vale de movimiento creado exitosamente para bien: ${data['inventarios2025']}');
        } else {
          print('El documento no existe');
        }
      } catch (e) {
        print('Error al procesar el bien: $e');
      }
    }

    print(
        'Se guardaron ${listaBienes.length} vales de movimiento exitosamente');
  } catch (e) {
    print('Error al guardar los vales de movimiento: $e');
  }
}
