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
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'dart:math' as math;

// ============================================================================
// FUNCIÓN PRINCIPAL
// ============================================================================

Future exceldepreciacion3(BuildContext context) async {
  // Color personalizado (tomado de "ejemplo")
  const Color customGreen = Color(0xFF164b2d);

  // 1. Verificación Web
  if (!kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Esta función solo está disponible en Web')),
    );
    return;
  }

  // Nuevo: Mostrar diálogo de carga mientras se obtienen las unidades (tomado de "ejemplo")
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customGreen),
          ),
          const SizedBox(width: 20),
          const Expanded(child: Text('Cargando opciones...')),
        ],
      ),
    ),
  );

  // Nuevo: Obtener unidades desde Firebase (tomado de "ejemplo")
  final firestore = FirebaseFirestore.instance;
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

  // Cerrar diálogo de carga
  Navigator.of(context).pop();

  // 2. Diálogo de Configuración (MODIFICADO con estilo y filtro de Firebase)
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String unidad = 'TODOS';
      bool excluirNoInventariables = true;
      final TextEditingController umaController =
          TextEditingController(text: '113.14');
      final TextEditingController yearController =
          TextEditingController(text: DateTime.now().year.toString());

      String? yearErrorText;

      bool validarYear() {
        final year = int.tryParse(yearController.text);
        if (year == null || year < 2024 || year > 2100) {
          yearErrorText = (year == null)
              ? 'Debe ser un número válido.'
              : 'Rango permitido: 2024 a 2100.';
          return false;
        }
        yearErrorText = null;
        return true;
      }

      return StatefulBuilder(
        builder: (ctx, setState) {
          return Theme(
            // Aplicación del tema verde (como en "ejemplo")
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
              title: const Text('Configuración Depreciación (Estricta)'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Filtro Unidad Presupuestal (MODIFICADO para usar Firebase)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Filtro Unidad Presupuestal:'),
                    ),
                    const SizedBox(height: 8),
                    // Generación dinámica de RadioListTiles (tomado de "ejemplo")
                    ...unidadesDisponibles.map((unidadNombre) {
                      return RadioListTile<String>(
                        dense: true,
                        title: Text(unidadNombre),
                        value: unidadNombre,
                        groupValue: unidad,
                        onChanged: (v) => setState(() => unidad = v!),
                      );
                    }),
                    const Divider(height: 16),
                    // Valor UMA
                    TextField(
                      controller: umaController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      decoration: InputDecoration(
                        // MODIFICADO: Estilo verde
                        labelText: 'Valor UMA (MXN)',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customGreen, width: 2),
                        ),
                        labelStyle: TextStyle(
                          color: umaController.text.isNotEmpty
                              ? customGreen
                              : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Año Base (Añadiendo borde verde en focus para consistencia)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Año Base para Cálculo:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: yearController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Ej. 2025',
                              border: const OutlineInputBorder(),
                              errorText: yearErrorText,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: customGreen, width: 2),
                              ),
                            ),
                            onChanged: (val) {
                              setState(() => validarYear());
                            },
                          ),
                          const SizedBox(height: 5),
                          Text('Rango permitido: 2024 a 2100',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700])),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Excluir No Inventariables
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
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  style: TextButton.styleFrom(
                    // MODIFICADO: Estilo verde
                    foregroundColor: customGreen,
                  ),
                  child: const Text('CANCELAR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (validarYear()) {
                      final double umaVal = double.tryParse(
                              umaController.text.replaceAll(',', '.')) ??
                          113.14;
                      final int selectedYear =
                          int.tryParse(yearController.text) ??
                              DateTime.now().year;

                      Navigator.of(context).pop(<String, dynamic>{
                        'unidad': unidad,
                        'umaValue': umaVal,
                        'selectedYear': selectedYear,
                        'excluirNoInventariables': excluirNoInventariables,
                      });
                    } else {
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // MODIFICADO: Estilo verde
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('GENERAR EXCEL'),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (result == null) return;
  // 3. Obtener parámetros seleccionados
  final String filtroNivel1 = (result['unidad'] as String?) ?? 'TODOS';
  final double umaValue = (result['umaValue'] as double?) ?? 113.14;
  final int selectedYear =
      (result['selectedYear'] as int?) ?? DateTime.now().year;
  final bool excluirNoInventariables =
      (result['excluirNoInventariables'] as bool?) ?? true;
  final DateTime fechaCalculoDepreciacion = DateTime(selectedYear, 12, 31);
  final double limiteUMA = umaValue * 20.0;
  // FIX: Crear formatter para la fila de totales (como en exceldepreciacion2)
  final currencyFormatter =
      NumberFormat.currency(locale: 'es_MX', symbol: '\$');
  // 4. Mostrar indicador de progreso
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Expanded(child: Text('Procesando Excel (Filtros Estrictos)...')),
        ],
      ),
    ),
  );
  try {
    final firestore = FirebaseFirestore.instance;

    // A. Cargar Vidas Útiles (Omitido por brevedad, se mantiene su lógica)
    final depreciacionSnapshot =
        await firestore.collection('depreciacion').get();
    final Map<String, int> vidaUtilData = {};
    for (final doc in depreciacionSnapshot.docs) {
      final d = doc.data();
      vidaUtilData[d['nombre'] as String] = (d['vidautil'] as num).toInt();
    }

    // B. Configurar Query Principal (Omitido por brevedad, se mantiene su lógica)
    Query<Map<String, dynamic>> query = firestore
        .collection('bienesmuebles')
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) => snap.data() ?? {},
          toFirestore: (data, _) => data,
        );
    if (filtroNivel1 != 'TODOS') {
      query = query.where('nivel1organizacion', isEqualTo: filtroNivel1);
    }
    query = query
        .orderBy('fechaadquisicion', descending: false)
        .orderBy('inventario2025', descending: false);
    // C. Variables de Control de Paginación y Excel
    DocumentSnapshot<Map<String, dynamic>>? ultimoDoc;
    bool hayMasDatos = true;
    const int TAMANO_LOTE_LECTURA = 1000;
    const int LIMITE_FILAS_ARCHIVO = 15000;
    // --- ESTILOS DE EXCEL (Alineación Centrada y Negritas para Header/Total) ---
    // Estilo para Encabezado (Negritas, Centrado)
    final headerStyle = CellStyle(
        fontFamily: getFontFamily(FontFamily.Arial),
        bold: true,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center);
    // Estilo para Celdas de Datos Monetarias/Numéricas (Centrado, sin formato de número explícito)
    final dataNumberStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center);
    // Estilo para Texto/Fecha (Centrado)
    final centerStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center);
    // Estilo para la fila de totales (Negritas, Centrado)
    final totalStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        fontFamily: getFontFamily(FontFamily.Arial),
        bold: true);
    // Variables de Totales y Archivo
    Map<String, double> subtotales = {
      'monto': 0.0,
      'depre_acumulada': 0.0,
      'valor_libros': 0.0
    };
    // Inicializamos el primer archivo Excel
    var excel = Excel.createExcel();
    _agregarEncabezados(excel, selectedYear, headerStyle);
    int filasEnArchivoActual = 0;
    int numeroArchivo = 1;
    int totalRegistrosProcesados = 0;

    // D. Bucle Principal de Lectura y Procesamiento
    while (hayMasDatos) {
      Query<Map<String, dynamic>> q = query.limit(TAMANO_LOTE_LECTURA);
      if (ultimoDoc != null) {
        q = q.startAfterDocument(ultimoDoc);
      }

      final snapshot = await q.get();
      if (snapshot.docs.isEmpty) {
        hayMasDatos = false;
        break;
      }

      ultimoDoc = snapshot.docs.last;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final cotejo =
            (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
        // --- FILTROS ESTRICTOS (Omitido por brevedad, se mantiene su lógica) ---
        if (excluirNoInventariables && cotejo == 'NO') continue;
        final double costo =
            _trunc2((data['importeinicialbien'] as num?)?.toDouble() ?? 0.0);
        final double avaluo =
            _trunc2((data['avaluo'] as num?)?.toDouble() ?? 0.0);
        final fechaAdq = _parseFecha(data['fechaadquisicion']);
        if (avaluo != 0.0) continue;
        if (costo < limiteUMA) continue;
        if (costo <= 0.0) continue;
        if (fechaAdq == null) continue;

        // --- CÁLCULO DEPRECIACIÓN (Omitido por brevedad, se mantiene su lógica) ---
        final resultadoDepre = _calcularDepreciacionLinealDefinitiva(
            data, vidaUtilData, fechaCalculoDepreciacion, selectedYear);
        final sumaDepreciada = resultadoDepre['suma_depreciada'] as double;
        final valorLibros = resultadoDepre['valor_en_libros'] as double;
        // Acumular subtotales
        subtotales['monto'] = (subtotales['monto'] ?? 0.0) + costo;
        subtotales['depre_acumulada'] =
            (subtotales['depre_acumulada'] ?? 0.0) + sumaDepreciada;
        subtotales['valor_libros'] =
            (subtotales['valor_libros'] ?? 0.0) + valorLibros;
        // Agregamos fila al Excel actual
        _agregarFilaExcel(excel, data, resultadoDepre, selectedYear,
            filasEnArchivoActual + 1, dataNumberStyle, centerStyle);
        filasEnArchivoActual++;
        totalRegistrosProcesados++;

        // --- CHEQUEO DE LÍMITE DE ARCHIVO ---
        if (filasEnArchivoActual >= LIMITE_FILAS_ARCHIVO) {
          _agregarFilaTotales(excel, subtotales, filasEnArchivoActual + 1,
              selectedYear, totalStyle, currencyFormatter);
          _descargarExcel(excel, filtroNivel1, numeroArchivo);

          numeroArchivo++;
          filasEnArchivoActual = 0;
          subtotales = {
            'monto': 0.0,
            'depre_acumulada': 0.0,
            'valor_libros': 0.0
          };
          excel = Excel.createExcel();
          _agregarEncabezados(excel, selectedYear, headerStyle);
        }
      }

      await Future.delayed(const Duration(milliseconds: 10));
    }

    // E. Descargar el último archivo
    if (filasEnArchivoActual > 0) {
      _agregarFilaTotales(excel, subtotales, filasEnArchivoActual + 1,
          selectedYear, totalStyle, currencyFormatter);
      _descargarExcel(excel, filtroNivel1, numeroArchivo);
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '✅ Proceso completado.\nRegistros válidos procesados: $totalRegistrosProcesados'),
      duration: const Duration(seconds: 5),
    ));
  } catch (e) {
    Navigator.of(context).pop();
    debugPrint('Error en exceldepreciacion3: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Error: $e')),
    );
  }
}

