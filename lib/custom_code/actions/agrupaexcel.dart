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

// ------------------------------------------------------------------
// IMPORTANTE: Asegúrate de tener 'universal_html: ^2.2.4' en dependencias
// ------------------------------------------------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

Future agrupaexcel(BuildContext context) async {
  // Color corporativo
  const Color customGreen = Color(0xFF164b2d);

  // 1. Verificación Web
  if (!kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solo disponible en Web')),
    );
    return;
  }

  // ===========================================================================
  // FASE 1: INTERFAZ (Igual que siempre)
  // ===========================================================================

  // Carga inicial
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          const SizedBox(width: 20),
          const Expanded(child: Text('Cargando catálogo...')),
        ],
      ),
    ),
  );

  final firestore = FirebaseFirestore.instance;
  List<String> unidadesDisponibles = ['TODOS'];

  try {
    final oficinasSnapshot =
        await firestore.collection('oficinasPJEV').orderBy('nombre1').get();
    for (var doc in oficinasSnapshot.docs) {
      final nombre1 = (doc.data()['nombre1'] ?? '').toString().trim();
      if (nombre1.isNotEmpty && !unidadesDisponibles.contains(nombre1)) {
        unidadesDisponibles.add(nombre1);
      }
    }
  } catch (e) {
    debugPrint('Error oficinas: $e');
  }

  Navigator.of(context).pop();

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
            title: const Text('Generar Reporte (Modo Directo)'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Descarga total sin paginación (Estilo Python)',
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  const Divider(),
                  const Text('Filtro Unidad:'),
                  ...unidadesDisponibles
                      .map((u) => RadioListTile<String>(
                            dense: true,
                            title: Text(u),
                            value: u,
                            groupValue: unidad,
                            onChanged: (v) => setState(() => unidad = v!),
                          ))
                      .toList(),
                  const Divider(),
                  TextField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Año Fiscal', border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  child: const Text('CANCELAR'),
                  onPressed: () => Navigator.pop(context)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: customGreen),
                child: const Text('DESCARGAR'),
                onPressed: () {
                  final y = int.tryParse(yearController.text);
                  if (y == null || y < 2000 || y > 2100) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Año inválido')));
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
  // FASE 2: DESCARGA TOTAL (AQUÍ ESTÁ LA SOLUCIÓN)
  // ===========================================================================
  // Eliminamos el bucle while y los limits.
  // Hacemos una sola petición gigante, igual que Python.

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          Expanded(
              child: Text(
                  'Descargando TODOS los registros...\n(Esto puede tardar unos segundos, no cierres)')),
        ],
      ),
    ),
  );

  try {
    Query<Map<String, dynamic>> query = firestore
        .collection('calculodepreciacion')
        .where('aniodepreciacion', isEqualTo: selectedYear);

    if (filtroUnidad != 'TODOS') {
      query = query.where('unidadpresupuestal', isEqualTo: filtroUnidad);
    }

    // --- EL CAMBIO MAGISTRAL ---
    // Sin limit(), sin startAfter(). Traemos TODO el año de un golpe.
    // Esto es matemáticamente idéntico a tu script de Python.
    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    // Lista para guardar resultados limpios
    // Usamos un Map para asegurar unicidad por si acaso (doble seguridad)
    Map<String, Map<String, dynamic>> mapaUnico = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      String idBien = data['inventario2025']?.toString().trim() ?? '';

      // Fallback si no tiene ID
      if (idBien.isEmpty) idBien = doc.id;

      // Solo guardamos si no existe (First win)
      if (!mapaUnico.containsKey(idBien)) {
        mapaUnico[idBien] = data;
      }
    }

    Navigator.pop(context); // Fin carga

    // ===========================================================================
    // FASE 3: GENERAR EXCEL
    // ===========================================================================

    if (mapaUnico.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontraron datos.')));
      return;
    }

    // Convertir a lista y ordenar
    List<Map<String, dynamic>> listaFinal = mapaUnico.values.toList();

    // Ordenar por ID para que se vea bonito
    listaFinal.sort((a, b) {
      String idA = a['inventario2025']?.toString() ?? '';
      String idB = b['inventario2025']?.toString() ?? '';
      return idA.compareTo(idB);
    });

    var excel = Excel.createExcel();
    final headerStyle = CellStyle(
        fontFamily: getFontFamily(FontFamily.Arial),
        bold: true,
        horizontalAlign: HorizontalAlign.Center);
    final dataStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);

    _agregarEncabezados(excel, selectedYear, headerStyle);

    int rowIndex = 1;
    int fileCount = 1;
    const int LIMIT = 15000;

    for (var data in listaFinal) {
      _agregarFilaExcel(excel, data, selectedYear, rowIndex, dataStyle);
      rowIndex++;

      // Manejo de partición de archivos (aunque con 11k no debería pasar el límite de 15k)
      if (rowIndex >= LIMIT) {
        _descargarExcel(excel, filtroUnidad, fileCount, selectedYear);
        fileCount++;
        rowIndex = 1;
        excel = Excel.createExcel();
        _agregarEncabezados(excel, selectedYear, headerStyle);
      }
    }

    // Descarga final
    if (rowIndex > 1) {
      _descargarExcel(excel, filtroUnidad, fileCount, selectedYear);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '✅ EXCEL GENERADO IGUAL QUE PYTHON.\nTotal Registros: ${listaFinal.length}'),
      backgroundColor: customGreen,
      duration: const Duration(seconds: 5),
    ));
  } catch (e) {
    Navigator.pop(context); // Cerrar dialogo si falla
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}

// ===================== FUNCIONES AUXILIARES =====================

void _agregarEncabezados(Excel excel, int year, CellStyle style) {
  final sheet = excel[excel.tables.keys.first];
  final headers = [
    'ID DEL BIEN',
    'COSTO (\$)',
    'AVALUO (\$)',
    'FECHA ADQ.',
    'FECHA AVALUO',
    'CLASE DE ACTIVO',
    'NIVEL 1',
    'DEPRECIACION $year (\$)'
  ];
  for (int i = 0; i < headers.length; i++) {
    var cell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
    cell.value = headers[i];
    cell.cellStyle = style;
  }
}

void _agregarFilaExcel(Excel excel, Map<String, dynamic> data, int year,
    int rowIndex, CellStyle style) {
  final sheet = excel[excel.tables.keys.first];

  String str(String key) => data[key]?.toString() ?? '';
  double dbl(String key) => (data[key] as num?)?.toDouble() ?? 0.0;
  String fmtDate(dynamic val) {
    if (val == null) return '';
    try {
      if (val is Timestamp)
        return DateFormat('dd/MM/yyyy').format(val.toDate());
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(val.toString()));
    } catch (_) {
      return '';
    }
  }

  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
      .value = str('inventario2025');
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
      .value = dbl('preciocosto');
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
      .value = dbl('precioavaluo');
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
      .value = fmtDate(data['fechaadquisicion']);
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
      .value = fmtDate(data['fechaavaluo']);
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
      .value = str('clasedeactivo');
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
      .value = str('unidadpresupuestal');
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
      .value = dbl('depreciacion');

  for (int i = 0; i < 8; i++) {
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex))
        .cellStyle = style;
  }
}

void _descargarExcel(Excel excel, String unidad, int parte, int year) {
  final bytes = excel.encode();
  if (bytes != null) {
    final cleanUnidad = unidad.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
    final suffix = parte > 1 ? '_Parte$parte' : '';
    final name = 'Reporte_Depreciacion_${year}_${cleanUnidad}${suffix}.xlsx';

    final blob = html.Blob([bytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', name)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
