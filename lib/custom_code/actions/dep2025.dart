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

import '/flutter_flow/custom_functions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

// Color institucional
const Color customGreen = Color(0xFF164b2d);

Future<void> dep2025(BuildContext context) async {
  final firestore = FirebaseFirestore.instance;

  // 1. Loader Inicial
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
          const Expanded(child: Text('Cargando unidades...')),
        ],
      ),
    ),
  );

  // 2. Obtener Oficinas
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

  Navigator.of(context).pop();

  // 3. Configuración (Año fijo 2025)
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String unidad = 'TODOS';
      bool excluirNoInventariables = true;
      // Valor UMA 2025 estimado/editable
      final TextEditingController umaController =
          TextEditingController(text: '113.14');

      return StatefulBuilder(
        builder: (ctx, setState) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: customGreen,
                secondary: customGreen,
              ),
              radioTheme: RadioThemeData(
                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected))
                    return customGreen;
                  return Colors.grey;
                }),
              ),
              checkboxTheme: CheckboxThemeData(
                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected))
                    return customGreen;
                  return Colors.grey;
                }),
              ),
            ),
            child: AlertDialog(
              title: const Text('Reporte Depreciación 2025'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Filtro Unidad Presupuestal:'),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300)),
                      child: ListView(
                        shrinkWrap: true,
                        children: unidadesDisponibles.map((unidadNombre) {
                          return RadioListTile<String>(
                            dense: true,
                            title: Text(unidadNombre),
                            value: unidadNombre,
                            groupValue: unidad,
                            onChanged: (v) => setState(() => unidad = v!),
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(height: 16),
                    TextField(
                      controller: umaController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      decoration: InputDecoration(
                        labelText: 'Valor UMA (MXN)',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customGreen, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Información Fija
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.calendar_today,
                              color: customGreen, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Año de Cálculo: 2025',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
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
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('CANCELAR',
                      style: TextStyle(color: customGreen)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final double umaVal = double.tryParse(
                            umaController.text.replaceAll(',', '.')) ??
                        113.14;
                    Navigator.of(context).pop(<String, dynamic>{
                      'unidad': unidad,
                      'umaValue': umaVal,
                      'excluirNoInventariables': excluirNoInventariables,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('GENERAR'),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (result == null) return;

  final String filtroNivel1 = (result['unidad'] as String?) ?? 'TODOS';
  final double umaValue = (result['umaValue'] as double?) ?? 113.14;
  final bool excluirNoInventariables =
      (result['excluirNoInventariables'] as bool?) ?? true;

  // Variables Fijas para 2025
  const int selectedYear = 2025;
  final DateTime fechaCalculoDepreciacion = DateTime(selectedYear, 12, 31);
  final double limiteUMA = umaValue * 20.0;
  final DateTime cutoff2020 = DateTime(2020, 1, 1);

  // 4. Loader Cálculo
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
          const Expanded(child: Text('Calculando diferencias 2025...')),
        ],
      ),
    ),
  );

  // Mapa Vidas Útiles
  Map<String, int> vidaUtilData = {};
  try {
    final depreciacionSnapshot =
        await firestore.collection('depreciacion').get();
    for (final doc in depreciacionSnapshot.docs) {
      final d = doc.data();
      vidaUtilData[d['nombre'] as String] = (d['vidautil'] as num).toInt();
    }

    // 5. Query Bienes
    final List<DocumentSnapshot<Map<String, dynamic>>> todosLosDocs = [];
    Query<Map<String, dynamic>> query = firestore
        .collection('bienesmuebles')
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) => snap.data() ?? {},
          toFirestore: (data, _) => data,
        );

    if (filtroNivel1 != 'TODOS') {
      query = query.where('nivel1organizacion', isEqualTo: filtroNivel1);
    }

    DocumentSnapshot<Map<String, dynamic>>? ultimo;
    while (true) {
      Query<Map<String, dynamic>> q = query.limit(500);
      if (ultimo != null) q = q.startAfterDocument(ultimo);
      final snap = await q.get();
      if (snap.docs.isEmpty) break;
      todosLosDocs.addAll(snap.docs);
      ultimo = snap.docs.last;
    }

    if (todosLosDocs.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ No se encontraron registros.')),
      );
      return;
    }

    // Estructura de reporte
    final Map<String, Map<String, dynamic>> tablaReporte = {};

    // Obtener Clases
    final Set<String> clasesReales = {};
    for (final doc in todosLosDocs) {
      final d = doc.data();
      if (d != null) {
        final c = (d['clasedeactivo'] ?? '').toString().trim();
        if (c.isNotEmpty) clasesReales.add(c);
      }
    }
    final List<String> listaClases = clasesReales.toList()..sort();

    // Inicializar mapa
    for (final c in listaClases) {
      tablaReporte[c] = {'bienes': 0, 'monto2025': 0.0};
    }

    // ========================================================================
    // LÓGICA DE CÁLCULO (INCLUYE BIENES DE 2024 EN EL CÁLCULO DE 2025)
    // ========================================================================

    for (final doc in todosLosDocs) {
      final data = doc.data();
      if (data == null) continue;

      // Filtro Inventariable
      final cotejo = (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
      if (excluirNoInventariables && cotejo == 'NO') {
        continue;
      }

      final clase = (data['clasedeactivo'] ?? '').toString().trim();
      if (clase.isEmpty) continue;

      final double costoRaw =
          _trunc2((data['importeinicialbien'] as num?)?.toDouble() ?? 0.0);
      final double avaluoRaw =
          _trunc2((data['avaluo'] as num?)?.toDouble() ?? 0.0);
      final fechaAdqRaw = _parseFecha(data['fechaadquisicion']);
      final fechaAvalRaw = _parseFecha(data['fechaavaluo']);

      // 1. FILTRO FECHA: Solo ignoramos lo que se compre DESPUES de 2025.
      // Un bien de 2024 PASA este filtro.
      if (fechaAdqRaw != null && fechaAdqRaw.year > selectedYear) {
        continue;
      }

      // 2. BASE "2024" (Lo que dice la BD, sin tocar)
      double acumuladoBD =
          (data['depreciacionacumulada'] as num?)?.toDouble() ?? 0.0;

      // 3. CALCULO DEL EJERCICIO 2025
      double depreciacionSolo2025 = 0.0;

      // Reglas: Usar avalúo si existe y es vigente, si no, costo.
      bool usarAvaluoTemp = (avaluoRaw > 0 &&
          fechaAvalRaw != null &&
          fechaAvalRaw.year <= selectedYear);
      double costoCheck = usarAvaluoTemp ? avaluoRaw : costoRaw;

      // Regla UMA: Solo depreciamos si vale más de ~20 UMA (aprox $2,200+)
      if (costoCheck >= limiteUMA && costoCheck > 0.0) {
        final DateTime fechaComputable =
            usarAvaluoTemp ? fechaAvalRaw! : (fechaAdqRaw ?? cutoff2020);

        final Map<String, dynamic> dataParaCalculo =
            Map<String, dynamic>.from(data);
        dataParaCalculo['importeinicialbien'] = costoCheck;
        dataParaCalculo['fechaadquisicion'] = fechaComputable;

        // Calculamos la tabla hasta 2025
        final resultadoDepre = _calcularDepreciacionLinealDefinitiva(
            dataParaCalculo,
            vidaUtilData,
            fechaCalculoDepreciacion,
            selectedYear);

        // Extraemos la cuota específica del año 2025
        final Map<int, double> mapDeps =
            resultadoDepre['deps'] as Map<int, double>;
        double calculoPuro2025 = mapDeps[selectedYear] ?? 0.0;

        // VALIDACIÓN DE TOPE (Saldo por depreciar)
        // El bien no puede depreciarse más de lo que costó.
        // Saldo disponible = Costo - LoQueYaTeniaAcumulado
        double remanentePorDepreciar = costoCheck - acumuladoBD;
        if (remanentePorDepreciar < 0) remanentePorDepreciar = 0;

        // Si el cálculo de 2025 es mayor al saldo disponible, solo tomamos el saldo.
        // Si el bien de 2024 tiene mucho saldo, tomará la cuota anual completa.
        if (calculoPuro2025 > remanentePorDepreciar) {
          depreciacionSolo2025 = remanentePorDepreciar;
        } else {
          depreciacionSolo2025 = calculoPuro2025;
        }
      }

      // 4. AGREGAR AL REPORTE
      if (!tablaReporte.containsKey(clase)) {
        tablaReporte[clase] = {'bienes': 0, 'monto2025': 0.0};
      }

      tablaReporte[clase]!['bienes'] =
          (tablaReporte[clase]!['bienes'] as int) + 1;
      tablaReporte[clase]!['monto2025'] =
          (tablaReporte[clase]!['monto2025'] as double) + depreciacionSolo2025;
    }

    // Limpieza
    tablaReporte.removeWhere((key, value) => (value['bienes'] as int) == 0);

    // ========================================================================
    // PDF GENERATION
    // ========================================================================
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    final clasesSorted = tablaReporte.keys.toList()..sort();

    pw.Widget buildHeader(pw.Context context) {
      final fh = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      final titulo = (filtroNivel1 != 'TODOS')
          ? 'REPORTE DEPRECIACIÓN 2025 - $filtroNivel1'
          : 'REPORTE DEPRECIACIÓN DEL EJERCICIO 2025';

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
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Text(titulo,
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.Text('Importes del ejercicio 2025 (Diferencia vs Base)',
                    style: pw.TextStyle(
                        fontSize: 9, fontStyle: pw.FontStyle.italic)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Fecha impresión:', style: pw.TextStyle(fontSize: 8)),
                pw.Text(fh, style: pw.TextStyle(fontSize: 8)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 15),
      ]);
    }

    pw.Widget _headerCell(String text,
        {pw.Alignment alignment = pw.Alignment.center}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Align(
          alignment: alignment,
          child: pw.Text(
            text,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            textAlign: alignment == pw.Alignment.centerLeft
                ? pw.TextAlign.left
                : pw.TextAlign.right,
          ),
        ),
      );
    }

    final List<pw.TableRow> filasTabla = [];
    filasTabla.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          _headerCell('CLASE DE ACTIVO', alignment: pw.Alignment.centerLeft),
          _headerCell('No. Bienes', alignment: pw.Alignment.centerRight),
          _headerCell('Dep. en 2025', alignment: pw.Alignment.centerRight),
        ],
      ),
    );

    for (final clase in clasesSorted) {
      final row = tablaReporte[clase]!;
      filasTabla.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(clase, style: pw.TextStyle(fontSize: 8)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(row['bienes'].toString(),
                    style: pw.TextStyle(fontSize: 8)),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(fmt.format(row['monto2025']),
                    style: pw.TextStyle(fontSize: 8)),
              ),
            ),
          ],
        ),
      );
    }

    // Totales
    final totalDepre = tablaReporte.values
        .fold<double>(0.0, (s, e) => s + (e['monto2025'] as double));
    final totalBienes =
        tablaReporte.values.fold<int>(0, (s, e) => s + (e['bienes'] as int));

    filasTabla.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text('TOTAL GENERAL',
                style:
                    pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(totalBienes.toString(),
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(fmt.format(totalDepre),
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(15),
        header: buildHeader,
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 8),
          ),
        ),
        build: (context) => [
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(10),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(5),
            },
            children: filasTabla,
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '✅ PDF 2025 generado.\n'
        'Bienes: $totalBienes | Dep. 2025: ${fmt.format(totalDepre)}',
      ),
      duration: const Duration(seconds: 8),
    ));

    final sufijo = (filtroNivel1 != 'TODOS')
        ? '_${filtroNivel1.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}'
        : '';
    final fileName =
        'Depreciacion2025${sufijo}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);
  } catch (e, st) {
    Navigator.of(context).pop();
    debugPrint('❌ Error: $e\n$st');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('❌ Error: $e')));
  }
}

// ========================================================================
// FUNCIONES AUXILIARES
// ========================================================================

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
    if (fechaContable.isBefore(finPeriodoHistorico)) {
      fechaContable = DateTime(2020, 1, 1);
    }
  }

  int year = fechaContable.year;
  int month = fechaContable.month;

  while (year <= selectedYearReporte && mesesAcumulados < totalMesesVida) {
    int mesesEnEsteAno = 0;
    if (year == fechaContable.year) {
      mesesEnEsteAno = 12 - month + 1;
    } else if (year > fechaContable.year) {
      mesesEnEsteAno = 12;
    }

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
