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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Future<void> depreacum(BuildContext context) async {
  // Color personalizado
  const Color customGreen = Color(0xFF164b2d);
  // Mostrar diálogo de carga mientras se obtienen las oficinas
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customGreen),
          ),
          const SizedBox(width: 20),
          const Expanded(child: Text('Cargando opciones...')),
        ],
      ),
    ),
  );
  // Obtener oficinas desde Firebase
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
    debugPrint('Error al cargar oficinas: $e');
  }

  // Cerrar diálogo de carga
  Navigator.of(context).pop();

  // 1) Diálogo de configuración
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String unidad = 'TODOS';
      String filtroUMA = 'TODOS';
      bool excluirNoInventariables = true;
      final TextEditingController umaController =
          TextEditingController(text: '113.14');

      return StatefulBuilder(
        builder: (ctx, setState) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
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
              title: const Text('Configuración de Reporte'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Filtro Unidad Presupuestal:'),
                    ),
                    const SizedBox(height: 8),
                    ...unidadesDisponibles.map((unidadNombre) {
                      return RadioListTile<String>(
                        dense: true,
                        title: Text(unidadNombre),
                        value: unidadNombre,
                        groupValue: unidad,
                        onChanged: (v) => setState(() => unidad = v!),
                      );
                    }),
                    const Divider(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Filtro por UMA:'),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<String>(
                      dense: true,
                      title: const Text('TODOS'),
                      value: 'TODOS',
                      groupValue: filtroUMA,
                      onChanged: (v) => setState(() => filtroUMA = v!),
                    ),
                    RadioListTile<String>(
                      dense: true,
                      title: const Text('MENORES A 20 UMAS'),
                      value: 'MENORES A 20 UMAS',
                      groupValue: filtroUMA,
                      onChanged: (v) => setState(() => filtroUMA = v!),
                    ),
                    RadioListTile<String>(
                      dense: true,
                      title: const Text('MAYOR O IGUAL A 20 UMAS'),
                      value: 'MAYOR O IGUAL A 20 UMAS',
                      groupValue: filtroUMA,
                      onChanged: (v) => setState(() => filtroUMA = v!),
                    ),
                    const Divider(height: 16),
                    TextField(
                      controller: umaController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      decoration: InputDecoration(
                        labelText: 'Valor UMA (MXN)',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customGreen, width: 2),
                        ),
                        labelStyle: TextStyle(
                          color: umaController.text.isNotEmpty
                              ? customGreen
                              : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Excluir NO inventariables'),
                      value: excluirNoInventariables,
                      onChanged: (v) =>
                          setState(() => excluirNoInventariables = v ?? true),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  style: TextButton.styleFrom(
                    foregroundColor: customGreen,
                  ),
                  child: const Text('CANCELAR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final double umaVal = double.tryParse(
                            umaController.text.replaceAll(',', '.')) ??
                        113.14;
                    Navigator.of(context).pop(<String, dynamic>{
                      'unidad': unidad,
                      'filtroUMA': filtroUMA,
                      'umaValue': umaVal,
                      'excluirNoInventariables': excluirNoInventariables,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('GENERAR REPORTE'),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (result == null) return;
  final String filtroNivel1 = (result['unidad'] as String?) ?? 'TODOS';
  final String filtroUMA = (result['filtroUMA'] as String?) ?? 'TODOS';
  final double umaValue = (result['umaValue'] as double?) ?? 113.14;
  final bool excluirNoInventariables =
      (result['excluirNoInventariables'] as bool?) ?? true;

  // 2) Mostrar progreso
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customGreen),
          ),
          const SizedBox(width: 20),
          const Expanded(
              child: Text('Procesando resumen de depreciación acumulada...')),
        ],
      ),
    ),
  );
  try {
    final List<DocumentSnapshot<Map<String, dynamic>>> todosLosDocs = [];
    Query<Map<String, dynamic>> query = firestore
        .collection('bienesmuebles')
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) => snap.data() ?? {},
          toFirestore: (data, _) => data,
        );
    if (filtroNivel1 != 'TODOS') {
      query = query.where('nivel1organizacion', isEqualTo: filtroNivel1);
    }

    // 3) Obtener todos los documentos
    DocumentSnapshot<Map<String, dynamic>>? ultimo;
    while (true) {
      Query<Map<String, dynamic>> q = query.limit(500);
      if (ultimo != null) q = q.startAfterDocument(ultimo);
      final snap = await q.get();
      if (snap.docs.isEmpty) break;
      todosLosDocs.addAll(snap.docs);
      ultimo = snap.docs.last;
    }

    if (todosLosDocs.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('⚠️ No se encontraron registros válidos.')),
      );
      return;
    }

    // 4) Obtener clases reales desde Firestore
    final Set<String> clasesReales = {};
    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;
      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isNotEmpty) clasesReales.add(clase);
    }
    final List<String> listaClases = clasesReales.toList()..sort();
    // 5) Agrupar valores
    final Map<String, Map<String, dynamic>> resumen = {};
    final double limiteUMA = umaValue * 20.0;
    int excluidosNoInventariables = 0;

    // =================================================================
    // PROCESAMIENTO
    // =================================================================
    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;
      final cotejo = (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
      if (excluirNoInventariables && cotejo == 'NO') {
        excluidosNoInventariables++;
        continue;
      }

      // FILTRO DE FECHA: Ignorar estrictamente 2025 en adelante
      final fechaAdq = _parseFecha(data['fechaadquisicion']);

      // Si EXISTE la fecha Y es 2025 o mayor -> SE SALTA.
      // Si fechaAdq es NULL -> NO se salta (pasa como bien viejo/sin fecha).
      if (fechaAdq != null && fechaAdq.year >= 2025) {
        continue;
      }

      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;
      final double depreAcum =
          (data['depreciacionacumulada'] as num?)?.toDouble() ?? 0.0;
      bool cumpleUMA = true;
      if (filtroUMA == 'MENORES A 20 UMAS') {
        cumpleUMA = depreAcum < limiteUMA;
      } else if (filtroUMA == 'MAYOR O IGUAL A 20 UMAS') {
        cumpleUMA = depreAcum >= limiteUMA;
      }
      if (!cumpleUMA) continue;

      final bucket =
          resumen.putIfAbsent(clase, () => {'bienes': 0, 'valor': 0.0});
      bucket['bienes'] = (bucket['bienes'] as int) + 1;
      bucket['valor'] = (bucket['valor'] as double) + depreAcum;
    }

    // 6) Rellenar con ceros las clases reales que no aparecieron
    for (final clase in listaClases) {
      resumen.putIfAbsent(clase, () => {'bienes': 0, 'valor': 0.0});
    }

    // LIMPIEZA: Eliminar filas vacías
    resumen.removeWhere((key, value) =>
        (value['bienes'] as int) == 0 && (value['valor'] as double) == 0.0);

    // ----------------------------------------------------------------------
    // 7) GENERAR PDF
    // ----------------------------------------------------------------------
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    final clases = resumen.keys.toList()..sort();

    // Calcular totales previos para usar en la fila final
    final totalBienesInt =
        resumen.values.fold<int>(0, (s, e) => s + (e['bienes'] as int));
    final totalValorDouble =
        resumen.values.fold<double>(0.0, (s, e) => s + (e['valor'] as double));
    // Función Header
    pw.Widget buildHeader(pw.Context context) {
      final fh = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      final titulo = (filtroNivel1 != 'TODOS')
          ? 'RESUMEN DE DEPRECIACIÓN ACUMULADA. $filtroNivel1'
          : 'RESUMEN GENERAL DE DEPRECIACIÓN ACUMULADA POR CLASE DE ACTIVO';
      return pw.Column(children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 50),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'PODER JUDICIAL DEL ESTADO DE VERACRUZ',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  titulo,
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Fecha y hora:', style: pw.TextStyle(fontSize: 8)),
                pw.Text(fh, style: pw.TextStyle(fontSize: 8)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 15),
      ]);
    }

    // Construcción del PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(15),
        header: buildHeader,
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 8)),
        ),
        build: (context) => [
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(5),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(3),
            },
            children: [
              // Encabezado Tabla
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Center(
                        child: pw.Text('CLASE DE ACTIVO',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Center(
                        child: pw.Text('NÚMERO DE BIENES',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Center(
                        child: pw.Text('DEPRECIACIÓN ACUMULADA (\$)',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  ),
                ],
              ),
              // Filas de Datos (Mapeo dinámico)
              ...clases.map((clase) {
                final row = resumen[clase]!;
                return pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(clase, style: pw.TextStyle(fontSize: 9)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Center(
                        child: pw.Text('${row['bienes']}',
                            style: pw.TextStyle(fontSize: 9))),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(fmt.format(row['valor']),
                          style: pw.TextStyle(fontSize: 9)),
                    ),
                  ),
                ]);
              }),
              // Fila de Total General
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('TOTAL GENERAL',
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Center(
                      child: pw.Text(
                        totalBienesInt.toString(),
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        fmt.format(totalValorDouble),
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
    final bytes = await pdf.save();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '✅ PDF generado correctamente\n'
        'Unidad: $filtroNivel1 | Filtro UMA: $filtroUMA | UMA: $umaValue\n'
        'Bienes: $totalBienesInt | Total Depreciación: ${fmt.format(totalValorDouble)}\n'
        'Excluidos (NO inventariables): $excluidosNoInventariables',
      ),
      duration: const Duration(seconds: 8),
    ));
    final sufijo = (filtroNivel1 != 'TODOS')
        ? '_${filtroNivel1.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}'
        : '';
    final fileName =
        'ResumenDepreAcum${sufijo}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);
  } catch (e, st) {
    Navigator.of(context).pop();
    debugPrint('❌ Error al generar reporte: $e\n$st');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('❌ Error: $e')));
  }
}

// ========================================================================
// FUNCION AUXILIAR DE PARSEO DE FECHA
// ========================================================================
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
