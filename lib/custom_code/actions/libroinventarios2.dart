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

Future<void> libroinventarios2(BuildContext context) async {
  // Color verde personalizado definido
  final Color customGreen = Color(0xFF164b2d);

  // --- 1. CARGA DE UNIDADES PRESUPUESTALES DESDE FIRESTORE ---
  List<String> ubicacionnivel1 = ['TODOS'];
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('oficinasPJEV').get();

    final nombres = snapshot.docs
        .map((doc) => doc.get('nombre1') as String?)
        .where((n) => n != null && n.isNotEmpty && n.toUpperCase() != 'TODOS')
        .cast<String>()
        .toSet()
        .toList();

    nombres.sort();
    ubicacionnivel1.addAll(nombres);
  } catch (e) {
    print('Error al cargar la colección oficinasPJEV: $e');
  }
  // ----------------------------------------------------------

  String? filtroAnexo = 'TODOS';
  String? filtroNivel1 = 'TODOS';
  String? filtroClaseActivo = 'TODOS';
  String? filtroPrecio = 'TODOS';
  double umaValue = 113.14;
  bool excluirNoInventariables = true;

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String localAnexo = filtroAnexo!;
      String localNivel1 = filtroNivel1!;
      String localClaseActivo = filtroClaseActivo!;
      String localFiltroPrecio = filtroPrecio!;
      double localUmaValue = umaValue;
      bool localExcluirNoInventariables = excluirNoInventariables;
      List<String> clasesDeActivo = ['TODOS'];

      return StatefulBuilder(
        builder: (context, setState) {
          if (clasesDeActivo.length == 1) {
            FirebaseFirestore.instance
                .collection('depreciacion')
                .get()
                .then((snapshot) {
              final nombres = snapshot.docs
                  .map((doc) => doc.get('nombre') as String)
                  .toSet()
                  .toList();
              nombres.sort();
              setState(() {
                clasesDeActivo.addAll(nombres);
              });
            });
          }

          return AlertDialog(
            title: Text('Selecciona filtros para exportar'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Filtro Anexo:'),
                  ...[
                    'TODOS',
                    'Localizados',
                    'NO Localizados',
                    'Alta',
                    'Propuesta Baja'
                  ].map(
                    (opcion) => RadioListTile<String>(
                      title: Text(opcion),
                      value: opcion,
                      groupValue: localAnexo,
                      // CAMBIO: Color activo a customGreen
                      activeColor: customGreen,
                      onChanged: (val) => setState(() => localAnexo = val!),
                    ),
                  ),
                  Divider(),
                  Text('Filtro Unidad Presupuestal:'),
                  // NOTA: DropdownButton no tiene propiedad 'activeColor'
                  // El color de su indicador de selección depende del tema
                  DropdownButton<String>(
                    value: localNivel1,
                    isExpanded: true,
                    items: ubicacionnivel1.map((opcion) {
                      return DropdownMenuItem(
                        value: opcion,
                        child: Text(opcion),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => localNivel1 = val!);
                    },
                  ),
                  Divider(),
                  Text('Clase de Activo:'),
                  DropdownButton<String>(
                    value: localClaseActivo,
                    isExpanded: true,
                    items: clasesDeActivo.map((clase) {
                      return DropdownMenuItem(
                        value: clase,
                        child: Text(clase),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => localClaseActivo = val!);
                    },
                  ),
                  Divider(),
                  Text('Filtro por UMA:'),
                  ...['TODOS', 'MENORES A 20 UMAS', 'MAYOR O IGUAL A 20 UMAS']
                      .map(
                    (opcion) => RadioListTile<String>(
                      title: Text(opcion),
                      value: opcion,
                      groupValue: localFiltroPrecio,
                      // CAMBIO: Color activo a customGreen
                      activeColor: customGreen,
                      onChanged: (val) =>
                          setState(() => localFiltroPrecio = val!),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: localUmaValue.toStringAsFixed(2),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Valor de la UMA (MXN)',
                      hintText: 'Ej. 113.14',
                      suffixText: 'MXN',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      final newValue = double.tryParse(val);
                      if (newValue != null && newValue > 0) {
                        setState(() => localUmaValue = newValue);
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  CheckboxListTile(
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('Excluir NO inventariables'),
                    value: localExcluirNoInventariables,
                    // CAMBIO: Color activo a customGreen
                    activeColor: customGreen,
                    // CAMBIO: Color del check (usualmente blanco para contraste)
                    checkColor: Colors.white,
                    onChanged: (v) => setState(
                        () => localExcluirNoInventariables = v ?? true),
                  ),
                  SizedBox(height: 10),
                  Text(
                      '20 UMAS = ${(localUmaValue * 20).toStringAsFixed(2)} MXN'),
                  Text('Este filtro se aplicará al valor en libros del bien',
                      style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600])),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text('CANCELAR', style: TextStyle(color: customGreen)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop({
                  'anexo': localAnexo,
                  'nivel1': localNivel1,
                  'clase': localClaseActivo,
                  'filtroPrecio': localFiltroPrecio,
                  'umaValue': localUmaValue,
                  'excluirNoInventariables': localExcluirNoInventariables,
                }),
                style: ElevatedButton.styleFrom(backgroundColor: customGreen),
                child:
                    Text('GENERAR PDF', style: TextStyle(color: Colors.white)),
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
  umaValue = result['umaValue'] ?? 113.14;
  excluirNoInventariables = result['excluirNoInventariables'] ?? true;

  String progressMessage = 'Inicializando carga...';
  int currentCount = 0;

  late StateSetter setProgressState;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          setProgressState = setState;
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
                SizedBox(width: 20),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(progressMessage),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Bienes cargados: $currentCount',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          );
        },
      );
    },
  );

  try {
    final firestore = FirebaseFirestore.instance;
    final Set<String> idsUnicos = <String>{};
    final List<DocumentSnapshot> todosLosDocs = [];
    DocumentSnapshot? ultimoDoc;
    int total = 0;

    Query queryBase = firestore.collection('bienesmuebles');

    if (filtroAnexo != 'TODOS') {
      String valorAnexo = '';
      switch (filtroAnexo) {
        case 'Localizados':
          valorAnexo = 'ANEXO 1';
          break;
        case 'NO Localizados':
          valorAnexo = 'ANEXO 2';
          break;
        case 'Alta':
          valorAnexo = 'ANEXO 3';
          break;
        case 'Propuesta Baja':
          valorAnexo = 'ANEXO 4';
          break;
      }
      if (valorAnexo.isNotEmpty) {
        queryBase = queryBase.where('anexo', isEqualTo: valorAnexo);
      }
    }

    if (filtroNivel1 != 'TODOS') {
      queryBase =
          queryBase.where('nivel1organizacion', isEqualTo: filtroNivel1);
    }

    if (filtroClaseActivo != 'TODOS') {
      queryBase =
          queryBase.where('clasedeactivo', isEqualTo: filtroClaseActivo);
    }

    while (true) {
      Query query = queryBase
          .orderBy('fechaadquisicion', descending: false)
          .orderBy('inventario2025', descending: false)
          .limit(500);

      if (ultimoDoc != null) query = query.startAfterDocument(ultimoDoc);

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) break;

      for (var doc in snapshot.docs) {
        if (!idsUnicos.contains(doc.id)) {
          idsUnicos.add(doc.id);
          todosLosDocs.add(doc);
        }
      }

      ultimoDoc = snapshot.docs.last;
      total = todosLosDocs.length;

      progressMessage = 'Cargando registros...';
      currentCount = total;

      if (total > 0) {
        setProgressState(() {});
      }

      await Future.delayed(Duration(milliseconds: 100));
    }

    progressMessage = 'Aplicando filtros a $total registros...';
    currentCount = total;
    setProgressState(() {});

    double calcularValorEnLibros(Map<String, dynamic> data) {
      final cutoff = DateTime(2020, 1, 1);

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

      return valorEnLibros;
    }

    final double limiteUMA = umaValue * 20.0;
    int excluidosNoInventariables = 0;

    final List<DocumentSnapshot> docsFiltrados = todosLosDocs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      if (excluirNoInventariables) {
        final cotejo =
            (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
        if (cotejo == 'NO') {
          excluidosNoInventariables++;
          return false;
        }
      }

      final valorEnLibros = calcularValorEnLibros(data);

      if (filtroPrecio == 'TODOS') return true;
      if (filtroPrecio == 'MENORES A 20 UMAS') return valorEnLibros < limiteUMA;
      if (filtroPrecio == 'MAYOR O IGUAL A 20 UMAS')
        return valorEnLibros >= limiteUMA;

      return true;
    }).toList();

    // --- ORDENAMIENTO ---
    docsFiltrados.sort((a, b) {
      final dataA = a.data() as Map<String, dynamic>;
      final dataB = b.data() as Map<String, dynamic>;

      String getPartida(Map<String, dynamic> data) {
        final clase = (data['clasedeactivo'] ?? '').toString();
        final match = RegExp(r'^\d{3}').firstMatch(clase);
        return match != null ? match.group(0)! : '---';
      }

      final partidaA = getPartida(dataA);
      final partidaB = getPartida(dataB);

      final id = 'inventario2025';
      final idA = (dataA[id] ?? '-----').toString();
      final idB = (dataB[id] ?? '-----').toString();

      final partidaCompare = partidaA.compareTo(partidaB);
      if (partidaCompare != 0) {
        return partidaCompare;
      }

      return idA.compareTo(idB);
    });

    // ----------------------------------------------------
    // PREPARACIÓN DE DATOS PARA LA TABLA RESUMEN (TABLA 2)
    // ----------------------------------------------------
    final Map<String, int> conteoPorPartida = {};
    for (var doc in docsFiltrados) {
      final data = doc.data() as Map<String, dynamic>;
      final clase = (data['clasedeactivo'] ?? '').toString();
      final match = RegExp(r'^\d{3}').firstMatch(clase);
      final partida = match != null ? match.group(0)! : 'SIN PARTIDA';

      conteoPorPartida.update(partida, (value) => value + 1, ifAbsent: () => 1);
    }

    final listaConteo = conteoPorPartida.entries.toList();
    listaConteo.sort((a, b) => a.key.compareTo(b.key));

    final List<List<String>> summaryData =
        listaConteo.map((e) => [e.key, e.value.toString()]).toList();

    final int totalItems = docsFiltrados.length;
    summaryData.add(['TOTAL', totalItems.toString()]);

    // ----------------------------------------------------

    if (docsFiltrados.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '⚠️ No se encontraron registros con los filtros aplicados')),
      );
      return;
    }

    progressMessage = 'Generando documento PDF...';
    setProgressState(() {});

    final pdf = pw.Document();

    final ByteData logoData =
        await rootBundle.load('assets/images/logopjev.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    final headerStyle =
        pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final tableHeaderStyle =
        pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);
    final cellStyle = pw.TextStyle(fontSize: 7);
    final totalStyle =
        pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
    final pdfGreenColor = PdfColor.fromInt(customGreen.value);

    final formatoMoneda =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);

    pw.Widget buildHeader() {
      final fechaHoraElaboracion =
          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      List<pw.Widget> encabezadoTextos = [
        pw.Text('PODER JUDICIAL DEL ESTADO DE VERACRUZ', style: headerStyle),
        pw.Text('SUBDIRECCIÓN DE RECURSOS MATERIALES', style: headerStyle),
      ];

      if (filtroNivel1 != 'TODOS') {
        encabezadoTextos.add(
          pw.Text('UNIDAD PRESUPUESTAL: $filtroNivel1', style: headerStyle),
        );
      }

      encabezadoTextos.add(
        pw.Text('LIBRO DE INVENTARIOS', style: headerStyle),
      );

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

    // ----------------------------------------------------
    // GENERACIÓN DE PÁGINAS PARA TABLA 2 (RESUMEN)
    // ----------------------------------------------------
    const int filasResumenPorPagina = 30;

    int paginasResumen = (summaryData.length / filasResumenPorPagina).ceil();
    if (paginasResumen == 0) paginasResumen = 1;

    // Generar páginas de Tabla 2 (Resumen)
    for (int paginaResumen = 0;
        paginaResumen < paginasResumen;
        paginaResumen++) {
      final desdeResumen = paginaResumen * filasResumenPorPagina;
      final hastaResumen =
          ((paginaResumen + 1) * filasResumenPorPagina) > summaryData.length
              ? summaryData.length
              : (paginaResumen + 1) * filasResumenPorPagina;

      final subsetResumen = summaryData.sublist(desdeResumen, hastaResumen);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.letter.landscape,
          margin: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildHeader(),
                pw.SizedBox(height: 10),
                if (paginaResumen == 0)
                  pw.Text('Resumen de Conteo por Partida:', style: totalStyle),
                if (paginaResumen == 0) pw.SizedBox(height: 5),
                pw.Table.fromTextArray(
                  headers: paginaResumen == 0 ? ['PARTIDA', 'CONTEO'] : null,
                  data: subsetResumen,
                  border: pw.TableBorder.all(width: 0.5),
                  headerStyle:
                      tableHeaderStyle.copyWith(color: PdfColors.black),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                  cellStyle: cellStyle,
                  cellAlignments: {
                    0: pw.Alignment.center,
                    1: pw.Alignment.center,
                  },
                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(1),
                  },
                ),
                pw.Spacer(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Página ${context.pageNumber} de ${context.pagesCount}',
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    // ----------------------------------------------------
    // GENERACIÓN DE PÁGINAS PARA TABLA 1 (BIENES)
    // ----------------------------------------------------
    const int filasPorPagina = 20;
    int paginasBienes = (docsFiltrados.length / filasPorPagina).ceil();
    if (paginasBienes == 0) paginasBienes = 1;

    // Generar páginas de Tabla 1 (Bienes)
    for (int paginaBien = 0; paginaBien < paginasBienes; paginaBien++) {
      final desdeBien = paginaBien * filasPorPagina;
      final hastaBien =
          ((paginaBien + 1) * filasPorPagina) > docsFiltrados.length
              ? docsFiltrados.length
              : (paginaBien + 1) * filasPorPagina;

      final subsetBienes = docsFiltrados.sublist(desdeBien, hastaBien);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.letter.landscape,
          margin: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildHeader(),
                pw.SizedBox(height: 10),
                // Tabla principal de datos
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1.5),
                    1: pw.FlexColumnWidth(1.5),
                    2: pw.FlexColumnWidth(4),
                    3: pw.FlexColumnWidth(1),
                    4: pw.FlexColumnWidth(1.5),
                    5: pw.FlexColumnWidth(2),
                  },
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('PARTIDA',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('ID-INVENTARIO',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('DESCRIPCIÓN',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('CANTIDAD',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('UNIDAD DE MEDIDA',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('VALOR EN LIBROS',
                                    style: tableHeaderStyle))),
                      ],
                    ),
                    ...subsetBienes.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final id = (data['inventario2025'] ?? '-----').toString();
                      final nombre = (data['nombre'] ?? '-----').toString();
                      final claseDeActivo =
                          (data['clasedeactivo'] ?? '-----').toString();

                      String partida = '---';
                      if (claseDeActivo.length >= 3) {
                        final match =
                            RegExp(r'^\d{3}').firstMatch(claseDeActivo);
                        if (match != null) {
                          partida = match.group(0)!;
                        }
                      }

                      final valorEnLibros = calcularValorEnLibros(data);
                      final cantidad = '1';
                      final unidadMedida = 'UNIDAD';
                      final valorEnLibrosFormato =
                          formatoMoneda.format(valorEnLibros);

                      return pw.TableRow(
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child: pw.Text(partida, style: cellStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child: pw.Text(id, style: cellStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Text(nombre, style: cellStyle)),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child: pw.Text(cantidad, style: cellStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child:
                                      pw.Text(unidadMedida, style: cellStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(valorEnLibrosFormato,
                                      style: cellStyle))),
                        ],
                      );
                    }),
                    // Fila de totales (solo en la última página de bienes)
                    if (paginaBien == paginasBienes - 1)
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Text('', style: totalStyle)),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Text('', style: totalStyle)),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                    'Total bienes: ${docsFiltrados.length}',
                                    style: totalStyle),
                              )),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child: pw.Text(
                                      docsFiltrados.length.toString(),
                                      style: totalStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Text('', style: totalStyle)),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                    '${formatoMoneda.format(docsFiltrados.fold<double>(0, (sum, doc) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;
                                      final valorEnLibros =
                                          calcularValorEnLibros(data);
                                      return sum + valorEnLibros;
                                    }))}',
                                    style: totalStyle.copyWith(
                                        color: pdfGreenColor)),
                              )),
                        ],
                      ),
                  ],
                ),

                pw.Spacer(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Página ${context.pageNumber} de ${context.pagesCount}',
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
    Navigator.of(context).pop();

    final totalBienes = docsFiltrados.length;
    final totalValor = docsFiltrados.fold<double>(0, (sum, doc) {
      final data = doc.data() as Map<String, dynamic>;
      final valorEnLibros = calcularValorEnLibros(data);
      return sum + valorEnLibros;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ PDF generado exitosamente\n'
            'Total de bienes: $totalBienes\n'
            'Valor total en libros: ${formatoMoneda.format(totalValor)}\n'
            '${excluirNoInventariables ? 'Excluidos (NO inventariables): $excluidosNoInventariables' : 'Incluye todos los bienes'}'),
        duration: Duration(seconds: 6),
      ),
    );

    // Descargar PDF
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download =
          'LibroInventarios_${DateTime.now().millisecondsSinceEpoch}.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    // Asegúrate de cerrar el diálogo de progreso si hay un error
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Error al generar PDF: $e'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
    print('Error detallado al generar PDF: $e');
  }
}
