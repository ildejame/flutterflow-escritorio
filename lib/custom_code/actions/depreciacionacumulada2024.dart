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
import 'dart:math';

Future<void> depreciacionacumulada2024(BuildContext context) async {
  // === 1) Diálogo de filtros ===
  String? filtroAnexo = 'TODOS';
  String? filtroNivel1 = 'TODOS';
  String? filtroClaseActivo = 'TODOS';
  String? filtroPrecio = 'TODOS';
  double umaValue = 113.14;
  DateTime? fechaInicio;
  DateTime? fechaFin;

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String localAnexo = filtroAnexo!;
      String localNivel1 = filtroNivel1!;
      String localClaseActivo = filtroClaseActivo!;
      String localFiltroPrecio = filtroPrecio!;
      double localUmaValue = umaValue;
      List<String> clasesDeActivo = ['TODOS'];

      return StatefulBuilder(
        builder: (context, setState) {
          if (clasesDeActivo.length == 1) {
            FirebaseFirestore.instance
                .collection('depreciacion')
                .get()
                .then((snap) {
              final nombres = snap.docs
                  .map((d) => (d.data()['nombre'] as String?)?.trim() ?? '')
                  .where((s) => s.isNotEmpty)
                  .toSet()
                  .toList()
                ..sort();
              setState(() {
                clasesDeActivo.addAll(nombres);
              });
            });
          }

          return AlertDialog(
            title: const Text('Configuración de reporte de depreciación'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Filtro Anexo:')),
                  ...[
                    'TODOS',
                    'Localizados',
                    'NO Localizados',
                    'Alta',
                    'Propuesta Baja'
                  ].map(
                    (op) => RadioListTile<String>(
                      dense: true,
                      title: Text(op),
                      value: op,
                      groupValue: localAnexo,
                      onChanged: (v) => setState(() => localAnexo = v!),
                    ),
                  ),
                  const Divider(),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Unidad Presupuestal:')),
                  ...[
                    'TODOS',
                    'CONSEJO DE LA JUDICATURA',
                    'TRIBUNAL SUPERIOR DE JUSTICIA',
                    'TRIBUNAL DE CONCILIACION Y ARBITRAJE'
                  ].map(
                    (op) => RadioListTile<String>(
                      dense: true,
                      title: Text(op),
                      value: op,
                      groupValue: localNivel1,
                      onChanged: (v) => setState(() => localNivel1 = v!),
                    ),
                  ),
                  const Divider(),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Clase de Activo:')),
                  DropdownButton<String>(
                    value: localClaseActivo,
                    isExpanded: true,
                    items: clasesDeActivo
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => localClaseActivo = v!),
                  ),
                  const Divider(),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'Filtro por Precio (UMAs sobre importe inicial):')),
                  ...['TODOS', 'MENOS A 20 UMAS', 'MAYOR A 20 UMAS'].map(
                    (op) => RadioListTile<String>(
                      dense: true,
                      title: Text(op),
                      value: op,
                      groupValue: localFiltroPrecio,
                      onChanged: (v) => setState(() => localFiltroPrecio = v!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: localUmaValue.toStringAsFixed(2),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Valor UMA (MXN)',
                      border: OutlineInputBorder(),
                      suffixText: 'MXN',
                    ),
                    onChanged: (val) {
                      final x = double.tryParse(val.replaceAll(',', '.'));
                      if (x != null && x > 0) setState(() => localUmaValue = x);
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '20 UMAs = ${(localUmaValue * 20).toStringAsFixed(2)} MXN',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontStyle: FontStyle.italic),
                  ),
                  const Divider(),
                  ListTile(
                    dense: true,
                    title: Text(fechaInicio == null
                        ? 'Seleccionar Fecha Inicial'
                        : 'Desde: ${DateFormat('dd/MM/yyyy').format(fechaInicio!)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (picked != null) setState(() => fechaInicio = picked);
                    },
                  ),
                  ListTile(
                    dense: true,
                    title: Text(fechaFin == null
                        ? 'Seleccionar Fecha Final'
                        : 'Hasta: ${DateFormat('dd/MM/yyyy').format(fechaFin!)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (picked != null) setState(() => fechaFin = picked);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('CANCELAR')),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop({
                  'anexo': localAnexo,
                  'nivel1': localNivel1,
                  'clase': localClaseActivo,
                  'filtroPrecio': localFiltroPrecio,
                  'umaValue': localUmaValue,
                  'fechaInicio': fechaInicio,
                  'fechaFin': fechaFin,
                }),
                child: const Text('GENERAR PDF'),
              ),
            ],
          );
        },
      );
    },
  );

  if (result == null) return;
  filtroAnexo = result['anexo'];
  filtroNivel1 = result['nivel1'];
  filtroClaseActivo = result['clase'];
  filtroPrecio = result['filtroPrecio'];
  umaValue = (result['umaValue'] as double?) ?? 113.14;
  fechaInicio = result['fechaInicio'];
  fechaFin = result['fechaFin'];

  // Diálogo de progreso
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(children: [
        CircularProgressIndicator(),
        SizedBox(width: 16),
        Expanded(child: Text('Calculando depreciación y generando PDF...')),
      ]),
    ),
  );

  try {
    final firestore = FirebaseFirestore.instance;

    // === 2) Vida útil por clase ===
    final vidSnap = await firestore.collection('depreciacion').get();
    final Map<String, int> vidaUtilData = {};
    for (final d in vidSnap.docs) {
      final data = d.data();
      final nombre = (data['nombre'] as String?)?.trim() ?? '';
      final vu = (data['vidautil'] as num?)?.toInt() ?? 0;
      if (nombre.isNotEmpty) vidaUtilData[nombre] = vu;
    }

    // === 3) Query base de bienes + filtros ===
    Query<Map<String, dynamic>> query = firestore
        .collection('bienesmuebles')
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) => (snap.data() ?? {}),
          toFirestore: (data, _) => data,
        );

    if (filtroAnexo != 'TODOS') {
      String valor = '';
      switch (filtroAnexo) {
        case 'Localizados':
          valor = 'ANEXO 1';
          break;
        case 'NO Localizados':
          valor = 'ANEXO 2';
          break;
        case 'Alta':
          valor = 'ANEXO 3';
          break;
        case 'Propuesta Baja':
          valor = 'ANEXO 4';
          break;
      }
      if (valor.isNotEmpty) query = query.where('anexo', isEqualTo: valor);
    }
    if (filtroNivel1 != 'TODOS') {
      query = query.where('nivel1organizacion', isEqualTo: filtroNivel1);
    }
    if (filtroClaseActivo != 'TODOS') {
      query = query.where('clasedeactivo', isEqualTo: filtroClaseActivo);
    }
    if (fechaInicio != null) {
      query = query.where('fechaadquisicion',
          isGreaterThanOrEqualTo: Timestamp.fromDate(fechaInicio!));
    }
    if (fechaFin != null) {
      query = query.where('fechaadquisicion',
          isLessThanOrEqualTo: Timestamp.fromDate(fechaFin!));
    }

    // === 3.1) Paginación ===
    final List<DocumentSnapshot<Map<String, dynamic>>> docs = [];
    DocumentSnapshot<Map<String, dynamic>>? last;
    while (true) {
      var q = query
          .orderBy('fechaadquisicion')
          .orderBy('inventario2025')
          .limit(500);
      if (last != null) q = q.startAfterDocument(last);
      final snap = await q.get();
      if (snap.docs.isEmpty) break;
      docs.addAll(snap.docs);
      last = snap.docs.last;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cargados ${docs.length} registros...'),
          duration: const Duration(milliseconds: 800)));
      await Future.delayed(const Duration(milliseconds: 120));
    }

    if (docs.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontraron registros.')));
      return;
    }

    // === 4) Procesamiento con reglas CORREGIDAS ===
    final double limitePrecio = umaValue * 20.0;
    final List<Map<String, dynamic>> filas = [];
    double totalMonto = 0.0;
    double totalValorLibros = 0.0;

    for (final doc in docs) {
      final data = doc.data();
      if (data == null) continue;

      final String clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

      final DateTime? fechaAdq = _parseFecha(data['fechaadquisicion']);
      final DateTime? fechaAvaluo = _parseFecha(data['fechaavaluo']);

      final double monto =
          _trunc2((data['importeinicialbien'] as num?)?.toDouble() ?? 0.0);

      final int vidaUtil = vidaUtilData[clase] ?? 0;

      final bool tieneCampoDep = data.containsKey('depreciacion');
      final double valorLibrosObjetivo =
          (tieneCampoDep && data['depreciacion'] != null)
              ? _trunc2((data['depreciacion'] as num).toDouble())
              : -1.0;

      // Excluir solo si tiene avalúo Y depreciación es 0
      if (valorLibrosObjetivo == 0.0 && fechaAvaluo != null) {
        continue;
      }

      double dep2020 = 0.0,
          dep2021 = 0.0,
          dep2022 = 0.0,
          dep2023 = 0.0,
          dep2024 = 0.0,
          valorEnLibros = 0.0;

      if (monto > 0 && vidaUtil > 0 && fechaAdq != null) {
        final double depMensual = monto / (vidaUtil * 12.0);
        final DateTime inicio = _ajustarInicioMes(fechaAdq);
        final DateTime fin = DateTime(2024, 12, 31);

        final int m2020 = _mesesEnAnio(inicio, fin, 2020);
        final int m2021 = _mesesEnAnio(inicio, fin, 2021);
        final int m2022 = _mesesEnAnio(inicio, fin, 2022);
        final int m2023 = _mesesEnAnio(inicio, fin, 2023);
        final int m2024 = _mesesEnAnio(inicio, fin, 2024);

        dep2020 = _trunc2(depMensual * m2020);
        dep2021 = _trunc2(depMensual * m2021);
        dep2022 = _trunc2(depMensual * m2022);
        dep2023 = _trunc2(depMensual * m2023);

        final double sumaParcial =
            _trunc2(dep2020 + dep2021 + dep2022 + dep2023);

        if (valorLibrosObjetivo >= 0.0) {
          // OPCIÓN 1: Usar valor directo de Firebase para el resultado final
          // pero calcular dep2024 correctamente

          double objetivo = _trunc2(valorLibrosObjetivo);

          // Validar límites del objetivo
          if (objetivo > monto) objetivo = monto;
          if (objetivo < 0.0) objetivo = 0.0;

          // Calcular el máximo de depreciación disponible para 2024
          double maxDep2024 = _trunc2(monto - sumaParcial);

          // Calcular dep2024 directamente: monto - sumaParcial - objetivo
          dep2024 = _trunc2(monto - sumaParcial - objetivo);

          // Validar límites de dep2024
          if (dep2024 < 0.0) dep2024 = 0.0;
          if (dep2024 > maxDep2024) dep2024 = maxDep2024;

          // IMPORTANTE: Usar el valor DIRECTO de Firebase, no el calculado
          // Esto elimina errores de truncamiento acumulado
          valorEnLibros = objetivo;

          // Limpiar -0.00 a 0.00
          if (valorEnLibros.abs() < 0.005) valorEnLibros = 0.0;
          if (dep2024.abs() < 0.005) dep2024 = 0.0;
        } else {
          // Sin objetivo específico, calcular normalmente
          dep2024 = _trunc2(depMensual * m2024);
          final double depTotal = sumaParcial + dep2024;
          if (depTotal > monto) {
            dep2024 = _trunc2(max(0.0, monto - sumaParcial));
          }
          valorEnLibros = _trunc2(max(0.0, monto - (sumaParcial + dep2024)));

          // Limpiar -0.00 a 0.00
          if (valorEnLibros == -0.0) valorEnLibros = 0.0;
          if (dep2024 == -0.0) dep2024 = 0.0;
        }
      } else {
        valorEnLibros =
            valorLibrosObjetivo >= 0.0 ? valorLibrosObjetivo : monto;
      }

      // Filtro por UMAs respecto a importe inicial
      final double baseUMA = monto;
      if (filtroPrecio == 'MENOS A 20 UMAS' && baseUMA >= limitePrecio)
        continue;
      if (filtroPrecio == 'MAYOR A 20 UMAS' && baseUMA < limitePrecio) continue;

      final registro = Map<String, dynamic>.from(data);
      registro['monto'] = monto;
      registro['dep2020'] = dep2020;
      registro['dep2021'] = dep2021;
      registro['dep2022'] = dep2022;
      registro['dep2023'] = dep2023;
      registro['dep2024'] = dep2024;
      registro['valor_en_libros'] = valorEnLibros;

      filas.add(registro);
      totalMonto += monto;
      totalValorLibros += valorEnLibros;
    }

    if (filas.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No hubo registros tras aplicar filtros.')));
      return;
    }

    // === 5) PDF ===
    final pdf = pw.Document();
    final ByteData logoData =
        await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: r'$', decimalDigits: 2);

    final headerStyle =
        pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final th = pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold);
    final td = pw.TextStyle(fontSize: 6);

    pw.Widget _header() {
      final fh = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      final List<pw.Widget> textos = [
        pw.Text('PODER JUDICIAL DEL ESTADO DE VERACRUZ', style: headerStyle),
        pw.Text('SUBDIRECCIÓN DE RECURSOS MATERIALES', style: headerStyle),
        pw.Text('DEPRECIACIÓN DE BIENES MUEBLES', style: headerStyle),
      ];
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 50),
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: textos),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('Fecha y hora de elaboración:',
                style:
                    pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
            pw.Text(fh, style: const pw.TextStyle(fontSize: 8)),
          ]),
        ],
      );
    }

    filas.sort((a, b) => (a['inventario2025'] ?? '')
        .toString()
        .compareTo((b['inventario2025'] ?? '').toString()));

    const int filasPorPagina = 15;
    final int paginas = (filas.length / filasPorPagina).ceil();

    for (int p = 0; p < paginas; p++) {
      final desde = p * filasPorPagina;
      final hasta = min((p + 1) * filasPorPagina, filas.length);
      final subset = filas.sublist(desde, hasta);

      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _header(),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.2),
                1: const pw.FlexColumnWidth(2.6),
                2: const pw.FlexColumnWidth(1.1),
                3: const pw.FlexColumnWidth(1.1),
                4: const pw.FlexColumnWidth(0.9),
                5: const pw.FlexColumnWidth(0.9),
                6: const pw.FlexColumnWidth(0.9),
                7: const pw.FlexColumnWidth(0.9),
                8: const pw.FlexColumnWidth(0.9),
                9: const pw.FlexColumnWidth(1.1),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _th('NÚMERO ID', th),
                    _th('DESCRIPCIÓN', th),
                    _th('FECHA\nADQUISICIÓN', th),
                    _th('MONTO \$', th),
                    _th('DEPRE 2020', th),
                    _th('DEPRE 2021', th),
                    _th('DEPRE 2022', th),
                    _th('DEPRE 2023', th),
                    _th('DEPRE 2024', th),
                    _th('VALOR EN LIBROS', th),
                  ],
                ),
                ...subset.map((r) => pw.TableRow(children: [
                      _tdCenter(
                          (r['inventario2025'] ?? '-----').toString(), td),
                      _tdLeft((r['nombre'] ?? '-----').toString(), td),
                      _tdCenter(_fmtFecha(r['fechaadquisicion']), td),
                      _tdCenter(fmt.format(_toD(r['monto'])), td),
                      _tdCenter(fmt.format(_toD(r['dep2020'])), td),
                      _tdCenter(fmt.format(_toD(r['dep2021'])), td),
                      _tdCenter(fmt.format(_toD(r['dep2022'])), td),
                      _tdCenter(fmt.format(_toD(r['dep2023'])), td),
                      _tdCenter(fmt.format(_toD(r['dep2024'])), td),
                      _tdCenter(fmt.format(_toD(r['valor_en_libros'])), td),
                    ])),
                if (p == paginas - 1)
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _tdCenter('', td),
                      _tdLeft('', td),
                      _tdCenter(
                          'Total: ${filas.length}',
                          pw.TextStyle(
                              fontSize: 6, fontWeight: pw.FontWeight.bold)),
                      _tdCenter(
                          fmt.format(_trunc2(totalMonto)),
                          pw.TextStyle(
                              fontSize: 6, fontWeight: pw.FontWeight.bold)),
                      _tdCenter('', td),
                      _tdCenter('', td),
                      _tdCenter('', td),
                      _tdCenter('', td),
                      _tdCenter('', td),
                      _tdCenter(
                          fmt.format(_trunc2(totalValorLibros)),
                          pw.TextStyle(
                              fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
              ],
            ),
            pw.Spacer(),
            pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Página ${p + 1} de $paginas',
                    style: const pw.TextStyle(fontSize: 8))),
          ],
        ),
      ));
    }

    final bytes = await pdf.save();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'PDF generado: ${filas.length} bienes | MONTO total: ${fmt.format(_trunc2(totalMonto))} | Valor en libros: ${fmt.format(_trunc2(totalValorLibros))}'),
        duration: const Duration(seconds: 5)));

    final nombre =
        'DepreciacionBienesMuebles_2020-2024_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final a = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = nombre
      ..click();
    html.Url.revokeObjectUrl(url);
  } catch (e, st) {
    Navigator.of(context).pop();
    debugPrint('Error al generar PDF: $e\n$st');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al generar PDF: $e'),
        backgroundColor: Colors.red));
  }
}

