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
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'package:excel/excel.dart' hide Border;

// ------------------- FUNCIONES AUXILIARES -------------------
String _nombreMes(int numeroMes) {
  if (numeroMes == 1) return 'ENERO';
  if (numeroMes == 2) return 'FEBRERO';
  if (numeroMes == 3) return 'MARZO';
  if (numeroMes == 4) return 'ABRIL';
  if (numeroMes == 5) return 'MAYO';
  if (numeroMes == 6) return 'JUNIO';
  if (numeroMes == 7) return 'JULIO';
  if (numeroMes == 8) return 'AGOSTO';
  if (numeroMes == 9) return 'SEPTIEMBRE';
  if (numeroMes == 10) return 'OCTUBRE';
  if (numeroMes == 11) return 'NOVIEMBRE';
  if (numeroMes == 12) return 'DICIEMBRE';
  return '';
}

String _nombreMesAbrev(int numeroMes) {
  if (numeroMes == 1) return 'ENE';
  if (numeroMes == 2) return 'FEB';
  if (numeroMes == 3) return 'MAR';
  if (numeroMes == 4) return 'ABR';
  if (numeroMes == 5) return 'MAY';
  if (numeroMes == 6) return 'JUN';
  if (numeroMes == 7) return 'JUL';
  if (numeroMes == 8) return 'AGO';
  if (numeroMes == 9) return 'SEP';
  if (numeroMes == 10) return 'OCT';
  if (numeroMes == 11) return 'NOV';
  if (numeroMes == 12) return 'DIC';
  return '';
}

// ── BLINDAJE: convierte cualquier valor del JSON en String seguro ──────────────
String _valorSeguro(dynamic valor) {
  if (valor == null) return '-----';
  final str = valor.toString().trim();
  if (str.isEmpty || str.toLowerCase() == 'null') return '-----';
  return str;
}

// ── BLINDAJE: parsea fechas de forma segura sin lanzar excepción ──────────────
String _formatearFecha(dynamic valor) {
  if (valor == null) return '-----';
  final str = valor.toString().trim();
  if (str.isEmpty || str.toLowerCase() == 'null') return '-----';
  try {
    final dt = DateTime.tryParse(str);
    if (dt != null) return DateFormat('dd/MM/yyyy').format(dt.toLocal());
    final dt2 = DateFormat('dd/MM/yyyy').tryParse(str, true);
    if (dt2 != null) return DateFormat('dd/MM/yyyy').format(dt2);
  } catch (_) {}
  return '-----';
}

// ── BLINDAJE: parsea periodo contable como "MES AÑO" ─────────────────────────
String _formatearPeriodo(dynamic valor) {
  if (valor == null) return '-----';
  final str = valor.toString().trim();
  if (str.isEmpty || str.toLowerCase() == 'null') return '-----';
  try {
    final dt = DateTime.tryParse(str);
    if (dt != null) return '${_nombreMes(dt.month)} ${dt.year}';
  } catch (_) {}
  return '-----';
}

// Función para calcular valor en libros (misma lógica que el PDF)
double _calcularValorEnLibros(Map<String, dynamic> data) {
  final cutoff = DateTime(2020, 1, 1); // ✅ CORREGIDO (sin const)

  DateTime? _parseFecha(dynamic f) {
    try {
      if (f == null || (f is String && f.isEmpty)) return null;
      final iso = DateTime.tryParse(f.toString());
      if (iso != null) return iso;
      return DateFormat('dd/MM/yyyy').parse(f.toString(), true).toLocal();
    } catch (_) {
      return null;
    }
  }

  final double costo = (data['importeinicialbien'] as num?)?.toDouble() ?? 0.0;
  final double avaluo = (data['avaluo'] as num?)?.toDouble() ?? 0.0;
  final fechaAdq = _parseFecha(data['fechaadquisicion']);

  if (fechaAdq == null || fechaAdq.isBefore(cutoff)) {
    return (avaluo != 0.0) ? avaluo : costo;
  } else {
    return (costo != 0.0) ? costo : avaluo;
  }
}

