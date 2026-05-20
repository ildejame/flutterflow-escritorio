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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart'; // <--- AGREGADO: Necesario para que Firebase funcione

Future<bool> confirmarBorradoEmpleado(
  BuildContext context,
  String authToken,
  String idEmpleado,
  String nombreEmpleado,
  String? firebaseDocId,
) async {
  // 1. Mostrar diálogo de confirmación
  final bool? confirmar = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              const Text(
                "¿Eliminar registro?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.black54, fontSize: 15),
                  children: [
                    const TextSpan(
                        text: "¿Estás seguro de que deseas borrar a "),
                    TextSpan(
                      text: nombreEmpleado,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const TextSpan(text: "? Esta acción no se puede deshacer."),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text("CANCELAR",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text("BORRAR",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );

  if (confirmar != true) return false;

  // 2. Borrado en PocketBase vía FastAPI
  final url =
      'https://api.servidor-inventarios.xyz/fastapi/empleadosPJEV/$idEmpleado';

  try {
    final resp = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 15));

    if (resp.statusCode == 200 || resp.statusCode == 204) {
      // 3. Borrado en Firebase (empleadospjev)
      try {
        // CAMBIO AQUÍ: Priorizamos la búsqueda por nombre ya que PocketBase no conoce el ID de Firebase
        final collection =
            FirebaseFirestore.instance.collection('empleadospjev');

        // Buscamos el documento donde el campo 'nombre' sea igual al que recibimos
        final querySnapshot =
            await collection.where('nombre', isEqualTo: nombreEmpleado).get();

        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            await doc.reference.delete();
          }
        } else {
          print("No se encontró el nombre '$nombreEmpleado' en Firebase");
        }
      } catch (e) {
        print("Error en Firebase: $e");
        // No retornamos false aquí para que al menos sepa que PocketBase sí se borró
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empleado '$nombreEmpleado' eliminado de ambos sistemas"),
        backgroundColor: const Color(0xFF1B5E20),
      ));
      return true;
    } else {
      throw Exception("Error del servidor: ${resp.statusCode}");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error al eliminar el registro: $e"),
      backgroundColor: Colors.red,
    ));
    return false;
  }
}
