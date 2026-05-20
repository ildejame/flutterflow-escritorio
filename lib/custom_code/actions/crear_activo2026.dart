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
// Imports custom functions

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

Future<bool> crearActivo2026(
  BuildContext context,
  String authToken,
) async {
  const Color customGreen = Color(0xFF164b2d);
  bool registroExitoso = false;

  final inv2025Controller = TextEditingController();
  final idAnteriorController = TextEditingController();
  final anioFiscalController =
      TextEditingController(text: DateTime.now().year.toString());

  final nombreBienController = TextEditingController();
  final descripcionController = TextEditingController();
  final proveedorController = TextEditingController();
  final noPartidaController =
      TextEditingController(); // NUEVO: Controlador No. de Partida
  final marcaController = TextEditingController();
  final modeloController = TextEditingController();
  final serieController = TextEditingController();

  final serieTecladoController = TextEditingController();
  final serieMouseController = TextEditingController();
  final colorController = TextEditingController();
  final importeController = TextEditingController(text: '0');

  final avaluoController = TextEditingController(text: '0');
  final titularController = TextEditingController();
  final depositarioController = TextEditingController();
  final nivel1Controller = TextEditingController();

  final nivel2Controller = TextEditingController();
  final nivel3Controller = TextEditingController();
  final ubicacionController = TextEditingController();

  final claseActivoController =
      TextEditingController(text: '511 MUEBLES DE OFICINA Y ESTANTERÍA');

  DateTime? fechaAdq;
  DateTime? fechaAva;

  String estatusSeleccionado = 'BUENO';
  String esInventariable = 'SI';
  String esDepreciable = 'NO';
  String recursoSeleccionado = 'FEDERAL';

  void showError(BuildContext contextError, String mensaje) {
    showDialog(
      context: contextError,
      builder: (c) => AlertDialog(
        title: const Text('Atención',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child:
                const Text('ENTENDIDO', style: TextStyle(color: customGreen)),
          )
        ],
      ),
    );
  }

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (contextBuilder, setState) {
          return AlertDialog(
            title: const Text(
                'Nuevo Registro - Poder Judicial del Estado de Veracruz',
                style:
                    TextStyle(color: customGreen, fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header("CONTROL Y VALORES"),
                    Row(
                      children: [
                        Expanded(
                            child: _txt(inv2025Controller, "ID - INVENTARIO",
                                Icons.tag)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _txt(idAnteriorController, "ID - ANTERIOR",
                                Icons.history)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: _txt(anioFiscalController,
                                "AÑO DE EJERCICIO", Icons.calendar_month,
                                isNum: true)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _drop(
                                "ES BIEN DEPRECIABLE",
                                ["SI", "NO"],
                                esDepreciable,
                                (v) => setState(() => esDepreciable = v!))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: _txt(importeController, "IMPORTE INICIAL",
                                Icons.attach_money,
                                isNum: true)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _date(contextBuilder, "F. ADQUISICIÓN",
                                fechaAdq, (d) => setState(() => fechaAdq = d))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                            child: _txt(avaluoController, "VALOR AVALÚO",
                                Icons.analytics,
                                isNum: true)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _date(contextBuilder, "F. AVALÚO", fechaAva,
                                (d) => setState(() => fechaAva = d))),
                      ],
                    ),
                    _header("DATOS DEL BIEN"),
                    _txt(nombreBienController, "NOMBRE DEL BIEN",
                        Icons.inventory_2),
                    _txt(descripcionController, "DESCRIPCIÓN DETALLADA",
                        Icons.notes),

                    _txt(proveedorController, "NOMBRE DEL PROVEEDOR",
                        Icons.local_shipping),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _drop(
                          "RECURSO",
                          ["ESTATAL", "FEDERAL"],
                          recursoSeleccionado,
                          (v) => setState(() => recursoSeleccionado = v!)),
                    ),
                    // NUEVO CAMPO: No. de Partida
                    _txt(noPartidaController, "No. DE PARTIDA",
                        Icons.format_list_numbered),

                    _label("CLASE DE ACTIVO"),
                    _autoFT(claseActivoController,
                        FFAppState().nombredepreciacion, "Seleccione clase..."),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: _txt(marcaController, "MARCA",
                                Icons.branding_watermark)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _txt(
                                modeloController, "MODELO", Icons.devices)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: _txt(serieController, "SERIE (PRINCIPAL)",
                                Icons.confirmation_number)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _txt(
                                colorController, "COLOR", Icons.color_lens)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: _txt(serieTecladoController, "SERIE TECLADO",
                                Icons.keyboard)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _txt(serieMouseController, "SERIE MOUSE",
                                Icons.mouse)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: _drop(
                                "INVENTARIABLE",
                                ["SI", "NO"],
                                esInventariable,
                                (v) => setState(() => esInventariable = v!))),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _drop(
                                "ESTATUS",
                                ["BUENO", "REGULAR", "MALO", "INSERVIBLE"],
                                estatusSeleccionado,
                                (v) =>
                                    setState(() => estatusSeleccionado = v!))),
                      ],
                    ),
                    _header("UBICACIÓN Y RESGUARDO"),
                    _label("DEPOSITARIO"),
                    _autoFT(titularController, FFAppState().idempleadosAPI,
                        "Seleccione depositario..."),
                    _label("USUARIO"),
                    _autoFT(depositarioController, FFAppState().idempleadosAPI,
                        "Seleccione usuario..."),
                    _label("NIVEL 1 (ORGANIZACIÓN)"),
                    _autoFT(nivel1Controller, FFAppState().sugerenciasN1,
                        "Seleccione nivel 1..."),
                    _label("NIVEL 2 (DIRECCIÓN)"),
                    _autoFT(nivel2Controller, FFAppState().sugerenciasN2,
                        "Seleccione nivel 2..."),
                    _label("NIVEL 3 (JURISDICCIÓN)"),
                    _autoFT(nivel3Controller, FFAppState().sugerenciasN3,
                        "Seleccione nivel 3..."),
                    const SizedBox(height: 10),
                    _txt(ubicacionController, "UBICACIÓN FÍSICA", Icons.map),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(contextBuilder),
                  child: const Text('CANCELAR',
                      style: TextStyle(color: customGreen))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  if (nombreBienController.text.trim().isEmpty) {
                    showError(
                        contextBuilder, "El nombre del bien es obligatorio.");
                    return;
                  }

                  double imp = double.tryParse(importeController.text) ?? 0;
                  double ava = double.tryParse(avaluoController.text) ?? 0;
                  if (imp <= 0 && ava <= 0) {
                    showError(
                        contextBuilder, "Debe ingresar un importe o avalúo.");
                    return;
                  }

                  bool confirmar = await showDialog(
                        context: contextBuilder,
                        builder: (c) => AlertDialog(
                          title: const Text('¿Confirmar Registro?'),
                          content: const Text(
                              'Se creará el registro en la base de datos.'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(c, false),
                                child: const Text('NO')),
                            TextButton(
                                onPressed: () => Navigator.pop(c, true),
                                child: const Text('SÍ')),
                          ],
                        ),
                      ) ??
                      false;

                  if (confirmar) {
                    showDialog(
                      context: contextBuilder,
                      barrierDismissible: false,
                      builder: (_) => const AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(customGreen)),
                            SizedBox(width: 20),
                            Text('Guardando...'),
                          ],
                        ),
                      ),
                    );
                    try {
                      final Map<String, dynamic> data = {
                        'inventario2025': inv2025Controller.text.trim(),
                        'numeroinventario': idAnteriorController.text.trim(),
                        'nombre': nombreBienController.text.trim(),
                        'descripciondelbien': descripcionController.text.trim(),

                        'nombredelprovedor': proveedorController.text.trim(),
                        'recurso': recursoSeleccionado,
                        'nopartida': noPartidaController.text
                            .trim(), // NUEVO: Adición al mapa de datos

                        'importeinicialbien': imp,
                        'avaluo': ava,
                        'fechaadquisicion': fechaAdq != null
                            ? Timestamp.fromDate(fechaAdq!)
                            : null,
                        'fechaavaluo': fechaAva != null
                            ? Timestamp.fromDate(fechaAva!)
                            : null,
                        'aniofiscal': int.tryParse(anioFiscalController.text) ??
                            DateTime.now().year,
                        'anexo': 'ANEXO 1',
                        'clasedeactivo': claseActivoController.text.trim(),
                        'estatusdelbien': estatusSeleccionado,
                        'cotejodoc': esInventariable,
                        'depreciable': esDepreciable,
                        'marcacomercial': marcaController.text.trim(),
                        'modelo': modeloController.text.trim(),
                        'numeroseriedelbien': serieController.text.trim(),
                        'serieteclado': serieTecladoController.text.trim(),
                        'seriemouse': serieMouseController.text.trim(),
                        'color': colorController.text.trim(),
                        'tituladelbien': titularController.text.trim(),
                        'depositario': depositarioController.text.trim(),
                        'nivel1organizacion': nivel1Controller.text.trim(),
                        'nivel2direccion': nivel2Controller.text.trim(),
                        'nivel3jurisdiccion': nivel3Controller.text.trim(),
                        'ubicacionfisica': ubicacionController.text.trim(),
                        'quienmodifico': currentUserDisplayName ?? 'Sistema',
                        'fechaalta': FieldValue.serverTimestamp(),
                      };
                      final docRefBien = FirebaseFirestore.instance
                          .collection('bienesmuebles')
                          .doc();
                      await docRefBien.set(data);

                      Map<String, dynamic> apiData = Map.from(data);
                      apiData['fechaadquisicion'] = fechaAdq?.toIso8601String();
                      apiData['fechaavaluo'] = fechaAva?.toIso8601String();
                      apiData.remove('fechaalta');
                      apiData['fechaalta'] = DateTime.now().toIso8601String();
                      final res = await http
                          .post(
                            Uri.parse(
                                'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles'),
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $authToken'
                            },
                            body: jsonEncode(apiData),
                          )
                          .timeout(const Duration(seconds: 15));
                      if (res.statusCode == 200 ||
                          res.statusCode == 201 ||
                          res.statusCode == 204) {
                        if (esDepreciable == 'SI') {
                          final cutoff2020 = DateTime(2020, 1, 1);
                          bool usarAvaluo = false;

                          if (fechaAdq == null) {
                            usarAvaluo = true;
                          } else if (fechaAdq!.isBefore(cutoff2020)) {
                            if (ava > 0 && fechaAva != null) usarAvaluo = true;
                          } else {
                            if (imp <= 0 && ava > 0 && fechaAva != null)
                              usarAvaluo = true;
                          }

                          double montoBase = usarAvaluo ? ava : imp;
                          DateTime? fechaInicio =
                              usarAvaluo ? fechaAva : fechaAdq;

                          if (montoBase > 0 && fechaInicio != null) {
                            final Map<String, int> vidaUtilMap = {};
                            final depSnapshot = await FirebaseFirestore.instance
                                .collection('depreciacion')
                                .get();
                            for (var doc in depSnapshot.docs) {
                              final dataDep = doc.data();
                              String nombreRaw =
                                  (dataDep['nombre'] ?? '').toString();
                              if (nombreRaw.isEmpty)
                                nombreRaw =
                                    (dataDep['descripcion'] ?? '').toString();
                              final vida =
                                  (dataDep['vidautil'] as num?)?.toInt() ?? 0;
                              if (nombreRaw.isNotEmpty)
                                vidaUtilMap[
                                    _generarClaveComparacion(nombreRaw)] = vida;
                            }

                            String claseLimpia = _generarClaveComparacion(
                                claseActivoController.text.trim());
                            int vidaUtilAnios = 0;

                            if (vidaUtilMap.containsKey(claseLimpia)) {
                              vidaUtilAnios = vidaUtilMap[claseLimpia]!;
                            } else {
                              String sinNumeros = claseLimpia.replaceAll(
                                  RegExp(r'^[0-9]+ '), '');
                              if (vidaUtilMap.containsKey(sinNumeros)) {
                                vidaUtilAnios = vidaUtilMap[sinNumeros]!;
                              } else {
                                for (var entry in vidaUtilMap.entries) {
                                  if (entry.key.contains(claseLimpia) ||
                                      claseLimpia.contains(entry.key)) {
                                    vidaUtilAnios = entry.value;
                                    break;
                                  }
                                }
                              }
                            }

                            if (vidaUtilAnios > 0) {
                              DateTime fechaContable;
                              if (fechaInicio.day > 15) {
                                fechaContable = DateTime(
                                    fechaInicio.year, fechaInicio.month + 1, 1);
                              } else {
                                fechaContable = DateTime(
                                    fechaInicio.year, fechaInicio.month, 1);
                              }

                              final int totalMesesVida = vidaUtilAnios * 12;
                              final double cuotaMensual =
                                  montoBase / totalMesesVida;
                              double sumaDepreciada = 0.0;
                              int mesesAcumulados = 0;
                              int anioCalculo = fechaContable.year;
                              int mesInicioAnual = fechaContable.month;
                              final DateTime fechaActualCalculo =
                                  DateTime.now();
                              WriteBatch depBatch =
                                  FirebaseFirestore.instance.batch();
                              List<Map<String, dynamic>> apiDepList = [];

                              while (mesesAcumulados < totalMesesVida) {
                                int mesesEnEsteAno = 0;
                                if (anioCalculo == fechaContable.year) {
                                  mesesEnEsteAno = 12 - mesInicioAnual + 1;
                                } else {
                                  mesesEnEsteAno = 12;
                                }

                                int mesesRestantes =
                                    totalMesesVida - mesesAcumulados;
                                mesesEnEsteAno =
                                    math.min(mesesEnEsteAno, mesesRestantes);
                                if (mesesEnEsteAno > 0) {
                                  double montoEsteAno;
                                  bool esUltimoTramo =
                                      (mesesAcumulados + mesesEnEsteAno) >=
                                          totalMesesVida;
                                  if (esUltimoTramo) {
                                    montoEsteAno = montoBase - sumaDepreciada;
                                    if (montoEsteAno < 0) montoEsteAno = 0;
                                    montoEsteAno = _round2(montoEsteAno);
                                  } else {
                                    montoEsteAno =
                                        _trunc2(cuotaMensual * mesesEnEsteAno);
                                  }

                                  sumaDepreciada += montoEsteAno;
                                  mesesAcumulados += mesesEnEsteAno;

                                  final docRefDep = FirebaseFirestore.instance
                                      .collection('calculodepreciacion')
                                      .doc();
                                  final mapDep = {
                                    'inventario2025':
                                        inv2025Controller.text.trim(),
                                    'aniodepreciacion': anioCalculo,
                                    'fechacalculo': fechaActualCalculo,
                                    'depreciacion': montoEsteAno,
                                    'precioavaluo': ava,
                                    'preciocosto': imp,
                                    'descripcion':
                                        nombreBienController.text.trim(),
                                    'unidadpresupuestal':
                                        nivel1Controller.text.trim(),
                                    'fechaadquisicion': fechaAdq != null
                                        ? Timestamp.fromDate(fechaAdq!)
                                        : null,
                                    'fechaavaluo': fechaAva != null
                                        ? Timestamp.fromDate(fechaAva!)
                                        : null,
                                    'clasedeactivo':
                                        claseActivoController.text.trim(),
                                    'bien_ref': docRefBien.id,
                                  };
                                  depBatch.set(docRefDep, mapDep);

                                  Map<String, dynamic> apiDepData =
                                      Map.from(mapDep);
                                  apiDepData['fechacalculo'] =
                                      fechaActualCalculo.toIso8601String();
                                  apiDepData['fechaadquisicion'] =
                                      fechaAdq?.toIso8601String();
                                  apiDepData['fechaavaluo'] =
                                      fechaAva?.toIso8601String();
                                  apiDepList.add(apiDepData);
                                }
                                anioCalculo++;
                              }

                              await depBatch.commit();
                              for (var depData in apiDepList) {
                                await http.post(
                                  Uri.parse(
                                      'https://api.servidor-inventarios.xyz/fastapi/calculodepreciacion'),
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer $authToken'
                                  },
                                  body: jsonEncode(depData),
                                );
                              }
                            }
                          }
                        }

                        Navigator.pop(contextBuilder);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('✅ Guardado correctamente'),
                                backgroundColor: customGreen));
                        registroExitoso = true;
                        Navigator.pop(contextBuilder);
                      } else {
                        Navigator.pop(contextBuilder);
                        throw Exception("Error API: ${res.statusCode}");
                      }
                    } catch (e) {
                      showError(contextBuilder, "Error:\n$e");
                    }
                  }
                },
                child: const Text('GUARDAR'),
              ),
            ],
          );
        },
      );
    },
  );
  return registroExitoso;
}

