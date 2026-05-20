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

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

Future<void> reporteusuario(
  List<BienesmueblesRecord>? bienesMuebles,
  String texto1, // NOMBRE COMPLETO DEL DEPOSITARIO O RESPONSABLE
  String texto2, // CARGO DEL DEPOSITARIO
  String texto3, // NOMBRE COMPLETO DE REVISOR
  String texto4, // CARGO DEL REVISOR
  String texto5, // UBICACIÓN
  String texto6, // DISTRITO
) async {
  // CRUCIAL: Asignar la lista a una variable local no nula para evitar errores
  final List<BienesmueblesRecord> listaBienes = bienesMuebles ?? [];

  // Cargar el logo desde assets
  final ByteData logoData = await rootBundle.load('assets/images/logopjev.png');
  final Uint8List logoBytes = logoData.buffer.asUint8List();

  // Crear el documento PDF
  final pdf = pw.Document();

  // Estilos comunes
  final headerTextStyle = pw.TextStyle(
    fontSize: 10,
    fontWeight: pw.FontWeight.bold,
  );

  final tableHeaderStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 8,
  );

  final cellTextStyle = pw.TextStyle(
    fontSize: 7,
  );

  final totalRowStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 8,
  );

  // --- CÁLCULO DE TOTALES ---
  double totalCosto = 0;
  // Usamos listaBienes, que es NO NULA
  for (var bien in listaBienes) {
    if (bien.importeinicialbien != null) {
      totalCosto += bien.importeinicialbien!;
    }
  }

  // Formatear el número para mostrar 2 decimales
  final formatoMoneda = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '\$',
    decimalDigits: 2,
  );
  final totalCostoFormateado = formatoMoneda.format(totalCosto);

  // Obtener la fecha actual
  final fechaActual =
      DateFormat("dd 'de' MMMM 'de' yyyy", 'es').format(DateTime.now());

  // --- FUNCIONES DE WIDGETS (sin cambios en las firmas/headers) ---

  pw.Widget _buildPageNumberFooter(int currentPage, int totalPages) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'Página ${currentPage}/$totalPages',
        style: const pw.TextStyle(fontSize: 7),
      ),
    );
  }

  pw.Widget _buildSignatureSection(String depositario, String cargoDepositario,
      String revisor, String cargoRevisor) {
    return pw.Container(
        margin: const pw.EdgeInsets.only(top: 20),
        child: pw.Column(
          children: [
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                pw.Column(
                  children: [
                    pw.Text("DEPOSITARIO/USUARIO",
                        style: pw.TextStyle(fontSize: 8)),
                    pw.SizedBox(height: 20),
                    pw.Container(width: 150, height: 1, color: PdfColors.black),
                    pw.Text(depositario,
                        style: pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.center),
                    pw.Text(cargoDepositario,
                        style: pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.center),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text("REVISÓ", style: pw.TextStyle(fontSize: 8)),
                    pw.SizedBox(height: 20),
                    pw.Container(width: 150, height: 1, color: PdfColors.black),
                    pw.Text(revisor,
                        style: pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.center),
                    pw.Text(cargoRevisor,
                        style: pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.center),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(4),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black),
              ),
              child: pw.Text(
                "El Depositario es el responsable del cuidado, uso adecuado de los bienes y de notificar al Departamento de Inventarios, de cualquier modificación que afecte al presente resguardo. Así como de notificar la pérdida, extravío, daño o menoscabo de los bienes enlistados, en observancia a los artículos 5 de la Ley de Responsabilidades Administrativas para el Estado de Veracruz de Ignacio de la Llave; 88, fracción II, 93 de la Ley de Adquisiciones, Arrendamientos, Administración y enajenación de bienes muebles del Estado de Veracruz de Ignacio de la Llave; y 31 del Reglamento Interior de la Dirección de administración del Órgano de Administración Judicial del Poder Judicial del Estado de Veracruz.",
                style: pw.TextStyle(fontSize: 6, color: PdfColors.black),
                textAlign: pw.TextAlign.justify,
              ),
            ),
          ],
        ));
  }

  pw.Widget _buildInfoHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      color: PdfColors.grey300,
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("Fecha: $fechaActual",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.Text("Adscripción: $texto5",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.Text("Dep./usuario: $texto1",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.Text("$texto6",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }

  pw.Widget _buildMainHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Image(
          pw.MemoryImage(logoBytes),
          width: 120,
          height: 60,
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              "PODER JUDICIAL DEL ESTADO DE VERACRUZ",
              style: headerTextStyle,
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              "RESGUARDO DE BIENES MUEBLES",
              style: headerTextStyle,
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              "ÓRGANO DE ADMINISTRACIÓN JUDICIAL",
              style: headerTextStyle,
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
        pw.SizedBox(width: 120, height: 60),
      ],
    );
  }

  pw.TableRow _buildTableHeaderRow() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey300,
      ),
      children: [
        pw.Text("ID", style: tableHeaderStyle, textAlign: pw.TextAlign.center),
        pw.Text("ID anterior",
            style: tableHeaderStyle, textAlign: pw.TextAlign.center),
        pw.Text("nombre",
            style: tableHeaderStyle, textAlign: pw.TextAlign.center),
        pw.Text("Marca",
            style: tableHeaderStyle, textAlign: pw.TextAlign.center),
        pw.Text("Modelo",
            style: tableHeaderStyle, textAlign: pw.TextAlign.center),
        pw.Text("Serie",
            style: tableHeaderStyle, textAlign: pw.TextAlign.center),
        pw.Text("Costo",
            style: tableHeaderStyle, textAlign: pw.TextAlign.center),
        pw.Text("Estado",
            style: tableHeaderStyle, textAlign: pw.TextAlign.center),
        pw.Text("Ubicación",
            style: tableHeaderStyle, textAlign: pw.TextAlign.center),
        pw.Text("Usuario",
            style: tableHeaderStyle, textAlign: pw.TextAlign.center),
      ],
    );
  }

  pw.Widget _buildProtectedTextCell(String? text, pw.TextStyle style) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Container(
        alignment: pw.Alignment.center,
        child: pw.Text(
          text ?? "Sin información",
          textAlign: pw.TextAlign.center,
          style: style,
          softWrap: true,
        ),
      ),
    );
  }

  // --- GENERACIÓN DE PÁGINAS CON MultiPage ---
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.letter.landscape.copyWith(
        marginLeft: 20,
        marginRight: 20,
        marginBottom: 30,
      ),
      header: (pw.Context context) {
        return pw.Column(
          children: [
            _buildMainHeader(),
            pw.SizedBox(height: 10),
            _buildInfoHeader(),
            pw.SizedBox(height: 2),
            // Encabezados de tabla (se repiten)
            pw.Table(
              border: const pw.TableBorder(),
              columnWidths: const {
                0: pw.FlexColumnWidth(1.5), // ID
                1: pw.FlexColumnWidth(1.5), // ID anterior
                2: pw.FlexColumnWidth(3), // DESCRIPCIÓN DEL BIEN
                3: pw.FlexColumnWidth(2), // MARCA
                4: pw.FlexColumnWidth(2), // MODELO
                5: pw.FlexColumnWidth(2), // SERIE
                6: pw.FlexColumnWidth(2), // COSTO INICIAL
                7: pw.FlexColumnWidth(2), // ESTADO FÍSICO
                8: pw.FlexColumnWidth(3), // UBIC.
                9: pw.FlexColumnWidth(3), // USUARIO
              },
              children: [
                _buildTableHeaderRow(),
              ],
            ),
          ],
        );
      },
      footer: (pw.Context context) {
        return _buildPageNumberFooter(context.pageNumber, context.pagesCount);
      },
      build: (pw.Context context) {
        // La lista de widgets para el contenido principal
        List<pw.Widget> widgets = [];

        // Tabla de bienes muebles (filas de datos)
        widgets.add(
          pw.Table(
            border: const pw.TableBorder(),
            columnWidths: const {
              0: pw.FlexColumnWidth(1.5),
              1: pw.FlexColumnWidth(1.5),
              2: pw.FlexColumnWidth(3),
              3: pw.FlexColumnWidth(2),
              4: pw.FlexColumnWidth(2),
              5: pw.FlexColumnWidth(2),
              6: pw.FlexColumnWidth(2),
              7: pw.FlexColumnWidth(2),
              8: pw.FlexColumnWidth(3),
              9: pw.FlexColumnWidth(3),
            },
            children: [
              // Filas de datos
              // ERROR 1 CORREGIDO: Usamos la lista NO NULA 'listaBienes'
              for (var bien in listaBienes)
                pw.TableRow(
                  verticalAlignment: pw.TableCellVerticalAlignment.middle,
                  children: [
                    // ID (Columna 0)
                    _buildProtectedTextCell(bien.inventario2025, cellTextStyle),
                    // ID Anterior (Columna 1)
                    _buildProtectedTextCell(bien.inventario, cellTextStyle),
                    // Nombre (Columna 2)
                    _buildProtectedTextCell(bien.nombre, cellTextStyle),
                    // Marca (Columna 3)
                    _buildProtectedTextCell(bien.marcacomercial, cellTextStyle),
                    // Modelo (Columna 4)
                    _buildProtectedTextCell(bien.modelo, cellTextStyle),
                    // Serie (Columna 5)
                    _buildProtectedTextCell(
                        bien.numeroseriedelbien, cellTextStyle),
                    // Costo (Columna 6) - No se aplica text break
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Text(
                          formatoMoneda.format(bien.importeinicialbien ?? 0.0),
                          textAlign: pw.TextAlign.center,
                          style: cellTextStyle),
                    ),
                    // Estado (Columna 7)
                    _buildProtectedTextCell(bien.estatusdelbien, cellTextStyle),
                    // Ubicación (Columna 8)
                    _buildProtectedTextCell(
                        bien.ubicacionfisica, cellTextStyle),
                    // Usuario (Columna 9)
                    _buildProtectedTextCell(bien.depositario, cellTextStyle),
                  ],
                ),
            ],
          ),
        );

        // Fila de totales (al final de los datos de la tabla)
        // ERROR 2 CORREGIDO: Usamos la lista NO NULA 'listaBienes'
        if (listaBienes.isNotEmpty) {
          widgets.add(pw.Table(
            border: const pw.TableBorder(),
            columnWidths: const {
              0: pw.FlexColumnWidth(1.5),
              1: pw.FlexColumnWidth(1.5),
              2: pw.FlexColumnWidth(3),
              3: pw.FlexColumnWidth(2),
              4: pw.FlexColumnWidth(2),
              5: pw.FlexColumnWidth(2),
              6: pw.FlexColumnWidth(2),
              7: pw.FlexColumnWidth(2),
              8: pw.FlexColumnWidth(3),
              9: pw.FlexColumnWidth(3),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey200,
                ),
                children: [
                  for (int i = 0; i < 4; i++) // 4 columnas vacías
                    pw.Container(child: pw.Text("")),
                  // Total depto: (Columna 5 - alineado a la derecha)
                  pw.Container(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text("Total: ", style: totalRowStyle),
                  ),
                  // $Costo (Columna 6 - alineado a la izquierda)
                  pw.Container(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(totalCostoFormateado, style: totalRowStyle),
                  ),
                  // Total bienes: (Columna 7 - alineado a la derecha)
                  pw.Container(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text("Total bienes: ", style: totalRowStyle),
                  ),
                  // Cantidad (Columna 8 - alineado a la izquierda)
                  pw.Container(
                    alignment: pw.Alignment.centerLeft,
                    // ERROR 3 CORREGIDO: Usamos la lista NO NULA 'listaBienes'
                    child:
                        pw.Text('${listaBienes.length}', style: totalRowStyle),
                  ),
                  for (int i = 0; i < 2; i++) // 2 columnas vacías
                    pw.Container(child: pw.Text("")),
                ],
              ),
            ],
          ));
        }

        // Sección de Firmas (siempre va al final del contenido)
        widgets.add(
          pw.Container(
            child: _buildSignatureSection(texto1, texto2, texto3, texto4),
          ),
        );

        return widgets; // Retorna la lista de widgets para MultiPage
      },
    ),
  );

  // Guardar y descargar el PDF
  final bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..target = 'webbrowser'
    ..download = 'BienesMuebles_${DateTime.now()}.pdf'
    ..click();
  html.Url.revokeObjectUrl(url);
}
