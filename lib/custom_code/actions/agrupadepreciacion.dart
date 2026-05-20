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

// Imports necesarios
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html; // Solo para WEB
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

// Color personalizado
const Color customGreen = Color(0xFF164b2d);

Future agrupadepreciacion(BuildContext context) async {
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

  Navigator.of(context).pop(); // Cerrar loader

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

      String? yearErrorText;

      bool validarYear() {
        final year = int.tryParse(yearController.text);
        if (year == null) {
          yearErrorText = 'Debe ser un número válido.';
          return false;
        }
        if (year < 2025) {
          yearErrorText = 'El año mínimo es 2025.';
          return false;
        }
        yearErrorText = null;
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
              radioTheme: RadioThemeData(
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  return states.contains(WidgetState.selected)
                      ? customGreen
                      : Colors.grey;
                }),
              ),
            ),
            child: AlertDialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              title: const Text('Generar Reporte Agrupado'),
              content: SizedBox(
                width: dialogWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro Unidad Presupuestal:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),

                      // --- CAMBIO AQUÍ: Usamos ConstrainedBox en lugar de height fijo ---
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight:
                              400, // Crece máximo hasta aquí si hay muchas opciones
                        ),
                        child: Container(
                          // Quitamos 'height: 400' para que se encoja si son pocas
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300)),
                          child: ListView(
                            shrinkWrap:
                                true, // Importante para que se ajuste al contenido
                            children: unidadesDisponibles.map((unidadNombre) {
                              return RadioListTile<String>(
                                dense: true,
                                title: Text(unidadNombre,
                                    style: const TextStyle(fontSize: 13)),
                                value: unidadNombre,
                                groupValue: unidad,
                                activeColor: customGreen,
                                onChanged: (v) => setState(() => unidad = v!),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      const SizedBox(
                          height: 15), // Reduje un poco este espacio también

                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Año Fiscal del Reporte:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: yearController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Ej. 2025',
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: customGreen)),
                                errorText: yearErrorText,
                                isDense: true,
                              ),
                              onChanged: (val) => setState(() => validarYear()),
                            ),
                            const SizedBox(height: 5),
                            Text('Rango permitido: a partir de 2025',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[700])),
                          ],
                        ),
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
                    if (validarYear()) {
                      final int selectedYear =
                          int.tryParse(yearController.text) ?? 2025;
                      Navigator.of(context).pop(
                          {'unidad': unidad, 'selectedYear': selectedYear});
                    } else {
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: customGreen,
                      foregroundColor: Colors.white),
                  child: const Text('GENERAR PDF'),
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

  // ---------------------------------------------------------------------------
  // 3. PROCESAMIENTO DE DATOS
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
          Expanded(
              child: Text('Procesando datos del año $anioSeleccionado...')),
        ],
      ),
    ),
  );

  try {
    Query query = firestore.collection('calculodepreciacion');

    // FILTRO 1: Año
    query = query.where('aniodepreciacion', isEqualTo: anioSeleccionado);

    // FILTRO 2: Unidad Presupuestal
    if (filtroUnidad != 'TODOS') {
      query = query.where('unidadpresupuestal', isEqualTo: filtroUnidad);
    }

    final QuerySnapshot snapshot = await query.get();
    final docs = snapshot.docs;

    if (docs.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '⚠️ No se encontraron registros para el año $anioSeleccionado.')),
      );
      return;
    }

    // Agrupación en memoria
    final Map<String, Map<String, dynamic>> datosAgrupados = {};
    double granTotalMonto = 0.0;
    int granTotalItems = 0;

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final String clase =
          (data['clasedeactivo'] ?? 'SIN CLASE DEFINIDA').toString();
      final double monto = (data['depreciacion'] as num?)?.toDouble() ?? 0.0;

      if (!datosAgrupados.containsKey(clase)) {
        datosAgrupados[clase] = {'items': 0, 'monto': 0.0};
      }

      datosAgrupados[clase]!['items'] =
          (datosAgrupados[clase]!['items'] as int) + 1;
      datosAgrupados[clase]!['monto'] =
          (datosAgrupados[clase]!['monto'] as double) + monto;

      granTotalMonto += monto;
      granTotalItems++;
    }

    final sortedClases = datosAgrupados.keys.toList()..sort();

    // ---------------------------------------------------------------------------
    // 4. GENERACIÓN DEL PDF
    // ---------------------------------------------------------------------------
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();

    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    final fechaHora = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

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
                pw.Text('RESUMEN DE DEPRECIACIÓN - EJERCICIO $anioSeleccionado',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                if (filtroUnidad != 'TODOS')
                  pw.Text('Unidad: $filtroUnidad',
                      style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Generado:', style: const pw.TextStyle(fontSize: 8)),
                pw.Text(fechaHora, style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 15),
      ]);
    }

    final List<pw.TableRow> filasTabla = [];

    // ENCABEZADOS
    filasTabla.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('CLASE DE ACTIVO',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('No. de Bienes',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('Dep. \$',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9))),
        ],
      ),
    );

    for (var clase in sortedClases) {
      final items = datosAgrupados[clase]!['items'] as int;
      final monto = datosAgrupados[clase]!['monto'] as double;

      filasTabla.add(
        pw.TableRow(
          children: [
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(clase, style: const pw.TextStyle(fontSize: 8))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(items.toString(),
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 8))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(fmt.format(monto),
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 8))),
          ],
        ),
      );
    }

    // TOTALES
    filasTabla.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('TOTAL',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(granTotalItems.toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(fmt.format(granTotalMonto),
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9))),
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
              0: const pw.FlexColumnWidth(6),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(3),
            },
            children: filasTabla,
          ),
        ],
      ),
    );

    // ---------------------------------------------------------------------------
    // 5. DESCARGA
    // ---------------------------------------------------------------------------
    final bytes = await pdf.save();

    Navigator.of(context).pop();

    final sufijo = (filtroUnidad != 'TODOS')
        ? '_${filtroUnidad.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}'
        : '_GLOBAL';
    final fileName = 'ResumenDepreciacion_$anioSeleccionado$sufijo.pdf';

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '✅ PDF generado: $fileName\nBienes: $granTotalItems | Total: ${fmt.format(granTotalMonto)}'),
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
