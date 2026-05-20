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

Future<void> informefinal(BuildContext context) async {
  // Color personalizado (mismo color que ejemplo.txt)
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

  // Obtener oficinas desde Firebase (Carga dinámica como en ejemplo.txt)
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

  // 1) Diálogo de configuración (APLICANDO ESTILO customGreen)
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String unidad = 'TODOS';
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
              title: const Text('Configuración de reporte histórico'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Filtro Unidad Presupuestal:'),
                    ),
                    const SizedBox(height: 8),
                    // Opciones cargadas dinámicamente de Firebase
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
  final double umaValue = (result['umaValue'] as double?) ?? 113.14;
  final bool excluirNoInventariables =
      (result['excluirNoInventariables'] as bool?) ?? true;

  // 2) Mostrar progreso (APLICANDO ESTILO customGreen)
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
          const Expanded(child: Text('Procesando reporte final...')),
        ],
      ),
    ),
  );

  try {
    final firestore = FirebaseFirestore.instance;
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

    // 4) Obtener todas las clases reales desde Firestore
    final Set<String> clasesReales = {};
    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;
      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isNotEmpty) clasesReales.add(clase);
    }
    final List<String> listaClases = clasesReales.toList()..sort();

    // 5) Función auxiliar para parsear fechas
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

    final cutoff = DateTime(2020, 1, 1);
    // NUEVO: Fecha límite para exclusión (1 de Enero 2025)
    final fechaTope2025 = DateTime(2025, 1, 1);
    final double limiteUMA = umaValue * 20.0;
    int excluidosNoInventariables = 0;

    // ========================================================================
    // PASO 1: GENERAR TABLA DE VALOR EN LIBROS (CON filtro >= 20 UMAS, y < 2025)
    // ========================================================================
    final Map<String, Map<String, dynamic>> tablaValorEnLibros = {};
    // Inicializar todas las clases con ceros
    for (final clase in listaClases) {
      tablaValorEnLibros[clase] = {'bienes': 0, 'valor': 0.0};
    }

    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;

      final cotejo = (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
      if (excluirNoInventariables && cotejo == 'NO') {
        continue;
      }

      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

      // Calcular Valor en Libros
      final double costo =
          (data['importeinicialbien'] as num?)?.toDouble() ?? 0.0;
      final double avaluo = (data['avaluo'] as num?)?.toDouble() ?? 0.0;
      final fechaAdq = _parseFecha(data['fechaadquisicion']);

      // ------------------------------------------------------------------
      // NUEVO: Si fecha adquisicion >= 1 enero 2025, saltar.
      // ------------------------------------------------------------------
      if (fechaAdq != null && !fechaAdq.isBefore(fechaTope2025)) {
        continue;
      }

      double valorEnLibros;
      if (fechaAdq == null || fechaAdq.isBefore(cutoff)) {
        valorEnLibros = (avaluo != 0.0) ? avaluo : costo;
      } else {
        valorEnLibros = (costo != 0.0) ? costo : avaluo;
      }

      // Solo agregar si cumple >= 20 UMAS (Lógica Original Mantenida)
      if (valorEnLibros >= limiteUMA) {
        if (!tablaValorEnLibros.containsKey(clase)) {
          tablaValorEnLibros[clase] = {'bienes': 0, 'valor': 0.0};
        }
        tablaValorEnLibros[clase]!['bienes'] =
            (tablaValorEnLibros[clase]!['bienes'] as int) + 1;
        tablaValorEnLibros[clase]!['valor'] =
            (tablaValorEnLibros[clase]!['valor'] as double) + valorEnLibros;
      }
    }

    // ========================================================================
    // PASO 2: GENERAR TABLA DE DEPRECIACIÓN ACUMULADA (SIN filtro de UMA, < 2025)
    // ========================================================================
    final Map<String, Map<String, dynamic>> tablaDepreciacion = {};
    // Inicializar todas las clases con ceros
    for (final clase in listaClases) {
      tablaDepreciacion[clase] = {'bienes': 0, 'valor': 0.0};
    }

    excluidosNoInventariables = 0;
    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;

      final cotejo = (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
      if (excluirNoInventariables && cotejo == 'NO') {
        excluidosNoInventariables++;
        continue;
      }

      // ------------------------------------------------------------------
      // NUEVO: También aplicamos el filtro de 2025 aquí para consistencia
      // ------------------------------------------------------------------
      final fechaAdq = _parseFecha(data['fechaadquisicion']);
      if (fechaAdq != null && !fechaAdq.isBefore(fechaTope2025)) {
        continue;
      }

      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

      final double depreAcum =
          (data['depreciacionacumulada'] as num?)?.toDouble() ?? 0.0;

      // Agregar sin filtro de UMA (TODO) - Lógica Original Mantenida
      if (!tablaDepreciacion.containsKey(clase)) {
        tablaDepreciacion[clase] = {'bienes': 0, 'valor': 0.0};
      }
      tablaDepreciacion[clase]!['bienes'] =
          (tablaDepreciacion[clase]!['bienes'] as int) + 1;
      tablaDepreciacion[clase]!['valor'] =
          (tablaDepreciacion[clase]!['valor'] as double) + depreAcum;
    }

    // ========================================================================
    // PASO 3: COMBINAR LAS DOS TABLAS Y CALCULAR DIFERENCIA
    // ========================================================================
    final Map<String, Map<String, dynamic>> tablaFinal = {};
    for (final clase in listaClases) {
      // Valor en Libros CON filtro >= 20 UMAS (Paso 1)
      final double valorVL = tablaValorEnLibros[clase]!['valor'] as double;
      // Depreciación Acumulada SIN filtro UMA (Paso 2)
      final int bienesDA = tablaDepreciacion[clase]!['bienes'] as int;
      // <-- Usamos el conteo SIN filtro UMA
      final double valorDA = tablaDepreciacion[clase]!['valor'] as double;
      final double diferencia = valorVL - valorDA;

      tablaFinal[clase] = {
        'bienes': bienesDA, // USAR CONTEO SIN FILTRO UMA (Paso 2)
        'valorEnLibros': valorVL,
        'depreciacionAcum': valorDA,
        'diferencia': diferencia,
      };
    }

    // ========================================================================
    // PASO 4: GENERAR PDF (MODIFICADO: MULTIPAGE)
    // ========================================================================
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    final clases = tablaFinal.keys.toList()..sort();

    // 4.1 Definir Header (Se repite automáticamente)
    pw.Widget buildHeader(pw.Context context) {
      final fh = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      final titulo = (filtroNivel1 != 'TODOS')
          ? 'REPORTE FINAL. $filtroNivel1'
          : 'REPORTE FINAL POR CLASE DE ACTIVO';

      return pw.Column(
        children: [
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
        ],
      );
    }

    // Función auxiliar para celdas de encabezado
    pw.Widget _headerCell(String text,
        {pw.Alignment alignment = pw.Alignment.center}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Align(
          alignment: alignment,
          child: pw.Text(
            text,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            textAlign: alignment == pw.Alignment.centerLeft
                ? pw.TextAlign.left
                : pw.TextAlign.right,
          ),
        ),
      );
    }

    // 4.2 Construir lista de filas
    final List<pw.TableRow> filasTabla = [];

    // Fila de encabezado
    filasTabla.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          _headerCell('CLASE DE ACTIVO', alignment: pw.Alignment.centerLeft),
          _headerCell('No. Bienes', alignment: pw.Alignment.centerRight),
          _headerCell('Val. Libros \$', alignment: pw.Alignment.centerRight),
          _headerCell('Dep. Acum. \$', alignment: pw.Alignment.centerRight),
          _headerCell('Val. Neto \$', alignment: pw.Alignment.centerRight),
        ],
      ),
    );

    // Filas de datos
    for (final clase in clases) {
      final row = tablaFinal[clase]!;
      filasTabla.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(clase, style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(row['bienes'].toString(),
                    style: pw.TextStyle(fontSize: 8)),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(fmt.format(row['valorEnLibros']),
                    style: pw.TextStyle(fontSize: 8)),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(fmt.format(row['depreciacionAcum']),
                    style: pw.TextStyle(fontSize: 8)),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(fmt.format(row['diferencia']),
                    style: pw.TextStyle(
                        fontSize: 8, fontWeight: pw.FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    // Calcular Totales Globales
    final totalBienes = tablaDepreciacion.values
        .fold<int>(0, (s, e) => s + (e['bienes'] as int));
    final totalValorLibros = tablaFinal.values
        .fold<double>(0.0, (s, e) => s + (e['valorEnLibros'] as double));
    final totalDepreAcum = tablaFinal.values
        .fold<double>(0.0, (s, e) => s + (e['depreciacionAcum'] as double));
    final totalDiferencia = tablaFinal.values
        .fold<double>(0.0, (s, e) => s + (e['diferencia'] as double));

    // Fila de totales
    filasTabla.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text('TOTAL GENERAL',
                style:
                    pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(totalBienes.toString(),
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(fmt.format(totalValorLibros),
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(fmt.format(totalDepreAcum),
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                fmt.format(totalDiferencia),
                style:
                    pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );

    // 4.3 Generar MultiPage
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
              0: const pw.FlexColumnWidth(7), // CLASE DE ACTIVO
              1: const pw.FlexColumnWidth(2), // No. Bienes
              2: const pw.FlexColumnWidth(4), // Val. Libros $
              3: const pw.FlexColumnWidth(4), // Dep. Acum. $
              4: const pw.FlexColumnWidth(4), // Val. Neto $
            },
            children: filasTabla,
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '✅ PDF generado correctamente\n'
        'Unidad: $filtroNivel1 | UMA: $umaValue\n'
        'Bienes Totales (sin filtro UMA): $totalBienes\n'
        'Valor en Libros (≥20 UMAS): ${fmt.format(totalValorLibros)}\n'
        'Deprec. Acum. (Todos): ${fmt.format(totalDepreAcum)}\n'
        'Diferencia: ${fmt.format(totalDiferencia)}\n'
        'Excluidos (NO inventariables): $excluidosNoInventariables',
      ),
      duration: const Duration(seconds: 10),
    ));

    final sufijo = (filtroNivel1 != 'TODOS')
        ? '_${filtroNivel1.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}'
        : '';
    final fileName =
        'ReporteFinal${sufijo}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

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