// ======================= Helpers =======================

double _trunc2(num v) {
  final sign = v < 0 ? -1 : 1;
  final av = v.abs();
  final scaled = (av * 100).floor(); // truncamiento
  return sign * (scaled / 100.0);
}

DateTime? _parseFecha(dynamic f) {
  try {
    if (f == null) return null;
    if (f is Timestamp) return f.toDate();
    if (f is DateTime) return f;
    final s = f.toString().trim();
    if (s.isEmpty) return null;
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;
    return DateFormat('dd/MM/yyyy').parse(s, true).toLocal();
  } catch (_) {
    return null;
  }
}

DateTime _ajustarInicioMes(DateTime fecha) {
  if (fecha.day > 15) {
    final y = fecha.year;
    final m = fecha.month;
    final nm = m == 12 ? 1 : m + 1;
    final ny = m == 12 ? y + 1 : y;
    return DateTime(ny, nm, 1);
  } else {
    return DateTime(fecha.year, fecha.month, 1);
  }
}

int _diffMeses(DateTime inicio, DateTime fin,
    {bool includeEndIfDayGT15 = true}) {
  int meses = (fin.year - inicio.year) * 12 + (fin.month - inicio.month);
  if (meses < 0) return 0;
  if (includeEndIfDayGT15 && fin.day > 15) meses += 1;
  return meses;
}

