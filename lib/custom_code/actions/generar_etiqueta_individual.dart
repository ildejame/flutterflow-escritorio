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

import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> generarEtiquetaIndividual(
    BuildContext context, String authToken) async {
  final TextEditingController idController = TextEditingController();

  await showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Generar etiqueta",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "inventario2025",
                  labelStyle: TextStyle(color: Color(0xFF1B5E20), fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF1B5E20), width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text("CANCELAR",
                        style: TextStyle(
                            color: Color(0xFF1B5E20),
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: () async {
                      final val = idController.text.trim();
                      if (val.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Advertencia: El campo está vacío"),
                            backgroundColor: Colors.red));
                        return;
                      }

                      try {
                        await _ejecutarEnvio(context, authToken, val);
                        Navigator.pop(dialogContext);
                      } catch (e) {
                        // El error se maneja dentro de _ejecutarEnvio
                      }
                    },
                    child: const Text("GENERAR",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

// Lógica simplificada: Envía el registro directamente sin validar duplicados
Future<void> _ejecutarEnvio(
    BuildContext context, String token, String id) async {
  final url = 'https://api.servidor-inventarios.xyz/fastapi/impresionetiquetas';

  // Se eliminó la sección de validación de duplicados (GET)

  // Crear registro directamente
  final resp = await http.post(Uri.parse('$url/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'inventario2025': id,
        'estado': 'pendiente',
        'intentos': 0,
        'listoParaImprimir': true
      }));

  if (resp.statusCode == 200 || resp.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Registro '$id' creado exitosamente"),
      backgroundColor: Color(0xFF1B5E20),
      duration: Duration(seconds: 2),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Error al crear el registro (Código: ${resp.statusCode})"),
        backgroundColor: Colors.red));
    throw Exception("Error de red");
  }
}