// Widget selector de mes y año (periodo contable)
Widget _buildPeriodoSelector(
  BuildContext ctx,
  String label,
  DateTime? valorActual,
  Function(DateTime) onSeleccionado,
) {
  const Color customGreen = Color(0xFF164b2d);
  final List<String> meses = [
    'ENE',
    'FEB',
    'MAR',
    'ABR',
    'MAY',
    'JUN',
    'JUL',
    'AGO',
    'SEP',
    'OCT',
    'NOV',
    'DIC'
  ];

  return InkWell(
    onTap: () async {
      int anioTemp = valorActual?.year ?? DateTime.now().year;
      int mesTemp = valorActual?.month ?? DateTime.now().month;

      await showDialog(
        context: ctx,
        builder: (dialogCtx) {
          return StatefulBuilder(
            builder: (dialogCtx, setStateDialog) {
              return AlertDialog(
                title: Text(
                  label,
                  style: const TextStyle(
                      color: customGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                content: SizedBox(
                  width: 280,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left,
                                color: customGreen),
                            onPressed: () => setStateDialog(() => anioTemp--),
                          ),
                          Text(
                            '$anioTemp',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: customGreen),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right,
                                color: customGreen),
                            onPressed: () => setStateDialog(() => anioTemp++),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1.6,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                        ),
                        itemCount: 12,
                        itemBuilder: (_, index) {
                          final seleccionado = (index + 1) == mesTemp;
                          return GestureDetector(
                            onTap: () {
                              setStateDialog(() => mesTemp = index + 1);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: seleccionado
                                    ? customGreen
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: seleccionado
                                      ? customGreen
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                meses[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: seleccionado
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: const Text('CANCELAR',
                        style: TextStyle(color: customGreen)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: customGreen,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      final fechaUtc = DateTime.utc(anioTemp, mesTemp, 1);
                      onSeleccionado(fechaUtc);
                      Navigator.pop(dialogCtx);
                    },
                    child: const Text('ACEPTAR'),
                  ),
                ],
              );
            },
          );
        },
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              Text(
                valorActual != null
                    ? '${meses[valorActual.month - 1]} - ${valorActual.year}'
                    : 'SELECCIONAR',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: valorActual != null ? Colors.black87 : Colors.grey),
              ),
            ],
          ),
          const Icon(Icons.calendar_month, size: 16, color: Color(0xFF164b2d)),
        ],
      ),
    ),
  );
}

Widget _buildFechaSelector(
  BuildContext ctx,
  String label,
  DateTime? valorActual,
  Function(DateTime) onSeleccionado,
) {
  const Color customGreen = Color(0xFF164b2d);
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  return InkWell(
    onTap: () async {
      final picked = await showDatePicker(
        context: ctx,
        initialDate: valorActual ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: customGreen,
                onPrimary: Colors.white,
                surface: customGreen,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        final fechaUtc = DateTime.utc(picked.year, picked.month, picked.day);
        onSeleccionado(fechaUtc);
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              Text(
                valorActual != null
                    ? formatter.format(valorActual)
                    : 'SELECCIONAR',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: valorActual != null ? Colors.black87 : Colors.grey),
              ),
            ],
          ),
          const Icon(Icons.calendar_month, size: 16, color: Color(0xFF164b2d)),
        ],
      ),
    ),
  );
}
// ------------------- FIN FUNCIONES AUXILIARES -------------------

