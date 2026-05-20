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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart'; // Librería para guardar en Galería/Fotos
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // Solo para funcionalidad Web

Future<bool> prueba02(
  BuildContext context,
  String authToken,
  String idInventario,
) async {
  const Color customGreen = Color(0xFF164b2d);

  if (idInventario.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⚠️ El ID de inventario está vacío.')),
    );
    return false;
  }

  // Se limpia el ID y se usa el campo inventario2025 según requerimiento
  final String inventarioBuscado =
      idInventario.trim().replaceAll(RegExp(r'\s+'), '');

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
    ),
  );

  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('bienesmuebles')
        .where('inventario2025', isEqualTo: inventarioBuscado)
        .limit(1)
        .get();

    if (context.mounted) Navigator.of(context).pop();

    if (querySnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ No se encontró el registro.')),
      );
      return false;
    }

    final data = querySnapshot.docs.first.data();
    final String? imageUrl = data['imagenbien']?.toString();

    // --- Widgets de Diseño (Se mantienen sin cambios) ---
    Widget _header(String t) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(t,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey)));

    Widget _txtRO(String val, String l, IconData i) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TextFormField(
            initialValue: (val == 'null' || val.isEmpty) ? 'N/A' : val,
            readOnly: true,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              labelText: l,
              prefixIcon: Icon(i, size: 18, color: customGreen),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
            )));

    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Detalle del Bien',
            style: TextStyle(color: customGreen, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header("CONTROL Y VALORES"),
                _txtRO(data['inventario2025']?.toString() ?? '',
                    "ID - INVENTARIO", Icons.tag),
                _txtRO(data['nombre']?.toString() ?? '', "NOMBRE DEL BIEN",
                    Icons.inventory_2),
                _header("EVIDENCIA FOTOGRÁFICA"),
                if (imageUrl != null && imageUrl.isNotEmpty)
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () async {
                          try {
                            // 1. Obtener los bytes de la imagen
                            final response =
                                await http.get(Uri.parse(imageUrl));
                            if (response.statusCode != 200) throw Exception();
                            final bytes = response.bodyBytes;

                            if (kIsWeb) {
                              // --- Lógica para Descarga en WEB ---
                              final blob = html.Blob([bytes]);
                              final url =
                                  html.Url.createObjectUrlFromBlob(blob);
                              final anchor = html.AnchorElement(href: url)
                                ..setAttribute(
                                    "download", "bien_$inventarioBuscado.jpg")
                                ..click();
                              html.Url.revokeObjectUrl(url);
                            } else {
                              // --- Lógica para Descarga en APK (Móvil) ---
                              // Guardar temporalmente para que Gal pueda procesarlo
                              final tempDir = await getTemporaryDirectory();
                              final tempPath = '${tempDir.path}/temp_img.jpg';
                              final file = File(tempPath);
                              await file.writeAsBytes(bytes);

                              // Guardar en la Galería de fotos del equipo
                              await Gal.putImage(tempPath);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('✅ Imagen guardada en la galería'),
                                  backgroundColor: customGreen,
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('❌ Error al descargar: $e')),
                            );
                          }
                        },
                        icon: const Icon(Icons.download, color: customGreen),
                        label: const Text("Descargar Imagen",
                            style: TextStyle(
                                color: customGreen,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                else
                  const Center(
                      child: Text("Sin imagen disponible",
                          style: TextStyle(fontStyle: FontStyle.italic))),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: customGreen, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('CERRAR'),
          ),
        ],
      ),
    );
    return true;
  } catch (e) {
    if (context.mounted) Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $e')));
    return false;
  }
}
