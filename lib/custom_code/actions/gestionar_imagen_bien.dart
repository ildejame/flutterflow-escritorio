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

import '/flutter_flow/custom_functions.dart';
// Imports custom functions

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

Future<bool> gestionarImagenBien(
  BuildContext context,
  String authToken,
  String idInventario,
) async {
  const Color customGreen = Color(0xFF164B2D);
  final String inventarioBuscado = idInventario.trim();

  if (inventarioBuscado.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⚠️ El ID proporcionado está vacío.')),
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
          Expanded(child: Text('Consultando registro en el servidor...')),
        ],
      ),
    ),
  );

  String? recordPk;
  String? currentFileName;

  // 2. Buscar el registro en FastAPI
  try {
    final searchUrl =
        'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/?filter=(inventario2025%3D%22$inventarioBuscado%22)';
    final response = await http.get(
      Uri.parse(searchUrl),
      headers: {'Authorization': 'Bearer $authToken'},
    ).timeout(const Duration(seconds: 15));

    if (Navigator.canPop(context)) Navigator.pop(context);

    if (response.statusCode == 200 || response.statusCode == 307) {
      final searchData = jsonDecode(response.body);
      if (searchData['items'] != null && searchData['items'].isNotEmpty) {
        final item = searchData['items'][0];
        recordPk = item['id'].toString();
        // Intentamos recuperar 'imagenbien' o 'imgBien' por seguridad
        currentFileName =
            item['imagenbien']?.toString() ?? item['imgBien']?.toString();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ Registro no encontrado.')));
        return false;
      }
    } else {
      throw Exception('Error API: ${response.statusCode}');
    }
  } catch (e) {
    if (Navigator.canPop(context)) Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('❌ Error al conectar: $e')));
    return false;
  }

  String fullImageUrl = (currentFileName != null &&
          currentFileName != 'ND' &&
          currentFileName!.isNotEmpty)
      ? 'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/files/$currentFileName'
      : '';

  Uint8List? imagenBytesSeleccionada;
  String? nombreArchivoSeleccionado;

  // 3. Interfaz visual interactiva
  return await showDialog<bool>(
        context: context,
        builder: (contextBuilder) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Imagen de: $inventarioBuscado',
                    style: const TextStyle(
                        color: customGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: imagenBytesSeleccionada != null
                          ? Image.memory(imagenBytesSeleccionada!,
                              fit: BoxFit.contain)
                          : (fullImageUrl.isNotEmpty
                              ? Image.network(
                                  fullImageUrl,
                                  headers: {
                                    'Authorization': 'Bearer $authToken'
                                  },
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported,
                                          size: 50, color: Colors.grey),
                                )
                              : const Icon(Icons.add_photo_alternate,
                                  size: 50, color: Colors.grey)),
                    ),
                    if (nombreArchivoSeleccionado != null) ...[
                      const SizedBox(height: 8),
                      Text("Archivo: $nombreArchivoSeleccionado",
                          style: const TextStyle(
                              fontSize: 11, color: Colors.green),
                          overflow: TextOverflow.ellipsis),
                    ],
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final XFile? photo = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 85,
                        );
                        if (photo != null) {
                          final bytes = await photo.readAsBytes();
                          setState(() {
                            imagenBytesSeleccionada = bytes;
                            nombreArchivoSeleccionado = photo.name;
                          });
                        }
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('SELECCIONAR NUEVA IMAGEN'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: customGreen,
                          side: const BorderSide(color: customGreen)),
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
                    onPressed: imagenBytesSeleccionada == null
                        ? null
                        : () async {
                            showDialog(
                              context: contextBuilder,
                              barrierDismissible: false,
                              builder: (_) => const AlertDialog(
                                content: Row(
                                  children: [
                                    CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                customGreen)),
                                    SizedBox(width: 20),
                                    Expanded(
                                        child:
                                            Text('Procesando y Subiendo...')),
                                  ],
                                ),
                              ),
                            );

                            try {
                              // Replicando tu lógica de procesamiento y compresión
                              Uint8List finalImageBytes =
                                  imagenBytesSeleccionada!;
                              final img.Image? originalImage =
                                  img.decodeImage(imagenBytesSeleccionada!);

                              if (originalImage != null) {
                                const maxWidth = 800;
                                const maxHeight = 800;
                                int newWidth = originalImage.width;
                                int newHeight = originalImage.height;

                                if (newWidth > maxWidth ||
                                    newHeight > maxHeight) {
                                  final double aspectRatio =
                                      newWidth / newHeight;
                                  if (aspectRatio > 1) {
                                    newWidth = maxWidth;
                                    newHeight =
                                        (maxWidth / aspectRatio).round();
                                  } else {
                                    newHeight = maxHeight;
                                    newWidth =
                                        (maxHeight * aspectRatio).round();
                                  }
                                  final img.Image resizedImage = img.copyResize(
                                    originalImage,
                                    width: newWidth,
                                    height: newHeight,
                                  );
                                  finalImageBytes = Uint8List.fromList(
                                      img.encodeJpg(resizedImage, quality: 85));
                                }
                              }

                              // Envío mediante PATCH utilizando el ID interno del registro
                              var request = http.MultipartRequest(
                                'PATCH',
                                Uri.parse(
                                    'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/$recordPk'),
                              );

                              request.headers['Authorization'] =
                                  'Bearer $authToken';

                              // Aseguramos enviar el archivo con el nombre esperado por la API
                              request.files.add(
                                http.MultipartFile.fromBytes(
                                  'imagenbien', // Nombre extraído de tu código de guardado
                                  finalImageBytes,
                                  filename: nombreArchivoSeleccionado ??
                                      'evidencia_actualizada.jpg',
                                ),
                              );

                              var response = await request
                                  .send()
                                  .timeout(const Duration(seconds: 30));

                              if (Navigator.canPop(context))
                                Navigator.pop(context); // Cierra carga

                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            '✅ Imagen actualizada exitosamente'),
                                        backgroundColor: Colors.green));
                                Navigator.pop(contextBuilder,
                                    true); // Cierra modal con éxito
                              } else {
                                throw Exception(
                                    'Error del servidor: ${response.statusCode}');
                              }
                            } catch (e) {
                              if (Navigator.canPop(context))
                                Navigator.pop(context); // Cierra carga
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('❌ Error: $e')));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: customGreen,
                        foregroundColor: Colors.white),
                    child: const Text('GUARDAR CAMBIOS'),
                  ),
                ],
              );
            },
          );
        },
      ) ??
      false;
}
