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

import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart' hide Border;

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

Future<void> exportarBienesMueblesExcel0(
  BuildContext context,
  String authToken,
  List<String> ubicacionesNivel1,
  List<String> nombredepreciacion,
) async {
  if (!kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('❌ Esta función solo está disponible en Web')),
    );
    return;
  }

  // Color personalizado institucional
  const Color customGreen = Color(0xFF164b2d);

  // URL base de PocketBase / Backend (Ajusta la URL de ser necesario)
  final String pbBaseUrl = 'https://api.servidor-inventarios.xyz';

  // ---------------------------------------------------------
  // 1. PREPARACIÓN DE LISTAS
  // ---------------------------------------------------------
  List<String> unidadesDisponibles = List.from(ubicacionesNivel1);
  unidadesDisponibles.sort((a, b) => a.compareTo(b));
  if (unidadesDisponibles.contains('TODOS')) {
    unidadesDisponibles.remove('TODOS');
  }
  unidadesDisponibles.insert(0, 'TODOS');

  List<String> clasesDeActivo = List.from(nombredepreciacion);
  clasesDeActivo.sort((a, b) => a.compareTo(b));
  if (clasesDeActivo.contains('TODOS')) {
    clasesDeActivo.remove('TODOS');
  }
  clasesDeActivo.insert(0, 'TODOS');

  // Variables para guardar selección
  String filtroAnexo = 'TODOS';
  String filtroNivel1 = 'TODOS';
  String filtroClaseActivo = 'TODOS';
  String filtroPrecio = 'TODOS';
  double umaValue = 113.14;
  bool excluirNoInventariables = true;

  // ---------------------------------------------------------
  // 2. DIÁLOGO DE CONFIGURACIÓN (MANTENIDO INTACTO)
  // ---------------------------------------------------------
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String localAnexo = filtroAnexo;
      String localNivel1 = filtroNivel1;
      String localClaseActivo = filtroClaseActivo;
      String localFiltroPrecio = filtroPrecio;
      double localUmaValue = umaValue;
      bool localExcluirNoInventariables = excluirNoInventariables;

      return StatefulBuilder(
        builder: (context, setState) {
          final double screenWidth = MediaQuery.of(context).size.width;
          final double dialogWidth =
              screenWidth > 700 ? 600 : screenWidth * 0.95;

          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: customGreen,
                secondary: customGreen,
              ),
              radioTheme: RadioThemeData(
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return customGreen;
                  }
                  return Colors.grey;
                }),
              ),
              checkboxTheme: CheckboxThemeData(
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return customGreen;
                  }
                  return Colors.grey;
                }),
              ),
            ),
            child: AlertDialog(
              title: const Text('Selecciona filtros para exportar'),
              content: SizedBox(
                width: dialogWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro Anexo:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ...[
                        'TODOS',
                        'Localizados',
                        'NO Localizados',
                        'Alta',
                        'Propuesta Baja'
                      ].map(
                        (opcion) => RadioListTile<String>(
                          dense: true,
                          title: Text(opcion),
                          value: opcion,
                          groupValue: localAnexo,
                          onChanged: (val) => setState(() => localAnexo = val!),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro Unidad Presupuestal:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: unidadesDisponibles.length,
                            itemBuilder: (context, index) {
                              final unidadNombre = unidadesDisponibles[index];
                              return RadioListTile<String>(
                                dense: true,
                                title: Text(unidadNombre,
                                    style: const TextStyle(fontSize: 12)),
                                value: unidadNombre,
                                groupValue: localNivel1,
                                onChanged: (val) =>
                                    setState(() => localNivel1 = val!),
                              );
                            },
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Clase de Activo:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: localClaseActivo,
                        isExpanded: true,
                        items: clasesDeActivo.map((clase) {
                          return DropdownMenuItem(
                            value: clase,
                            child: Text(clase,
                                style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => localClaseActivo = val!);
                        },
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro por Precio (en UMA):',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 4),
                      ...['TODOS', 'MENOS A 20 UMAS', 'MAYOR A 20 UMAS'].map(
                        (opcion) => RadioListTile<String>(
                          dense: true,
                          title: Text(opcion),
                          value: opcion,
                          groupValue: localFiltroPrecio,
                          onChanged: (val) =>
                              setState(() => localFiltroPrecio = val!),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: TextEditingController(
                          text: localUmaValue.toStringAsFixed(2),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Valor de la UMA (MXN)',
                          hintText: 'Ej. 113.14',
                          suffixText: 'MXN',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: customGreen, width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: customGreen,
                          ),
                        ),
                        onChanged: (val) {
                          final newValue =
                              double.tryParse(val.replaceAll(',', '.'));
                          if (newValue != null && newValue > 0) {
                            setState(() => localUmaValue = newValue);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '20 UMAS = ${(localUmaValue * 20).toStringAsFixed(2)} MXN',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: customGreen,
                        ),
                      ),
                      CheckboxListTile(
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Excluir NO inventariables'),
                        value: localExcluirNoInventariables,
                        onChanged: (v) => setState(
                            () => localExcluirNoInventariables = v ?? true),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  style: TextButton.styleFrom(
                    foregroundColor: customGreen,
                  ),
                  child: const Text('CANCELAR'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop({
                    'anexo': localAnexo,
                    'nivel1': localNivel1,
                    'clase': localClaseActivo,
                    'filtroPrecio': localFiltroPrecio,
                    'umaValue': localUmaValue,
                    'excluirNoInventariables': localExcluirNoInventariables,
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('DESCARGAR'),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (result == null) return;

  // Extraemos resultados del dialogo
  filtroAnexo = result['anexo'] as String;
  filtroNivel1 = result['nivel1'] as String;
  filtroClaseActivo = result['clase'] as String;
  filtroPrecio = result['filtroPrecio'] as String;
  umaValue = (result['umaValue'] as double?) ?? 113.14;
  excluirNoInventariables =
      (result['excluirNoInventariables'] as bool?) ?? true;

  // ---------------------------------------------------------
  // 3. DIALOGO DE CARGA Y PETICIÓN AL SERVIDOR
  // ---------------------------------------------------------
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Row(
          children: const [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen),
            ),
            SizedBox(width: 20),
            Expanded(child: Text('Generando archivo Excel en el servidor...')),
          ],
        ),
      );
    },
  );

  try {
    // LLamada al backend en python para delegar el trabajo pesado
    final response = await http.post(
      Uri.parse('$pbBaseUrl/fastapi/exportar-bienesmuebles-excel'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'anexo': filtroAnexo,
        'nivel1': filtroNivel1,
        'clase': filtroClaseActivo,
        'filtroPrecio': filtroPrecio,
        'umaValue': umaValue,
        'excluirNoInventariables': excluirNoInventariables,
      }),
    );

    // Cerramos el cuadro de diálogo de carga
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    if (response.statusCode == 200) {
      // Extraer nombre del archivo sugerido por el servidor
      String fileName =
          'BienesMuebles_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
      final contentDisposition = response.headers['content-disposition'];
      if (contentDisposition != null &&
          contentDisposition.contains('filename=')) {
        fileName = contentDisposition.split('filename=')[1].replaceAll('"', '');
      }

      // Descargando el archivo en web
      final blob = html.Blob([response.bodyBytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Exportación descargada con éxito!'),
          duration: Duration(seconds: 4),
          backgroundColor: customGreen,
        ),
      );
    } else {
      throw Exception(
          'El servidor respondió con error: ${response.statusCode}');
    }
  } catch (e, st) {
    debugPrint('❌ Error al exportar: $e\n$st');
    // Si falla, cerrar loading por si acaaso
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('❌ Error al exportar datos: $e'),
          backgroundColor: Colors.red),
    );
  }
}