Widget _header(String t) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(t,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.2)));
Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Text(t,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF164b2d),
            fontSize: 12)));
Widget _txt(TextEditingController c, String l, IconData i,
        {bool isNum = false, int maxLines = 1}) =>
    Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TextFormField(
            controller: c,
            keyboardType: isNum ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: l,
              prefixIcon: Icon(i, size: 18, color: const Color(0xFF164b2d)),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => c.clear()),
            )));
Widget _autoFT(TextEditingController ctrl, List<String> options, String hint) =>
    Autocomplete<String>(
        initialValue: TextEditingValue(text: ctrl.text),
        optionsBuilder: (val) => options
            .where((s) => s.toLowerCase().contains(val.text.toLowerCase())),
        onSelected: (s) => ctrl.text = s,
        fieldViewBuilder: (context, fieldCtrl, node, onSub) {
          if (fieldCtrl.text != ctrl.text) fieldCtrl.text = ctrl.text;
          return TextField(
            controller: fieldCtrl,
            focusNode: node,
            onChanged: (v) => ctrl.text = v,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    fieldCtrl.clear();
                    ctrl.clear();
                  }),
            ),
          );
        });

Widget _drop(String l, List<String> items, String cur, Function(String?) onC) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      DropdownButtonFormField<String>(
          value: cur,
          isExpanded: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10)),
          onChanged: onC,
          items: items
              .map((i) => DropdownMenuItem(
                  value: i,
                  child: Text(i, style: const TextStyle(fontSize: 12))))
              .toList())
    ]);
