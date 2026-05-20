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

import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';

Future descargarReporteAseguradora(BuildContext context, String urlBase,
    String token, List<String>? ubicacionesNivel1) async {
  const Color customGreen = Color(0xFF164b2d);

  // 1. Verificación Web
  if (!kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('La descarga de Excel solo está disponible en Web.')),
    );
    return;
  }

  // 2. PREPARAR Y ORDENAR LA LISTA DESDE EL APP STATE
  List<String> opcionesExtraidas = [];

  if (ubicacionesNivel1 != null && ubicacionesNivel1.isNotEmpty) {
    for (String u in ubicacionesNivel1) {
      final nombre = u.trim();
      if (nombre.isNotEmpty &&
          nombre.toUpperCase() != 'TODOS' &&
          !opcionesExtraidas.contains(nombre)) {
        opcionesExtraidas.add(nombre);
      }
    }
  }

  if (opcionesExtraidas.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se encontraron unidades presupuestales disponibles.'),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  opcionesExtraidas.sort((a, b) => a.compareTo(b));
  List<String> unidadesDisponibles = ['TODOS', ...opcionesExtraidas];

  // 3. INTERFAZ DE SELECCIÓN
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String unidad = 'TODOS';
      final TextEditingController yearController =
          TextEditingController(text: DateTime.now().year.toString());

      return StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Generar Reporte de Depreciación',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filtro Unidad Presupuestal:',
                      style: TextStyle(fontWeight: FontWeight.normal)),
                  const SizedBox(height: 20),
                  ...unidadesDisponibles
                      .map((u) => RadioListTile<String>(
                            dense: true,
                            title:
                                Text(u, style: const TextStyle(fontSize: 12)),
                            value: u,
                            groupValue: unidad,
                            activeColor: customGreen,
                            onChanged: (v) => setState(() => unidad = v!),
                          ))
                      .toList(),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  TextField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Año Fiscal:',
                      labelStyle: TextStyle(color: customGreen),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: customGreen, width: 2.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(foregroundColor: customGreen),
                  child: const Text('CANCELAR'),
                  onPressed: () => Navigator.pop(context)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: customGreen),
                child: const Text('DESCARGAR',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  final y = int.tryParse(yearController.text);
                  if (y == null || y < 2000 || y > 2100) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Por favor ingrese un año válido.')));
                  } else {
                    Navigator.pop(context, {'unidad': unidad, 'year': y});
                  }
                },
              )
            ],
          );
        },
      );
    },
  );

  if (result == null) return;

  final String filtroUnidad = result['unidad'];
  final int selectedYear = result['year'];

  // ===========================================================================
  // 4. SOLICITUD AL SERVIDOR (Validación y Descarga)
  // ===========================================================================
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text(
        'Verificando datos en el servidor. La descarga iniciará en breve...'),
    backgroundColor: customGreen,
    duration: Duration(seconds: 3),
  ));

  final String encodedUnidad = Uri.encodeComponent(filtroUnidad);
  final String finalUrl =
      "$urlBase?anio=$selectedYear&unidad=$encodedUnidad&token=$token";

  try {
    // Hacemos la consulta "por detrás"
    final response = await http.get(Uri.parse(finalUrl));

    // Revisamos si el servidor nos mandó un JSON (es decir, el mensaje de error)
    bool isJson =
        response.headers['content-type']?.contains('application/json') ?? false;

    if (response.statusCode != 200 || isJson) {
      // Intentamos extraer el mensaje "detail" que manda FastAPI
      String errorMessage = "No se pudo generar el reporte.";
      try {
        final errorData = json.decode(utf8.decode(response.bodyBytes));
        if (errorData['detail'] != null) {
          errorMessage = errorData['detail'];
        }
      } catch (_) {}

      // MOSTRAMOS LA ALERTA CON BOTÓN DE REGRESAR
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Aviso', style: TextStyle(color: Colors.black)),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('REGRESAR',
                    style: TextStyle(color: customGreen)),
              )
            ],
          ),
        );
      }
      return; // Terminamos aquí, no descargamos nada.
    }

    // SI TODO ESTÁ BIEN Y ES UN EXCEL, LO DESCARGAMOS MÁGICAMENTE:
    final blob = html.Blob([response.bodyBytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    String unidadpresupuestal = filtroUnidad.replaceAll(' ', '_');
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download",
          "Reporte_Depreciacion_${selectedYear}_$unidadpresupuestal.xlsx")
      ..click();

    // Limpiamos la URL temporal para no consumir memoria
    html.Url.revokeObjectUrl(url);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Descarga completada con éxito.'),
        backgroundColor: customGreen,
        duration: Duration(seconds: 4),
      ));
    }
  } catch (e) {
    // Si se cae el servidor o hay problema de red
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error de conexión'),
          content: Text(
              'No pudimos conectarnos al servidor. Intenta nuevamente.\n\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
                  const Text('REGRESAR', style: TextStyle(color: customGreen)),
            )
          ],
        ),
      );
    }
  }
}
