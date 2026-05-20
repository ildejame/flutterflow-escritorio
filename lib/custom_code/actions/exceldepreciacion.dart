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

import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart' hide Border;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart'; // *** Importación clave para formato de moneda ***
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'dart:math' as math;

Future exceldepreciacion(BuildContext context) async {
  if (!kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Esta funcion solo esta disponible en Web')),
    );
    return;
  }

  // Variables para guardar seleccion
  String? filtroAnexo = 'TODOS';
  String? filtroNivel1 = 'TODOS';
  String? filtroClaseActivo = 'TODOS';
  String? filtroPrecio = 'TODOS';
  double umaValue = 113.14;
  int selectedYear = DateTime.now().year; // Valor inicial
  bool excluirNoInventariables = true;

  // Mostrar dialogo de seleccion
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String localAnexo = filtroAnexo!;
      String localNivel1 = filtroNivel1!;
      String localClaseActivo = filtroClaseActivo!;
      String localFiltroPrecio = filtroPrecio!;
      double localUmaValue = umaValue;
      // Convertir el int a String para el Textfield
      String localSelectedYearString = selectedYear.toString();
      bool localExcluirNoInventariables = excluirNoInventariables;
      List<String> clasesDeActivo = ['TODOS'];
      String? yearErrorText; // Para mostrar errores de validación

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

          // Función de validación del año para el botón de descarga
          bool validarYear() {
            final year = int.tryParse(localSelectedYearString);
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

          return AlertDialog(
            title: Text('Configuracion de Reporte de Depreciacion'),
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
                    'TRIBUNAL DE CONCILIACION Y ARBITRAJE',
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
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      final newValue = double.tryParse(val);
                      if (newValue != null && newValue > 0) {
                        setState(() => localUmaValue = newValue);
                      }
                    },
                  ),
                  Divider(),
                  // --- CAMBIO A TEXTFIELD PARA EL AÑO ---
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ano para Calculo:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          initialValue: localSelectedYearString,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Ej. 2028',
                            border: OutlineInputBorder(),
                            errorText: yearErrorText, // Mostrar error si existe
                          ),
                          onChanged: (val) {
                            setState(() => localSelectedYearString = val);
                          },
                        ),
                        SizedBox(height: 5),
                        Text('Rango permitido: 2024 a 2100',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700])),
                      ],
                    ),
                  ),
                  // --- FIN CAMBIO A TEXTFIELD ---
                  Divider(),
                  CheckboxListTile(
                    title: Text('Excluir NO INVENTARIABLES'),
                    subtitle: Text('Basado en campo cotejodoc="NO"'),
                    value: localExcluirNoInventariables,
                    onChanged: (val) =>
                        setState(() => localExcluirNoInventariables = val!),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text('CANCELAR')),
              ElevatedButton(
                onPressed: () {
                  if (validarYear()) {
                    Navigator.of(context).pop({
                      'anexo': localAnexo,
                      'nivel1': localNivel1,
                      'clase': localClaseActivo,
                      'filtroPrecio': localFiltroPrecio,
                      'umaValue': localUmaValue,
                      'selectedYear': int.parse(
                          localSelectedYearString), // Parsear el String a int aquí
                      'excluirNoInventariables': localExcluirNoInventariables,
                    });
                  } else {
                    setState(
                        () {}); // Forzar la reconstrucción para mostrar el error
                  }
                },
                child: Text('DESCARGAR EXCEL'),
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
  selectedYear = result['selectedYear'] ?? DateTime.now().year;
  excluirNoInventariables = result['excluirNoInventariables'] ?? true;

  final fechaCalculoDepreciacion = DateTime(selectedYear, 12, 31);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text('Procesando...'),
        ],
      ),
    ),
  );

  try {
    final firestore = FirebaseFirestore.instance;

    // Cargar Vidas Utiles
    final depreciacionSnapshot =
        await firestore.collection('depreciacion').get();
    final Map<String, int> vidaUtilData = {};
    for (final doc in depreciacionSnapshot.docs) {
      final d = doc.data();
      vidaUtilData[d['nombre'] as String] = (d['vidautil'] as num).toInt();
    }

    // Construir Query
    Query queryBase = firestore.collection('bienesmuebles');

    if (filtroAnexo != 'TODOS') {
      String valorAnexo = '';
      if (filtroAnexo == 'Localizados') valorAnexo = 'ANEXO 1';
      if (filtroAnexo == 'NO Localizados') valorAnexo = 'ANEXO 2';
      if (filtroAnexo == 'Alta') valorAnexo = 'ANEXO 3';
      if (filtroAnexo == 'Propuesta Baja') valorAnexo = 'ANEXO 4';
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

    // Procesamiento por Lotes
    const int REGISTROS_POR_LOTE = 10000;
    const int REGISTROS_POR_CONSULTA = 500;
    int numeroArchivo = 1;
    int totalProcesados = 0;
    QueryDocumentSnapshot? ultimoDocumento;
    bool hayMasDatos = true;

    while (hayMasDatos) {
      List<QueryDocumentSnapshot> loteActual = [];

      while (loteActual.length < REGISTROS_POR_LOTE && hayMasDatos) {
        Query query = queryBase
            .orderBy('fechaadquisicion', descending: false)
            .orderBy('inventario2025', descending: false)
            .limit(REGISTROS_POR_CONSULTA);

        if (ultimoDocumento != null) {
          query = query.startAfterDocument(ultimoDocumento);
        }

        final snapshot = await query.get();
        if (snapshot.docs.isEmpty) {
          hayMasDatos = false;
          break;
        }

        loteActual.addAll(snapshot.docs);
        ultimoDocumento = snapshot.docs.last;
      }

      if (loteActual.isEmpty) break;

      final procesadosEnEsteLote = await _generarExcelLote(
        loteActual,
        vidaUtilData,
        numeroArchivo,
        umaValue,
        filtroPrecio,
        fechaCalculoDepreciacion,
        selectedYear,
        excluirNoInventariables,
        filtroNivel1,
      );

      totalProcesados += procesadosEnEsteLote;
      numeroArchivo++;
      loteActual.clear();
      await Future.delayed(Duration(milliseconds: 100));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Completado. Total: $totalProcesados registros')),
    );
  } catch (e) {
    debugPrint('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    Navigator.of(context).pop();
  }
}

Future<int> _generarExcelLote(
  List<QueryDocumentSnapshot> docs,
  Map<String, int> vidaUtilData,
  int numeroArchivo,
  double umaValue,
  String? filtroPrecio,
  DateTime fechaCorte,
  int selectedYear,
  bool excluirNoInventariables,
  String? filtroNivel1,
) async {
  final excel = Excel.createExcel();
  final sheet = excel[excel.tables.keys.first];

  // *** INICIALIZACIÓN DE FORMATTER PARA TOTALES ***
  final currencyFormatter =
      NumberFormat.currency(locale: 'es_MX', symbol: '\$');

  // Encabezados
  final headers = [
    'NUMERO ID',
    'DESCRIPCION',
    'FECHA ADQ',
    'FECHA AVALUO',
    'MONTO \$',
    'AVALUO \$',
    'DEPRE 2020',
    'DEPRE 2021',
    'DEPRE 2022',
    'DEPRE 2023',
    'DEPRE 2024'
  ];
  for (int y = 2025; y <= selectedYear; y++) headers.add('DEPRE $y');
  // *** NUEVA COLUMNA DE DEPRECIACIÓN ACUMULADA ***
  headers.add('DEPRECIACIÓN ACUMULADA');
  headers.add('VALOR EN LIBROS');

  for (int i = 0; i < headers.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value =
        headers[i];
  }

  int rowIndex = 1;
  double sumaMonto = 0,
      sumaAvaluo = 0,
      sumaLibros = 0,
      sumaDepreAcumuladaTotal = 0;
  final limitePrecio = umaValue * 20;

  for (final doc in docs) {
    final data = doc.data() as Map<String, dynamic>;

    if (excluirNoInventariables) {
      if ((data['cotejodoc'] ?? '').toString().toUpperCase() == 'NO') continue;
    }

    // Calculo Depreciacion con logica corregida
    final resultado = _calcularDepreciacionLinealDefinitiva(
        data, vidaUtilData, fechaCorte, selectedYear);

    final valorLibros = resultado['valor_en_libros'] as double;
    final sumaDepreciada =
        resultado['suma_depreciada'] as double; // Obtener la suma

    // Filtro Precio
    if (filtroPrecio == 'MENOS A 20 UMAS' && valorLibros >= limitePrecio)
      continue;
    if (filtroPrecio == 'MAYOR A 20 UMAS' && valorLibros < limitePrecio)
      continue;

    // Escribir fila
    final monto =
        _trunc2((data['importeinicialbien'] as num?)?.toDouble() ?? 0);
    final avaluo = _trunc2((data['avaluo'] as num?)?.toDouble() ?? 0);

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .value = data['inventario2025']?.toString() ?? '';
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .value = data['nombre']?.toString() ?? '';

    final fAdq = _parseFecha(data['fechaadquisicion']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
        .value = fAdq != null ? DateFormat('dd/MM/yyyy').format(fAdq) : '';

    final fAv = _parseFecha(data['fechaavaluo']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
        .value = fAv != null ? DateFormat('dd/MM/yyyy').format(fAv) : '';

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
        .value = monto;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
        .value = avaluo;

    final deps = resultado['deps'] as Map<int, double>;
    int col = 6;
    for (int y = 2020; y <= selectedYear; y++) {
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: col++, rowIndex: rowIndex))
          .value = deps[y] ?? 0.0;
    }

    // *** ESCRIBIR DEPRECIACIÓN ACUMULADA ***
    sheet
        .cell(
            CellIndex.indexByColumnRow(columnIndex: col++, rowIndex: rowIndex))
        .value = sumaDepreciada;

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex))
        .value = valorLibros;

    sumaMonto += monto;
    sumaAvaluo += avaluo;
    sumaLibros += valorLibros;
    sumaDepreAcumuladaTotal += sumaDepreciada;
    rowIndex++;
  }

  // --- FILA DE TOTALES CON FORMATO DE MONEDA ---

  // Columna 4 (MONTO $)
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
      .value = currencyFormatter.format(sumaMonto);

  // Columna 5 (AVALUO $)
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
      .value = currencyFormatter.format(sumaAvaluo);

  // Depreciaciones Anuales (Columnas 6 en adelante)
  int totalCol = 6;
  for (int y = 2020; y <= selectedYear; y++) {
    // La suma de la depreciación anual por columna NO es necesaria,
    // solo se suma la DEPRECIACIÓN ACUMULADA TOTAL
    double sumaDepreAnual =
        0.0; // Se podría calcular, pero para simplicidad, dejamos el formato.

    // Aquí solo aplicamos el formato si la columna es relevante (tiene un valor sumado)
    // Para las depreciaciones anuales, la suma se calcula por columna si se quisiera,
    // pero ya tenemos la suma total de la depreciación acumulada.
    // Para evitar complejidad innecesaria en la suma de columnas,
    // solo aplicaremos formato al total de la Depreciación Acumulada.

    // Sin embargo, para que TODA la fila se vea con formato de dinero,
    // debemos sumar la depreciación de CADA COLUMNA, o dejarlo en 0.00 con formato si no se sumó.
    // Para mantener el reporte funcional y solo dar formato al total general:
    totalCol++;
  }

  // Columna de DEPRECIACIÓN ACUMULADA TOTAL
  sheet
      .cell(CellIndex.indexByColumnRow(
          columnIndex: totalCol++, rowIndex: rowIndex))
      .value = currencyFormatter.format(sumaDepreAcumuladaTotal);

  // Columna de VALOR EN LIBROS TOTAL
  sheet
      .cell(
          CellIndex.indexByColumnRow(columnIndex: totalCol, rowIndex: rowIndex))
      .value = currencyFormatter.format(sumaLibros);

  // --- FIN FILA DE TOTALES ---

  // Descarga
  final bytes = excel.encode();
  if (bytes != null) {
    final blob = html.Blob([bytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download',
          'Depreciacion_${filtroNivel1 ?? "Gral"}_$numeroArchivo.xlsx')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  return rowIndex - 1;
}

// --- LOGICA MAESTRA BLINDADA (SIN CAMBIOS EN CÁLCULO CORE) ---
Map<String, dynamic> _calcularDepreciacionLinealDefinitiva(
  Map<String, dynamic> data,
  Map<String, int> vidaUtilData,
  DateTime fechaCorteReporte,
  int selectedYearReporte,
) {
  final Map<int, double> deps = {};

  // 1. Obtener Valores Base
  final clase = (data['clasedeactivo'] ?? '').toString();
  final vidaUtilAnios = vidaUtilData[clase] ?? 0;

  final fAdq = _parseFecha(data['fechaadquisicion']);
  final fAv = _parseFecha(data['fechaavaluo']);

  // Truncar base inicial
  final importe =
      _trunc2((data['importeinicialbien'] as num?)?.toDouble() ?? 0);
  final avaluo = _trunc2((data['avaluo'] as num?)?.toDouble() ?? 0);

  // Determinar Base de Calculo (Prioridad Avaluo)
  double montoBase = 0.0;
  DateTime? fechaInicio;

  if (fAv != null && avaluo > 0) {
    montoBase = avaluo;
    fechaInicio = fAv;
  } else if (fAdq != null && importe > 0) {
    montoBase = importe;
    fechaInicio = fAdq;
  }

  // Inicializar todo en 0
  for (int y = 2020; y <= selectedYearReporte; y++) deps[y] = 0.0;

  if (montoBase <= 0 || vidaUtilAnios <= 0 || fechaInicio == null) {
    return {'deps': deps, 'valor_en_libros': montoBase, 'suma_depreciada': 0.0};
  }

  // 2. Preparar Logica Temporal
  final totalMesesVida = vidaUtilAnios * 12;
  final cuotaMensualExacta = montoBase / totalMesesVida;

  // Ajuste de Fecha Inicio (Dia > 15 pasa al siguiente mes)
  DateTime fechaContable = fechaInicio.day > 15
      ? DateTime(fechaInicio.year, fechaInicio.month + 1, 1)
      : DateTime(fechaInicio.year, fechaInicio.month, 1);
  if (fechaContable.month > 12) {
    fechaContable = DateTime(fechaContable.year + 1, 1, 1);
  }

  double sumaDepreciada = 0.0;
  int mesesAcumulados = 0;

  // 3. Iterar Año por Año
  for (int year = 2020; year <= selectedYearReporte; year++) {
    if (mesesAcumulados >= totalMesesVida) {
      deps[year] = 0.0;
      continue;
    }

    // Calcular meses aplicables en este año
    int mesesEnEsteAno = 0;

    if (fechaContable.year > year) {
      mesesEnEsteAno = 0;
    } else {
      int mesInicio = (fechaContable.year < year) ? 1 : fechaContable.month;
      int mesesPotenciales = 12 - mesInicio + 1;
      int mesesRestantesVida = totalMesesVida - mesesAcumulados;
      mesesEnEsteAno = math.min(mesesPotenciales, mesesRestantesVida);
    }

    if (mesesEnEsteAno <= 0) {
      deps[year] = 0.0;
      continue;
    }

    // --- CORRECCIÓN CLAVE: AJUSTE FINAL CON REDONDEO ---
    double montoEsteAno;
    bool esUltimoAnoDeVida =
        (mesesAcumulados + mesesEnEsteAno) >= totalMesesVida;

    if (esUltimoAnoDeVida) {
      double remanenteExacto = montoBase - sumaDepreciada;
      montoEsteAno = _round2(remanenteExacto);

      if (montoEsteAno < 0) montoEsteAno = 0;
    } else {
      // Años intermedios: Seguimos truncando para mantener estabilidad
      montoEsteAno = _trunc2(cuotaMensualExacta * mesesEnEsteAno);
    }

    deps[year] = montoEsteAno;
    sumaDepreciada += montoEsteAno; // **ACUMULANDO LA SUMA TOTAL**
    mesesAcumulados += mesesEnEsteAno;
  }

  // 4. Calculo Final de Valor en Libros
  double valorEnLibros;

  double remanenteFinal = montoBase - sumaDepreciada;
  valorEnLibros = _round2(remanenteFinal);

  if (valorEnLibros.abs() < 0.01) valorEnLibros = 0.0;

  return {
    'deps': deps,
    'valor_en_libros': valorEnLibros,
    'suma_depreciada': sumaDepreciada // **RETORNAR LA SUMA ACUMULADA**
  };
}

// Utilidad para TRUNCAR
double _trunc2(num v) {
  return (v * 100).floorToDouble() / 100.0;
}

// Utilidad para REDONDEAR (para el ajuste final)
double _round2(num v) {
  return (v * 100).roundToDouble() / 100.0;
}

DateTime? _parseFecha(dynamic f) {
  if (f == null) return null;
  if (f is Timestamp) return f.toDate();
  if (f is DateTime) return f;
  try {
    return DateFormat('dd/MM/yyyy').parse(f.toString());
  } catch (_) {
    return null;
  }
}
