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

import '/flutter_flow/custom_functions.dart';
// Imports custom functions

import '/flutter_flow/custom_functions.dart';
// Imports custom functions

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math; // Necesario para math.min

// Color personalizado (tomado de ejemplo.txt)
const Color customGreen = Color(0xFF164b2d);

// ========================================================================
// ACCIÓN PRINCIPAL: informetotal2
// ========================================================================
Future<void> informetotal2(BuildContext context) async {
  // Instancia de Firestore
  final firestore = FirebaseFirestore.instance;

  // 1. Mostrar diálogo de carga mientras se obtienen las oficinas
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

  // 2. Obtener oficinas desde Firebase (oficinasPJEV)
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

  // 3. Cerrar diálogo de carga
  Navigator.of(context).pop();

  // 4. Diálogo de configuración (con tema verde y unidades dinámicas)
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
          // Aplicar el tema verde a todos los widgets del diálogo
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
                    // Filtro Unidad Presupuestal
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Filtro Unidad Presupuestal:'),
                    ),
                    const SizedBox(height: 8),
                    // Lista de unidades cargadas dinámicamente
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

                    // Valor UMA
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

                    // Año Base
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50, // Fondo verde claro
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Año Base para Cálculo de Depreciación:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: yearController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Ej. 2025',
                              border: OutlineInputBorder(),
                              errorText: yearErrorText,
                            ),
                            onChanged: (val) {
                              setState(() => validarYear());
                            },
                          ),
                          SizedBox(height: 5),
                          Text('Rango permitido: a partir de 2024',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700])),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Excluir No Inventariables
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
                    foregroundColor: customGreen, // Color verde
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
                        'selectedYear': selectedYear, // Nuevo parámetro
                        'excluirNoInventariables': excluirNoInventariables,
                      });
                    } else {
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen, // Color verde
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

  // 5. Mostrar progreso (con color verde)
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                customGreen), // <-- CAMBIO A VERDE
          ),
          const SizedBox(width: 20),
          const Expanded(child: Text('Procesando reporte total...')),
        ],
      ),
    ),
  );

  // Vidas Útiles (Cargadas de Firestore)
  Map<String, int> vidaUtilData = {};
  try {
    // Cargar Vidas Utiles (Necesario para el cálculo)
    final depreciacionSnapshot =
        await firestore.collection('depreciacion').get();
    for (final doc in depreciacionSnapshot.docs) {
      final d = doc.data();
      vidaUtilData[d['nombre'] as String] = (d['vidautil'] as num).toInt();
    }

    // 6. Obtener todos los documentos
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

    // 7. Obtener todas las clases reales desde Firestore
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
    // PASO ADICIONAL: GENERAR TABLA DE CONTEO INICIAL (PARA COLUMNA "No. Bienes")
    // ========================================================================
    final Map<String, int> tablaConteoInicial = {};
    for (final clase in listaClases) {
      tablaConteoInicial[clase] = 0;
    }

    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;

      final cotejo = (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
      // Aplicar filtros de diálogo: Unidad Presupuestal (ya en la query) y Exclusión NO inventariable
      if (excluirNoInventariables && cotejo == 'NO') {
        continue; // Excluir si NO inventariable y el filtro está activo
      }

      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

      // Incrementar el conteo si pasó los filtros de Unidad y Exclusión
      if (tablaConteoInicial.containsKey(clase)) {
        tablaConteoInicial[clase] = (tablaConteoInicial[clase] ?? 0) + 1;
      }
    }
    // ========================================================================
    // FIN TABLA DE CONTEO INICIAL
    // ========================================================================

    // ========================================================================
    // PASO 1: GENERAR TABLA DE VALOR EN LIBROS (CON filtro >= 20 UMAS)
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

      double valorEnLibros;
      if (fechaAdq == null || fechaAdq.isBefore(cutoff)) {
        valorEnLibros = (avaluo != 0.0) ? avaluo : costo;
      } else {
        valorEnLibros = (costo != 0.0) ? costo : avaluo;
      }

      // Solo agregar si cumple >= 20 UMAS
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
    // PASO 2: GENERAR TABLA DE DEPRECIACIÓN ACUMULADA (APLICANDO FILTROS ESTRICTOS)
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

      final double costo =
          (data['importeinicialbien'] as num?)?.toDouble() ?? 0.0;
      final double avaluo = (data['avaluo'] as num?)?.toDouble() ?? 0.0;
      final fechaAdq = _parseFecha(data['fechaadquisicion']);

      // ***************************************************************
      // *********** FILTROS ESTRICTOS PARA DEPRECIACIÓN **********
      // ***************************************************************

      // 1. Exclusión si el avalúo es diferente de cero.
      if (avaluo != 0.0) {
        continue;
      }

      // 2. Exclusión si el costo es menor a 20 UMAS.
      if (costo < limiteUMA) {
        continue;
      }

      // 3. Exclusión si el costo es cero o no existe.
      if (costo <= 0.0) {
        continue;
      }

      // 4. Exclusión si la fecha de adquisición no existe.
      if (fechaAdq == null) {
        continue;
      }

      // ***************************************************************
      // *********** FIN DE FILTROS ESTRICTOS PARA DEPRECIACIÓN **********
      // ***************************************************************

      // *** CÁLCULO DEPRECIACIÓN ***
      final resultadoDepre = _calcularDepreciacionLinealDefinitiva(
          data, vidaUtilData, fechaCalculoDepreciacion, selectedYear);
      final double depreAcum = resultadoDepre['suma_depreciada'] as double;
      // ---------------------------------------

      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

      // Agregar solo los bienes que pasaron el filtro y generaron depreciación
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
      // Depreciación Acumulada CON FILTROS ESTRICTOS (Paso 2)
      final double valorDA = tablaDepreciacion[clase]!['valor'] as double;
      final double diferencia = valorVL - valorDA;

      // OBTENER CONTEO INICIAL (USANDO la nueva tabla)
      final int bienesIniciales =
          tablaConteoInicial[clase] ?? 0; // <--- MODIFICACIÓN CLAVE

      tablaFinal[clase] = {
        'bienes':
            bienesIniciales, // <--- CAMBIO: Usar el conteo inicial (sin filtro UMA ni depreciación)
        'valorEnLibros': valorVL,
        'depreciacionAcum': valorDA,
        'diferencia': diferencia,
      };
    }

    // ========================================================================
    // PASO 4: GENERAR PDF
    // ========================================================================
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    final clases = tablaFinal.keys.toList()..sort();

    pw.Widget _header() {
      final fh = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      final titulo = (filtroNivel1 != 'TODOS')
          ? 'REPORTE TOTAL — $filtroNivel1'
          : 'REPORTE TOTAL POR CLASE DE ACTIVO';
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 50),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'TRIBUNAL SUPERIOR DE JUSTICIA DEL ESTADO DE VERACRUZ',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                titulo,
                style:
                    pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'Año Base para Depreciación: $selectedYear',
                style:
                    pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.normal),
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

    // Construir lista de filas de la tabla (5 COLUMNAS)
    final List<pw.TableRow> filasTabla = [];
    // Fila de encabezado
    filasTabla.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          // 1. CLASE DE ACTIVO
          _headerCell('CLASE DE ACTIVO', alignment: pw.Alignment.centerLeft),
          // 2. No. Bienes
          _headerCell('No. Bienes', alignment: pw.Alignment.centerRight),
          // 3. Val. Libros $
          _headerCell('Val. Libros \$', alignment: pw.Alignment.centerRight),
          // 4. Dep. Acum. $
          _headerCell('Dep. Acum. \$', alignment: pw.Alignment.centerRight),
          // 5. Val. Neto $
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
            // 1. CLASE DE ACTIVO (Texto, tamaño 8)
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(clase, style: pw.TextStyle(fontSize: 8)),
            ),
            // 2. No. Bienes (USA EL NUEVO CONTEO, tamaño 8)
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                    row['bienes']
                        .toString(), // <--- CONTEO INICIAL CON FILTROS DE DIALOGO
                    style: pw.TextStyle(fontSize: 8)),
              ),
            ),
            // 3. Val. Libros $ (CON FILTRO UMA, tamaño 8)
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(fmt.format(row['valorEnLibros']),
                    style: pw.TextStyle(fontSize: 8)),
              ),
            ),
            // 4. Dep. Acum. $ (AHORA CON FILTROS ESTRICTOS, tamaño 8)
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(fmt.format(row['depreciacionAcum']),
                    style: pw.TextStyle(fontSize: 8)),
              ),
            ),
            // 5. Val. Neto $ (Diferencia, tamaño 8, negrita)
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
    final totalBienes = tablaFinal.values // Sumar el nuevo conteo de bienes
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
          // 1. TOTAL GENERAL
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text('TOTAL GENERAL',
                style:
                    pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
          ),
          // 2. Total Bienes (TOTAL CON FILTROS DE DIALOGO)
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                  totalBienes.toString(), // <--- Mostrar el nuevo total
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          // 3. Total Val. Libros $ (TOTAL CON FILTRO UMA)
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(fmt.format(totalValorLibros),
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          // 4. Total Dep. Acum. $ (TOTAL CON FILTROS ESTRICTOS)
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(fmt.format(totalDepreAcum),
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          // 5. Total Val. Neto $ (Diferencia)
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
    // Dividir en páginas
    const filasPorPag = 35;
    final paginas = (filasTabla.length / filasPorPag).ceil();

    for (var p = 0; p < paginas; p++) {
      final desde = p * filasPorPag;
      final hasta = ((p + 1) * filasPorPag > filasTabla.length)
          ? filasTabla.length
          : (p + 1) * filasPorPag;
      final subsetFilas = filasTabla.sublist(desde, hasta);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.letter.landscape, // Formato horizontal
          margin: const pw.EdgeInsets.all(15),
          build: (_) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _header(),
                pw.SizedBox(height: 15),
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  // Ancho de columnas para evitar el desborde
                  columnWidths: {
                    0: const pw.FlexColumnWidth(7), // CLASE DE ACTIVO
                    1: const pw.FlexColumnWidth(2), // No. Bienes
                    2: const pw.FlexColumnWidth(4), // Val. Libros $
                    3: const pw.FlexColumnWidth(4), // Dep. Acum. $
                    4: const pw.FlexColumnWidth(4), // Val. Neto $
                  },
                  children: subsetFilas,
                ),
                pw.Spacer(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text('Página ${p + 1} de $paginas',
                      style: pw.TextStyle(fontSize: 8)),
                ),
              ],
            );
          },
        ),
      );
    }

    final bytes = await pdf.save();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '✅ PDF generado correctamente\n'
        'Unidad: $filtroNivel1 | UMA: $umaValue | Año Base: $selectedYear\n'
        'Bienes Totales (con filtros de diálogo): $totalBienes\n'
        'Valor en Libros (≥20 UMAS): ${fmt.format(totalValorLibros)}\n'
        'Deprec. Acum. (Calculada al $selectedYear con filtros estrictos): ${fmt.format(totalDepreAcum)}\n'
        'Diferencia: ${fmt.format(totalDiferencia)}\n'
        'Excluidos (NO inventariables): $excluidosNoInventariables',
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
// FUNCIONES AUXILIARES DE CÁLCULO DE DEPRECIACIÓN (SIN CAMBIOS)
// ========================================================================

