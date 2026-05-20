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

// Función auxiliar para redondear a 2 decimales sin errores de punto flotante
double _roundTo2Decimals(double value) {
  return (value * 100).roundToDouble() / 100;
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

// Widget selector de fecha y hora (para fecha de elaboración)
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

Future<void> valorEnLibros2025502(
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

  // Color personalizado institucional
  const Color customGreen = Color(0xFF164b2d);
  // URL base de PocketBase
  final String pbBaseUrl = 'https://api.servidor-inventarios.xyz';

  // ---------------------------------------------------------
  // 0. OBTENER VALOR DE UMA DESDE FIREBASE
  // ---------------------------------------------------------
  double valorUmaPorDefecto = 113.14; // Valor fallback

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
            '⚠️ Campo "precio" no encontrado, usando por defecto: $valorUmaPorDefecto');
      }
    } else {
      debugPrint('⚠️ Colección vacía, usando por defecto: $valorUmaPorDefecto');
    }
  } catch (e) {
    debugPrint(
        '❌ Error al obtener UMA: $e. Usando por defecto: $valorUmaPorDefecto');
  }

  // ---------------------------------------------------------
  // 1. CARGA DE LISTAS PARA DIÁLOGO
  // ---------------------------------------------------------
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

  // ---------------------------------------------------------
  // 2. DIÁLOGO DE CONFIGURACIÓN
  // ---------------------------------------------------------
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
  DateTime? fechaElaboracion;

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
      DateTime? localFechaElaboracion = fechaElaboracion;

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
              title: const Text('Configuración de Reporte (Valor en Libros)',
                  style: TextStyle(fontSize: 16)),
              content: SizedBox(
                width: dialogWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // FILTRO DE UMAS
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

                      // FILTRO ANEXO
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

                      // SELECTOR DE FECHA Y HORA DE ELABORACIÓN
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
                    'fechaElaboracion': localFechaElaboracion,
                  }),
                  style: ElevatedButton.styleFrom(backgroundColor: customGreen),
                  child: const Text('GENERAR REPORTE',
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
  fechaElaboracion = result['fechaElaboracion'] as DateTime?;

  // ---------------------------------------------------------
  // 3. OBTENCIÓN Y FILTRADO DE DATOS (VERSIÓN CORREGIDA)
  // ---------------------------------------------------------
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: const <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customGreen),
          ),
          SizedBox(width: 20),
          Expanded(child: Text('Procesando resumen de valor en libros...')),
        ],
      ),
    ),
  );

  try {
    final Map<String, Map<String, dynamic>> resumen = {};
    final Set<String> clasesReales = {};
    final cutoff = DateTime(2020, 1, 1);
    int excluidosNoInventariables = 0;
    final double limiteUMA = umaValue * 20.0;

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

    // =========================================================
    // CONSTRUCCIÓN CORREGIDA DE FILTROS PARA POCKETBASE
    // =========================================================
    List<String> filtrosList = [];

    // 1. FILTRO ANEXO (sin cambios, funciona bien)
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
        filtrosList.add("anexo = '${valorAnexo.replaceAll("'", "''")}'");
      }
    }

    // 2. FILTRO POR UNIDAD (CORREGIDO)
    if (filtroNivel1 != 'TODOS' &&
        filtroNivel1 != null &&
        filtroNivel1!.isNotEmpty) {
      String valorUnidad = filtroNivel1!.trim();
      valorUnidad = valorUnidad.replaceAll("'", "''");
      // Usamos comparación exacta
      filtrosList.add("nivel1organizacion = '$valorUnidad'");
      debugPrint(
          '🔍 Filtro unidad aplicado: nivel1organizacion = "$valorUnidad"');
    }

    // 3. FILTRO CLASE DE ACTIVO (CORREGIDO)
    if (filtroClaseActivo != 'TODOS' &&
        filtroClaseActivo != null &&
        filtroClaseActivo!.isNotEmpty) {
      String valorClase = filtroClaseActivo!.trim();
      valorClase = valorClase.replaceAll("'", "''");
      filtrosList.add("clasedeactivo = '$valorClase'");
      debugPrint('🔍 Filtro clase aplicado: clasedeactivo = "$valorClase"');
    }

    // 4. FILTRO POR PERIODO CONTABLE
    if (periodoInicial != null || periodoFinal != null) {
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      if (periodoInicial != null && periodoFinal != null) {
        final inicio =
            DateTime.utc(periodoInicial!.year, periodoInicial!.month, 1);
        final ultimoDia =
            DateTime.utc(periodoFinal!.year, periodoFinal!.month + 1, 0);
        final fin = DateTime.utc(
            ultimoDia.year, ultimoDia.month, ultimoDia.day, 23, 59, 59);
        filtrosList.add(
            "periodocontable >= '${dbFormat.format(inicio)}' && periodocontable <= '${dbFormat.format(fin)}'");
      } else if (periodoInicial != null) {
        final inicio =
            DateTime.utc(periodoInicial!.year, periodoInicial!.month, 1);
        filtrosList.add("periodocontable >= '${dbFormat.format(inicio)}'");
      } else if (periodoFinal != null) {
        final ultimoDia =
            DateTime.utc(periodoFinal!.year, periodoFinal!.month + 1, 0);
        final fin = DateTime.utc(
            ultimoDia.year, ultimoDia.month, ultimoDia.day, 23, 59, 59);
        filtrosList.add("periodocontable <= '${dbFormat.format(fin)}'");
      }
    }

    // 5. FILTRO POR FECHA DE ADQUISICIÓN
    if (fechaAdqInicial != null || fechaAdqFinal != null) {
      final DateFormat dbFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      if (fechaAdqInicial != null && fechaAdqFinal != null) {
        final inicio = DateTime.utc(fechaAdqInicial!.year,
            fechaAdqInicial!.month, fechaAdqInicial!.day);
        final fin = DateTime.utc(fechaAdqFinal!.year, fechaAdqFinal!.month,
            fechaAdqFinal!.day, 23, 59, 59);
        filtrosList.add(
            "fechaadquisicion >= '${dbFormat.format(inicio)}' && fechaadquisicion <= '${dbFormat.format(fin)}'");
      } else if (fechaAdqInicial != null) {
        final inicio = DateTime.utc(fechaAdqInicial!.year,
            fechaAdqInicial!.month, fechaAdqInicial!.day);
        filtrosList.add("fechaadquisicion >= '${dbFormat.format(inicio)}'");
      } else if (fechaAdqFinal != null) {
        final fin = DateTime.utc(fechaAdqFinal!.year, fechaAdqFinal!.month,
            fechaAdqFinal!.day, 23, 59, 59);
        filtrosList.add("fechaadquisicion <= '${dbFormat.format(fin)}'");
      }
    }

    String filtroBienes =
        filtrosList.isNotEmpty ? filtrosList.join(' && ') : "";
    debugPrint('📋 Filtro PocketBase completo: $filtroBienes');

    // =========================================================
    // OBTENCIÓN DE DATOS CON PAGINACIÓN
    // =========================================================
    int pageBienes = 1;
    bool hasMoreBienes = true;
    int totalRegistrosProcesados = 0;

    while (hasMoreBienes) {
      String urlBienesStr =
          '$pbBaseUrl/fastapi/bienesmuebles?page=$pageBienes&perPage=500';
      if (filtroBienes.isNotEmpty) {
        urlBienesStr += '&filter=${Uri.encodeComponent(filtroBienes)}';
      }

      debugPrint('🌐 Consultando página $pageBienes: $urlBienesStr');

      final resBienes = await http.get(
        Uri.parse(urlBienesStr),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (resBienes.statusCode == 200) {
        final decoded = json.decode(resBienes.body);
        final items = decoded['items'] as List;
        totalRegistrosProcesados += items.length;
        debugPrint(
            '📊 Página $pageBienes: ${items.length} registros (total acumulado: $totalRegistrosProcesados)');

        if (pageBienes == 1 &&
            items.isEmpty &&
            (decoded['totalItems'] == 0 || decoded['totalItems'] == null)) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  '⚠️ No se encontraron registros válidos con estos filtros.')));
          return;
        }

        for (var data in items) {
          // =================================================
          // FILTRO: Excluir NO Inventariables (SI el usuario lo pidió)
          // =================================================
          final cotejo =
              (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
          if (excluirNoInventariables && cotejo == 'NO') {
            excluidosNoInventariables++;
            continue;
          }

          // =================================================
          // FILTRO DE UMAS por campo 'depreciable' de PocketBase
          // =================================================
          if (filtroDepreciable != 'TODOS') {
            final depreciableValor =
                (data['depreciable'] ?? '').toString().trim().toUpperCase();
            if (filtroDepreciable == 'MENOR A 20 UMAS' &&
                depreciableValor != 'NO') continue;
            if (filtroDepreciable == 'MAYORES O IGUALES A 20 UMAS' &&
                depreciableValor != 'SI') continue;
          }

          // Obtener clase de activo
          final clase = (data['clasedeactivo'] ?? '').toString().trim();
          if (clase.isEmpty) continue;

          // Obtener valores numéricos
          final double costo =
              (data['importeinicialbien'] as num?)?.toDouble() ?? 0.0;
          final double avaluo = (data['avaluo'] as num?)?.toDouble() ?? 0.0;
          final fechaAdq = _parseFecha(data['fechaadquisicion']);

          // Calcular valor en libros
          double valorEnLibros;
          if (fechaAdq == null || fechaAdq.isBefore(cutoff)) {
            valorEnLibros = (avaluo != 0.0) ? avaluo : costo;
          } else {
            valorEnLibros = (costo != 0.0) ? costo : avaluo;
          }

          // =================================================
          // FILTRO POR PRECIO (Valor en Libros vs UMAS)
          // =================================================
          if (filtroPrecio == 'MENORES A 20 UMAS' && valorEnLibros >= limiteUMA)
            continue;
          if (filtroPrecio == 'MAYOR O IGUAL A 20 UMAS' &&
              valorEnLibros < limiteUMA) continue;

          // Si pasó todos los filtros, agregar al resumen
          clasesReales.add(clase);
          final bucket =
              resumen.putIfAbsent(clase, () => {'bienes': 0, 'valor': 0.0});
          bucket['bienes'] = (bucket['bienes'] as int) + 1;
          bucket['valor'] = (bucket['valor'] as double) + valorEnLibros;
        }

        // Control de paginación
        if (pageBienes >= (decoded['totalPages'] ?? 1)) {
          hasMoreBienes = false;
        } else {
          pageBienes++;
        }
      } else {
        hasMoreBienes = false;
        debugPrint(
            '❌ Error PB bienesmuebles: ${resBienes.statusCode} - ${resBienes.body}');
      }
    }

    debugPrint(
        '✅ Procesamiento completado. Total registros evaluados: $totalRegistrosProcesados');
    debugPrint('📊 Clases encontradas: ${clasesReales.length}');

    // Asegurar que todas las clases tengan entrada en el resumen
    final List<String> listaClases = clasesReales.toList()..sort();
    for (final clase in listaClases) {
      resumen.putIfAbsent(clase, () => {'bienes': 0, 'valor': 0.0});
    }

    // =========================================================
    // 4. GENERACIÓN DE PDF CON REDONDEO CORRECTO (TOTAL = SUMA DE FILAS)
    // =========================================================
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/images/logopjev.png');
    final logoBytes = logoData.buffer.asUint8List();
    final fmt =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
    final clases = resumen.keys.toList()..sort();

    // Construir las filas de la tabla y calcular totales redondeados
    List<pw.TableRow> filasData = [];
    int totalBienesRedondeado = 0;
    double totalValorRedondeado = 0.0;

    for (final clase in clases) {
      final row = resumen[clase]!;
      final bienes = row['bienes'] as int;
      final valorRaw = row['valor'] as double;
      final valorRedondo = _roundTo2Decimals(valorRaw);

      totalBienesRedondeado += bienes;
      totalValorRedondeado += valorRedondo;

      filasData.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(clase, style: const pw.TextStyle(fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                child:
                    pw.Text('$bienes', style: const pw.TextStyle(fontSize: 9)),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(fmt.format(valorRedondo),
                    style: const pw.TextStyle(fontSize: 9)),
              ),
            ),
          ],
        ),
      );
    }

    // Redondear el total final por si la suma acumuló un epsilon mínimo
    totalValorRedondeado = _roundTo2Decimals(totalValorRedondeado);

    // Función para el encabezado (sin cambios)
    String getPeriodoTexto() {
      if (periodoInicial == null && periodoFinal == null) return '';
      if (periodoInicial != null && periodoFinal != null) {
        if (periodoInicial!.year == periodoFinal!.year &&
            periodoInicial!.month == periodoFinal!.month) {
          return 'PERIODO CONTABLE: ${_nombreMes(periodoInicial!.month)} - ${periodoInicial!.year}';
        } else {
          return 'PERIODO CONTABLE: ${_nombreMes(periodoInicial!.month)} - ${periodoInicial!.year} a ${_nombreMes(periodoFinal!.month)} - ${periodoFinal!.year}';
        }
      } else if (periodoInicial != null) {
        return 'PERIODO CONTABLE (DESDE): ${_nombreMes(periodoInicial!.month)} - ${periodoInicial!.year}';
      } else if (periodoFinal != null) {
        return 'PERIODO CONTABLE (HASTA): ${_nombreMes(periodoFinal!.month)} - ${periodoFinal!.year}';
      }
      return '';
    }

    pw.Widget buildHeader(pw.Context context) {
      final fechaHoraElaboracionStr = (fechaElaboracion != null)
          ? DateFormat('dd/MM/yyyy HH:mm').format(fechaElaboracion!)
          : DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      final tituloBase = (filtroNivel1 != 'TODOS')
          ? 'RESUMEN DE VALOR EN LIBROS - $filtroNivel1'
          : 'RESUMEN GENERAL DE VALOR EN LIBROS POR CLASE DE ACTIVO';

      final periodoTexto = getPeriodoTexto();

      List<String> filtrosExtra = [];
      if (filtroDepreciable != 'TODOS')
        filtrosExtra.add('FILTRO UMA: $filtroDepreciable');
      if (filtroPrecio != 'TODOS') filtrosExtra.add('PRECIO: $filtroPrecio');
      if (filtroAnexo != 'TODOS') filtrosExtra.add('ANEXO: $filtroAnexo');
      if (filtroClaseActivo != 'TODOS')
        filtrosExtra.add('CLASE: $filtroClaseActivo');

      String textoFiltrosExtra = filtrosExtra.join(' | ');

      return pw.Column(
        children: [
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
                  pw.Text(tituloBase,
                      style: pw.TextStyle(
                          fontSize: 11, fontWeight: pw.FontWeight.bold)),
                  if (textoFiltrosExtra.isNotEmpty) ...[
                    pw.SizedBox(height: 3),
                    pw.Text(textoFiltrosExtra,
                        style: pw.TextStyle(
                            fontSize: 9, fontWeight: pw.FontWeight.normal)),
                  ],
                  if (periodoTexto.isNotEmpty) ...[
                    pw.SizedBox(height: 3),
                    pw.Text(periodoTexto,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.normal)),
                  ],
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Fecha y hora de elaboración:',
                      style: pw.TextStyle(fontSize: 8)),
                  pw.Text(fechaHoraElaboracionStr,
                      style: pw.TextStyle(fontSize: 8)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 15),
        ],
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(15),
        header: buildHeader,
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
        build: (context) => [
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(5),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(3),
            },
            children: [
              // Encabezado
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Center(
                          child: pw.Text('CLASE DE ACTIVO',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Center(
                          child: pw.Text('NÚMERO DE BIENES',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Center(
                          child: pw.Text('VALOR EN LIBROS (\$)',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)))),
                ],
              ),
              // Filas de datos (con valores redondeados)
              ...filasData,
              // Fila de total general (usando los acumuladores redondeados)
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('TOTAL GENERAL',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Center(
                          child: pw.Text('$totalBienesRedondeado',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(fmt.format(totalValorRedondeado),
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)))),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    Navigator.of(context).pop();

    // Mostrar SnackBar con los totales redondeados (consistentes con el PDF)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '✅ PDF generado correctamente\n'
        'Unidad: $filtroNivel1 | Filtro UMA: $filtroDepreciable | Precio: $filtroPrecio\n'
        'Bienes: $totalBienesRedondeado | Valor total: ${fmt.format(totalValorRedondeado)}\n'
        'Excluidos (NO inventariables): $excluidosNoInventariables',
      ),
      duration: const Duration(seconds: 8),
      backgroundColor: customGreen,
    ));

    final sufijo = (filtroNivel1 != 'TODOS')
        ? '_${filtroNivel1!.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}'
        : '';

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

    final fileName =
        'ResumenValorEnLibros${sufijo}${periodoSufijo}${fechaAdqSufijo}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);
  } catch (e, st) {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    debugPrint('❌ Error al generar reporte: $e\n$st');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('❌ Error: $e'),
      backgroundColor: Colors.red,
    ));
  }
}
