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

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Función auxiliar para obtener nombre del mes en español
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

// Función auxiliar para meses abreviados
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

// Widget selector de mes y año (para periodo contable)
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
                      // Selector de año
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
                      // Grid de meses
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

// Widget selector de fecha exacta (para fecha de adquisición)
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

// NUEVO: Widget selector de fecha y hora (para fecha de elaboración)
Widget _buildDateTimeSelector(
  BuildContext ctx,
  String label,
  DateTime? valorActual,
  Function(DateTime) onSeleccionado,
) {
  const Color customGreen = Color(0xFF164b2d);
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

  return InkWell(
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: ctx,
        initialDate: valorActual ?? DateTime.now(),
        firstDate: DateTime(2020),
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
      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: ctx,
          initialTime: TimeOfDay.fromDateTime(valorActual ?? DateTime.now()),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: customGreen,
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          final finalDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          onSeleccionado(finalDateTime);
        }
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
                    : 'AHORA (actual)',
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

Future<void> libroinventarios302(
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

  // ---------------------------------------------------------
  // 0. OBTENER VALOR DE UMA DESDE FIREBASE
  // ---------------------------------------------------------
  double valorUmaPorDefecto = 113.14;

  try {
    final precioumaDoc =
        await FirebaseFirestore.instance.collection('preciouma').limit(1).get();

    if (precioumaDoc.docs.isNotEmpty) {
      final precioumaData = precioumaDoc.docs.first.data();
      if (precioumaData.containsKey('precio') &&
          precioumaData['precio'] != null) {
        valorUmaPorDefecto = (precioumaData['precio'] as num).toDouble();
        debugPrint('✅ UMA obtenida de Firebase: $valorUmaPorDefecto');
      } else {
        debugPrint(
            '⚠️ Campo "precio" no encontrado en Firebase, usando valor por defecto: $valorUmaPorDefecto');
      }
    } else {
      debugPrint(
          '⚠️ Colección "preciouma" vacía o no existe, usando valor por defecto: $valorUmaPorDefecto');
    }
  } catch (e) {
    debugPrint(
        '❌ Error al obtener UMA de Firebase: $e. Usando valor por defecto: $valorUmaPorDefecto');
  }

  // --- 1. PREPARACIÓN DE LISTAS ---
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

  // Opciones para el filtro de Anexo
  List<String> opcionesAnexo = [
    'TODOS',
    'Localizados',
    'NO Localizados',
    'Alta',
    'Propuesta Baja'
  ];

  // Variables para guardar selección
  String? filtroDepreciable = 'TODOS';
  String? filtroAnexo = 'TODOS';
  String? filtroNivel1 = 'TODOS';
  String? filtroClaseActivo = 'TODOS';
  String? filtroPrecio = 'TODOS';
  double umaValue = valorUmaPorDefecto;
  bool excluirNoInventariables = true;
  DateTime? periodoInicial;
  DateTime? periodoFinal;
  DateTime? fechaAdqInicial;
  DateTime? fechaAdqFinal;
  DateTime? fechaElaboracion; // NUEVO: fecha y hora de elaboración

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
      DateTime? localFechaElaboracion = fechaElaboracion; // NUEVO

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
                      // FILTRO DE UMAS (Dropdown)
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

                      // FILTRO ANEXO (Dropdown)
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

                      // FILTRO UNIDAD PRESUPUESTAL
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

                      // FILTRO CLASE DE ACTIVO
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

                      // FILTRO PERIODO CONTABLE
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

                      // FILTRO POR FECHA DE ADQUISICIÓN
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

                      // FILTRO POR PRECIO
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
                      CheckboxListTile(
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Excluir NO Inventariables'),
                        value: localExcluirNoInventariables,
                        activeColor: customGreen,
                        checkColor: Colors.white,
                        onChanged: (v) => setState(
                            () => localExcluirNoInventariables = v ?? true),
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

                      // NUEVO: SELECTOR DE FECHA Y HORA DE ELABORACIÓN
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Fecha y hora de elaboración del PDF:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      _buildDateTimeSelector(
                        context,
                        'FECHA Y HORA DE ELABORACIÓN (opcional)',
                        localFechaElaboracion,
                        (seleccionado) {
                          setState(() => localFechaElaboracion = seleccionado);
                        },
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Si no selecciona, se usará la fecha y hora actual',
                        style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 10),
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
                    'fechaElaboracion': localFechaElaboracion, // NUEVO
                  }),
                  style: ElevatedButton.styleFrom(backgroundColor: customGreen),
                  child: const Text('GENERAR PDF',
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
  umaValue = result['umaValue'] ?? valorUmaPorDefecto;
  excluirNoInventariables = result['excluirNoInventariables'] ?? true;
  periodoInicial = result['periodoInicial'] as DateTime?;
  periodoFinal = result['periodoFinal'] as DateTime?;
  fechaAdqInicial = result['fechaAdqInicial'] as DateTime?;
  fechaAdqFinal = result['fechaAdqFinal'] as DateTime?;
  fechaElaboracion = result['fechaElaboracion'] as DateTime?; // NUEVO

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
                const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
                const SizedBox(width: 20),
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
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  try {
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

    // FILTRO POR PERIODO CONTABLE - CORREGIDO
    if (periodoInicial != null || periodoFinal != null) {
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      if (periodoInicial != null && periodoFinal != null) {
        // Ambos: rango normal
        final inicio =
            DateTime.utc(periodoInicial!.year, periodoInicial!.month, 1);
        final ultimoDia =
            DateTime.utc(periodoFinal!.year, periodoFinal!.month + 1, 0);
        final fin = DateTime.utc(
            ultimoDia.year, ultimoDia.month, ultimoDia.day, 23, 59, 59);
        final inicioStr = dbFormat.format(inicio);
        final finStr = dbFormat.format(fin);
        filters.add(
            "periodocontable >= '$inicioStr' && periodocontable <= '$finStr'");
      } else if (periodoInicial != null) {
        // Solo inicial: desde ese mes en adelante
        final inicio =
            DateTime.utc(periodoInicial!.year, periodoInicial!.month, 1);
        final inicioStr = dbFormat.format(inicio);
        filters.add("periodocontable >= '$inicioStr'");
      } else if (periodoFinal != null) {
        // Solo final: hasta ese mes inclusive
        final ultimoDia =
            DateTime.utc(periodoFinal!.year, periodoFinal!.month + 1, 0);
        final fin = DateTime.utc(
            ultimoDia.year, ultimoDia.month, ultimoDia.day, 23, 59, 59);
        final finStr = dbFormat.format(fin);
        filters.add("periodocontable <= '$finStr'");
      }
    }

    // Filtro por fecha de adquisición (rango de día completo UTC)
    if (fechaAdqInicial != null && fechaAdqFinal != null) {
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final inicio = DateTime.utc(
          fechaAdqInicial!.year, fechaAdqInicial!.month, fechaAdqInicial!.day);
      final fin = DateTime.utc(fechaAdqFinal!.year, fechaAdqFinal!.month,
          fechaAdqFinal!.day, 23, 59, 59);
      final inicioStr = dbFormat.format(inicio);
      final finStr = dbFormat.format(fin);
      filters.add(
          "fechaadquisicion >= '$inicioStr' && fechaadquisicion <= '$finStr'");
    } else if (fechaAdqInicial != null) {
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final inicio = DateTime.utc(
          fechaAdqInicial!.year, fechaAdqInicial!.month, fechaAdqInicial!.day);
      final inicioStr = dbFormat.format(inicio);
      filters.add("fechaadquisicion >= '$inicioStr'");
    } else if (fechaAdqFinal != null) {
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final fin = DateTime.utc(fechaAdqFinal!.year, fechaAdqFinal!.month,
          fechaAdqFinal!.day, 23, 59, 59);
      final finStr = dbFormat.format(fin);
      filters.add("fechaadquisicion <= '$finStr'");
    }

    String filterParam = filters.isNotEmpty ? filters.join(' && ') : '';

    int page = 1;
    bool hayMasDatos = true;
    final List<Map<String, dynamic>> todosLosDocs = [];

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

        progressMessage = 'Cargando registros de PocketBase...';
        currentCount = todosLosDocs.length;
        setProgressState(() {});
      } else {
        hayMasDatos = false;
        debugPrint('Error fetch PB: ${response.body}');
        throw Exception('Fallo al obtener datos de PocketBase');
      }
    }

    progressMessage = 'Aplicando filtros a ${todosLosDocs.length} registros...';
    setProgressState(() {});

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

      double valorEnLibros;
      if (fechaAdq == null || fechaAdq.isBefore(cutoff)) {
        valorEnLibros = (avaluo != 0.0) ? avaluo : costo;
      } else {
        valorEnLibros = (costo != 0.0) ? costo : avaluo;
      }

      return valorEnLibros;
    }

    final double limiteUMA = umaValue * 20.0;
    int excluidosNoInventariablesCount = 0;

    final List<Map<String, dynamic>> docsFiltrados = todosLosDocs.where((data) {
      if (excluirNoInventariables!) {
        final cotejo =
            (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
        if (cotejo == 'NO') {
          excluidosNoInventariablesCount++;
          return false;
        }
      }

      // FILTRO DE UMAS por campo depreciable
      if (filtroDepreciable != 'TODOS') {
        final depreciable =
            (data['depreciable'] ?? '').toString().trim().toUpperCase();
        if (filtroDepreciable == 'MENOR A 20 UMAS' && depreciable != 'NO') {
          return false;
        }
        if (filtroDepreciable == 'MAYORES O IGUALES A 20 UMAS' &&
            depreciable != 'SI') {
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

    // Ordenamiento
    docsFiltrados.sort((a, b) {
      String getPartida(Map<String, dynamic> data) {
        final clase = (data['clasedeactivo'] ?? '').toString();
        final match = RegExp(r'^\d{3}').firstMatch(clase);
        return match != null ? match.group(0)! : '---';
      }

      final partidaA = getPartida(a);
      final partidaB = getPartida(b);

      final id = 'inventario2025';
      final idA = (a[id] ?? '-----').toString();
      final idB = (b[id] ?? '-----').toString();

      final partidaCompare = partidaA.compareTo(partidaB);
      if (partidaCompare != 0) {
        return partidaCompare;
      }

      return idA.compareTo(idB);
    });

    // Tabla resumen
    final Map<String, int> conteoPorPartida = {};
    for (var data in docsFiltrados) {
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
    final cellStyle = const pw.TextStyle(fontSize: 7);
    final totalStyle =
        pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
    final pdfGreenColor = PdfColor.fromInt(customGreen.value);
    final formatoMoneda =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);

    // NUEVO: usar la fecha de elaboración seleccionada o la actual
    final fechaHoraElaboracion = (fechaElaboracion != null)
        ? DateFormat('dd/MM/yyyy HH:mm').format(fechaElaboracion!)
        : DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    String getPeriodoTexto() {
      if (periodoInicial == null && periodoFinal == null) return '';

      if (periodoInicial != null && periodoFinal != null) {
        if (periodoInicial!.year == periodoFinal!.year &&
            periodoInicial!.month == periodoFinal!.month) {
          return 'PERIODO: ${_nombreMes(periodoInicial!.month)} - ${periodoInicial!.year}';
        } else {
          return 'PERIODO: ${_nombreMes(periodoInicial!.month)} - ${periodoInicial!.year} a ${_nombreMes(periodoFinal!.month)} - ${periodoFinal!.year}';
        }
      } else if (periodoInicial != null) {
        return 'PERIODO DESDE: ${_nombreMes(periodoInicial!.month)} - ${periodoInicial!.year}';
      } else if (periodoFinal != null) {
        return 'PERIODO AL: ${_nombreMes(periodoFinal!.month)} - ${periodoFinal!.year}';
      }
      return '';
    }

    String getFechaAdqTexto() {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      if (fechaAdqInicial == null && fechaAdqFinal == null) return '';
      if (fechaAdqInicial != null && fechaAdqFinal != null) {
        if (fechaAdqInicial!.year == fechaAdqFinal!.year &&
            fechaAdqInicial!.month == fechaAdqFinal!.month &&
            fechaAdqInicial!.day == fechaAdqFinal!.day) {
          return 'PERIODO: ${formatter.format(fechaAdqInicial!)}';
        } else {
          return 'PERIODO: ${formatter.format(fechaAdqInicial!)} a ${formatter.format(fechaAdqFinal!)}';
        }
      } else if (fechaAdqInicial != null) {
        return 'PERIODO DESDE: ${formatter.format(fechaAdqInicial!)}';
      } else if (fechaAdqFinal != null) {
        return 'PERIODO AL: ${formatter.format(fechaAdqFinal!)}';
      }
      return '';
    }

    pw.Widget buildHeader() {
      final periodoTexto = getPeriodoTexto();
      final fechaAdqTexto = getFechaAdqTexto();

      List<pw.Widget> encabezadoTextos = [
        pw.Text('PODER JUDICIAL DEL ESTADO DE VERACRUZ', style: headerStyle),
        pw.Text('SUBDIRECCIÓN DE RECURSOS MATERIALES', style: headerStyle),
      ];
      if (filtroNivel1 != 'TODOS') {
        encabezadoTextos.add(
          pw.Text('UNIDAD PRESUPUESTAL: $filtroNivel1', style: headerStyle),
        );
      }
      if (filtroDepreciable != 'TODOS') {
        encabezadoTextos.add(
          pw.Text('FILTRO DE UMAS: $filtroDepreciable', style: headerStyle),
        );
      }
      if (periodoTexto.isNotEmpty) {
        encabezadoTextos.add(
          pw.Text(periodoTexto, style: headerStyle),
        );
      }
      if (fechaAdqTexto.isNotEmpty) {
        encabezadoTextos.add(
          pw.Text(fechaAdqTexto, style: headerStyle),
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
              pw.Text(fechaHoraElaboracion,
                  style: const pw.TextStyle(fontSize: 8)),
            ],
          ),
        ],
      );
    }

    // Tabla resumen (paginada)
    const int filasResumenPorPagina = 30;
    int paginasResumen = (summaryData.length / filasResumenPorPagina).ceil();
    if (paginasResumen == 0) paginasResumen = 1;

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
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.grey300),
                  cellStyle: cellStyle,
                  cellAlignments: {
                    0: pw.Alignment.center,
                    1: pw.Alignment.center,
                  },
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(1),
                  },
                ),
                pw.Spacer(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Página ${context.pageNumber} de ${context.pagesCount}',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    // Tabla de bienes (paginada)
    const int filasPorPagina = 20;
    int paginasBienes = (docsFiltrados.length / filasPorPagina).ceil();
    if (paginasBienes == 0) paginasBienes = 1;

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
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1.2),
                    1: const pw.FlexColumnWidth(1.5),
                    2: const pw.FlexColumnWidth(3.3),
                    3: const pw.FlexColumnWidth(0.8),
                    4: const pw.FlexColumnWidth(1.5),
                    5: const pw.FlexColumnWidth(1.2),
                    6: const pw.FlexColumnWidth(2.0),
                  },
                  children: [
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('PARTIDA',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('ID-INVENTARIO',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('DESCRIPCIÓN',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('CANTIDAD',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('COSTO UNITARIO',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child: pw.Text('UNIDAD DE MEDIDA',
                                    style: tableHeaderStyle))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Center(
                                child:
                                    pw.Text('MONTO', style: tableHeaderStyle))),
                      ],
                    ),
                    ...subsetBienes.map((data) {
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
                      const cantidad = '1';
                      const unidadMedida = 'UNIDAD';
                      final valorEnLibrosFormato =
                          formatoMoneda.format(valorEnLibros);

                      return pw.TableRow(
                        children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child: pw.Text(partida, style: cellStyle))),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child: pw.Text(id, style: cellStyle))),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text(nombre, style: cellStyle)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child: pw.Text(cantidad, style: cellStyle))),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(valorEnLibrosFormato,
                                      style: cellStyle))),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child:
                                      pw.Text(unidadMedida, style: cellStyle))),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(valorEnLibrosFormato,
                                      style: cellStyle))),
                        ],
                      );
                    }),
                    if (paginaBien == paginasBienes - 1)
                      pw.TableRow(
                        decoration:
                            const pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text('', style: totalStyle)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text('', style: totalStyle)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                    'Total bienes: ${docsFiltrados.length}',
                                    style: totalStyle),
                              )),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Center(
                                  child: pw.Text(
                                      docsFiltrados.length.toString(),
                                      style: totalStyle))),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text('', style: totalStyle)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text('', style: totalStyle)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                    formatoMoneda.format(docsFiltrados
                                        .fold<double>(0, (sum, data) {
                                      final valorEnLibros =
                                          calcularValorEnLibros(data);
                                      return sum + valorEnLibros;
                                    })),
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
                    style: const pw.TextStyle(fontSize: 8),
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
    final totalValor = docsFiltrados.fold<double>(0, (sum, data) {
      final valorEnLibros = calcularValorEnLibros(data);
      return sum + valorEnLibros;
    });

    // Mensaje de éxito
    String periodoInfo = '';
    if (periodoInicial != null || periodoFinal != null) {
      if (periodoInicial != null && periodoFinal != null) {
        if (periodoInicial!.year == periodoFinal!.year &&
            periodoInicial!.month == periodoFinal!.month) {
          periodoInfo =
              ' | Periodo: ${_nombreMesAbrev(periodoInicial!.month)}-${periodoInicial!.year}';
        } else {
          periodoInfo =
              ' | Periodo: ${_nombreMesAbrev(periodoInicial!.month)}-${periodoInicial!.year} a ${_nombreMesAbrev(periodoFinal!.month)}-${periodoFinal!.year}';
        }
      } else if (periodoInicial != null) {
        periodoInfo =
            ' | Desde: ${_nombreMesAbrev(periodoInicial!.month)}-${periodoInicial!.year}';
      } else if (periodoFinal != null) {
        periodoInfo =
            ' | Hasta: ${_nombreMesAbrev(periodoFinal!.month)}-${periodoFinal!.year}';
      }
    }

    String fechaAdqInfo = '';
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (fechaAdqInicial != null || fechaAdqFinal != null) {
      if (fechaAdqInicial != null && fechaAdqFinal != null) {
        if (fechaAdqInicial!.year == fechaAdqFinal!.year &&
            fechaAdqInicial!.month == fechaAdqFinal!.month &&
            fechaAdqInicial!.day == fechaAdqFinal!.day) {
          fechaAdqInfo = ' | Fecha Adq: ${formatter.format(fechaAdqInicial!)}';
        } else {
          fechaAdqInfo =
              ' | Fecha Adq: ${formatter.format(fechaAdqInicial!)} a ${formatter.format(fechaAdqFinal!)}';
        }
      } else if (fechaAdqInicial != null) {
        fechaAdqInfo = ' | Desde Adq: ${formatter.format(fechaAdqInicial!)}';
      } else if (fechaAdqFinal != null) {
        fechaAdqInfo = ' | Hasta Adq: ${formatter.format(fechaAdqFinal!)}';
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ PDF generado exitosamente\n'
            'Total de bienes: $totalBienes\n'
            'Valor total en libros: ${formatoMoneda.format(totalValor)}$periodoInfo$fechaAdqInfo\n'
            '${excluirNoInventariables! ? 'Excluidos (NO inventariables): $excluidosNoInventariablesCount' : 'Incluye todos los bienes'}'),
        duration: const Duration(seconds: 6),
      ),
    );

    // Descargar PDF
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    String periodoSufijo = '';
    if (periodoInicial != null || periodoFinal != null) {
      if (periodoInicial != null && periodoFinal != null) {
        if (periodoInicial!.year == periodoFinal!.year &&
            periodoInicial!.month == periodoFinal!.month) {
          periodoSufijo =
              '_${periodoInicial!.year}${periodoInicial!.month.toString().padLeft(2, '0')}';
        } else {
          periodoSufijo =
              '_${periodoInicial!.year}${periodoInicial!.month.toString().padLeft(2, '0')}_a_${periodoFinal!.year}${periodoFinal!.month.toString().padLeft(2, '0')}';
        }
      } else if (periodoInicial != null) {
        periodoSufijo =
            '_desde_${periodoInicial!.year}${periodoInicial!.month.toString().padLeft(2, '0')}';
      } else if (periodoFinal != null) {
        periodoSufijo =
            '_hasta_${periodoFinal!.year}${periodoFinal!.month.toString().padLeft(2, '0')}';
      }
    }

    String fechaAdqSufijo = '';
    if (fechaAdqInicial != null || fechaAdqFinal != null) {
      if (fechaAdqInicial != null && fechaAdqFinal != null) {
        if (fechaAdqInicial!.year == fechaAdqFinal!.year &&
            fechaAdqInicial!.month == fechaAdqFinal!.month &&
            fechaAdqInicial!.day == fechaAdqFinal!.day) {
          fechaAdqSufijo =
              '_adq_${fechaAdqInicial!.year}${fechaAdqInicial!.month.toString().padLeft(2, '0')}${fechaAdqInicial!.day.toString().padLeft(2, '0')}';
        } else {
          fechaAdqSufijo =
              '_adq_${fechaAdqInicial!.year}${fechaAdqInicial!.month.toString().padLeft(2, '0')}${fechaAdqInicial!.day.toString().padLeft(2, '0')}_a_${fechaAdqFinal!.year}${fechaAdqFinal!.month.toString().padLeft(2, '0')}${fechaAdqFinal!.day.toString().padLeft(2, '0')}';
        }
      } else if (fechaAdqInicial != null) {
        fechaAdqSufijo =
            '_adq_desde_${fechaAdqInicial!.year}${fechaAdqInicial!.month.toString().padLeft(2, '0')}${fechaAdqInicial!.day.toString().padLeft(2, '0')}';
      } else if (fechaAdqFinal != null) {
        fechaAdqSufijo =
            '_adq_hasta_${fechaAdqFinal!.year}${fechaAdqFinal!.month.toString().padLeft(2, '0')}${fechaAdqFinal!.day.toString().padLeft(2, '0')}';
      }
    }

    html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download =
          'LibroInventarios${periodoSufijo}${fechaAdqSufijo}_${DateTime.now().millisecondsSinceEpoch}.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  } catch (e, st) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Error al generar PDF: $e'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
    debugPrint('Error detallado al generar PDF: $e\n$st');
  }
}