int _mesesEnAnio(DateTime inicio, DateTime fin, int year) {
  final DateTime a =
      inicio.isAfter(DateTime(year, 1, 1)) ? inicio : DateTime(year, 1, 1);
  final DateTime b =
      fin.isBefore(DateTime(year, 12, 31)) ? fin : DateTime(year, 12, 31);
  if (b.isBefore(a)) return 0;
  final DateTime ai = _ajustarInicioMes(a);
  final int meses = _diffMeses(ai, b, includeEndIfDayGT15: true);
  return (meses < 0) ? 0 : meses;
}

pw.Widget _th(String text, pw.TextStyle style) => pw.Padding(
    padding: const pw.EdgeInsets.all(3),
    child: pw.Center(child: pw.Text(text, style: style)));

pw.Widget _tdCenter(String text, pw.TextStyle style) => pw.Padding(
    padding: const pw.EdgeInsets.all(3),
    child: pw.Center(child: pw.Text(text, style: style)));

pw.Widget _tdLeft(String text, pw.TextStyle style) => pw.Padding(
    padding: const pw.EdgeInsets.all(3),
    child: pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(text, style: style)));

double _toD(dynamic v) =>
    (v is num) ? v.toDouble() : double.tryParse(v.toString()) ?? 0.0;

String _fmtFecha(dynamic fecha) {
  if (fecha is Timestamp) {
    return DateFormat('dd/MM/yyyy').format(fecha.toDate());
  }
  if (fecha is DateTime) {
    return DateFormat('dd/MM/yyyy').format(fecha);
  }
  return '-----';
}