// ============================================================================
// FUNCIONES AUXILIARES DE EXCEL Y CÁLCULO
// ============================================================================

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

double _trunc2(double val) {
  return (val * 100).truncateToDouble() / 100;
}

double _round2(double val) {
  return (val * 100).roundToDouble() / 100;
}

Map<String, dynamic> _calcularDepreciacionLinealDefinitiva(
  Map<String, dynamic> data,
  Map<String, int> vidaUtilData,
  DateTime fechaCalculoDepreciacion,
  int selectedYearReporte,
) {
  final vidaUtilAnios =
      vidaUtilData[(data['clasedeactivo'] ?? '').toString()] ?? 0;
  final montoBase =
      _trunc2((data['importeinicialbien'] as num?)?.toDouble() ?? 0.0);
  final fechaInicio = _parseFecha(data['fechaadquisicion']);
  Map<int, double> deps = {};
  for (int y = 2020; y <= selectedYearReporte; y++) deps[y] = 0.0;

  if (montoBase <= 0 || vidaUtilAnios <= 0 || fechaInicio == null) {
    return {'deps': deps, 'valor_en_libros': montoBase, 'suma_depreciada': 0.0};
  }

  final totalMesesVida = vidaUtilAnios * 12;
  final cuotaMensualExacta = montoBase / totalMesesVida;

  DateTime fechaContable = fechaInicio.day > 15
      ? DateTime(fechaInicio.year, fechaInicio.month + 1, 1)
      : DateTime(fechaInicio.year, fechaInicio.month, 1);
  if (fechaContable.month > 12) {
    fechaContable = DateTime(fechaContable.year + 1, 1, 1);
  }

  double sumaDepreciada = 0.0;
  int mesesAcumulados = 0;

  // Depreciación Histórica
  final finPeriodoHistorico = DateTime(2019, 12, 31);
  if (fechaContable.isBefore(finPeriodoHistorico)) {
    int anoContable = fechaContable.year;
    int mesContable = fechaContable.month;

    while (anoContable <= 2019 && mesesAcumulados < totalMesesVida) {
      int mesesEnAno = 12 - mesContable + 1;

      if (anoContable < finPeriodoHistorico.year) {
        mesesEnAno = 12;
      }

      int mesesRestantesVida = totalMesesVida - mesesAcumulados;
      int mesesEsteAno = math.min(mesesEnAno, mesesRestantesVida);

      double montoEsteAno = _trunc2(cuotaMensualExacta * mesesEsteAno);
      if (montoEsteAno < 0) montoEsteAno = 0;

      deps[anoContable] = montoEsteAno;
      sumaDepreciada += montoEsteAno;
      mesesAcumulados += mesesEsteAno;

      anoContable++;
      mesContable = 1;
    }
    // Ajuste de fechaContable si ya se terminó el periodo histórico
    if (fechaContable.isBefore(finPeriodoHistorico)) {
      fechaContable = DateTime(2020, 1, 1);
    }
  }

  // Depreciación 2020 en adelante
  int year = fechaContable.year;
  int month = fechaContable.month;

  while (year <= selectedYearReporte && mesesAcumulados < totalMesesVida) {
    int mesesEnEsteAno = 0;

    if (year == fechaContable.year) {
      // Año de inicio (2020 o después)
      mesesEnEsteAno = 12 - month + 1;
    } else if (year > fechaContable.year) {
      // Años intermedios
      mesesEnEsteAno = 12;
    }

    // Meses de este año que tienen vida útil
    if (year >= 2020 && year <= selectedYearReporte) {
      int mesesRestantesVida = totalMesesVida - mesesAcumulados;
      mesesEnEsteAno = math.min(mesesEnEsteAno, mesesRestantesVida);
    } else {
      mesesEnEsteAno = 0;
    }

    if (mesesEnEsteAno <= 0) {
      deps[year] = 0.0;
      year++;
      continue;
    }

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
    sumaDepreciada += montoEsteAno;
    mesesAcumulados += mesesEnEsteAno;
    year++;
  }

  double remanenteFinal = montoBase - sumaDepreciada;
  double valorEnLibros = _round2(remanenteFinal);
  if (valorEnLibros.abs() < 0.01) valorEnLibros = 0.0;

  return {
    'deps': deps,
    'valor_en_libros': valorEnLibros,
    'suma_depreciada': sumaDepreciada
  };
}

