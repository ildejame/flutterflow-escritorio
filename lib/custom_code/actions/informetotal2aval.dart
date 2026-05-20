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
import 'dart:math' as math;

// Color personalizado
const Color customGreen = Color(0xFF164b2d);

// ========================================================================
// ACCIÓN PRINCIPAL: informetotal2aval (Cálculo corregido estilo Reporte 1)
// ========================================================================
Future<void> informetotal2aval(BuildContext context) async {
  // Instancia de Firestore
  final firestore = FirebaseFirestore.instance;

  // 1. Mostrar diálogo de carga
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
          const Expanded(child: Text('Cargando opciones de unidades...')),
        ],
      ),
    ),
  );

  // 2. Obtener oficinas desde Firebase
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

  // 3. Diálogo de configuración
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String unidad = 'TODOS';
      bool excluirNoInventariables = true;
      final TextEditingController umaController =
          TextEditingController(text: '113.14');
      final TextEditingController yearController =
          TextEditingController(text: DateTime.now().year.toString());

      String? yearErrorText;

      bool validarYear() {
        final year = int.tryParse(yearController.text);
        if (year == null) {
          yearErrorText = 'Debe ser un número válido.';
          return false;
        }
        if (year < 2024) {
          yearErrorText = 'No puede ser menor a 2024.';
          return false;
        }
        if (year > 2100) {
          yearErrorText = 'Año máximo es 2100.';
          return false;
        }
        yearErrorText = null;
        return true;
      }

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
              title: const Text('Configuración de reporte total'),
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Año Base para Cálculo de Depreciación:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: yearController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Ej. 2025',
                              border: const OutlineInputBorder(),
                              errorText: yearErrorText,
                            ),
                            onChanged: (val) {
                              setState(() => validarYear());
                            },
                          ),
                          const SizedBox(height: 5),
                          Text('Rango permitido: a partir de 2024',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700])),
                        ],
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
                    if (validarYear()) {
                      final double umaVal = double.tryParse(
                              umaController.text.replaceAll(',', '.')) ??
                          113.14;
                      final int selectedYear =
                          int.tryParse(yearController.text) ??
                              DateTime.now().year;

                      Navigator.of(context).pop(<String, dynamic>{
                        'unidad': unidad,
                        'umaValue': umaVal,
                        'selectedYear': selectedYear,
                        'excluirNoInventariables': excluirNoInventariables,
                      });
                    } else {
                      setState(() {});
                    }
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
  final int selectedYear =
      (result['selectedYear'] as int?) ?? DateTime.now().year;
  final DateTime fechaCalculoDepreciacion = DateTime(selectedYear, 12, 31);
  final bool excluirNoInventariables =
      (result['excluirNoInventariables'] as bool?) ?? true;

  // 4. Mostrar progreso
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
          const Expanded(child: Text('Procesando reporte total...')),
        ],
      ),
    ),
  );

  // Vidas Útiles
  Map<String, int> vidaUtilData = {};
  try {
    final depreciacionSnapshot =
        await firestore.collection('depreciacion').get();
    for (final doc in depreciacionSnapshot.docs) {
      final d = doc.data();
      vidaUtilData[d['nombre'] as String] = (d['vidautil'] as num).toInt();
    }

    // 5. Obtener todos los documentos
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

    // 6. Obtener todas las clases reales
    final Set<String> clasesReales = {};
    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;
      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isNotEmpty) clasesReales.add(clase);
    }
    final List<String> listaClases = clasesReales.toList()..sort();

    final cutoff = DateTime(2020, 1, 1);
    final double limiteUMA = umaValue * 20.0;
    int excluidosNoInventariables = 0;

    // ========================================================================
    // PASO ADICIONAL: GENERAR TABLA DE CONTEO INICIAL
    // ========================================================================
    final Map<String, int> tablaConteoInicial = {};
    for (final clase in listaClases) {
      tablaConteoInicial[clase] = 0;
    }

    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;

      final cotejo = (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
      if (excluirNoInventariables && cotejo == 'NO') {
        continue;
      }

      // Filtro de consistencia temporal: Si el bien se compró DESPUÉS
      // del año seleccionado, no debe contar en este reporte histórico/proyectado.
      final fechaAdq = _parseFecha(data['fechaadquisicion']);
      if (fechaAdq != null && fechaAdq.year > selectedYear) {
        continue;
      }

      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

      if (tablaConteoInicial.containsKey(clase)) {
        tablaConteoInicial[clase] = (tablaConteoInicial[clase] ?? 0) + 1;
      }
    }

    // ========================================================================
    // PASO 1: GENERAR TABLA DE VALOR EN LIBROS (LÓGICA IGUAL A REPORTE 1)
    // ========================================================================
    // Nota: Aquí usamos doubles crudos (sin _trunc2) para que la suma matemática
    // sea idéntica al Reporte 1, eliminando la diferencia de centavos.
    final Map<String, Map<String, dynamic>> tablaValorEnLibros = {};
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

      // Filtro Temporal Dinámico (Según selectedYear)
      final fechaAdq = _parseFecha(data['fechaadquisicion']);
      if (fechaAdq != null && fechaAdq.year > selectedYear) {
        continue;
      }

      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

      // Lectura DIRECTA (sin truncar) como en Reporte 1
      final double costoRaw =
          (data['importeinicialbien'] as num?)?.toDouble() ?? 0.0;
      final double avaluoRaw = (data['avaluo'] as num?)?.toDouble() ?? 0.0;

      // Selección de valor (Lógica 2020 idéntica a Reporte 1)
      double valorEnLibros;
      if (fechaAdq == null || fechaAdq.isBefore(cutoff)) {
        valorEnLibros = (avaluoRaw != 0.0) ? avaluoRaw : costoRaw;
      } else {
        valorEnLibros = (costoRaw != 0.0) ? costoRaw : avaluoRaw;
      }

      // Filtro UMA
      if (valorEnLibros >= limiteUMA) {
        if (!tablaValorEnLibros.containsKey(clase)) {
          tablaValorEnLibros[clase] = {'bienes': 0, 'valor': 0.0};
        }
        tablaValorEnLibros[clase]!['bienes'] =
            (tablaValorEnLibros[clase]!['bienes'] as int) + 1;
        // Suma DIRECTA (sin _round2) para máxima precisión
        tablaValorEnLibros[clase]!['valor'] =
            (tablaValorEnLibros[clase]!['valor'] as double) + valorEnLibros;
      }
    }

    // ========================================================================
    // PASO 2: GENERAR TABLA DE DEPRECIACIÓN ACUMULADA (LÓGICA EXCEL)
    // ========================================================================
    // Aquí mantenemos la lógica compleja del cálculo de depreciación (Excel),
    // pero aseguramos que el filtro de bienes sea consistente.
    final Map<String, Map<String, dynamic>> tablaDepreciacion = {};
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

      // Usar _trunc2 en entradas para el CÁLCULO DE DEPRECIACIÓN
      // (Esto se mantiene porque el cálculo de depreciación emula Excel y requiere valores truncados base)
      final double costoRaw =
          _trunc2((data['importeinicialbien'] as num?)?.toDouble() ?? 0.0);
      final double avaluoRaw =
          _trunc2((data['avaluo'] as num?)?.toDouble() ?? 0.0);
      final fechaAdqRaw = _parseFecha(data['fechaadquisicion']);
      final fechaAvalRaw = _parseFecha(data['fechaavaluo']);

      // Filtro Temporal Dinámico
      if (fechaAdqRaw != null && fechaAdqRaw.year > selectedYear) {
        continue;
      }

      bool usarAvaluo = false;
      // Si estamos proyectando a futuro (>=2025), permitimos lógica de avalúo nuevo si existe
      if (selectedYear >= 2025 && avaluoRaw > 0 && fechaAvalRaw != null) {
        usarAvaluo = true;
      }

      // Definir variables computables para la depreciación
      final double costoComputable = usarAvaluo ? avaluoRaw : costoRaw;
      final DateTime? fechaComputable = usarAvaluo ? fechaAvalRaw : fechaAdqRaw;

      // 1. Lógica Legacy: Si el año seleccionado es anterior a 2025 y tiene avalúo,
      // la lógica estricta de Excel anterior a veces excluía ciertos bienes.
      // (Mantenemos esta lógica si el usuario selecciona 2024 para consistencia histórica)
      if (selectedYear < 2025 && avaluoRaw != 0.0) {
        continue;
      }

      // Filtros básicos de integridad para depreciación
      // Nota: Aquí se usa costoComputable que ya está truncado, consistente con ExcelDep
      if (costoComputable < limiteUMA) continue;
      if (costoComputable <= 0.0) continue;
      if (fechaComputable == null) continue;

      // PREPARAR DATOS PARA CÁLCULO
      final Map<String, dynamic> dataParaCalculo =
          Map<String, dynamic>.from(data);
      dataParaCalculo['importeinicialbien'] = costoComputable;
      dataParaCalculo['fechaadquisicion'] = fechaComputable;

      // CÁLCULO DEPRECIACIÓN (Usando la lógica exacta de Excel)
      final resultadoDepre = _calcularDepreciacionLinealDefinitiva(
          dataParaCalculo,
          vidaUtilData,
          fechaCalculoDepreciacion,
          selectedYear);
      final double depreAcum = resultadoDepre['suma_depreciada'] as double;

      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

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
      final double valorVL = tablaValorEnLibros[clase]!['valor'] as double;
      final double valorDA = tablaDepreciacion[clase]!['valor'] as double;

      // Diferencia: Valor en Libros (Exacto) - Depreciación (Excel truncado)
      double diferencia = valorVL - valorDA;

      // Corrección visual para ceros negativos
      if (diferencia.abs() < 0.01) {
        diferencia = 0.0;
      }

      final int bienesIniciales = tablaConteoInicial[clase] ?? 0;
      tablaFinal[clase] = {
        'bienes': bienesIniciales,
        'valorEnLibros': valorVL,
        'depreciacionAcum': valorDA,
        'diferencia': diferencia,
      };
    }

    // ========================================================================
    // PASO 4: GENERAR PDF (5 Columnas) CON PAGINACIÓN AUTOMÁTICA
    // ========================================================================
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    final clases = tablaFinal.keys.toList()..sort();

    // 4.1 Definir el Header (se repetirá automáticamente)
    pw.Widget buildHeader(pw.Context context) {
      final fh = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      final titulo = (filtroNivel1 != 'TODOS')
          ? 'REPORTE TOTAL. $filtroNivel1'
          : 'REPORTE TOTAL POR CLASE DE ACTIVO';
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
                pw.Text(
                  'Año base para Depreciación: $selectedYear',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.normal),
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

    // 4.2 Construir lista de filas (Header + Data + Totales)
    final List<pw.TableRow> filasTabla = [];

    // Fila de Encabezados
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

    // Filas de Datos
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

    // Cálculo de Totales para la fila final
    final totalValorLibros = tablaFinal.values
        .fold<double>(0.0, (s, e) => s + (e['valorEnLibros'] as double));
    final totalDepreAcum = tablaFinal.values
        .fold<double>(0.0, (s, e) => s + (e['depreciacionAcum'] as double));
    final totalBienes =
        tablaFinal.values.fold<int>(0, (s, e) => s + (e['bienes'] as int));

    // Total diferencia y corrección visual
    double totalDiferencia = totalValorLibros - totalDepreAcum;
    if (totalDiferencia.abs() < 0.01) {
      totalDiferencia = 0.0;
    }

    // Fila de Totales
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
              style: pw.TextStyle(fontSize: 8)),
        ),
        build: (context) => [
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(7), // Clase
              1: const pw.FlexColumnWidth(2), // Bienes
              2: const pw.FlexColumnWidth(4), // VL
              3: const pw.FlexColumnWidth(4), // DA
              4: const pw.FlexColumnWidth(4), // VN
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
        'Unidad: $filtroNivel1 | UMA: $umaValue | Año Base: $selectedYear\n'
        'Bienes Totales: $totalBienes\n'
        'Valor en Libros: ${fmt.format(totalValorLibros)}\n'
        'Deprec. Acum.: ${fmt.format(totalDepreAcum)}\n'
        'Excluidos (NO): $excluidosNoInventariables',
      ),
      duration: const Duration(seconds: 10),
    ));
    final sufijo = (filtroNivel1 != 'TODOS')
        ? '_${filtroNivel1.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}'
        : '';
    final fileName =
        'ReporteTotal${sufijo}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

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
// FUNCIONES AUXILIARES (LÓGICA EXCEL EXACTA)
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

