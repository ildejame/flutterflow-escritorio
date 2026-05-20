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
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as excel;

Future<void> cargarArchivoExcel(BuildContext context, String authToken) async {
  PlatformFile? selectedFile;
  bool isProcessing = false;
  String statusMessage = "En espera de archivo Excel (.xlsx)";

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Cargar archivo",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                            isProcessing
                                ? Icons.sync
                                : (selectedFile != null
                                    ? Icons.check_circle
                                    : Icons.description_outlined),
                            color: const Color(0xFF1B5E20),
                            size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isProcessing
                                ? "Procesando registros..."
                                : statusMessage,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isProcessing)
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text("CANCELAR",
                              style: TextStyle(color: Color(0xFF1B5E20))),
                        ),
                      const SizedBox(width: 8),
                      if (!isProcessing && selectedFile == null)
                        ElevatedButton.icon(
                          label: const Text("CARGAR"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1B5E20),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['xlsx'],
                              withData: true,
                            );

                            if (result != null) {
                              setState(() {
                                selectedFile = result.files.first;
                                statusMessage =
                                    "Archivo listo: ${selectedFile!.name}";
                              });
                            }
                          },
                        ),
                      if (!isProcessing && selectedFile != null)
                        ElevatedButton.icon(
                          label: const Text("SUBIR"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            setState(() {
                              isProcessing = true;
                            });

                            try {
                              var bytes = selectedFile!.bytes;
                              var file = excel.Excel.decodeBytes(bytes!);
                              List<String> inventarios = [];

                              for (var table in file.tables.keys) {
                                int rowIndex = 0;
                                for (var row in file.tables[table]!.rows) {
                                  if (rowIndex == 0) {
                                    rowIndex++;
                                    continue;
                                  }
                                  if (row.isNotEmpty && row[0] != null) {
                                    var cellValue =
                                        row[0]?.value.toString().trim() ?? "";
                                    final isInteger =
                                        RegExp(r'^\d+$').hasMatch(cellValue);
                                    if (isInteger && cellValue.isNotEmpty) {
                                      inventarios.add(cellValue);
                                    }
                                  }
                                  rowIndex++;
                                }
                              }

                              if (inventarios.isEmpty) {
                                throw "El archivo no contiene datos válidos.";
                              }

                              for (String id in inventarios) {
                                await _enviarRegistroExcel(
                                    context, authToken, id);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Importación finalizada con éxito"),
                                  backgroundColor: Color(0xFF1B5E20),
                                ),
                              );
                              Navigator.pop(dialogContext);
                            } catch (e) {
                              setState(() {
                                isProcessing = false;
                                statusMessage = "Error: ${e.toString()}";
                                selectedFile = null;
                              });
                            }
                          },
                        ),
                      if (isProcessing)
                        const CircularProgressIndicator(
                            color: Color(0xFF1B5E20)),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

// Lógica de envío directo sin verificación de duplicados
Future<void> _enviarRegistroExcel(
    BuildContext context, String token, String id) async {
  final url = 'https://api.servidor-inventarios.xyz/fastapi/impresionetiquetas';

  try {
    // Se ha eliminado la sección de 'http.get' que validaba duplicados

    await http
        .post(
          Uri.parse('$url/'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'inventario2025': id,
            'estado': 'pendiente',
            'intentos': 0,
            'listoParaImprimir': true
          }),
        )
        .timeout(const Duration(seconds: 5));
  } catch (e) {
    print("Error enviando ID $id: $e");
  }
}
