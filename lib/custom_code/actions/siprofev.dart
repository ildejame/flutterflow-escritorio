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
String _sipNombreMes(int numeroMes) {
  const meses = [
    '',
    'ENERO',
    'FEBRERO',
    'MARZO',
    'ABRIL',
    'MAYO',
    'JUNIO',
    'JULIO',
    'AGOSTO',
    'SEPTIEMBRE',
    'OCTUBRE',
    'NOVIEMBRE',
    'DICIEMBRE'
  ];
  return (numeroMes >= 1 && numeroMes <= 12) ? meses[numeroMes] : '';
}

String _sipNombreMesAbrev(int numeroMes) {
  const meses = [
    '',
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
  return (numeroMes >= 1 && numeroMes <= 12) ? meses[numeroMes] : '';
}

Widget _sipBuildPeriodoSelector(
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

Widget _sipBuildFechaSelector(
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

Future<void> siprofev(
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

  // Variables de selección (se añade filtroDepreciable)
  String? filtroDepreciable = 'TODOS';
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

  // Diálogo de filtros (con nuevo filtro Depreciable)
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
              title: const Text('SIPROFEV – Selecciona filtros para exportar',
                  style: TextStyle(fontSize: 16)),
              content: SizedBox(
                width: dialogWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ===== NUEVO: FILTRO DE UMAS (depreciable) =====
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
                      _sipBuildPeriodoSelector(
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
                      _sipBuildPeriodoSelector(
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
                      _sipBuildFechaSelector(
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
                      _sipBuildFechaSelector(
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
                  child: const Text('DESCARGAR SIPROFEV',
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
            Expanded(child: Text('Cargando datos y generando SIPROFEV...')),
          ],
        ),
      );
    },
  );

  try {
    // ------------------- CONSTRUIR FILTROS -------------------
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
    if (periodoInicial != null && periodoFinal != null) {
      final inicio =
          DateTime.utc(periodoInicial!.year, periodoInicial!.month, 1);
      final ultimoDia =
          DateTime.utc(periodoFinal!.year, periodoFinal!.month + 1, 0);
      final fin = DateTime.utc(
          ultimoDia.year, ultimoDia.month, ultimoDia.day, 23, 59, 59);
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      filters.add(
          "periodocontable >= '${dbFormat.format(inicio)}' && periodocontable <= '${dbFormat.format(fin)}'");
    } else if (periodoInicial != null) {
      final inicio =
          DateTime.utc(periodoInicial!.year, periodoInicial!.month, 1);
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      filters.add("periodocontable >= '${dbFormat.format(inicio)}'");
    } else if (periodoFinal != null) {
      final ultimoDia =
          DateTime.utc(periodoFinal!.year, periodoFinal!.month + 1, 0);
      final fin = DateTime.utc(
          ultimoDia.year, ultimoDia.month, ultimoDia.day, 23, 59, 59);
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      filters.add("periodocontable <= '${dbFormat.format(fin)}'");
    }

    // Fecha de adquisición
    if (fechaAdqInicial != null && fechaAdqFinal != null) {
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final inicio = DateTime.utc(
          fechaAdqInicial!.year, fechaAdqInicial!.month, fechaAdqInicial!.day);
      final fin = DateTime.utc(fechaAdqFinal!.year, fechaAdqFinal!.month,
          fechaAdqFinal!.day, 23, 59, 59);
      filters.add(
          "fechaadquisicion >= '${dbFormat.format(inicio)}' && fechaadquisicion <= '${dbFormat.format(fin)}'");
    } else if (fechaAdqInicial != null) {
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final inicio = DateTime.utc(
          fechaAdqInicial!.year, fechaAdqInicial!.month, fechaAdqInicial!.day);
      filters.add("fechaadquisicion >= '${dbFormat.format(inicio)}'");
    } else if (fechaAdqFinal != null) {
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final fin = DateTime.utc(fechaAdqFinal!.year, fechaAdqFinal!.month,
          fechaAdqFinal!.day, 23, 59, 59);
      filters.add("fechaadquisicion <= '${dbFormat.format(fin)}'");
    }

    String filterParam = filters.isNotEmpty ? filters.join(' && ') : '';

    // ------------------- OBTENER DATOS PAGINADOS (Bienes Muebles) -------------------
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
          todosLosDocs.add(item as Map<String, dynamic>);
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

    // ------------------- OBTENER CATÁLOGO DE DEPRECIACIÓN -------------------
    Map<String, String> mapaClavesArmonizadas = {};
    int pageDep = 1;
    bool hayMasDep = true;

    while (hayMasDep) {
      String urlDep =
          '$pbBaseUrl/fastapi/depreciacion?page=$pageDep&perPage=500';
      final responseDep = await http.get(
        Uri.parse(urlDep),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (responseDep.statusCode == 200) {
        final decodedDep = json.decode(responseDep.body);
        final itemsDep = decodedDep['items'] as List;
        for (var item in itemsDep) {
          final mapItem = item as Map<String, dynamic>;
          final nombre = (mapItem['nombre'] ?? '').toString().trim();
          final clave = (mapItem['clavearmonizada'] ?? '').toString().trim();
          if (nombre.isNotEmpty) {
            mapaClavesArmonizadas[nombre] = clave;
          }
        }
        if (pageDep >= (decodedDep['totalPages'] ?? 1)) {
          hayMasDep = false;
        } else {
          pageDep++;
        }
      } else {
        hayMasDep = false;
        print('Error al obtener depreciacion: ${responseDep.statusCode}');
      }
    }

    // ------------------- APLICAR FILTROS DE PRECIO / INVENTARIABLES y NUEVO FILTRO UMAS -------------------
    double calcularValorEnLibros(Map<String, dynamic> data) {
      final cutoff = DateTime(2020, 1, 1);
      DateTime? parseFecha(dynamic f) {
        try {
          if (f == null || (f is String && f.isEmpty)) return null;
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
      final fechaAdq = parseFecha(data['fechaadquisicion']);

      if (fechaAdq == null || fechaAdq.isBefore(cutoff)) {
        return (avaluo != 0.0) ? avaluo : costo;
      } else {
        return (costo != 0.0) ? costo : avaluo;
      }
    }

    final double limiteUMA = umaValue * 20.0;
    int excluidosCount = 0;
    List<Map<String, dynamic>> docsFiltrados = [];

    for (var data in todosLosDocs) {
      // 1. Filtro UMAS (depreciable) - NUEVO
      if (filtroDepreciable != 'TODOS') {
        final depreciable =
            (data['depreciable'] ?? '').toString().trim().toUpperCase();
        if (filtroDepreciable == 'MENOR A 20 UMAS' && depreciable != 'NO') {
          continue;
        }
        if (filtroDepreciable == 'MAYORES O IGUALES A 20 UMAS' &&
            depreciable != 'SI') {
          continue;
        }
      }

      // 2. Excluir NO inventariables
      if (excluirNoInventariables) {
        final cotejo =
            (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
        if (cotejo == 'NO') {
          excluidosCount++;
          continue;
        }
      }

      // 3. Filtro Precio (valor en libros)
      final valorLibros = calcularValorEnLibros(data);
      if (filtroPrecio == 'MENORES A 20 UMAS' && valorLibros >= limiteUMA)
        continue;
      if (filtroPrecio == 'MAYOR O IGUAL A 20 UMAS' && valorLibros < limiteUMA)
        continue;

      docsFiltrados.add(data);
    }

    // ------------------- GENERAR EXCEL SIPROFEV -------------------
    final excel = Excel.createExcel();
    final defaultSheetName = excel.tables.keys.first;
    final sheet = excel[defaultSheetName];

    // Colores de encabezado: verde claro institucional RGB(198,224,180)
    final CellStyle estiloCabecera = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: '#C6E0B4',
      fontColorHex: '#000000',
      textWrapping: TextWrapping.WrapText,
    );
    final CellStyle estiloDatos = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // Definición completa de columnas (sin cambios)
    final List<Map<String, String>> columnas = [
      // DOCUMENTO SOPORTE (A-H)
      {
        'grupo': 'DOCUMENTO SOPORTE',
        'sub': 'Número de Factura',
        'campo': 'factura'
      },
      {'grupo': '', 'sub': 'Fecha', 'campo': 'fechaadquisicion'},
      {'grupo': '', 'sub': 'Fondo', 'campo': 'recurso'},
      {
        'grupo': '',
        'sub': 'Clasificación del Bien',
        'campo': '__clavearmonizada__'
      },
      {'grupo': '', 'sub': 'Cantidad', 'campo': '__cantidad__'},
      {'grupo': '', 'sub': 'Descripción', 'campo': 'nombre'},
      {'grupo': '', 'sub': 'Costo \$', 'campo': 'importeinicialbien'},
      {'grupo': '', 'sub': 'Valor de Avalúo', 'campo': 'avaluo'},
      // CONTABILIDAD (I-K)
      {
        'grupo': 'CONTABILIDAD',
        'sub': 'Póliza de Registro',
        'campo': '__vacio__'
      },
      {'grupo': '', 'sub': 'Fecha', 'campo': '__vacio__'},
      {'grupo': '', 'sub': 'Cuenta de Registro', 'campo': '__vacio__'},
      // CÉDULA DE REGISTRO (L-U)
      {
        'grupo': 'CÉDULA DE REGISTRO',
        'sub': 'Tipo de Bien:\nBien Mayor/Bien Menor',
        'campo': 'depreciable'
      },
      {'grupo': '', 'sub': 'Adscripción', 'campo': 'nivel2direccion'},
      {'grupo': '', 'sub': 'Código de Inventario', 'campo': 'inventario2025'},
      {'grupo': '', 'sub': 'No de Inventario', 'campo': 'inventario2025'},
      {'grupo': '', 'sub': 'Serie', 'campo': 'numeroseriedelbien'},
      {'grupo': '', 'sub': 'Marca', 'campo': 'marcacomercial'},
      {'grupo': '', 'sub': 'Modelo', 'campo': 'modelo'},
      {'grupo': '', 'sub': 'Color', 'campo': 'color'},
      {'grupo': '', 'sub': 'Condición del Bien', 'campo': 'estatusdelbien'},
      {'grupo': '', 'sub': 'Resguardante', 'campo': 'tituladelbien'},
      // COMODATO (V-X)
      {'grupo': 'COMODATO', 'sub': 'Otorgante', 'campo': '__na__'},
      {'grupo': '', 'sub': 'Comodatario', 'campo': '__na__'},
      {'grupo': '', 'sub': 'Cuenta Contable de Comodato', 'campo': '__na__'},
    ];

    // Merge y escribir fila 1 (grupos)
    final List<Map<String, dynamic>> grupos = [
      {'texto': 'DOCUMENTO SOPORTE', 'inicio': 0, 'fin': 7},
      {'texto': 'CONTABILIDAD', 'inicio': 8, 'fin': 10},
      {'texto': 'CÉDULA DE REGISTRO', 'inicio': 11, 'fin': 20},
      {'texto': 'COMODATO', 'inicio': 21, 'fin': 23},
    ];

    for (final g in grupos) {
      final int ini = g['inicio'] as int;
      final int fin = g['fin'] as int;
      sheet.merge(
        CellIndex.indexByColumnRow(columnIndex: ini, rowIndex: 0),
        CellIndex.indexByColumnRow(columnIndex: fin, rowIndex: 0),
      );
      final cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: ini, rowIndex: 0));
      cell.value = g['texto'] as String;
      cell.cellStyle = estiloCabecera;
    }

    // Escribir fila 2 (subencabezados)
    for (int col = 0; col < columnas.length; col++) {
      final cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1));
      cell.value = columnas[col]['sub']!;
      cell.cellStyle = estiloCabecera;
    }

    // Escribir datos desde fila 3 (índice 2)
    final DateFormat formatoFecha = DateFormat('dd/MM/yyyy');

    for (int i = 0; i < docsFiltrados.length; i++) {
      final data = docsFiltrados[i];
      final int rowIdx = i + 2;

      for (int col = 0; col < columnas.length; col++) {
        final campo = columnas[col]['campo']!;
        final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIdx));
        cell.cellStyle = estiloDatos;

        if (campo == '__cantidad__') {
          cell.value = 1;
        } else if (campo == '__na__') {
          cell.value = 'N/A';
        } else if (campo == '__vacio__') {
          cell.value = 'N/A';
        } else if (campo == '__clavearmonizada__') {
          final claseActivo = (data['clasedeactivo'] ?? '').toString().trim();
          cell.value = mapaClavesArmonizadas.containsKey(claseActivo) &&
                  mapaClavesArmonizadas[claseActivo]!.isNotEmpty
              ? mapaClavesArmonizadas[claseActivo]!
              : 'N/A';
        } else if (campo == 'depreciable') {
          final dep =
              (data['depreciable'] ?? '').toString().trim().toUpperCase();
          cell.value = (dep == 'SI') ? 'My' : 'Mn';
        } else if (campo == 'fechaadquisicion') {
          final raw = data[campo];
          if (raw != null && raw.toString().trim().isNotEmpty) {
            final dt = DateTime.tryParse(raw.toString());
            cell.value =
                dt != null ? formatoFecha.format(dt.toLocal()) : raw.toString();
          } else {
            cell.value = 'N/A';
          }
        } else if (campo == 'importeinicialbien' || campo == 'avaluo') {
          final num? val = data[campo] as num?;
          cell.value = val != null ? val.toDouble() : 'N/A';
        } else {
          final raw = data[campo];
          cell.value = (raw == null ||
                  raw.toString().trim().isEmpty ||
                  raw.toString() == 'null')
              ? 'N/A'
              : raw.toString();
        }
      }
    }

    // Ajustar ancho de columnas
    for (int i = 0; i < columnas.length; i++) {
      sheet.setColAutoFit(i);
    }

    // Codificar y descargar
    final bytes = excel.encode();
    if (bytes == null) throw Exception('Error al generar el archivo Excel');

    final blob = html.Blob([bytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download',
          'SIPROFEV_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx')
      ..click();
    html.Url.revokeObjectUrl(url);

    // Resumen informativo (incluyendo el nuevo filtro de UMAS)
    String periodoInfo = '';
    if (periodoInicial != null || periodoFinal != null) {
      if (periodoInicial != null && periodoFinal != null) {
        periodoInfo =
            ' | Periodo: ${_sipNombreMesAbrev(periodoInicial!.month)}-${periodoInicial!.year} a ${_sipNombreMesAbrev(periodoFinal!.month)}-${periodoFinal!.year}';
      } else if (periodoInicial != null) {
        periodoInfo =
            ' | Desde: ${_sipNombreMesAbrev(periodoInicial!.month)}-${periodoInicial!.year}';
      } else if (periodoFinal != null) {
        periodoInfo =
            ' | Hasta: ${_sipNombreMesAbrev(periodoFinal!.month)}-${periodoFinal!.year}';
      }
    }

    String fechaAdqInfo = '';
    if (fechaAdqInicial != null || fechaAdqFinal != null) {
      if (fechaAdqInicial != null && fechaAdqFinal != null) {
        fechaAdqInfo =
            ' | Adq: ${formatoFecha.format(fechaAdqInicial!)} a ${formatoFecha.format(fechaAdqFinal!)}';
      } else if (fechaAdqInicial != null) {
        fechaAdqInfo = ' | Adq desde: ${formatoFecha.format(fechaAdqInicial!)}';
      } else if (fechaAdqFinal != null) {
        fechaAdqInfo = ' | Adq hasta: ${formatoFecha.format(fechaAdqFinal!)}';
      }
    }

    String umasInfo = '';
    if (filtroDepreciable != 'TODOS') {
      umasInfo = ' | Filtro UMAS: $filtroDepreciable';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ SIPROFEV generado: ${docsFiltrados.length} bienes'
            '\nExcluidos NO inventariables: $excluidosCount'
            '$umasInfo$periodoInfo$fechaAdqInfo'),
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