double _trunc2(double val) {
  return (val * 100).truncateToDouble() / 100;
}

double _round2(double val) {
  return (val * 100).roundToDouble() / 100;
}

// Esta es la versión EXACTA del archivo ExcelDep
Map<String, dynamic> _calcularDepreciacionLinealDefinitiva(
  Map<String, dynamic> data,
  Map<String, int> vidaUtilData,
  DateTime fechaCalculoDepreciacion,
  int selectedYearReporte,
) {
  final vidaUtilAnios =
      vidaUtilData[(data['clasedeactivo'] ?? '').toString()] ?? 0;

  // En Excel se usa _trunc2 para el monto base
  final montoBase =
      _trunc2((data['importeinicialbien'] as num?)?.toDouble() ?? 0.0);
  final fechaInicio = _parseFecha(data['fechaadquisicion']);
  Map<int, double> deps = {};
  for (int y = 2020; y <= selectedYearReporte; y++) deps[y] = 0.0;
  if (montoBase <= 0 || vidaUtilAnios <= 0 || fechaInicio == null) {
    return {'deps': deps, 'valor_en_libros': montoBase, 'suma_depreciada': 0.0};
  }

  final totalMesesVida = vidaUtilAnios * 12;
  final cuotaMensualExacta = montoBase / totalMesesVida;
  DateTime fechaContable = fechaInicio.day > 15
      ? DateTime(fechaInicio.year, fechaInicio.month + 1, 1)
      : DateTime(fechaInicio.year, fechaInicio.month, 1);
  if (fechaContable.month > 12) {
    fechaContable = DateTime(fechaContable.year + 1, 1, 1);
  }

  double sumaDepreciada = 0.0;
  int mesesAcumulados = 0;

  final finPeriodoHistorico = DateTime(2019, 12, 31);
  if (fechaContable.isBefore(finPeriodoHistorico)) {
    int anoContable = fechaContable.year;
    int mesContable = fechaContable.month;
    while (anoContable <= 2019 && mesesAcumulados < totalMesesVida) {
      int mesesEnAno = 12 - mesContable + 1;
      if (anoContable < finPeriodoHistorico.year) {
        mesesEnAno = 12;
      }
      int mesesRestantesVida = totalMesesVida - mesesAcumulados;
      int mesesEsteAno = math.min(mesesEnAno, mesesRestantesVida);
      // Lógica Excel: truncar la cuota anual
      double montoEsteAno = _trunc2(cuotaMensualExacta * mesesEsteAno);
      if (montoEsteAno < 0) montoEsteAno = 0;

      deps[anoContable] = montoEsteAno;
      sumaDepreciada += montoEsteAno;
      mesesAcumulados += mesesEsteAno;
      anoContable++;
      mesContable = 1;
    }
    if (fechaContable.isBefore(finPeriodoHistorico)) {
      fechaContable = DateTime(2020, 1, 1);
    }
  }

  int year = fechaContable.year;
  int month = fechaContable.month;
  while (year <= selectedYearReporte && mesesAcumulados < totalMesesVida) {
    int mesesEnEsteAno = 0;
    if (year == fechaContable.year) {
      mesesEnEsteAno = 12 - month + 1;
    } else if (year > fechaContable.year) {
      mesesEnEsteAno = 12;
    }

    if (year >= 2020 && year <= selectedYearReporte) {
      int mesesRestantesVida = totalMesesVida - mesesAcumulados;
      mesesEnEsteAno = math.min(mesesEnEsteAno, mesesRestantesVida);
    } else {
      mesesEnEsteAno = 0;
    }

    if (mesesEnEsteAno <= 0) {
      deps[year] = 0.0;
      year++;
      continue;
    }

    double montoEsteAno;
    bool esUltimoAnoDeVida =
        (mesesAcumulados + mesesEnEsteAno) >= totalMesesVida;
    // Lógica Excel para último año: Remanente exacto
    if (esUltimoAnoDeVida) {
      double remanenteExacto = montoBase - sumaDepreciada;
      montoEsteAno = _round2(remanenteExacto);
      if (montoEsteAno < 0) montoEsteAno = 0;
    } else {
      montoEsteAno = _trunc2(cuotaMensualExacta * mesesEnEsteAno);
    }

    deps[year] = montoEsteAno;
    sumaDepreciada += montoEsteAno;
    mesesAcumulados += mesesEnEsteAno;
    year++;
  }

  double remanenteFinal = montoBase - sumaDepreciada;
  double valorEnLibros = _round2(remanenteFinal);
  // Limpieza de valores cercanos a cero (evita -0.00)
  if (valorEnLibros.abs() < 0.01) valorEnLibros = 0.0;
  return {
    'deps': deps,
    'valor_en_libros': valorEnLibros,
    'suma_depreciada': sumaDepreciada
  };
}
