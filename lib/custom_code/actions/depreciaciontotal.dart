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

Future depreciaciontotal(BuildContext context) async {
  // Color personalizado institucional
  const Color customGreen = Color(0xFF164b2d);
  final firestore = FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // 1. CARGA DE CATÁLOGO DE OFICINAS
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

  Navigator.of(context).pop(); // Cierra loader inicial

  // ---------------------------------------------------------------------------
  // 2. DIÁLOGO DE CONFIGURACIÓN (Unidad, Año, Valor UMA)
  // ---------------------------------------------------------------------------
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String unidad = 'TODOS';
      final TextEditingController umaController =
          TextEditingController(text: '113.14');

      int currentYear = DateTime.now().year;
      final TextEditingController yearController = TextEditingController(
          text: (currentYear < 2025 ? 2025 : currentYear).toString());

      String? yearErrorText;

      bool validarYear() {
        final year = int.tryParse(yearController.text);
        if (year == null) {
          yearErrorText = 'Número inválido';
          return false;
        }
        if (year < 2025) {
          yearErrorText = 'Mínimo 2025';
          return false;
        }
        yearErrorText = null;
        return true;
      }

      return StatefulBuilder(
        builder: (ctx, setState) {
          final double screenWidth = MediaQuery.of(context).size.width;
          // Ajuste de ancho para el diálogo
          final double dialogWidth =
              screenWidth > 600 ? 500 : screenWidth * 0.9;

          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: customGreen,
                secondary: customGreen,
              ),
              radioTheme: RadioThemeData(
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  return states.contains(WidgetState.selected)
                      ? customGreen
                      : Colors.grey;
                }),
              ),
            ),
            child: AlertDialog(
              title: const Text('Configuración Depreciación Total'),
              content: SizedBox(
                width: dialogWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // --- SECCIÓN UNIDAD ---
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro Unidad Presupuestal:',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ),
                      const SizedBox(height: 4),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 250),
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
                                onChanged: (v) => setState(() => unidad = v!),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // --- SECCIÓN AÑO ---
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Año Fiscal:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Ej. 2025',
                          border: const OutlineInputBorder(),
                          errorText: yearErrorText,
                          isDense: true,
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: customGreen)),
                        ),
                        onChanged: (_) => setState(() => validarYear()),
                      ),

                      const SizedBox(height: 15),

                      // --- SECCIÓN VALOR UMA ---
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Valor UMA (MXN):',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: umaController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          hintText: 'Ej. 113.14',
                          border: OutlineInputBorder(),
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: customGreen),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Nota: El conteo de bienes filtrará solo aquellos >= 20 UMAS.',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  style: TextButton.styleFrom(foregroundColor: customGreen),
                  child: const Text('CANCELAR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!validarYear()) {
                      setState(() {}); // Refrescar error
                      return;
                    }
                    final double umaVal = double.tryParse(
                            umaController.text.replaceAll(',', '.')) ??
                        113.14;
                    final int yearVal =
                        int.tryParse(yearController.text) ?? 2025;

                    Navigator.of(context).pop({
                      'unidad': unidad,
                      'anio': yearVal,
                      'umaValue': umaVal,
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

  final String filtroUnidad = result['unidad'];
  final int anioSeleccionado = result['anio'];
  final double umaValue = result['umaValue'];
  final double limiteUMA = umaValue * 20.0;

  // ---------------------------------------------------------------------------
  // 3. OBTENCIÓN Y PROCESAMIENTO DE DATOS
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
          Expanded(child: Text('Procesando datos $anioSeleccionado...')),
        ],
      ),
    ),
  );

  try {
    // --- PASO A: Procesar "bienesmuebles" (Conteo con filtro UMA) ---
    // Estructura Map: Clase -> { 'conteo': int, 'depreciacion': double }
    final Map<String, Map<String, dynamic>> resumen = {};

    Query queryBienes = firestore.collection('bienesmuebles');
    if (filtroUnidad != 'TODOS') {
      queryBienes =
          queryBienes.where('nivel1organizacion', isEqualTo: filtroUnidad);
    }

    // Función auxiliar fecha (copiada de tu lógica)
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

    // Debido a que debemos recorrer para calcular valores, traemos todo lo que coincida con la unidad
    // Usamos paginación simple o stream si fuera mucho, pero aquí get() directo por simplicidad basada en tu ejemplo anterior.
    // Para optimizar en colecciones muy grandes, se debería paginar, pero seguimos tu patrón.
    final bienesSnapshot = await queryBienes.get();

    for (var doc in bienesSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

      // Inicializar en el mapa si no existe (importante para mostrar clases con 0 bienes válidos)
      if (!resumen.containsKey(clase)) {
        resumen[clase] = {'conteo': 0, 'depreciacion': 0.0};
      }

      // Lógica de Filtro (Inventariable + Valor UMA)
      final cotejo = (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
      // Si no es inventariable, no suma al conteo, pero la clase ya se registró arriba.
      if (cotejo == 'NO') continue;

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

      // SOLO contar si cumple >= 20 UMAS
      if (valorEnLibros >= limiteUMA) {
        resumen[clase]!['conteo'] = (resumen[clase]!['conteo'] as int) + 1;
      }
    }

    // --- PASO B: Procesar "calculodepreciacion" (Suma de valores) ---
    Query queryDep = firestore.collection('calculodepreciacion');
    queryDep = queryDep.where('aniodepreciacion', isEqualTo: anioSeleccionado);
    if (filtroUnidad != 'TODOS') {
      queryDep = queryDep.where('unidadpresupuestal', isEqualTo: filtroUnidad);
    }

    final depSnapshot = await queryDep.get();

    for (var doc in depSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      // Si llega una clase vacía o nula, la ignoramos o le ponemos "SIN CLASE"
      final validClase = clase.isEmpty ? 'SIN DEFINIR' : clase;

      if (!resumen.containsKey(validClase)) {
        // Puede ocurrir que haya depreciación de algo que no apareció en bienesmuebles (raro, pero posible)
        resumen[validClase] = {'conteo': 0, 'depreciacion': 0.0};
      }

      final double monto = (data['depreciacion'] as num?)?.toDouble() ?? 0.0;
      resumen[validClase]!['depreciacion'] =
          (resumen[validClase]!['depreciacion'] as double) + monto;
    }

    // --- PASO C: Filtrado Final para el PDF ---
    // Regla:
    // - Si filtroUnidad == TODOS -> Mostrar todo lo que esté en 'resumen'.
    // - Si filtroUnidad != TODOS -> Omitir si (conteo == 0 AND depreciacion == 0).

    final List<String> clasesFinales = [];
    final keysOrdenadas = resumen.keys.toList()..sort();

    for (var k in keysOrdenadas) {
      if (filtroUnidad == 'TODOS') {
        clasesFinales.add(k);
      } else {
        final int c = resumen[k]!['conteo'];
        final double d = resumen[k]!['depreciacion'];
        if (c > 0 || d > 0) {
          clasesFinales.add(k);
        }
      }
    }

    if (clasesFinales.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                '⚠️ No hay información para generar el reporte con los criterios seleccionados.')),
      );
      return;
    }

    // ---------------------------------------------------------------------------
    // 4. GENERACIÓN DE PDF
    // ---------------------------------------------------------------------------
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    final fechaHora = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    // Calculamos Totales Generales
    int totalBienesReporte = 0;
    double totalDepreciacionReporte = 0.0;

    for (var k in clasesFinales) {
      totalBienesReporte += (resumen[k]!['conteo'] as int);
      totalDepreciacionReporte += (resumen[k]!['depreciacion'] as double);
    }

    pw.Widget buildHeader(pw.Context context) {
      return pw.Column(children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 50),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('PODER JUDICIAL DEL ESTADO DE VERACRUZ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.SizedBox(height: 4),
                pw.Text('RESUMEN DE DEPRECIACIÓN Y BIENES PATRIMONIALES',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.Text('EJERCICIO $anioSeleccionado',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.SizedBox(height: 2),
                if (filtroUnidad != 'TODOS')
                  pw.Text('Unidad: $filtroUnidad',
                      style: const pw.TextStyle(fontSize: 9))
                else
                  pw.Text('REPORTE GENERAL (TODAS LAS UNIDADES)',
                      style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Criterio Bienes: >= 20 UMAS',
                    style: const pw.TextStyle(fontSize: 7)),
                pw.Text('Valor UMA: \$${umaValue.toStringAsFixed(2)}',
                    style: const pw.TextStyle(fontSize: 7)),
                pw.SizedBox(height: 2),
                pw.Text('Generado: $fechaHora',
                    style: const pw.TextStyle(fontSize: 7)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 15),
      ]);
    }

    final List<pw.TableRow> filasTabla = [];

    // Header Tabla
    filasTabla.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                  child: pw.Text('CLASE DE ACTIVO',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 9)))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                  child: pw.Text('No. de Bienes\n(>= 20 UMAS)',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 8)))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                  child: pw.Text('Depreciación Ejercicio\n(Total)',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 8)))),
        ],
      ),
    );

    // Filas Datos
    for (var clase in clasesFinales) {
      final int conteo = resumen[clase]!['conteo'];
      final double dep = resumen[clase]!['depreciacion'];

      filasTabla.add(
        pw.TableRow(
          children: [
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(clase, style: const pw.TextStyle(fontSize: 8))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('$conteo',
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 8))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(fmt.format(dep),
                        style: const pw.TextStyle(fontSize: 8)))),
          ],
        ),
      );
    }

    // Fila Totales
    filasTabla.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('TOTAL GENERAL',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('$totalBienesReporte',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(fmt.format(totalDepreciacionReporte),
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 9)))),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(20),
        header: buildHeader,
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8)),
        ),
        build: (context) => [
          pw.Table(
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
            columnWidths: {
              0: const pw.FlexColumnWidth(6), // Clase
              1: const pw.FlexColumnWidth(2), // Bienes
              2: const pw.FlexColumnWidth(3), // Depreciacion
            },
            children: filasTabla,
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    Navigator.of(context).pop(); // Cerrar loader

    final sufijo = (filtroUnidad != 'TODOS')
        ? '_${filtroUnidad.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}'
        : '_GLOBAL';
    final fileName = 'DepreciacionTotal_$anioSeleccionado$sufijo.pdf';

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✅ PDF generado: $fileName'),
      backgroundColor: customGreen,
      duration: const Duration(seconds: 5),
    ));
  } catch (e) {
    Navigator.of(context).pop();
    debugPrint('❌ Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('❌ Error al generar reporte: $e'),
      backgroundColor: Colors.red,
    ));
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
