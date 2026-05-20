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
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Future<void> valorEnLibros2025(BuildContext context) async {
  // Color personalizado
  const Color customGreen = Color(0xFF164b2d);

  // ---------------------------------------------------------
  // 1. CARGA DE OFICINAS
  // ---------------------------------------------------------
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

  Navigator.of(context).pop();

  // ---------------------------------------------------------
  // 2. DIÁLOGO DE CONFIGURACIÓN
  // ---------------------------------------------------------
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
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
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

  // ---------------------------------------------------------
  // 3. OBTENCIÓN Y FILTRADO DE DATOS
  // ---------------------------------------------------------
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
              child: Text('Procesando resumen de valor en libros...')),
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

    final Set<String> clasesReales = {};
    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;
      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isNotEmpty) clasesReales.add(clase);
    }
    final List<String> listaClases = clasesReales.toList()..sort();

    final Map<String, Map<String, dynamic>> resumen = {};
    final cutoff = DateTime(2020, 1, 1);
    int excluidosNoInventariables = 0;

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

    final double limiteUMA = umaValue * 20.0;

    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;

      final cotejo = (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
      if (excluirNoInventariables && cotejo == 'NO') {
        excluidosNoInventariables++;
        continue;
      }

      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

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

      bool cumpleUMA = true;
      if (filtroUMA == 'MENORES A 20 UMAS') {
        cumpleUMA = valorEnLibros < limiteUMA;
      } else if (filtroUMA == 'MAYOR O IGUAL A 20 UMAS') {
        cumpleUMA = valorEnLibros >= limiteUMA;
      }
      if (!cumpleUMA) continue;

      final bucket =
          resumen.putIfAbsent(clase, () => {'bienes': 0, 'valor': 0.0});
      bucket['bienes'] = (bucket['bienes'] as int) + 1;
      bucket['valor'] = (bucket['valor'] as double) + valorEnLibros;
    }

    for (final clase in listaClases) {
      resumen.putIfAbsent(clase, () => {'bienes': 0, 'valor': 0.0});
    }

    // ---------------------------------------------------------
    // 4. GENERACIÓN DE PDF (MULTIPAGE)
    // ---------------------------------------------------------
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    final clases = resumen.keys.toList()..sort();

    final totalBienesInt =
        resumen.values.fold<int>(0, (s, e) => s + (e['bienes'] as int));
    final totalValorDouble =
        resumen.values.fold<double>(0.0, (s, e) => s + (e['valor'] as double));

    pw.Widget buildHeader(pw.Context context) {
      final fh = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      String textoFiltroUma = '';
      if (filtroUMA == 'TODOS') {
        textoFiltroUma = 'GENERAL';
      } else if (filtroUMA == 'MENORES A 20 UMAS') {
        textoFiltroUma = 'MENOR A 20 UMAS';
      } else {
        textoFiltroUma = 'MAYOR O IGUAL A 20 UMAS';
      }

      final tituloBase = (filtroNivel1 != 'TODOS')
          ? 'RESUMEN DE VALOR EN LIBROS - $filtroNivel1'
          : 'RESUMEN GENERAL DE VALOR EN LIBROS POR CLASE DE ACTIVO';
      final titulo = '$tituloBase ($textoFiltroUma)';

      return pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 50),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('PODER JUDICIAL DEL ESTADO DE VERACRUZ',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 5),
                  pw.Text(titulo,
                      style: pw.TextStyle(
                          fontSize: 11, fontWeight: pw.FontWeight.bold)),
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
        ],
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(15),
        header: buildHeader,
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 8),
          ),
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
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Center(
                          child: pw.Text('CLASE DE ACTIVO',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Center(
                          child: pw.Text('NÚMERO DE BIENES',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Center(
                          child: pw.Text('VALOR EN LIBROS (\$)',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)))),
                ],
              ),
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
                        child: pw.Text('$totalBienesInt',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(fmt.format(totalValorDouble),
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold))),
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
        'Bienes: $totalBienesInt | Valor total: ${fmt.format(totalValorDouble)}\n'
        'Excluidos (NO inventariables): $excluidosNoInventariables',
      ),
      duration: const Duration(seconds: 8),
    ));

    final sufijo = (filtroNivel1 != 'TODOS')
        ? '_${filtroNivel1.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}'
        : '';
    final fileName =
        'ResumenValorEnLibros${sufijo}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);
  } catch (e, st) {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    debugPrint('❌ Error al generar reporte: $e\n$st');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('❌ Error: $e')));
  }
}
