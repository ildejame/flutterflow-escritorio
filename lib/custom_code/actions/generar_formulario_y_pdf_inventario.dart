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

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import '/auth/firebase_auth/auth_util.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

Future<void> generarFormularioYPdfInventario(
  BuildContext context,
  String authToken,
  String inventarioBuscado,
) async {
  const Color customGreen = Color(0xFF164b2d);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          SizedBox(width: 20),
          Expanded(child: Text('Buscando información del bien...')),
        ],
      ),
    ),
  );

  try {
    final String inv = inventarioBuscado.trim();
    final searchUrl =
        'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/?filter=(inventario2025%3D%22$inv%22)';
    final searchResp = await http.get(
      Uri.parse(searchUrl),
      headers: {'Authorization': 'Bearer $authToken'},
    );
    Navigator.of(context).pop();

    if (searchResp.statusCode == 200) {
      final searchData = jsonDecode(searchResp.body);
      if (searchData['items'] != null && searchData['items'].isNotEmpty) {
        final data = searchData['items'][0];

        // Extracción de datos
        final String nivel1 = (data['nivel1organizacion'] ?? 'ND').toString();
        final String factura = (data['factura'] ?? 'ND').toString();
        final String proveedor = (data['nombredelprovedor'] ?? 'ND').toString();
        final String noPartida = (data['nopartida'] ?? 'ND').toString();
        final String recurso = (data['recurso'] ?? '').toString().toUpperCase();
        final String cotejoDoc =
            (data['cotejodoc'] ?? '').toString().toLowerCase().trim();
        final String nombreBien = (data['nombre'] ?? 'ND').toString();

        // Extracción de la fecha de adquisición
        final String fechaAdquisicionRaw =
            (data['fechaadquisicion'] ?? '').toString();

        // Lógica para determinar la Clave de Organización
        String claveNivel = '';
        String nivelUpper = nivel1.toUpperCase();

        if (nivelUpper.contains('TRIBUNAL SUPERIOR DE JUSTICIA')) {
          claveNivel = '301C11001';
        } else if (nivelUpper
            .contains('TRIBUNAL DE CONCILIACION Y ARBITRAJE')) {
          claveNivel = '301C21001';
        } else if (nivelUpper.contains('TRIBUNAL DE DISCIPLINA JUDICIAL')) {
          claveNivel = '301C71001';
        } else if (nivelUpper.contains('ORGANO DE ADMINISTRACION JUDICIAL')) {
          claveNivel = '301C81001';
        }

        // Si se encontró una clave, se formatea como "CLAVE (NIVEL)". Si no, se deja el nivel normal.
        final String organizacionDisplay =
            claveNivel.isNotEmpty ? '$claveNivel ($nivel1)' : nivel1;

        final double importeNum =
            double.tryParse(data['importeinicialbien']?.toString() ?? '0') ??
                0.0;
        final formatCurrency = NumberFormat('#,##0.00', 'en_US');
        final String importeFormatted = formatCurrency.format(importeNum);

        final bool esCapitalizable = cotejoDoc == 'sí' || cotejoDoc == 'si';
        final bool recursoEstatal = recurso.contains('ESTATAL');
        final bool recursoFederal = recurso.contains('FEDERAL');

        final String displayUser = currentUserDisplayName ?? 'Usuario';

        // Controlador para el campo de comentarios
        final TextEditingController comentariosController =
            TextEditingController();

        bool? confirmarDescarga = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Generar Reporte de Alta',
                  style: TextStyle(
                      color: customGreen, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No. Inventario: $inv',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Descripción: $nombreBien'),
                    Text('Proveedor: $proveedor'),
                    Text('Importe: \$ $importeFormatted'),
                    const SizedBox(height: 16),
                    Material(
                      color: Colors.transparent,
                      child: TextField(
                        controller: comentariosController,
                        cursorColor: customGreen,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Comentarios',
                          floatingLabelStyle: TextStyle(
                            color: customGreen,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: customGreen,
                              width: 2.0,
                            ),
                          ),
                          isDense: true,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                        '¿Desea generar y descargar el documento PDF con esta información?'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('CANCELAR',
                      style: TextStyle(color: customGreen)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: customGreen,
                      foregroundColor: Colors.white),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('DESCARGAR PDF'),
                ),
              ],
            );
          },
        );

        if (confirmarDescarga == true) {
          final String comentariosTexto = comentariosController.text.trim();
          pw.MemoryImage? logoIzquierdo;
          pw.MemoryImage? logoDerecho;

          try {
            final dataIzquierda =
                await rootBundle.load('assets/images/logopjev.png');
            logoIzquierdo = pw.MemoryImage(dataIzquierda.buffer.asUint8List());

            final dataDerecha =
                await rootBundle.load('assets/images/03logo.png');
            logoDerecho = pw.MemoryImage(dataDerecha.buffer.asUint8List());
          } catch (e) {
            print('Error al cargar logos: $e');
          }

          final pdf = pw.Document();

          // Lógica de fechas ajustada
          DateTime? dateToUse = DateTime.tryParse(fechaAdquisicionRaw);
          // Fallback por si la fecha de adquisición viene vacía o en un formato no compatible
          if (dateToUse == null) {
            dateToUse = DateTime.now();
          }

          final List<String> meses = [
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
          final String fechaFormateada =
              'Xalapa, Ver., a ${dateToUse.day} de ${meses[dateToUse.month - 1]} de ${dateToUse.year}';

          final PdfColor colorGrisFondo = PdfColor.fromHex('#E0E0E0');
          final PdfColor colorGrisTabla = PdfColor.fromHex('#BDBDBD');

          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.letter,
              margin: const pw.EdgeInsets.all(40),
              build: (pw.Context context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 110,
                          height: 110,
                          child: logoIzquierdo != null
                              ? pw.Image(logoIzquierdo)
                              : pw.SizedBox(),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.SizedBox(height: 20),
                              pw.Text('PODER JUDICIAL DEL ESTADO DE VERACRUZ',
                                  style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 4),
                              pw.Text('Dirección General de Administración del',
                                  style: const pw.TextStyle(fontSize: 10),
                                  textAlign: pw.TextAlign.center),
                              pw.Text('Órgano de Administración Judicial',
                                  style: const pw.TextStyle(fontSize: 10),
                                  textAlign: pw.TextAlign.center),
                              pw.Text('Subdirección de Recursos Materiales',
                                  style: const pw.TextStyle(fontSize: 10),
                                  textAlign: pw.TextAlign.center),
                              pw.Text('Departamento de Control de Inventarios',
                                  style: const pw.TextStyle(fontSize: 10),
                                  textAlign: pw.TextAlign.center),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 60,
                          height: 60,
                          child: logoDerecho != null
                              ? pw.Image(logoDerecho)
                              : pw.SizedBox(),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Container(
                      width: double.infinity,
                      color: colorGrisFondo,
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('FOLIO FISCAL DE FACTURA: $factura',
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Text('PROVEEDOR: $proveedor',
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Text('No. DE PARTIDA: $noPartida',
                              style: const pw.TextStyle(fontSize: 10)),
                          // Aquí se imprime la organización con la clave
                          pw.Text('ORGANIZACIÓN: $organizacionDisplay',
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Text(
                              'RECURSO: ESTATAL (${recursoEstatal ? 'X' : '  '})    FEDERAL (${recursoFederal ? 'X' : '  '})',
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Text(
                              'TIPO DE BIEN: CAPITALIZABLE (${esCapitalizable ? 'X' : '  '})    NO CAPITALIZABLE (${!esCapitalizable ? 'X' : '  '})',
                              style: const pw.TextStyle(fontSize: 10)),
                          if (comentariosTexto.isNotEmpty)
                            pw.Text(comentariosTexto,
                                style: const pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(2),
                        1: const pw.FlexColumnWidth(5),
                        2: const pw.FlexColumnWidth(2),
                      },
                      children: [
                        pw.TableRow(
                          decoration: pw.BoxDecoration(color: colorGrisTabla),
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('No. DE INVENTARIO',
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.center)),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(
                                    'CARACTERISTICAS DE LA DESCRIPCION',
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.center)),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('IMPORTE',
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.center)),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(inv,
                                    style: const pw.TextStyle(fontSize: 10),
                                    textAlign: pw.TextAlign.center)),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(nombreBien,
                                    style: const pw.TextStyle(fontSize: 10))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('\$ $importeFormatted',
                                    style: const pw.TextStyle(fontSize: 10),
                                    textAlign: pw.TextAlign.right)),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('',
                                    style: const pw.TextStyle(fontSize: 10))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('TOTAL ANEXO:',
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.right)),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('\$ $importeFormatted',
                                    style: const pw.TextStyle(fontSize: 10),
                                    textAlign: pw.TextAlign.right)),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 15),
                    pw.Center(
                      child: pw.Text(fechaFormateada,
                          style: const pw.TextStyle(fontSize: 10)),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            children: [
                              pw.Text('ELABORÓ',
                                  style: const pw.TextStyle(fontSize: 8)),
                              pw.SizedBox(height: 40),
                              pw.Container(
                                  height: 1,
                                  width: 120,
                                  color: PdfColors.black),
                              pw.SizedBox(height: 5),
                              pw.Text(displayUser,
                                  style: const pw.TextStyle(fontSize: 8),
                                  textAlign: pw.TextAlign.center),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                            children: [
                              pw.Text('REVISÓ',
                                  style: const pw.TextStyle(fontSize: 8)),
                              pw.SizedBox(height: 40),
                              pw.Container(
                                  height: 1,
                                  width: 120,
                                  color: PdfColors.black),
                              pw.SizedBox(height: 5),
                              pw.Text('L.C. ALEJANDRO OLIVO MARTINEZ',
                                  style: const pw.TextStyle(fontSize: 8),
                                  textAlign: pw.TextAlign.center),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                            children: [
                              pw.Text('RECIBIÓ ANEXO',
                                  style: const pw.TextStyle(fontSize: 8)),
                              pw.SizedBox(height: 40),
                              pw.Container(
                                  height: 1,
                                  width: 120,
                                  color: PdfColors.black),
                              pw.SizedBox(height: 5),
                              pw.Text('NOMBRE Y FIRMA',
                                  style: const pw.TextStyle(fontSize: 8),
                                  textAlign: pw.TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
          final bytes = await pdf.save();
          final blob = html.Blob([bytes], 'application/pdf');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'Resguardo_$inv.pdf')
            ..click();
          html.Url.revokeObjectUrl(url);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('✅ Documento descargado con éxito'),
              backgroundColor: customGreen));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                '⚠️ No se encontró el inventario $inv en la base de datos.')));
      }
    } else {
      throw Exception("Error GET: ${searchResp.statusCode}");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al procesar el documento: $e')));
  }
}
