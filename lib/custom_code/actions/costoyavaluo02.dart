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

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Future<void> costoyavaluo02(
  BuildContext context,
  String authToken,
  List<String> ubicacionesNivel1,
) async {
  // Color personalizado institucional
  const Color customGreen = Color(0xFF164b2d);
  // URL base de PocketBase
  final String pbBaseUrl = 'https://api.servidor-inventarios.xyz';

  // ---------------------------------------------------------------------------
  // 1. PREPARACIÓN DE UNIDADES
  // ---------------------------------------------------------------------------
  List<String> unidadesDisponibles = List.from(ubicacionesNivel1);

  // Ordenar la lista alfabéticamente
  unidadesDisponibles.sort((a, b) => a.compareTo(b));

  // Asegurar que la opción 'TODOS' esté siempre al inicio
  if (unidadesDisponibles.contains('TODOS')) {
    unidadesDisponibles.remove('TODOS');
  }
  unidadesDisponibles.insert(0, 'TODOS');

  // ---------------------------------------------------------------------------
  // 2. DIÁLOGO DE CONFIGURACIÓN
  // ---------------------------------------------------------------------------
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
          final double screenWidth = MediaQuery.of(context).size.width;
          final double dialogWidth =
              screenWidth > 600 ? 350 : screenWidth * 0.9;

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
                      // Contenedor optimizado para mayor espacio
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: unidadesDisponibles.length,
                            itemBuilder: (context, index) {
                              final unidadNombre = unidadesDisponibles[index];
                              return RadioListTile<String>(
                                dense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                title: Text(unidadNombre,
                                    style: const TextStyle(fontSize: 12)),
                                value: unidadNombre,
                                groupValue: unidad,
                                onChanged: (v) => setState(() => unidad = v!),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro por UMA:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Valor UMA (MXN)',
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: customGreen, width: 2),
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
              ),
              actions: [
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
                    Navigator.of(context).pop({
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

  final String filtroNivel1 = result['unidad'] ?? 'TODOS';
  final String filtroUMA = result['filtroUMA'] ?? 'TODOS';
  final double umaValue = result['umaValue'] ?? 113.14;
  final bool excluirNoInventariables =
      result['excluirNoInventariables'] ?? true;

  // ---------------------------------------------------------------------------
  // 3. OBTENCIÓN Y PROCESAMIENTO DE DATOS
  // ---------------------------------------------------------------------------
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: const [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customGreen),
          ),
          SizedBox(width: 20),
          Expanded(child: Text('Procesando resumen de costo y avalúo...')),
        ],
      ),
    ),
  );

  try {
    final Map<String, Map<String, dynamic>> resumen = {};
    final Set<String> clasesReales = {};
    int excluidosNoInventariables = 0;
    final double limiteUMA = umaValue * 20.0;

    String filtroBienes = "";
    if (filtroNivel1 != 'TODOS') {
      filtroBienes =
          "nivel1organizacion = '${filtroNivel1.replaceAll("'", "''")}'";
    }

    int pageBienes = 1;
    bool hasMoreBienes = true;

    while (hasMoreBienes) {
      String urlBienesStr =
          '$pbBaseUrl/fastapi/bienesmuebles?page=$pageBienes&perPage=500';
      if (filtroBienes.isNotEmpty) {
        urlBienesStr += '&filter=${Uri.encodeComponent(filtroBienes)}';
      }

      final resBienes = await http.get(
        Uri.parse(urlBienesStr),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (resBienes.statusCode == 200) {
        final decoded = json.decode(resBienes.body);
        final items = decoded['items'] as List;

        if (pageBienes == 1 &&
            items.isEmpty &&
            (decoded['totalItems'] == 0 || decoded['totalItems'] == null)) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('⚠️ No se encontraron registros.')));
          return;
        }

        for (var data in items) {
          final cotejo =
              (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
          if (excluirNoInventariables && cotejo == 'NO') {
            excluidosNoInventariables++;
            continue;
          }

          final clase = (data['clasedeactivo'] ?? '').toString().trim();
          if (clase.isNotEmpty) {
            clasesReales.add(clase);
          } else {
            continue; // Ignorar si no tiene clase
          }

          final double costo =
              (data['importeinicialbien'] as num?)?.toDouble() ?? 0.0;
          final double avaluo = (data['avaluo'] as num?)?.toDouble() ?? 0.0;
          final String fechaAvaluo =
              (data['fechaavaluo'] ?? '').toString().trim();

          // Filtro UMA se aplicará sobre COSTO (importeinicialbien)
          bool cumpleUMA = true;
          if (filtroUMA == 'MENORES A 20 UMAS') {
            cumpleUMA = costo < limiteUMA;
          } else if (filtroUMA == 'MAYOR O IGUAL A 20 UMAS') {
            cumpleUMA = costo >= limiteUMA;
          }
          if (!cumpleUMA) continue;

          final bucket = resumen.putIfAbsent(
              clase,
              () => {
                    'bienes': 0,
                    'costoTotal': 0.0,
                    'bienesValuados': 0,
                    'montoAvaluo': 0.0,
                  });

          bucket['bienes'] = (bucket['bienes'] as int) + 1;
          bucket['costoTotal'] = (bucket['costoTotal'] as double) + costo;
          if (fechaAvaluo.isNotEmpty) {
            bucket['bienesValuados'] = (bucket['bienesValuados'] as int) + 1;
            bucket['montoAvaluo'] = (bucket['montoAvaluo'] as double) + avaluo;
          }
        }

        if (pageBienes >= (decoded['totalPages'] ?? 1)) {
          hasMoreBienes = false;
        } else {
          pageBienes++;
        }
      } else {
        hasMoreBienes = false;
        debugPrint('Error PB bienesmuebles: ${resBienes.body}');
      }
    }

    final List<String> clases = clasesReales.toList()..sort();

    for (final clase in clases) {
      resumen.putIfAbsent(
          clase,
          () => {
                'bienes': 0,
                'costoTotal': 0.0,
                'bienesValuados': 0,
                'montoAvaluo': 0.0,
              });
    }

    // ---------------------------------------------------------------------------
    // 4. GENERACIÓN DE PDF
    // ---------------------------------------------------------------------------
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);

    final pdf = pw.Document();

    pw.Widget headerBuilder(pw.Context ctx) {
      final titulo = (filtroNivel1 != 'TODOS')
          ? 'RESUMEN DE COSTO Y AVALÚO. $filtroNivel1'
          : 'RESUMEN GENERAL DE COSTO Y AVALÚO POR CLASE DE ACTIVO';

      return pw.Container(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 50),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'TRIBUNAL SUPERIOR DE JUSTICIA DEL ESTADO DE VERACRUZ',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  titulo,
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.SizedBox(height: 20),
              ],
            ),
          ],
        ),
      );
    }

    pw.Widget footerBuilder(pw.Context ctx) {
      return pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text('Página ${ctx.pageNumber} de ${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 8)),
      );
    }

    pw.Widget headerRow() {
      pw.Widget cell(String t) => pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Center(
              child: pw.Text(
                t,
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
            ),
          );

      return pw.Container(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        child: pw.Row(
          children: [
            pw.Expanded(flex: 5, child: cell('CLASE DE ACTIVO')),
            pw.Expanded(flex: 2, child: cell('NÚMERO DE BIENES')),
            pw.Expanded(flex: 3, child: cell('COSTO TOTAL (\$)')),
            pw.Expanded(flex: 2, child: cell('N° BIENES VALUADOS')),
            pw.Expanded(flex: 3, child: cell('MONTO AVALÚO (\$)')),
          ],
        ),
      );
    }

    pw.Widget dataRow(String clase, Map<String, dynamic> row) {
      pw.Widget cellText(String t, {bool right = false}) => pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Align(
              alignment:
                  right ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
              child: pw.Text(t, style: const pw.TextStyle(fontSize: 9)),
            ),
          );

      return pw.Row(
        children: [
          pw.Expanded(flex: 5, child: cellText(clase)),
          pw.Expanded(
              flex: 2,
              child: pw.Center(
                  child: pw.Text('${row['bienes']}',
                      style: const pw.TextStyle(fontSize: 9)))),
          pw.Expanded(
              flex: 3,
              child: cellText(fmt.format(row['costoTotal']), right: true)),
          pw.Expanded(
              flex: 2,
              child: pw.Center(
                  child: pw.Text('${row['bienesValuados']}',
                      style: const pw.TextStyle(fontSize: 9)))),
          pw.Expanded(
              flex: 3,
              child: cellText(fmt.format(row['montoAvaluo']), right: true)),
        ],
      );
    }

    final clasesOrdenadas = resumen.keys.toList()..sort();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(15),
        header: headerBuilder,
        footer: footerBuilder,
        build: (ctx) {
          final widgets = <pw.Widget>[];

          widgets.add(headerRow());

          for (final clase in clasesOrdenadas) {
            widgets.add(
              pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                  ),
                ),
                child: dataRow(clase, resumen[clase]!),
              ),
            );
          }

          final totalBienes =
              resumen.values.fold<int>(0, (s, e) => s + (e['bienes'] as int));
          final totalCosto = resumen.values
              .fold<double>(0.0, (s, e) => s + (e['costoTotal'] as double));
          final totalValuados = resumen.values
              .fold<int>(0, (s, e) => s + (e['bienesValuados'] as int));
          final totalAvaluo = resumen.values
              .fold<double>(0.0, (s, e) => s + (e['montoAvaluo'] as double));

          widgets.add(
            pw.Container(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 5,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('TOTAL GENERAL',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Center(
                      child: pw.Text('$totalBienes',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(fmt.format(totalCosto),
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Center(
                      child: pw.Text('$totalValuados',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(fmt.format(totalAvaluo),
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          return widgets;
        },
      ),
    );

    final bytes = await pdf.save();
    Navigator.of(context).pop();

    final totalBienes =
        resumen.values.fold<int>(0, (s, e) => s + (e['bienes'] as int));
    final totalCosto = resumen.values
        .fold<double>(0.0, (s, e) => s + (e['costoTotal'] as double));
    final totalValuados =
        resumen.values.fold<int>(0, (s, e) => s + (e['bienesValuados'] as int));
    final totalAvaluo = resumen.values
        .fold<double>(0.0, (s, e) => s + (e['montoAvaluo'] as double));

    final fmtSnack =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '✅ PDF generado correctamente\n'
        'Unidad: $filtroNivel1 | Filtro UMA: $filtroUMA | UMA: $umaValue\n'
        'Bienes: $totalBienes | Costo Total: ${fmtSnack.format(totalCosto)} | '
        'Bienes Valuados: $totalValuados | Avalúo: ${fmtSnack.format(totalAvaluo)}\n'
        'Excluidos (NO inventariables): $excluidosNoInventariables',
      ),
      duration: const Duration(seconds: 10),
      backgroundColor: customGreen,
    ));

    final sufijo = (filtroNivel1 != 'TODOS')
        ? '_${filtroNivel1.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}'
        : '';
    final fileName =
        'ResumenCostoAvaluo${sufijo}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('❌ Error: $e'),
      backgroundColor: Colors.red,
    ));
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
