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
import 'package:intl/intl.dart'; // Para formatear la fecha

Future<void> libroinventarios(BuildContext context) async {
  // Primero preguntamos los filtros (igual que en Excel)
  String? filtroAnexo = 'TODOS';
  String? filtroNivel1 = 'TODOS';
  String? filtroClaseActivo = 'TODOS';
  String? filtroPrecio = 'TODOS';
  double umaValue = 113.14; // Valor actual de la UMA en MXN
  DateTime? fechaInicio;
  DateTime? fechaFin;
  bool incluirFechaAvaluo = false; // Nueva opción

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String localAnexo = filtroAnexo!;
      String localNivel1 = filtroNivel1!;
      String localClaseActivo = filtroClaseActivo!;
      String localFiltroPrecio = filtroPrecio!;
      double localUmaValue = umaValue;
      bool localIncluirFechaAvaluo = incluirFechaAvaluo;
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
                      onChanged: (val) => setState(() => localAnexo = val!),
                    ),
                  ),
                  Divider(),
                  Text('Filtro Unidad Presupuestal:'),
                  ...[
                    'TODOS',
                    'CONSEJO DE LA JUDICATURA',
                    'TRIBUNAL SUPERIOR DE JUSTICIA',
                    //'OTRO'
                  ].map(
                    (opcion) => RadioListTile<String>(
                      title: Text(opcion),
                      value: opcion,
                      groupValue: localNivel1,
                      onChanged: (val) => setState(() => localNivel1 = val!),
                    ),
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
                  Text('Filtro por Precio (en UMA):'),
                  ...['TODOS', 'MENOS A 20 UMAS', 'MAYOR A 20 UMAS'].map(
                    (opcion) => RadioListTile<String>(
                      title: Text(opcion),
                      value: opcion,
                      groupValue: localFiltroPrecio,
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
                  Text(
                      '20 UMAS = ${(localUmaValue * 20).toStringAsFixed(2)} MXN'),
                  Divider(),
                  // Nueva opción para incluir fecha de avalúo
                  CheckboxListTile(
                    title: Text('Incluir bienes con fecha de avalúo'),
                    subtitle: Text(
                        'Incluye TODOS los bienes que tienen fecha de avalúo\n(independientemente del rango de fechas seleccionado)'),
                    value: localIncluirFechaAvaluo,
                    onChanged: (bool? value) {
                      setState(() {
                        localIncluirFechaAvaluo = value ?? false;
                      });
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text(fechaInicio == null
                        ? 'Seleccionar Fecha Inicial'
                        : 'Desde: ${DateFormat('dd/MM/yyyy').format(fechaInicio!)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          fechaInicio = picked;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text(fechaFin == null
                        ? 'Seleccionar Fecha Final'
                        : 'Hasta: ${DateFormat('dd/MM/yyyy').format(fechaFin!)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          fechaFin = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text('CANCELAR'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop({
                  'anexo': localAnexo,
                  'nivel1': localNivel1,
                  'clase': localClaseActivo,
                  'filtroPrecio': localFiltroPrecio,
                  'umaValue': localUmaValue,
                  'fechaInicio': fechaInicio,
                  'fechaFin': fechaFin,
                  'incluirFechaAvaluo': localIncluirFechaAvaluo,
                }),
                child: Text('GENERAR PDF'),
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
  fechaInicio = result['fechaInicio'];
  fechaFin = result['fechaFin'];
  incluirFechaAvaluo = result['incluirFechaAvaluo'] ?? false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Expanded(child: Text('Procesando y generando PDF...')),
          ],
        ),
      );
    },
  );

  try {
    final firestore = FirebaseFirestore.instance;
    final List<DocumentSnapshot> todosLosDocs = [];
    final List<DocumentSnapshot> docsConFechaAvaluo = [];
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

    if (fechaInicio != null) {
      queryBase = queryBase.where('fechaadquisicion',
          isGreaterThanOrEqualTo: Timestamp.fromDate(fechaInicio!));
    }

    if (fechaFin != null) {
      queryBase = queryBase.where('fechaadquisicion',
          isLessThanOrEqualTo: Timestamp.fromDate(fechaFin!));
    }

    // Obtener documentos con fecha de adquisición
    while (true) {
      Query query = queryBase
          .orderBy('fechaadquisicion', descending: false)
          .orderBy('inventario2025', descending: false)
          .limit(500);

      if (ultimoDoc != null) query = query.startAfterDocument(ultimoDoc);

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) break;

      todosLosDocs.addAll(snapshot.docs);
      ultimoDoc = snapshot.docs.last;
      total += snapshot.docs.length;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '📄 Cargados $total registros con fecha de adquisición...')),
      );
      await Future.delayed(Duration(milliseconds: 300));
    }

    // Si está habilitada la opción, obtener TODOS los documentos con fecha de avalúo
    if (incluirFechaAvaluo) {
      Query queryAvaluo = firestore.collection('bienesmuebles');

      // Aplicar solo los filtros que NO sean de fecha
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
          queryAvaluo = queryAvaluo.where('anexo', isEqualTo: valorAnexo);
        }
      }

      if (filtroNivel1 != 'TODOS') {
        queryAvaluo =
            queryAvaluo.where('nivel1organizacion', isEqualTo: filtroNivel1);
      }

      if (filtroClaseActivo != 'TODOS') {
        queryAvaluo =
            queryAvaluo.where('clasedeactivo', isEqualTo: filtroClaseActivo);
      }

      // NO aplicar ningún filtro de fecha
      // Obtener TODOS los que tienen fecha de avalúo independientemente de la fecha

      // Obtener documentos con fecha de avalúo
      DocumentSnapshot? ultimoDocAvaluo;
      int totalAvaluo = 0;

      while (true) {
        Query query =
            queryAvaluo.orderBy('inventario2025', descending: false).limit(500);

        if (ultimoDocAvaluo != null)
          query = query.startAfterDocument(ultimoDocAvaluo);

        final snapshot = await query.get();
        if (snapshot.docs.isEmpty) break;

        // Filtrar solo los que tienen fecha de avalúo no vacía Y que NO tengan fecha de adquisición
        // (para evitar duplicados con la primera consulta)
        final docsConAvaluo = snapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final fechaAvaluo = data['fechaavaluo'];
          final fechaAdquisicion = data['fechaadquisicion'];

          // Solo incluir si tiene fecha de avalúo Y no tiene fecha de adquisición
          //return fechaAvaluo != null && fechaAdquisicion == null;
          return fechaAvaluo != null;
        }).toList();

        docsConFechaAvaluo.addAll(docsConAvaluo);
        ultimoDocAvaluo = snapshot.docs.last;
        totalAvaluo += docsConAvaluo.length;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '📄 Cargados $totalAvaluo registros con fecha de avalúo (TODOS, sin filtro de fecha)...')),
        );
        await Future.delayed(Duration(milliseconds: 300));
      }
    }

    // Combinar ambas listas
    final List<DocumentSnapshot> todosLosDocsCombinados = [
      ...todosLosDocs,
      ...docsConFechaAvaluo
    ];

    // Aplicar filtro de precio localmente
    final double limitePrecio = umaValue * 20;
    final List<DocumentSnapshot> docsFiltrados =
        todosLosDocsCombinados.where((doc) {
      if (filtroPrecio == 'TODOS') return true;

      final data = doc.data() as Map<String, dynamic>;
      double importe = (data['importeinicialbien'] as num?)?.toDouble() ?? 0.0;

      // Si no hay importe inicial, usar avalúo
      if (importe == 0.0) {
        importe = (data['avaluo'] as num?)?.toDouble() ?? 0.0;
      }

      if (filtroPrecio == 'MENOS A 20 UMAS') return importe < limitePrecio;
      if (filtroPrecio == 'MAYOR A 20 UMAS') return importe >= limitePrecio;

      return true;
    }).toList();

    if (docsFiltrados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '⚠️ No se encontraron registros con los filtros aplicados')),
      );
      Navigator.of(context).pop();
      return;
    }

    // Crear PDF
    final pdf = pw.Document();

    // Cargar logo
    final ByteData logoData =
        await rootBundle.load('assets/images/logopjev.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    // Estilos
    final headerStyle =
        pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final tableHeaderStyle =
        pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);
    final cellStyle = pw.TextStyle(fontSize: 7);
    final totalStyle =
        pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);

    // Formatear moneda
    final formatoMoneda =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);

    // Fecha para encabezado
    final fechaReporte =
        fechaFin != null ? DateFormat('dd/MM/yyyy').format(fechaFin!) : '';

    // Paginación para tabla - ajustado por las nuevas columnas
    const int filasPorPagina = 20;
    int paginas = (docsFiltrados.length / filasPorPagina).ceil();

    // Función para crear encabezado profesional con logo y textos
    pw.Widget buildHeader() {
      final fechaHoraElaboracion =
          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      final fechaCorte = fechaFin != null
          ? DateFormat('dd/MM/yyyy').format(fechaFin!)
          : DateFormat('dd/MM/yyyy').format(DateTime.now());

      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 50),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('PODER JUDICIAL DEL ESTADO DE VERACRUZ',
                  style: headerStyle),
              pw.Text('SUBDIRECCIÓN DE RECURSOS MATERIALES',
                  style: headerStyle),
              pw.Text('LIBRO DE INVENTARIOS', style: headerStyle),
              if (incluirFechaAvaluo)
                pw.Text('(Incluye TODOS los bienes con fecha de avalúo)',
                    style: pw.TextStyle(
                        fontSize: 8, fontStyle: pw.FontStyle.italic)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Fecha y hora de elaboración:',
                  style: pw.TextStyle(
                      fontSize: 8, fontWeight: pw.FontWeight.bold)),
              pw.Text(fechaHoraElaboracion, style: pw.TextStyle(fontSize: 8)),
              pw.SizedBox(height: 5),
              pw.Text('CORTE A:',
                  style: pw.TextStyle(
                      fontSize: 8, fontWeight: pw.FontWeight.bold)),
              pw.Text(fechaCorte, style: pw.TextStyle(fontSize: 8)),
            ],
          ),
        ],
      );
    }

    // Generar páginas PDF
    for (int pagina = 0; pagina < paginas; pagina++) {
      final desde = pagina * filasPorPagina;
      final hasta = ((pagina + 1) * filasPorPagina) > docsFiltrados.length
          ? docsFiltrados.length
          : (pagina + 1) * filasPorPagina;

      final subset = docsFiltrados.sublist(desde, hasta);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat
              .letter.landscape, // Formato horizontal para más columnas
          margin: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildHeader(),
                pw.SizedBox(height: 10),
                if (fechaReporte.isNotEmpty)
                  pw.Text('Reporte hasta: $fechaReporte',
                      style: pw.TextStyle(fontSize: 9)),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1.5), // ID-INVENTARIO
                    1: pw.FlexColumnWidth(4), // DESCRIPCIÓN
                    2: pw.FlexColumnWidth(1), // CANTIDAD
                    3: pw.FlexColumnWidth(2), // COSTO UNITARIO
                    4: pw.FlexColumnWidth(1.5), // UNIDAD DE MEDIDA
                    5: pw.FlexColumnWidth(2), // MONTO
                  },
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
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
                                child: pw.Text('COSTO UNITARIO',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('UNIDAD DE MEDIDA',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child:
                                    pw.Text('MONTO', style: tableHeaderStyle))),
                      ],
                    ),
                    ...subset.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final id = (data['inventario2025'] ?? '-----').toString();
                      final nombre = (data['nombre'] ?? '-----').toString();

                      // Verificar condiciones para usar avalúo
                      final fechaAdquisicion =
                          data['fechaadquisicion'] as Timestamp?;
                      bool usarAvaluo = false;

                      if (fechaAdquisicion == null) {
                        // Si fechaadquisicion es null o vacío, usar avalúo
                        usarAvaluo = true;
                      } else {
                        // Si fechaadquisicion es menor a 2020, usar avalúo
                        final fechaDateTime = fechaAdquisicion.toDate();
                        if (fechaDateTime.year < 2020) {
                          usarAvaluo = true;
                        }
                      }

                      double costoNum;
                      if (usarAvaluo) {
                        // Usar avalúo
                        costoNum = (data['avaluo'] as num?)?.toDouble() ?? 0.0;
                      } else {
                        // Usar importe inicial, si es cero usar avalúo como respaldo
                        costoNum =
                            (data['importeinicialbien'] as num?)?.toDouble() ??
                                0.0;
                        if (costoNum == 0.0) {
                          costoNum =
                              (data['avaluo'] as num?)?.toDouble() ?? 0.0;
                        }
                      }

                      // Nuevas columnas según especificaciones
                      final cantidad = '1'; // Siempre 1
                      final costoUnitario = formatoMoneda
                          .format(costoNum); // Mismo valor que precio
                      final unidadMedida = 'UNIDAD'; // Siempre "UNIDAD"
                      final monto = formatoMoneda
                          .format(costoNum); // El mismo valor (precio)

                      return pw.TableRow(
                        children: [
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
                                  child: pw.Text(costoUnitario,
                                      style: cellStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child:
                                      pw.Text(unidadMedida, style: cellStyle))),
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child: pw.Text(monto, style: cellStyle))),
                        ],
                      );
                    }),
                    // En última página agregar fila de totales
                    if (pagina == paginas - 1)
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child:
                                  pw.Text('', style: totalStyle)), // vacía ID
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
                                      style: totalStyle))), // Total cantidad
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Text('',
                                  style: totalStyle)), // vacía costo unitario
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Text('',
                                  style: totalStyle)), // vacía unidad medida
                          pw.Padding(
                              padding: pw.EdgeInsets.all(3),
                              child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                    '${formatoMoneda.format(docsFiltrados.fold<double>(0, (sum, doc) {
                                      final d =
                                          doc.data() as Map<String, dynamic>;

                                      // Aplicar la misma lógica para el total
                                      final fechaAdquisicion =
                                          d['fechaadquisicion'] as Timestamp?;
                                      bool usarAvaluo = false;

                                      if (fechaAdquisicion == null) {
                                        usarAvaluo = true;
                                      } else {
                                        final fechaDateTime =
                                            fechaAdquisicion.toDate();
                                        if (fechaDateTime.year < 2020) {
                                          usarAvaluo = true;
                                        }
                                      }

                                      double val;
                                      if (usarAvaluo) {
                                        val =
                                            (d['avaluo'] as num?)?.toDouble() ??
                                                0.0;
                                      } else {
                                        val = (d['importeinicialbien'] as num?)
                                                ?.toDouble() ??
                                            0.0;
                                        if (val == 0.0) {
                                          val = (d['avaluo'] as num?)
                                                  ?.toDouble() ??
                                              0.0;
                                        }
                                      }

                                      return sum + val;
                                    }))}',
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
    Navigator.of(context).pop(); // cerrar diálogo si hubo error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al generar PDF: $e')),
    );
  }
}
