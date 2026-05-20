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

Future<void> depreciacion2025(BuildContext context) async {
  // Mostrar diálogo de filtro de Unidad Presupuestal
  String? filtroNivel1 = 'TODOS';

  final result = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String localNivel1 = filtroNivel1!;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Seleccionar Unidad Presupuestal'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Filtro Unidad Presupuestal:'),
                SizedBox(height: 10),
                ...[
                  'TODOS',
                  'CONSEJO DE LA JUDICATURA',
                  'TRIBUNAL SUPERIOR DE JUSTICIA',
                  'TRIBUNAL DE CONCILIACION Y ARBITRAJE'
                ].map(
                  (opcion) => RadioListTile<String>(
                    title: Text(opcion),
                    value: opcion,
                    groupValue: localNivel1,
                    onChanged: (val) => setState(() => localNivel1 = val!),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text('CANCELAR'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(localNivel1),
                child: Text('GENERAR RESUMEN'),
              ),
            ],
          );
        },
      );
    },
  );

  if (result == null) return;
  filtroNivel1 = result;

  // Mostrar diálogo de progreso
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Expanded(child: Text('Procesando resumen de costos y avalúos...')),
          ],
        ),
      );
    },
  );

  try {
    final firestore = FirebaseFirestore.instance;

    // Cargar todos los bienes muebles con filtro opcional
    final List<DocumentSnapshot> todosLosDocs = [];
    Query query = firestore.collection('bienesmuebles');

    // Aplicar filtro de Unidad Presupuestal si no es "TODOS"
    if (filtroNivel1 != 'TODOS') {
      query = query.where('nivel1organizacion', isEqualTo: filtroNivel1);
    }

    DocumentSnapshot? ultimoDoc;

    // Cargar todos los documentos en lotes
    while (true) {
      Query queryPaginada = query.limit(500);
      if (ultimoDoc != null) {
        queryPaginada = queryPaginada.startAfterDocument(ultimoDoc);
      }

      final snapshot = await queryPaginada.get();
      if (snapshot.docs.isEmpty) break;

      todosLosDocs.addAll(snapshot.docs);
      ultimoDoc = snapshot.docs.last;
    }

    // Filtrar solo los que tengan importe inicial, avalúo o depreciación > 0
    final List<DocumentSnapshot> docsFiltrados = todosLosDocs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final importe = (data['importeinicialbien'] as num?)?.toDouble() ?? 0.0;
      final avaluo = (data['avaluo'] as num?)?.toDouble() ?? 0.0;
      final depreciacion = (data['depreciacion'] as num?)?.toDouble() ?? 0.0;
      return importe > 0 || avaluo > 0 || depreciacion > 0;
    }).toList();

    if (docsFiltrados.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '⚠️ No se encontraron registros con costos, avalúos o depreciaciones mayores a 0.')),
      );
      return;
    }

    // Agrupar por clase de activo y sumar costos, avalúos y depreciación
    final Map<String, Map<String, double>> resumen = {};

    for (final doc in docsFiltrados) {
      final data = doc.data() as Map<String, dynamic>;
      final claseDeActivo =
          data['clasedeactivo'] as String? ?? 'SIN CLASIFICAR';
      final importeInicial =
          (data['importeinicialbien'] as num?)?.toDouble() ?? 0.0;
      final avaluo = (data['avaluo'] as num?)?.toDouble() ?? 0.0;
      final depreciacion = (data['depreciacion'] as num?)?.toDouble() ?? 0.0;

      if (!resumen.containsKey(claseDeActivo)) {
        resumen[claseDeActivo] = {
          'costo': 0.0,
          'avaluo': 0.0,
          'depreciacion': 0.0
        };
      }

      resumen[claseDeActivo]!['costo'] =
          (resumen[claseDeActivo]!['costo']! + importeInicial).toDouble();
      resumen[claseDeActivo]!['avaluo'] =
          (resumen[claseDeActivo]!['avaluo']! + avaluo).toDouble();
      resumen[claseDeActivo]!['depreciacion'] =
          (resumen[claseDeActivo]!['depreciacion']! + depreciacion).toDouble();
    }

    // Crear PDF
    final pdf = pw.Document();

    // Cargar logo
    final ByteData logoData =
        await rootBundle.load('assets/images/logopjev.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    // Estilos
    final headerStyle =
        pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold);
    final tableHeaderStyle =
        pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final cellStyle = pw.TextStyle(fontSize: 9);
    final totalStyle =
        pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);

    // Formatear moneda
    final formatoMoneda =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);

    // Función para crear encabezado profesional con logo
    pw.Widget buildHeader() {
      final fechaHoraElaboracion =
          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      List<pw.Widget> encabezadoTextos = [
        pw.Text('TRIBUNAL SUPERIOR DE JUSTICIA DEL ESTADO DE VERACRUZ',
            style: headerStyle),
        pw.SizedBox(height: 5),
        pw.Text('RESUMEN', style: headerStyle),
      ];

      // Agregar línea de UNIDAD PRESUPUESTAL solo si no es "TODOS"
      if (filtroNivel1 != 'TODOS') {
        encabezadoTextos.add(
          pw.SizedBox(height: 3),
        );
        encabezadoTextos.add(
          pw.Text('UNIDAD PRESUPUESTAL: $filtroNivel1',
              style:
                  pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        );
      }

      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 50),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: encabezadoTextos,
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Fecha y hora de elaboración:',
                  style: pw.TextStyle(
                      fontSize: 8, fontWeight: pw.FontWeight.bold)),
              pw.Text(fechaHoraElaboracion, style: pw.TextStyle(fontSize: 8)),
            ],
          ),
        ],
      );
    }

    final clasesOrdenadas = resumen.keys.toList()..sort();

    // Calcular si necesitamos múltiples páginas (más filas por página en horizontal)
    const int filasPorPagina = 35; // Más filas debido al formato horizontal
    int paginas = (clasesOrdenadas.length / filasPorPagina).ceil();

    // Generar páginas PDF
    for (int pagina = 0; pagina < paginas; pagina++) {
      final desde = pagina * filasPorPagina;
      final hasta = ((pagina + 1) * filasPorPagina) > clasesOrdenadas.length
          ? clasesOrdenadas.length
          : (pagina + 1) * filasPorPagina;

      final subsetClases = clasesOrdenadas.sublist(desde, hasta);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.letter.landscape, // ORIENTACIÓN HORIZONTAL
          margin: const pw.EdgeInsets.all(
              15), // Márgenes reducidos para aprovechar espacio
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildHeader(),
                pw.SizedBox(height: 15),
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: pw.FlexColumnWidth(5), // CLASE DE ACTIVO - más espacio
                    1: pw.FlexColumnWidth(2.5), // COSTO
                    2: pw.FlexColumnWidth(2.5), // COSTO AVALÚO
                    3: pw.FlexColumnWidth(2.5), // DEPRECIACIÓN
                  },
                  children: [
                    // Encabezado de la tabla
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Center(
                                child: pw.Text('CLASE DE ACTIVO',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Center(
                                child:
                                    pw.Text('COSTO', style: tableHeaderStyle))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Center(
                                child: pw.Text('COSTO AVALÚO',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Center(
                                child: pw.Text('DEPRECIACIÓN',
                                    style: tableHeaderStyle))),
                      ],
                    ),
                    // Datos
                    ...subsetClases.map((claseActivo) {
                      final datos = resumen[claseActivo]!;
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Center(
                                  // CENTRADO
                                  child:
                                      pw.Text(claseActivo, style: cellStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Center(
                                  // CENTRADO
                                  child: pw.Text(
                                      formatoMoneda.format(datos['costo']!),
                                      style: cellStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Center(
                                  // CENTRADO
                                  child: pw.Text(
                                      formatoMoneda.format(datos['avaluo']!),
                                      style: cellStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Center(
                                  // CENTRADO
                                  child: pw.Text(
                                      formatoMoneda
                                          .format(datos['depreciacion']!),
                                      style: cellStyle))),
                        ],
                      );
                    }),
                    // Fila de totales (solo en la última página)
                    if (pagina == paginas - 1)
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Center(
                                  // CENTRADO
                                  child: pw.Text('TOTAL GENERAL',
                                      style: totalStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Align(
                                // Totales alineados a la derecha para mejor legibilidad
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                    formatoMoneda.format(resumen.values.fold(
                                        0.0,
                                        (sum, datos) => sum + datos['costo']!)),
                                    style: totalStyle),
                              )),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Align(
                                // Totales alineados a la derecha para mejor legibilidad
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                    formatoMoneda.format(resumen.values.fold(
                                        0.0,
                                        (sum, datos) =>
                                            sum + datos['avaluo']!)),
                                    style: totalStyle),
                              )),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Align(
                                // Totales alineados a la derecha para mejor legibilidad
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                    formatoMoneda.format(resumen.values.fold(
                                        0.0,
                                        (sum, datos) =>
                                            sum + datos['depreciacion']!)),
                                    style: totalStyle),
                              )),
                        ],
                      ),
                  ],
                ),
                pw.Spacer(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Página ${pagina + 1} de $paginas',
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    final bytes = await pdf.save();

    Navigator.of(context).pop(); // cerrar diálogo de "Procesando"

    // Mostrar estadísticas finales con información del filtro
    final totalClases = clasesOrdenadas.length;
    final totalCosto =
        resumen.values.fold(0.0, (sum, datos) => sum + datos['costo']!);
    final totalAvaluo =
        resumen.values.fold(0.0, (sum, datos) => sum + datos['avaluo']!);
    final totalDepreciacion =
        resumen.values.fold(0.0, (sum, datos) => sum + datos['depreciacion']!);

    String mensajeFiltro =
        filtroNivel1 != 'TODOS' ? 'Filtro aplicado: $filtroNivel1\n' : '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ PDF generado exitosamente\n'
            '${mensajeFiltro}'
            'Total de clases: $totalClases\n'
            'Costo total: ${formatoMoneda.format(totalCosto)}\n'
            'Avalúo total: ${formatoMoneda.format(totalAvaluo)}\n'
            'Depreciación total: ${formatoMoneda.format(totalDepreciacion)}'),
        duration: Duration(seconds: 5),
      ),
    );

    // Descargar PDF con nombre que incluya el filtro
    String sufijo =
        filtroNivel1 != 'TODOS' ? '_${filtroNivel1.replaceAll(' ', '_')}' : '';
    final fileName =
        'ResumenCostosAvaluosDepreciacion${sufijo}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);
  } catch (e, st) {
    Navigator.of(context).pop();
    debugPrint('❌ Error al generar resumen: $e\n$st');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Error al procesar datos: $e')),
    );
  }
}