Widget _date(BuildContext ctx, String l, DateTime? d, Function(DateTime) onP) =>
    InkWell(
        onTap: () async {
          DateTime? p = await showDatePicker(
            context: ctx,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            builder: (context, child) => Theme(
                data: ThemeData.light().copyWith(
                    colorScheme:
                        const ColorScheme.light(primary: Color(0xFF164b2d))),
                child: child!),
          );
          if (p != null) onP(p);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(d == null ? l : DateFormat('dd/MM/yyyy').format(d),
                  style: TextStyle(
                      fontSize: 12,
                      color: d == null ? Colors.grey[600] : Colors.black)),
              const Icon(Icons.calendar_today,
                  size: 16, color: Color(0xFF164b2d)),
            ],
          ),
        ));
String _generarClaveComparacion(String texto) {
  if (texto.isEmpty) return '';
  String t = texto.toUpperCase();
  t = t.replaceAll('\u00A0', ' ').replaceAll('\u200B', '');
  t = t
      .replaceAll('Á', 'A')
      .replaceAll('É', 'E')
      .replaceAll('Í', 'I')
      .replaceAll('Ó', 'O')
      .replaceAll('Ú', 'U')
      .replaceAll('Ü', 'U')
      .replaceAll('Ñ', 'N');
  t = t.replaceAll(RegExp(r'[^A-Z0-9 ]'), '');
  t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
  return t;
}

double _trunc2(double val) => (val * 100).truncateToDouble() / 100;
double _round2(double val) => (val * 100).roundToDouble() / 100;