Future<void> exportarBienesMueblesExcel02(
  BuildContext context,
  String authToken,
  List<String> ubicacionesNivel1,
  List<String> nombredepreciacion,
) async {
  if (!kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('❌ Esta función solo está disponible en Web')),
    );
    return;
  }

  const Color customGreen = Color(0xFF164b2d);
  final String pbBaseUrl = 'https://api.servidor-inventarios.xyz';

  // Preparar listas para dropdowns
  List<String> unidadesDisponibles = List.from(ubicacionesNivel1);
  unidadesDisponibles.sort((a, b) => a.compareTo(b));
  if (unidadesDisponibles.contains('TODOS')) {
    unidadesDisponibles.remove('TODOS');
  }
  unidadesDisponibles.insert(0, 'TODOS');

  List<String> clasesDeActivo = List.from(nombredepreciacion);
  clasesDeActivo.sort((a, b) => a.compareTo(b));
  if (clasesDeActivo.contains('TODOS')) {
    clasesDeActivo.remove('TODOS');
  }
  clasesDeActivo.insert(0, 'TODOS');

  List<String> opcionesAnexo = [
    'TODOS',
    'Localizados',
    'NO Localizados',
    'Alta',
    'Propuesta Baja'
  ];

  // Variables de selección
  String? filtroDepreciable = 'TODOS'; // NUEVO filtro UMAS
  String? filtroAnexo = 'TODOS';
  String? filtroNivel1 = 'TODOS';
  String? filtroClaseActivo = 'TODOS';
  String? filtroPrecio = 'TODOS';
  double umaValue = 113.14;
  bool excluirNoInventariables = true;
  DateTime? periodoInicial;
  DateTime? periodoFinal;
  DateTime? fechaAdqInicial;
  DateTime? fechaAdqFinal;

  // Diálogo de filtros (con filtro UMAS al inicio)
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String localFiltroDepreciable = filtroDepreciable!;
      String localAnexo = filtroAnexo!;
      String localNivel1 = filtroNivel1!;
      String localClaseActivo = filtroClaseActivo!;
      String localFiltroPrecio = filtroPrecio!;
      double localUmaValue = umaValue;
      bool localExcluirNoInventariables = excluirNoInventariables;
      DateTime? localPeriodoInicial = periodoInicial;
      DateTime? localPeriodoFinal = periodoFinal;
      DateTime? localFechaAdqInicial = fechaAdqInicial;
      DateTime? localFechaAdqFinal = fechaAdqFinal;

      return StatefulBuilder(
        builder: (context, setState) {
          final double screenWidth = MediaQuery.of(context).size.width;
          final double dialogWidth =
              screenWidth > 600 ? 550 : screenWidth * 0.95;

          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: customGreen,
                secondary: customGreen,
              ),
            ),
            child: AlertDialog(
              title: const Text('Selecciona filtros para exportar',
                  style: TextStyle(fontSize: 16)),
              content: SizedBox(
                width: dialogWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ----------------- FILTRO DE UMAS (depreciable) -----------------
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('FILTRO DE UMAS:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: localFiltroDepreciable,
                        isExpanded: true,
                        items: [
                          'TODOS',
                          'MENOR A 20 UMAS',
                          'MAYORES O IGUALES A 20 UMAS'
                        ].map((opcion) {
                          return DropdownMenuItem(
                            value: opcion,
                            child: Text(opcion,
                                style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => localFiltroDepreciable = val!);
                        },
                      ),
                      const Divider(),
                      // --------------------------------------------------------------

                      // Anexo
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro Anexo:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: localAnexo,
                        isExpanded: true,
                        items: opcionesAnexo.map((opcion) {
                          return DropdownMenuItem(
                            value: opcion,
                            child: Text(opcion,
                                style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => localAnexo = val!);
                        },
                      ),
                      const Divider(),

                      // Unidad Presupuestal
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro Unidad Presupuestal:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: localNivel1,
                        isExpanded: true,
                        items: unidadesDisponibles.map((opcion) {
                          return DropdownMenuItem(
                            value: opcion,
                            child: Text(opcion,
                                style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => localNivel1 = val!);
                        },
                      ),
                      const Divider(),

                      // Clase de Activo
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Clase de Activo:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: localClaseActivo,
                        isExpanded: true,
                        items: clasesDeActivo.map((clase) {
                          return DropdownMenuItem(
                            value: clase,
                            child: Text(clase,
                                style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => localClaseActivo = val!);
                        },
                      ),
                      const Divider(),

                      // Periodo Contable
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro por Periodo Contable:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                localPeriodoInicial = null;
                                localPeriodoFinal = null;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: customGreen,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                            child: const Text('LIMPIAR PERIODOS',
                                style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                      _buildPeriodoSelector(
                        context,
                        'PERIODO INICIAL',
                        localPeriodoInicial,
                        (seleccionado) {
                          if (localPeriodoFinal != null &&
                              seleccionado.isAfter(localPeriodoFinal!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Periodo inicial no puede ser mayor al final'),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            setState(() => localPeriodoInicial = seleccionado);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildPeriodoSelector(
                        context,
                        'PERIODO FINAL',
                        localPeriodoFinal,
                        (seleccionado) {
                          if (localPeriodoInicial != null &&
                              seleccionado.isBefore(localPeriodoInicial!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Periodo final no puede ser menor al inicial'),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            setState(() => localPeriodoFinal = seleccionado);
                          }
                        },
                      ),
                      const Divider(),

                      // Fecha de Adquisición
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro por Fecha de Adquisición:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                localFechaAdqInicial = null;
                                localFechaAdqFinal = null;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: customGreen,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                            child: const Text('LIMPIAR FECHAS',
                                style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                      _buildFechaSelector(
                        context,
                        'FECHA INICIAL',
                        localFechaAdqInicial,
                        (seleccionado) {
                          if (localFechaAdqFinal != null &&
                              seleccionado.isAfter(localFechaAdqFinal!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Fecha inicial no puede ser mayor a la final'),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            setState(() => localFechaAdqInicial = seleccionado);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildFechaSelector(
                        context,
                        'FECHA FINAL',
                        localFechaAdqFinal,
                        (seleccionado) {
                          if (localFechaAdqInicial != null &&
                              seleccionado.isBefore(localFechaAdqInicial!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Fecha final no puede ser menor a la inicial'),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            setState(() => localFechaAdqFinal = seleccionado);
                          }
                        },
                      ),
                      const Divider(),

                      // Precio UMA
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Filtro por Precio (en UMA):',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 4),
                      ...[
                        'TODOS',
                        'MENORES A 20 UMAS',
                        'MAYOR O IGUAL A 20 UMAS'
                      ].map(
                        (opcion) => RadioListTile<String>(
                          dense: true,
                          title: Text(opcion),
                          value: opcion,
                          groupValue: localFiltroPrecio,
                          activeColor: customGreen,
                          onChanged: (val) =>
                              setState(() => localFiltroPrecio = val!),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: localUmaValue.toStringAsFixed(2),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Valor de la UMA (MXN)',
                          hintText: 'Ej. 113.14',
                          suffixText: 'MXN',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: customGreen, width: 2),
                          ),
                          labelStyle: TextStyle(color: customGreen),
                        ),
                        onChanged: (val) {
                          final newValue =
                              double.tryParse(val.replaceAll(',', '.'));
                          if (newValue != null && newValue > 0) {
                            setState(() => localUmaValue = newValue);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '20 UMAS = ${(localUmaValue * 20).toStringAsFixed(2)} MXN',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: customGreen),
                      ),
                      Text(
                        'Este filtro se aplicará al valor en libros del bien',
                        style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600]),
                      ),
                      const Divider(),

                      // Excluir NO inventariables
                      CheckboxListTile(
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Excluir NO inventariables'),
                        value: localExcluirNoInventariables,
                        activeColor: customGreen,
                        checkColor: Colors.white,
                        onChanged: (v) => setState(
                            () => localExcluirNoInventariables = v ?? true),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('CANCELAR',
                      style: TextStyle(color: customGreen)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop({
                    'filtroDepreciable': localFiltroDepreciable,
                    'anexo': localAnexo,
                    'nivel1': localNivel1,
                    'clase': localClaseActivo,
                    'filtroPrecio': localFiltroPrecio,
                    'umaValue': localUmaValue,
                    'excluirNoInventariables': localExcluirNoInventariables,
                    'periodoInicial': localPeriodoInicial,
                    'periodoFinal': localPeriodoFinal,
                    'fechaAdqInicial': localFechaAdqInicial,
                    'fechaAdqFinal': localFechaAdqFinal,
                  }),
                  style: ElevatedButton.styleFrom(backgroundColor: customGreen),
                  child: const Text('DESCARGAR EXCEL',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (result == null) return;

  filtroDepreciable = result['filtroDepreciable'];
  filtroAnexo = result['anexo'];
  filtroNivel1 = result['nivel1'];
  filtroClaseActivo = result['clase'];
  filtroPrecio = result['filtroPrecio'];
  umaValue = result['umaValue'] ?? 113.14;
  excluirNoInventariables = result['excluirNoInventariables'] ?? true;
  periodoInicial = result['periodoInicial'] as DateTime?;
  periodoFinal = result['periodoFinal'] as DateTime?;
  fechaAdqInicial = result['fechaAdqInicial'] as DateTime?;
  fechaAdqFinal = result['fechaAdqFinal'] as DateTime?;

  // Diálogo de carga
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Row(
          children: const [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen),
            ),
            SizedBox(width: 20),
            Expanded(child: Text('Cargando datos y generando Excel...')),
          ],
        ),
      );
    },
  );

  try {
    // Construir filtros para PocketBase
    List<String> filters = [];

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
        filters.add("anexo = '${valorAnexo.replaceAll("'", "''")}'");
      }
    }

    if (filtroNivel1 != 'TODOS') {
      filters
          .add("nivel1organizacion = '${filtroNivel1!.replaceAll("'", "''")}'");
    }

    if (filtroClaseActivo != 'TODOS') {
      filters
          .add("clasedeactivo = '${filtroClaseActivo!.replaceAll("'", "''")}'");
    }

    // Periodo contable
    final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    if (periodoInicial != null && periodoFinal != null) {
      final inicio =
          DateTime.utc(periodoInicial!.year, periodoInicial!.month, 1);
      final ultimoDia =
          DateTime.utc(periodoFinal!.year, periodoFinal!.month + 1, 0);
      final fin = DateTime.utc(
          ultimoDia.year, ultimoDia.month, ultimoDia.day, 23, 59, 59);
      filters.add(
          "periodocontable >= '${dbFormat.format(inicio)}' && periodocontable <= '${dbFormat.format(fin)}'");
    } else if (periodoInicial != null) {
      final inicio =
          DateTime.utc(periodoInicial!.year, periodoInicial!.month, 1);
      filters.add("periodocontable >= '${dbFormat.format(inicio)}'");
    } else if (periodoFinal != null) {
      final ultimoDia =
          DateTime.utc(periodoFinal!.year, periodoFinal!.month + 1, 0);
      final fin = DateTime.utc(
          ultimoDia.year, ultimoDia.month, ultimoDia.day, 23, 59, 59);
      filters.add("periodocontable <= '${dbFormat.format(fin)}'");
    }

    // Fecha de adquisición
    if (fechaAdqInicial != null && fechaAdqFinal != null) {
      final inicio = DateTime.utc(
          fechaAdqInicial!.year, fechaAdqInicial!.month, fechaAdqInicial!.day);
      final fin = DateTime.utc(fechaAdqFinal!.year, fechaAdqFinal!.month,
          fechaAdqFinal!.day, 23, 59, 59);
      filters.add(
          "fechaadquisicion >= '${dbFormat.format(inicio)}' && fechaadquisicion <= '${dbFormat.format(fin)}'");
    } else if (fechaAdqInicial != null) {
      final inicio = DateTime.utc(
          fechaAdqInicial!.year, fechaAdqInicial!.month, fechaAdqInicial!.day);
      filters.add("fechaadquisicion >= '${dbFormat.format(inicio)}'");
    } else if (fechaAdqFinal != null) {
      final fin = DateTime.utc(fechaAdqFinal!.year, fechaAdqFinal!.month,
          fechaAdqFinal!.day, 23, 59, 59);
      filters.add("fechaadquisicion <= '${dbFormat.format(fin)}'");
    }

    String filterParam = filters.isNotEmpty ? filters.join(' && ') : '';

    // Obtener todos los datos paginados
    int page = 1;
    bool hayMasDatos = true;
    List<Map<String, dynamic>> todosLosDocs = [];

    while (hayMasDatos) {
      String urlStr = '$pbBaseUrl/fastapi/bienesmuebles?page=$page&perPage=500';
      urlStr += '&sort=fechaadquisicion,inventario2025';

      if (filterParam.isNotEmpty) {
        urlStr += '&filter=${Uri.encodeComponent(filterParam)}';
      }

      final response = await http.get(
        Uri.parse(urlStr),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final items = decoded['items'] as List;
        for (var item in items) {
          todosLosDocs.add(Map<String, dynamic>.from(item as Map));
        }
        if (page >= (decoded['totalPages'] ?? 1)) {
          hayMasDatos = false;
        } else {
          page++;
        }
      } else {
        hayMasDatos = false;
        throw Exception('Error al obtener datos: ${response.statusCode}');
      }
    }

    if (todosLosDocs.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                '⚠️ No se encontraron registros con los filtros seleccionados.')),
      );
      return;
    }

    // Aplicar filtros adicionales (depreciable, excluir NO inventariables, precio)
    final double limiteUMA = umaValue * 20.0;
    int excluidosNoInv = 0;
    List<Map<String, dynamic>> docsFiltrados = [];

    for (var data in todosLosDocs) {
      // Filtro de UMAS (depreciable)
      if (filtroDepreciable != 'TODOS') {
        final depreciableValor =
            (data['depreciable'] ?? '').toString().trim().toUpperCase();
        if (filtroDepreciable == 'MENOR A 20 UMAS' && depreciableValor != 'NO')
          continue;
        if (filtroDepreciable == 'MAYORES O IGUALES A 20 UMAS' &&
            depreciableValor != 'SI') continue;
      }

      // Excluir NO inventariables
      if (excluirNoInventariables) {
        final cotejo =
            (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
        if (cotejo == 'NO') {
          excluidosNoInv++;
          continue;
        }
      }

      // Calcular valor en libros
      final valorLibros = _calcularValorEnLibros(data);

      // Filtro por precio
      if (filtroPrecio == 'MENORES A 20 UMAS' && valorLibros >= limiteUMA)
        continue;
      if (filtroPrecio == 'MAYOR O IGUAL A 20 UMAS' && valorLibros < limiteUMA)
        continue;

      docsFiltrados.add(data);
    }

    // =========================================================
    // GENERACIÓN DEL EXCEL (con nueva columna VALOR EN LIBROS)
    // =========================================================

    final List<String> encabezados = [
      'NÚMERO ID',
      'ID ANTERIOR',
      'NOMBRE',
      'COSTO \$',
      'FECHA DE ADQUISICIÓN',
      'AVALÚO \$',
      'FECHA DE AVALÚO',
      'PERIODO CONTABLE',
      'MARCA',
      'MODELO',
      'SERIE',
      'ESTADO FÍSICO',
      'DESCRIPCIÓN',
      'UBICACIÓN',
      'USUARIO',
      'COLOR',
      'LICITACION',
      'ORIGEN RECURSO',
      'TIPO RECURSO',
      'FACTURA',
      'PROVEEDOR',
      'CLASE DE ACTIVO',
      'AÑO FISCAL',
      'NIVEL 1. ORGANIZACIÓN',
      'NIVEL 2. DIRECCIÓN',
      'NIVEL 3. JURISDICCIÓN',
      'SERIE MONITOR',
      'SERIE TECLADO',
      'SERIE MOUSE',
      'PLACA',
      'DEPOSITARIO',
      'CARGO DEPOSITARIO',
      'TIPO DE ANEXO',
      'VALOR EN LIBROS (\$)' // NUEVA COLUMNA
    ];

    final List<String> campos = [
      'inventario2025',
      'numeroinventario',
      'nombre',
      'importeinicialbien',
      'fechaadquisicion',
      'avaluo',
      'fechaavaluo',
      'periodocontable',
      'marcacomercial',
      'modelo',
      'numeroseriedelbien',
      'estatusdelbien',
      'descripciondelbien',
      'ubicacionfisica',
      'depositario',
      'color',
      'licitacion',
      'recurso',
      'tiporecurso',
      'factura',
      'nombredelprovedor',
      'clasedeactivo',
      'aniofiscal',
      'nivel1organizacion',
      'nivel2direccion',
      'nivel3jurisdiccion',
      'serimonitor',
      'serieteclado',
      'seriemouse',
      'placa',
      'tituladelbien',
      'cargotitular',
      'anexo'
    ];

    const Set<String> camposFecha = {'fechaadquisicion', 'fechaavaluo'};
    const Set<String> camposPeriodo = {'periodocontable'};

    final excel = Excel.createExcel();
    final String defaultSheetName = excel.tables.keys.first;
    final Sheet sheet = excel[defaultSheetName];

    final CellStyle estiloEncabezado =
        CellStyle(bold: true, horizontalAlign: HorizontalAlign.Center);
    final CellStyle estiloDato =
        CellStyle(horizontalAlign: HorizontalAlign.Center);
    final CellStyle estiloMoneda =
        CellStyle(horizontalAlign: HorizontalAlign.Right);

    // Encabezados
    for (int col = 0; col < encabezados.length; col++) {
      final idx = CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0);
      sheet.cell(idx).value = encabezados[col];
      sheet.cell(idx).cellStyle = estiloEncabezado;
    }

    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);

    // Datos
    for (int fila = 0; fila < docsFiltrados.length; fila++) {
      final data = docsFiltrados[fila];
      final int rowIndex = fila + 1;

      for (int col = 0; col < campos.length; col++) {
        final campo = campos[col];
        final valorRaw = data[campo];
        String textoCelda;
        if (camposFecha.contains(campo)) {
          textoCelda = _formatearFecha(valorRaw);
        } else if (camposPeriodo.contains(campo)) {
          textoCelda = _formatearPeriodo(valorRaw);
        } else {
          textoCelda = _valorSeguro(valorRaw);
        }
        final idx =
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex);
        sheet.cell(idx).value = textoCelda;
        sheet.cell(idx).cellStyle = estiloDato;
      }

      // Columna de valor en libros (índice = campos.length)
      final valorLibros = _calcularValorEnLibros(data);
      final idxValor = CellIndex.indexByColumnRow(
          columnIndex: campos.length, rowIndex: rowIndex);
      sheet.cell(idxValor).value = currencyFormat.format(valorLibros);
      sheet.cell(idxValor).cellStyle = estiloMoneda;
    }

    // Anchos de columna (incluyendo la nueva)
    final List<double> anchos = [
      18,
      18,
      30,
      14,
      20,
      14,
      18,
      20,
      20,
      20,
      22,
      16,
      35,
      30,
      25,
      14,
      20,
      22,
      18,
      18,
      28,
      22,
      14,
      30,
      30,
      30,
      20,
      20,
      18,
      14,
      28,
      25,
      18,
      18
    ];
    for (int i = 0; i < anchos.length; i++) {
      sheet.setColWidth(i, anchos[i]);
    }

    final List<int>? bytes = excel.encode();
    if (bytes == null || bytes.isEmpty) {
      throw Exception('Error al codificar el Excel');
    }

    final blob = html.Blob([bytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download',
          'Inventario_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx')
      ..click();
    html.Url.revokeObjectUrl(url);

    // Mensaje final
    String periodoInfo = '';
    if (periodoInicial != null || periodoFinal != null) {
      if (periodoInicial != null && periodoFinal != null) {
        periodoInfo =
            ' | Periodo: ${_nombreMesAbrev(periodoInicial!.month)}-${periodoInicial!.year} a ${_nombreMesAbrev(periodoFinal!.month)}-${periodoFinal!.year}';
      } else if (periodoInicial != null) {
        periodoInfo =
            ' | Desde periodo: ${_nombreMesAbrev(periodoInicial!.month)}-${periodoInicial!.year}';
      } else if (periodoFinal != null) {
        periodoInfo =
            ' | Hasta periodo: ${_nombreMesAbrev(periodoFinal!.month)}-${periodoFinal!.year}';
      }
    }

    String fechaAdqInfo = '';
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (fechaAdqInicial != null || fechaAdqFinal != null) {
      if (fechaAdqInicial != null && fechaAdqFinal != null) {
        fechaAdqInfo =
            ' | Fecha Adq: ${formatter.format(fechaAdqInicial!)} a ${formatter.format(fechaAdqFinal!)}';
      } else if (fechaAdqInicial != null) {
        fechaAdqInfo = ' | Desde Adq: ${formatter.format(fechaAdqInicial!)}';
      } else if (fechaAdqFinal != null) {
        fechaAdqInfo = ' | Hasta Adq: ${formatter.format(fechaAdqFinal!)}';
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '✅ Excel generado: ${docsFiltrados.length} bienes\nExcluidos NO inventariables: $excluidosNoInv$periodoInfo$fechaAdqInfo'),
        duration: const Duration(seconds: 6),
        backgroundColor: customGreen,
      ),
    );
  } catch (e) {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
    );
  } finally {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }
}