// --- LOGICA MAESTRA BLINDADA Y CORREGIDA PARA HISTÓRICOS ---
Map<String, dynamic> _calcularDepreciacionLinealDefinitiva(
  Map<String, dynamic> data,
  Map<String, int> vidaUtilData,
  DateTime fechaCorteReporte,
  int selectedYearReporte,
) {
  final Map<int, double> deps = {};
  final clase = (data['clasedeactivo'] ?? '').toString(); //
  final vidaUtilAnios = vidaUtilData[clase] ?? 0;
  //
  // *** SOLO IMPORTES Y FECHAS DE ADQUISICIÓN ***
  final montoBase =
      _trunc2((data['importeinicialbien'] as num?)?.toDouble() ?? 0);
  //
  final fechaInicio = _parseFecha(data['fechaadquisicion']); //
  // El Avalúo se ignora para el cálculo

  // Inicializar todo en 0
  for (int y = 2020; y <= selectedYearReporte; y++) deps[y] = 0.0;
  //
  if (montoBase <= 0 || vidaUtilAnios <= 0 || fechaInicio == null) {
    return {'deps': deps, 'valor_en_libros': montoBase, 'suma_depreciada': 0.0};
    //
  }

  // 2. Preparar Logica Temporal
  final totalMesesVida = vidaUtilAnios * 12;
  //
  final cuotaMensualExacta = montoBase / totalMesesVida; //
  // Ajuste de Fecha Inicio (Día > 15 pasa al siguiente mes)
  DateTime fechaContable = fechaInicio.day > 15
      ? DateTime(fechaInicio.year, fechaInicio.month + 1, 1) //
      : DateTime(fechaInicio.year, fechaInicio.month, 1);
  //
  if (fechaContable.month > 12) {
    fechaContable = DateTime(fechaContable.year + 1, 1, 1);
    //
  }

  double sumaDepreciada = 0.0;
  int mesesAcumulados = 0;
  //
  // *** CÁLCULO DE DEPRECIACIÓN HISTÓRICA (PRE-2020) ***
  final finPeriodoHistorico = DateTime(2019, 12, 31);
  //
  // Solo calcular histórico si la fecha contable es ANTERIOR a 2020
  if (fechaContable.isBefore(finPeriodoHistorico)) {
    //
    int anoContable = fechaContable.year;
    //
    int mesContable = fechaContable.month; //

    // Contar meses entre fecha contable y fin de 2019
    while (anoContable <= 2019 && mesesAcumulados < totalMesesVida) {
      //
      int mesesEnAno = 12 - mesContable + 1;
      //
      if (anoContable < 2019) mesesEnAno = 12;
      //

      int mesesRestantesVida = totalMesesVida - mesesAcumulados;
      //
      int mesesAContar = math.min(mesesEnAno, mesesRestantesVida); //
      mesesAcumulados += mesesAContar;
      //

      if (anoContable == 2019) break;
      // Terminamos al final de 2019

      anoContable++;
      //
      mesContable = 1; //
    }

    // Forzar ajuste para bienes totalmente depreciados antes de 2020
    if (mesesAcumulados >= totalMesesVida) {
      //
      sumaDepreciada = montoBase;
      //
      mesesAcumulados = totalMesesVida; // Asegurar que no se deprecie más
    } else {
      // Truncar la depreciación histórica
      sumaDepreciada = _trunc2(cuotaMensualExacta * mesesAcumulados);
      //
    }
  }

  // 3. Iterar Año por Año (2020 en adelante)
  for (int year = 2020; year <= selectedYearReporte; year++) {
    //
    if (mesesAcumulados >= totalMesesVida) {
      deps[year] = 0.0;
      //
      continue; //
    }

    // Calcular meses aplicables en este año
    int mesesEnEsteAno = 0;
    //
    // Si la depreciación aún no ha comenzado (fechaContable futura)
    if (fechaContable.year > year) {
      //
      mesesEnEsteAno = 0;
      //
    } else {
      // Mes de inicio en este año (si fechaContable es anterior a este año, empieza en mes 1)
      int mesInicio = (fechaContable.year < year) ? 1 : fechaContable.month; //

      int mesesPotenciales = 12 - mesInicio + 1;
      //
      int mesesRestantesVida = totalMesesVida - mesesAcumulados;
      //
      mesesEnEsteAno = math.min(mesesPotenciales, mesesRestantesVida);
      //
    }

    if (mesesEnEsteAno <= 0) {
      deps[year] = 0.0;
      //
      continue; //
    }

    // --- Lógica de Depreciación Anual ---
    double montoEsteAno;
    //
    bool esUltimoAnoDeVida =
        (mesesAcumulados + mesesEnEsteAno) >= totalMesesVida;
    //
    if (esUltimoAnoDeVida) {
      //
      double remanenteExacto = montoBase - sumaDepreciada;
      //
      montoEsteAno = _round2(remanenteExacto); //
      if (montoEsteAno < 0) montoEsteAno = 0;
      //
    } else {
      // Años intermedios: Seguimos truncando para mantener estabilidad
      montoEsteAno = _trunc2(cuotaMensualExacta * mesesEnEsteAno);
      //
    }

    deps[year] = montoEsteAno;
    sumaDepreciada += montoEsteAno;
    mesesAcumulados += mesesEnEsteAno;
    //
  }

  // 4. Calculo Final de Valor en Libros
  double valorEnLibros;
  //
  double remanenteFinal = montoBase - sumaDepreciada; //
  valorEnLibros = _round2(remanenteFinal);
  //

  if (valorEnLibros.abs() < 0.01) valorEnLibros = 0.0; //
  return {
    'deps': deps,
    'valor_en_libros': valorEnLibros,
    'suma_depreciada': sumaDepreciada
  };
  //
}

// Utilidad para TRUNCAR
double _trunc2(num v) {
  return (v * 100).floorToDouble() / 100.0;
  //
}

// Utilidad para REDONDEAR (para el ajuste final)
double _round2(num v) {
  return (v * 100).roundToDouble() / 100.0;
}

DateTime? _parseFecha(dynamic f) {
  //
  if (f == null) return null; //
  if (f is Timestamp) return f.toDate();
  //
  if (f is DateTime) return f; //
  try {
    return DateFormat('dd/MM/yyyy').parse(f.toString());
    //
  } catch (_) {
    //
    return null; //
  }
}
