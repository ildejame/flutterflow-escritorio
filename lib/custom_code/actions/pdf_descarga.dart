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

import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> pdfDescarga(String? urlpdf) async {
  try {
    if (urlpdf != null) {
      final response = await Dio().get(
        urlpdf,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final content = response.data;

        if (kIsWeb) {
          // Código específico de Flutter web
          final blob =
              html.Blob([Uint8List.fromList(content)], 'application/pdf');
          final url = html.Url.createObjectUrlFromBlob(blob);

          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = 'file.pdf'
            ..click();

          html.Url.revokeObjectUrl(url);
        } else {
          // Código para otras plataformas (si es necesario)
          print("La descarga de PDF solo es compatible con Flutter web.");
        }

        print("Archivo disponible para descarga.");
      } else {
        print(
            "Error al descargar el PDF. Código de estado: ${response.statusCode}");
        print("Detalles del error: ${response.statusMessage}");
      }
    }
  } catch (e) {
    print("Error durante la descarga del PDF: $e");
    print("Detalles del error: ${e.toString()}");
  }
}
