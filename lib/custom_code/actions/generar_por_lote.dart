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

Future<void> generarPorLote(BuildContext context, String authToken) async {
  final TextEditingController inicioCtrl = TextEditingController();
  final TextEditingController finCtrl = TextEditingController();
  bool isProcessing = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => Dialog(
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
                  "Generar por lote",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                const SizedBox(height: 24),
                _buildNumericField(inicioCtrl, "Valor inicial", isProcessing),
                const SizedBox(height: 16),
                _buildNumericField(finCtrl, "Valor final", isProcessing),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isProcessing)
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text("CANCELAR",
                            style: TextStyle(
                                color: Color(0xFF1B5E20),
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
                      onPressed: isProcessing
                          ? null
                          : () async {
                              final txtInicio = inicioCtrl.text.trim();
                              final txtFin = finCtrl.text.trim();

                              if (txtInicio.isEmpty || txtFin.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Advertencia: Faltan campos"),
                                        backgroundColor: Colors.red));
                                return;
                              }

                              int inicio = int.parse(txtInicio);
                              int fin = int.parse(txtFin);

                              if (inicio > fin) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Advertencia: Rango inválido"),
                                        backgroundColor: Colors.red));
                                return;
                              }

                              setState(() => isProcessing = true);

                              try {
                                for (int i = inicio; i <= fin; i++) {
                                  // Se envía directamente sin validación previa
                                  await _enviarRegistroLote(
                                      context, authToken, i.toString(),
                                      esUltimo: i == fin);
                                }
                                Navigator.pop(dialogContext);
                              } catch (e) {
                                setState(() => isProcessing = false);
                              }
                            },
                      child: isProcessing
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text("GENERAR",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                if (isProcessing)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: Text("Procesando lote, por favor espere...",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1B5E20),
                              fontStyle: FontStyle.italic)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildNumericField(
    TextEditingController controller, String label, bool disabled) {
  return TextField(
    controller: controller,
    enabled: !disabled,
    style: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF1B5E20), fontSize: 16),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(4)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1B5E20), width: 1.5),
          borderRadius: BorderRadius.circular(4)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
  );
}

Future<void> _enviarRegistroLote(BuildContext context, String token, String id,
    {required bool esUltimo}) async {
  final url = 'https://api.servidor-inventarios.xyz/fastapi/impresionetiquetas';

  // --- SE ELIMINÓ EL BLOQUE DE VALIDACIÓN GET ---

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

  // Notificación de éxito solo al terminar el lote o si hay un error crítico
  if ((resp.statusCode == 200 || resp.statusCode == 201)) {
    if (esUltimo) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Lote procesado exitosamente"),
          backgroundColor: Color(0xFF1B5E20)));
    }
  } else {
    // Si falla un registro individual, notificamos el error
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error en ID $id: ${resp.statusCode}"),
        backgroundColor: Colors.orange));
  }
}
