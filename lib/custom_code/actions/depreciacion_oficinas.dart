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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Future<void> depreciacionOficinas(BuildContext context) async {
  const Color customGreen = Color(0xFF164b2d);
  final firestore = FirebaseFirestore.instance;

  String cleanText(dynamic text) {
    if (text == null) return '';
    String str = text.toString();
    return str
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        .replaceAll('„', '"')
        .replaceAll('–', '-')
        .trim();
  }

  final List<String> mesesLabel = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      int selectedMonth = 0;
      TextEditingController yearController =
          TextEditingController(text: '2025');

      return StatefulBuilder(builder: (ctx, setState) {
        return AlertDialog(
          title: const Text('Consultar Lista de Bienes Inmuebles Valorizados'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Seleccione el Mes:',
                  style: TextStyle(color: Colors.black)),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                height: 200,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    bool isSelected = (index + 1) == selectedMonth;
                    return InkWell(
                      onTap: () => setState(() => selectedMonth = index + 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? customGreen : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          mesesLabel[index].substring(0, 3),
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Año del registro',
                  labelStyle: TextStyle(color: customGreen),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customGreen, width: 2.0)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCELAR',
                    style: TextStyle(color: customGreen))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: customGreen),
              onPressed: () => Navigator.pop(context, {
                'month': selectedMonth,
                'year': int.tryParse(yearController.text) ?? 2025
              }),
              child: const Text('GENERAR PDF',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      });
    },
  );

  if (result == null) return;
  int targetMonth = result['month'];
  int targetYear = result['year'];

  try {
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    DateTime start = DateTime(targetYear, targetMonth, 1, 0, 0, 0);
    DateTime end = DateTime(targetYear, targetMonth + 1, 0, 23, 59, 59);

    final snap = await firestore
        .collection('inmueblesvalorizados')
        .where('fechavalidez',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('fechavalidez', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    if (snap.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'No hay datos para ${mesesLabel[targetMonth - 1]} $targetYear')));
      return;
    }

    final pdf = pw.Document();
    final currencyFmt = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    double totalTerreno = 0;
    double totalEdificacion = 0;

    final dataRows = snap.docs.asMap().entries.map((entry) {
      final index = entry.key;
      final d = entry.value.data();
      double impTerr = (d['importeterreno'] ?? 0).toDouble();
      double impEdif = (d['importeedificacion'] ?? 0).toDouble();

      totalTerreno += impTerr;
      totalEdificacion += impEdif;

      return [
        (index + 1).toString(),
        cleanText(d['municipio']),
        cleanText(d['inmueble']),
        cleanText(d['ubicacion']),
        cleanText(d['noclavecatastral']),
        currencyFmt.format(impTerr),
        currencyFmt.format(impEdif),
        currencyFmt.format(impTerr + impEdif),
      ];
    }).toList();

    // Fila de Totales
    dataRows.add([
      '',
      '',
      '',
      '',
      '',
      currencyFmt.format(totalTerreno),
      currencyFmt.format(totalEdificacion),
      currencyFmt.format(totalTerreno + totalEdificacion)
    ]);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(25),
        header: (pw.Context context) => pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(logoImage, width: 90),
                pw.Column(
                  children: [
                    pw.Text('PODER JUDICIAL DEL ESTADO DE VERACRUZ',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.Text(
                        'Dirección General de Administración del Consejo de la Judicatura',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    pw.Text(
                        'LISTADO DE BIENES INMUEBLES VALORIZADOS AL 31 DE ${mesesLabel[targetMonth - 1].toUpperCase()} DE $targetYear',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  ],
                ),
                pw.SizedBox(width: 90),
              ],
            ),
            pw.SizedBox(height: 15),
          ],
        ),
        footer: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 7)),
        ),
        build: (pw.Context context) => [
          pw.TableHelper.fromTextArray(
            headers: [
              'ID',
              'MUNICIPIO',
              'INMUEBLE',
              'UBICACIÓN',
              'NO. CLAVE CATASTRAL',
              'IMPORTE TERRENO',
              'IMPORTE EDIFICACIÓN',
              'VALOR TOTAL'
            ],
            data: dataRows,
            headerStyle:
                pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey400),
            cellStyle: const pw.TextStyle(fontSize: 6.5),
            columnWidths: {
              0: const pw.FixedColumnWidth(25),
              1: const pw.FixedColumnWidth(65),
              2: const pw.FixedColumnWidth(85),
              3: const pw.FlexColumnWidth(3),
              4: const pw.FixedColumnWidth(80),
              5: const pw.FixedColumnWidth(65),
              6: const pw.FixedColumnWidth(65),
              7: const pw.FixedColumnWidth(65),
            },
            border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),

            // Alineación de encabezados al centro y celdas a la izquierda
            headerAlignment: pw.Alignment.center,
          ),
          pw.SizedBox(height: 40),
          // Bloque de Firma sin la línea horizontal
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text('ARQ. JOSE RAUL PLATAS GARCIA',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.Text(
                    'JEFE DEL DEPARTAMENTO DE INFRAESTRUCTURA Y SUPERVISION DE OBRA',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.normal, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'Listado_Inmuebles_${targetMonth}_$targetYear.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    debugPrint('Error: $e');
  }
}
