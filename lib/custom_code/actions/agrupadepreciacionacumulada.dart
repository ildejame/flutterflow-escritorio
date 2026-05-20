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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

// Color personalizado
const Color customGreen = Color(0xFF164b2d);

Future agrupadepreciacionacumulada(BuildContext context) async {
  final firestore = FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // 1. CARGA INICIAL DE OFICINAS
  // ---------------------------------------------------------------------------
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          const SizedBox(width: 20),
          const Expanded(child: Text('Cargando catálogo de unidades...')),
        ],
      ),
    ),
  );

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
    debugPrint('Error al cargar oficinas: $e');
  }

  Navigator.of(context).pop();

  // ---------------------------------------------------------------------------
  // 2. DIÁLOGO DE CONFIGURACIÓN
  // ---------------------------------------------------------------------------
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String unidad = 'TODOS';
      int currentYear = DateTime.now().year;
      final TextEditingController yearController = TextEditingController(
          text: (currentYear < 2025 ? 2025 : currentYear).toString());

      final TextEditingController umaController =
          TextEditingController(text: '113.14');

      bool validarYear() {
        final year = int.tryParse(yearController.text);
        if (year == null || year < 2025) return false;
        return true;
      }

      return StatefulBuilder(
        builder: (ctx, setState) {
          final double screenWidth = MediaQuery.of(context).size.width;
          final double dialogWidth = screenWidth * 0.6;

          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                  primary: customGreen, secondary: customGreen),
            ),
            child: AlertDialog(
              title: const Text('Generar Reporte Acumulado'),
              content: SizedBox(
                width: dialogWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Filtro Unidad Presupuestal:',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                      const SizedBox(height: 4),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: Container(
                          child: ListView(
                            shrinkWrap: true,
                            children: unidadesDisponibles.map((unidadNombre) {
                              return RadioListTile<String>(
                                dense: true,
                                title: Text(unidadNombre,
                                    style: const TextStyle(fontSize: 12)),
                                value: unidadNombre,
                                groupValue: unidad,
                                activeColor: customGreen,
                                onChanged: (v) => setState(() => unidad = v!),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Año Fiscal de Corte (Ej. 2025)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: umaController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Valor UMA (MXN)',
                          hintText: 'Ej. 113.14',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Nota: El conteo requiere activos >= 20 UMAs. La depreciación histórica suma todos los activos válidos.',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.blueGrey[600],
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('CANCELAR',
                      style: TextStyle(color: customGreen)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (validarYear()) {
                      final double umaVal = double.tryParse(
                              umaController.text.replaceAll(',', '.')) ??
                          113.14;

                      Navigator.of(context).pop({
                        'unidad': unidad,
                        'selectedYear': int.parse(yearController.text),
                        'umaValue': umaVal,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: customGreen),
                  child: const Text('GENERAR PDF',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (result == null) return;

  final String filtroUnidad = result['unidad'];
  final int anioSeleccionado = result['selectedYear'];
  final double umaValue = result['umaValue'];
  final double limiteUMA = umaValue * 20.0;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          const SizedBox(width: 20),
          Expanded(child: Text('Procesando datos $anioSeleccionado...')),
        ],
      ),
    ),
  );

  DateTime? _parseFecha(dynamic f) {
    try {
      if (f == null || (f is String && f.isEmpty)) return null;
      if (f is Timestamp) return f.toDate();
      final iso = DateTime.tryParse(f.toString());
      if (iso != null) return iso;
      return DateFormat('dd/MM/yyyy').parse(f.toString(), true).toLocal();
    } catch (_) {
      return null;
    }
  }

  try {
    debugPrint('--- INICIO PROCESO DEPRECIACION ACUMULADA (Optimizado) ---');
    debugPrint('Unidad: $filtroUnidad, UMA: $umaValue');

    final catalogoSnapshot = await firestore.collection('depreciacion').get();
    final Set<String> allClases = {};
    for (var doc in catalogoSnapshot.docs) {
      final c = (doc.data()['clasedeactivo'] ?? '').toString().trim();
      if (c.isNotEmpty) allClases.add(c);
    }

    final Map<String, int> conteoBienes = {};
    final Map<String, double> montoDepreciacion = {};

    // -------------------------------------------------------------------------
    // 2. CONTEO DE BIENES ACTUALES Y SUMA HISTÓRICA DIRECTA
    // -------------------------------------------------------------------------
    Query queryBienes = firestore.collection('bienesmuebles');

    // >>> OPTIMIZACIÓN CLAVE: Filtrar en el servidor <<<
    // Esto evita descargar los 51,000 bienes si solo quieres una unidad.
    if (filtroUnidad != 'TODOS') {
      queryBienes =
          queryBienes.where('nivel1organizacion', isEqualTo: filtroUnidad);
    }

    final bienesSnapshot = await queryBienes.get();

    final cutoff = DateTime(2020, 1, 1);
    int totalBienesValidosEncontrados = 0;

    debugPrint('Docs descargados: ${bienesSnapshot.docs.length}');

    for (var doc in bienesSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Filtro Cotejo
      final cotejo = (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
      if (cotejo == 'NO') continue;

      final clase = (data['clasedeactivo'] ?? 'SIN CLASE').toString().trim();
      if (clase.isNotEmpty) allClases.add(clase);

      // >>> SUMA DE DINERO HISTÓRICO <<<
      final double depAcumuladaHist =
          (data['depreciacionacumulada'] as num?)?.toDouble() ?? 0.0;
      if (!montoDepreciacion.containsKey(clase)) montoDepreciacion[clase] = 0.0;
      montoDepreciacion[clase] = montoDepreciacion[clase]! + depAcumuladaHist;

      // >>> FILTRO VALOR (UMAs) SOLO PARA CONTEO <<<
      final double costo =
          (data['importeinicialbien'] as num?)?.toDouble() ?? 0.0;
      final double avaluo = (data['avaluo'] as num?)?.toDouble() ?? 0.0;
      final fechaAdq = _parseFecha(data['fechaadquisicion']);

      double valorEnLibros;
      if (fechaAdq == null || fechaAdq.isBefore(cutoff)) {
        valorEnLibros = (avaluo != 0.0) ? avaluo : costo;
      } else {
        valorEnLibros = (costo != 0.0) ? costo : avaluo;
      }

      if (valorEnLibros >= limiteUMA) {
        if (!conteoBienes.containsKey(clase)) conteoBienes[clase] = 0;
        conteoBienes[clase] = conteoBienes[clase]! + 1;
        totalBienesValidosEncontrados++;
      }
    }

    debugPrint(
        'Total Bienes Válidos para conteo: $totalBienesValidosEncontrados');

    // -------------------------------------------------------------------------
    // 3. ACUMULADO 2025 -> AÑO SELECCIONADO
    // -------------------------------------------------------------------------
    Query queryCalculo = firestore.collection('calculodepreciacion');
    if (filtroUnidad != 'TODOS') {
      queryCalculo =
          queryCalculo.where('unidadpresupuestal', isEqualTo: filtroUnidad);
    }

    queryCalculo = queryCalculo
        .where('aniodepreciacion', isGreaterThanOrEqualTo: 2025)
        .where('aniodepreciacion', isLessThanOrEqualTo: anioSeleccionado);

    final calculoSnapshot = await queryCalculo.get();

    for (var doc in calculoSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final clase = (data['clasedeactivo'] ?? 'SIN CLASE').toString().trim();
      final double monto = (data['depreciacion'] as num?)?.toDouble() ?? 0.0;

      if (clase.isNotEmpty) allClases.add(clase);

      if (!montoDepreciacion.containsKey(clase)) montoDepreciacion[clase] = 0.0;
      montoDepreciacion[clase] = montoDepreciacion[clase]! + monto;
    }

    // -------------------------------------------------------------------------
    // 4. ARMAR ESTRUCTURA FINAL
    // -------------------------------------------------------------------------
    final List<Map<String, dynamic>> filasFinales = [];
    final sortedClases = allClases.toList()..sort();

    double granTotalMonto = 0.0;
    int granTotalItems = 0;

    for (var clase in sortedClases) {
      if (clase == 'SIN CLASE') continue;

      final int items = conteoBienes[clase] ?? 0;
      final double monto = montoDepreciacion[clase] ?? 0.0;

      if (items == 0 && monto == 0.0) continue;

      filasFinales.add({'clase': clase, 'items': items, 'monto': monto});
      granTotalMonto += monto;
      granTotalItems += items;
    }

    if (granTotalItems == 0) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            '⚠️ No hay datos de inventario válidos (>= 20 UMAs). No se generó el reporte.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 5),
      ));
      return;
    }

    if (filasFinales.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('⚠️ No hay información para mostrar.'),
        duration: Duration(seconds: 5),
      ));
      return;
    }

    // -------------------------------------------------------------------------
    // GENERAR PDF
    // -------------------------------------------------------------------------
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    final fechaHora = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(20),
        header: (ctx) => pw.Column(children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 50),
              pw.Column(children: [
                pw.Text('PODER JUDICIAL DEL ESTADO DE VERACRUZ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text('DEPRECIACIÓN ACUMULADA AL $anioSeleccionado',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                if (filtroUnidad != 'TODOS')
                  pw.Text('Unidad: $filtroUnidad',
                      style: const pw.TextStyle(fontSize: 9)),
              ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Criterio Bienes: >= 20 UMAS',
                        style: const pw.TextStyle(fontSize: 8)),
                    pw.Text('Generado: $fechaHora',
                        style: const pw.TextStyle(fontSize: 8)),
                  ]),
            ],
          ),
          pw.SizedBox(height: 15),
        ]),
        footer: (ctx) => pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text('Página ${ctx.pageNumber} de ${ctx.pagesCount}',
                style: const pw.TextStyle(fontSize: 8))),
        build: (ctx) {
          return [
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
              columnWidths: {
                0: const pw.FlexColumnWidth(6),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(3),
              },
              children: [
                // HEADER
                pw.TableRow(
                  children: [
                    'CLASE DE ACTIVO',
                    'No. de Bienes (>= 20 UMAS)',
                    'Dep. Acumulada \$'
                  ]
                      .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(e,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 9),
                              textAlign: e.contains('Activo')
                                  ? pw.TextAlign.left
                                  : pw.TextAlign.center)))
                      .toList(),
                ),
                // BODY
                ...filasFinales.map((fila) {
                  return pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(fila['clase'],
                            style: const pw.TextStyle(fontSize: 8))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(fila['items'].toString(),
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 8))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(fmt.format(fila['monto']),
                            textAlign: pw.TextAlign.right,
                            style: const pw.TextStyle(fontSize: 8))),
                  ]);
                }).toList(),
                // FOOTER
                pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('GRAN TOTAL',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(granTotalItems.toString(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(fmt.format(granTotalMonto),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9))),
                    ])
              ],
            )
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    Navigator.of(context).pop();

    final sufijo = (filtroUnidad != 'TODOS')
        ? '_${filtroUnidad.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}'
        : '_GLOBAL';
    final fileName = 'DepreciacionAcumulada_$anioSeleccionado$sufijo.pdf';

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✅ Reporte generado ($anioSeleccionado)'),
      backgroundColor: customGreen,
    ));
  } catch (e) {
    Navigator.of(context).pop();
    debugPrint('❌ ERROR CRÍTICO: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error: $e'),
      backgroundColor: Colors.red,
    ));
  }
}
