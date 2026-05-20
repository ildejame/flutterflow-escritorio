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
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<bool> consultarBienVisVariable02(
  BuildContext context,
  String authToken,
  String idInventario,
) async {
  const Color customGreen = Color(0xFF164B2D);
  final String inventarioBuscado = idInventario.trim();

  if (inventarioBuscado.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('⚠️ Por favor, ingrese un ID de inventario.')),
    );
    return false;
  }

  // 1. Mostrar indicador de búsqueda
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          SizedBox(width: 20),
          Expanded(child: Text('Buscando registro...')),
        ],
      ),
    ),
  );

  String? recordPk; // ID primario para el PATCH
  String? currentImagePath;

  // 2. Buscar el registro para obtener el ID real y la imagen actual
  try {
    final searchUrl =
        'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/?filter=(inventario2025%3D%22$inventarioBuscado%22)';
    final response = await http.get(
      Uri.parse(searchUrl),
      headers: {'Authorization': 'Bearer $authToken'},
    ).timeout(const Duration(seconds: 15));

    if (Navigator.canPop(context)) Navigator.pop(context); // Cerrar indicador

    if (response.statusCode == 200) {
      final searchData = jsonDecode(response.body);
      if (searchData['items'] != null && searchData['items'].isNotEmpty) {
        final item = searchData['items'][0];
        recordPk = item['id'].toString(); // El ID interno del servidor
        currentImagePath = item['imgBien']?.toString();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ No se encontró el registro.')),
        );
        return false;
      }
    } else {
      throw Exception('Error en API: ${response.statusCode}');
    }
  } catch (e) {
    if (Navigator.canPop(context)) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Error al buscar: $e')),
    );
    return false;
  }

  // 3. Abrir interfaz de gestión de imagen
  XFile? pickedFile;

  // Construcción de la URL de visualización (ajustar prefijo si es necesario)
  String getFullUrl(String? path) {
    if (path == null || path.isEmpty || path == 'ND') return '';
    if (path.startsWith('http')) return path;
    return 'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/files/$path';
  }

  return await showDialog<bool>(
        context: context,
        builder: (contextBuilder) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Imagen de: $inventarioBuscado',
                    style: const TextStyle(
                        color: customGreen, fontWeight: FontWeight.bold)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: pickedFile != null
                          ? Image.file(File(pickedFile!.path),
                              fit: BoxFit.cover)
                          : (currentImagePath != null &&
                                  currentImagePath != 'ND'
                              ? Image.network(
                                  getFullUrl(currentImagePath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 50),
                                )
                              : const Icon(Icons.image_not_supported,
                                  size: 50)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final selected = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (selected != null)
                          setState(() => pickedFile = selected);
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Cambiar Imagen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: customGreen,
                        side: const BorderSide(color: customGreen),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(contextBuilder, false),
                    child: const Text('CANCELAR',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    onPressed: pickedFile == null
                        ? null
                        : () async {
                            // Lógica de actualización (PATCH)
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const AlertDialog(
                                  content: Text('Guardando cambios...')),
                            );

                            try {
                              var request = http.MultipartRequest(
                                'PATCH',
                                Uri.parse(
                                    'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/$recordPk'),
                              );
                              request.headers['Authorization'] =
                                  'Bearer $authToken';
                              request.files.add(
                                  await http.MultipartFile.fromPath(
                                      'imgBien', pickedFile!.path));

                              var res = await request.send();
                              if (Navigator.canPop(context))
                                Navigator.pop(context);

                              if (res.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('✅ Actualizado.')));
                                Navigator.pop(contextBuilder, true);
                              } else {
                                throw Exception('Error al subir');
                              }
                            } catch (e) {
                              if (Navigator.canPop(context))
                                Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('❌ Error: $e')));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: customGreen,
                        foregroundColor: Colors.white),
                    child: const Text('GUARDAR'),
                  ),
                ],
              );
            },
          );
        },
      ) ??
      false;
}