void _agregarEncabezados(Excel excel, int selectedYear, CellStyle headerStyle) {
  final sheet = excel[excel.tables.keys.first];
  final headers = [
    'NUMERO ID',
    'DESCRIPCION',
    'FECHA ADQ',
    'MONTO \$',
    'DEPRE 2020',
    'DEPRE 2021',
    'DEPRE 2022',
    'DEPRE 2023',
    'DEPRE 2024'
  ];
  for (int y = 2025; y <= selectedYear; y++) headers.add('DEPRE $y');

  headers.add('DEPRECIACIÓN ACUMULADA');
  headers.add('VALOR EN LIBROS');
  for (int i = 0; i < headers.length; i++) {
    var cell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
    cell.value = headers[i];
    cell.cellStyle = headerStyle; // Negritas y centrado
  }
}

void _agregarFilaExcel(
  Excel excel,
  Map<String, dynamic> data,
  Map<String, dynamic> resultadoDepre,
  int selectedYear,
  int rowIndex,
  CellStyle dataNumberStyle,
  CellStyle centerStyle,
) {
  final sheet = excel[excel.tables.keys.first];
  final fechaAdq = _parseFecha(data['fechaadquisicion']);
  final monto =
      _trunc2((data['importeinicialbien'] as num?)?.toDouble() ?? 0.0);
  // Columna 0, 1, 2: Texto/Fecha (Centrado)
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
      .value = data['inventario2025']?.toString() ?? '';
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
      .cellStyle = centerStyle;
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
      .value = data['nombre']?.toString() ?? '';
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
      .cellStyle = centerStyle;
  sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value =
      fechaAdq != null ? DateFormat('dd/MM/yyyy').format(fechaAdq) : '';
  sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
      .cellStyle = centerStyle;
  // Montos y Depreciaciones (Centrado, asignación de valor numérico simple)
  var col = 3;
  var montoCell = sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: col++, rowIndex: rowIndex));
  montoCell.value = monto;
  montoCell.cellStyle = dataNumberStyle;
  final deps = (resultadoDepre['deps'] as Map<int, double>);
  for (int y = 2020; y <= selectedYear; y++) {
    var cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col++, rowIndex: rowIndex));
    cell.value = deps[y] ?? 0.0;
    cell.cellStyle = dataNumberStyle;
  }
  final sumaDepreciada = resultadoDepre['suma_depreciada'] as double;
  var cellDepreAcum = sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: col++, rowIndex: rowIndex));
  // FIX: Asignación simple de valor (double) para evitar el error 'NumericCellValue'
  cellDepreAcum.value = sumaDepreciada;
  cellDepreAcum.cellStyle = dataNumberStyle;
  final valorLibros = resultadoDepre['valor_en_libros'] as double;
  var cellValorLibros = sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex));
  // FIX: Asignación simple de valor (double) para evitar el error 'NumericCellValue'
  cellValorLibros.value = valorLibros;
  cellValorLibros.cellStyle = dataNumberStyle;
}

