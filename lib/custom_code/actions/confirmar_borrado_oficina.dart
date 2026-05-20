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

Future<bool> confirmarBorradoOficina(
  BuildContext context,
  String authToken,
  String idOficina,
) async {
  // 1. Mostramos el diálogo con el diseño de la captura
  final bool? resultado = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono de Alerta (Triángulo rojo)
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFF5252), // Rojo tipo "Salmon" de la imagen
            size: 60,
          ),
          const SizedBox(height: 16),

          // Título
          const Text(
            "¿Eliminar registro?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Texto del cuerpo
          const Text(
            "¿Estás seguro de que deseas borrar este registro?\nEsta acción no se puede deshacer.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54, // Gris suave
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Botones (Fila)
          Row(
            children: [
              // Botón CANCELAR (Borde gris, fondo blanco)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                        color: Color(0xFFE0E0E0)), // Borde gris claro
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: Colors.black87, // Color del texto
                  ),
                  child: const Text(
                    "CANCELAR",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Botón BORRAR (Fondo Rojo, texto blanco)
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFFFF5252), // Rojo intenso
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "BORRAR",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  // Si cancela, salimos
  if (resultado != true) return false;

  // 2. Lógica de borrado (API)
  final url =
      'https://api.servidor-inventarios.xyz/fastapi/oficinasPJEV/$idOficina';

  try {
    final resp = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (!context.mounted)
      return (resp.statusCode == 200 || resp.statusCode == 204);

    if (resp.statusCode == 200 || resp.statusCode == 204) {
      // ÉXITO: SnackBar Verde
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Oficina eliminada correctamente",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF1B5E20), // Verde oscuro
          behavior: SnackBarBehavior.floating,
        ),
      );
      return true;
    } else {
      // ERROR
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al eliminar el registro"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error de conexión"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    return false;
  }
}