void _agregarFilaTotales(
  Excel excel,
  Map<String, double> subtotales,
  int rowIndex,
  int selectedYear,
  CellStyle totalStyle,
  NumberFormat
      currencyFormatter, // FIX: Nuevo parámetro para formatear totales como string
) {
  final sheet = excel[excel.tables.keys.first];
  // Columna 1: Etiqueta "TOTALES DEL ARCHIVO"
  var totalLabelCell = sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
  totalLabelCell.value = 'TOTALES DEL ARCHIVO:';
  // Aplicamos el estilo de Negrita y Centrado
  totalLabelCell.cellStyle = totalStyle;
  // MONTO $ (Columna 3)
  var montoCell = sheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
  // FIX: Formatear a string de moneda
  montoCell.value = currencyFormatter.format(subtotales['monto'] ?? 0.0);
  montoCell.cellStyle = totalStyle;
  // DEPRECIACIÓN ACUMULADA
  int depreAcumuladaCol = 4 + (selectedYear - 2020 + 1);
  var depreAcumCell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: depreAcumuladaCol, rowIndex: rowIndex));
  // FIX: Formatear a string de moneda
  depreAcumCell.value =
      currencyFormatter.format(subtotales['depre_acumulada'] ?? 0.0);
  depreAcumCell.cellStyle = totalStyle;
  // VALOR EN LIBROS
  int valorLibrosCol = depreAcumuladaCol + 1;
  var valorLibrosCell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: valorLibrosCol, rowIndex: rowIndex));
  // FIX: Formatear a string de moneda
  valorLibrosCell.value =
      currencyFormatter.format(subtotales['valor_libros'] ?? 0.0);
  valorLibrosCell.cellStyle = totalStyle;
  // Combinar celdas para la etiqueta "TOTALES DEL ARCHIVO"
  sheet.merge(
    CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex),
    CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex),
  );
}

void _descargarExcel(Excel excel, String filtroNivel1, int numeroArchivo) {
  final bytes = excel.encode();
  if (bytes != null) {
    // Sufijo para nombre de archivo limpio
    final sufijoUnidad = filtroNivel1.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
    final sufijoArchivo = (numeroArchivo > 1) ? '_Parte$numeroArchivo' : '';
    final fileName =
        'DepreciacionEstricta${sufijoUnidad}${sufijoArchivo}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';

    // Descarga en Web
    final blob = html.Blob([bytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
