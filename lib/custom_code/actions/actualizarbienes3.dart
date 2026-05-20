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
import '/custom_code/actions/index.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

Future<bool> actualizarbienes3(
  BuildContext context,
  String authToken,
) async {
  const Color customGreen = Color(0xFF164b2d);
  bool registroExitoso = false;

  // CAMBIO 1: periodoContable reemplaza a anioFiscalController
  // Se inicializa con el mes y año en curso (día fijo en 1)
  DateTime periodoContable =
      DateTime(DateTime.now().year, DateTime.now().month, 1);

  final idAnteriorController = TextEditingController();
  final nombreBienController = TextEditingController();
  final descripcionController = TextEditingController();
  final proveedorController = TextEditingController();
  final noPartidaController = TextEditingController();
  final facturaController = TextEditingController();
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
  String recursoSeleccionado = 'ESTATAL';

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
                        // CAMBIO 2: El campo ID-INVENTARIO ya no se captura manualmente.
                        // Se muestra como solo lectura indicando que se asignará automáticamente.
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.shade100,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.tag,
                                    size: 18, color: Colors.grey.shade500),
                                const SizedBox(width: 8),
                                Text(
                                  'ID - INVENTARIO (AUTO)',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _txt(idAnteriorController, "ID - ANTERIOR",
                                Icons.history)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // CAMBIO 1: Selector de mes/año "PERIODO CONTABLE"
                        Expanded(
                          child: _monthYearPicker(
                            contextBuilder,
                            periodoContable,
                            (DateTime seleccionado) =>
                                setState(() => periodoContable = seleccionado),
                          ),
                        ),
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
                    _txt(noPartidaController, "No. DE PARTIDA",
                        Icons.format_list_numbered),
                    _txt(facturaController, "FACTURA",
                        Icons.receipt), // <-- NUEVO CAMPO
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
                      final db = FirebaseFirestore.instance;

                      // ─────────────────────────────────────────────────────
                      // CAMBIO 2: Asignar inventario2025 con transacción atómica
                      // sobre el documento único de la colección "controlid".
                      // Se hace aquí, al último momento, para minimizar colisiones.
                      // ─────────────────────────────────────────────────────
                      String nuevoInventarioId = '';

                      final controlIdQuery =
                          await db.collection('controlid').limit(1).get();
                      if (controlIdQuery.docs.isEmpty) {
                        Navigator.pop(contextBuilder);
                        showError(contextBuilder,
                            'No se encontró el documento de control de IDs.');
                        return;
                      }
                      final controlIdDocRef =
                          controlIdQuery.docs.first.reference;

                      await db.runTransaction((transaction) async {
                        final snapshot = await transaction.get(controlIdDocRef);
                        final snapshotData =
                            snapshot.data() as Map<String, dynamic>? ?? {};
                        final ultimoIdStr =
                            (snapshotData['ultimoid'] ?? '0').toString();
                        final nuevoId = (int.tryParse(ultimoIdStr) ?? 0) + 1;
                        nuevoInventarioId = nuevoId.toString();
                        transaction.update(controlIdDocRef, {
                          'ultimoid': nuevoInventarioId,
                          'fechaultimaasignacion': Timestamp.now(),
                          'quienasignoultimo':
                              currentUserDisplayName ?? 'Sistema',
                        });
                      });

                      // ─────────────────────────────────────────────────────
                      // CAMBIO 3: Leer numerobienes al último momento y preparar
                      // el incremento (se ejecuta con FieldValue.increment al final)
                      // ─────────────────────────────────────────────────────
                      final contadorQuery = await db
                          .collection('archivocontrolinventarios')
                          .limit(1)
                          .get();
                      if (contadorQuery.docs.isEmpty) {
                        Navigator.pop(contextBuilder);
                        showError(contextBuilder,
                            'No se encontró el documento de control de inventarios.');
                        return;
                      }
                      final contadorDocRef = contadorQuery.docs.first.reference;

                      // ─────────────────────────────────────────────────────
                      // Construcción del mapa de datos principal
                      // CAMBIO 1: periodocontable como Timestamp (día 1 del mes)
                      // CAMBIO 2: inventario2025 asignado automáticamente
                      // Sin aniofiscal
                      // ─────────────────────────────────────────────────────
                      final Map<String, dynamic> data = {
                        'inventario2025': nuevoInventarioId,
                        'numeroinventario': idAnteriorController.text.trim(),
                        'nombre': nombreBienController.text.trim(),
                        'descripciondelbien': descripcionController.text.trim(),
                        'nombredelprovedor': proveedorController.text.trim(),
                        'recurso': recursoSeleccionado,
                        'nopartida': noPartidaController.text.trim(),
                        'factura':
                            facturaController.text.trim(), // <-- NUEVO CAMPO
                        'importeinicialbien': imp,
                        'avaluo': ava,
                        'fechaadquisicion': fechaAdq != null
                            ? Timestamp.fromDate(fechaAdq!)
                            : null,
                        'fechaavaluo': fechaAva != null
                            ? Timestamp.fromDate(fechaAva!)
                            : null,
                        // CAMBIO 1: periodocontable guarda día 1 del mes seleccionado
                        'periodocontable': Timestamp.fromDate(periodoContable),
                        'anexo': 'ANEXO 3',
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

                      final docRefBien = db.collection('bienesmuebles').doc();
                      await docRefBien.set(data);

                      // CAMBIO 3: Incrementar numerobienes en 1 tras guardar el bien
                      await contadorDocRef.update({
                        'numerobienes': FieldValue.increment(1),
                      });

                      Map<String, dynamic> apiData = Map.from(data);
                      apiData['fechaadquisicion'] = fechaAdq?.toIso8601String();
                      apiData['fechaavaluo'] = fechaAva?.toIso8601String();
                      // CAMBIO 1: serializar periodocontable para la API
                      apiData['periodocontable'] =
                          periodoContable.toIso8601String();
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
                            final depSnapshot =
                                await db.collection('depreciacion').get();
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
                              WriteBatch depBatch = db.batch();
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

                                  final docRefDep = db
                                      .collection('calculodepreciacion')
                                      .doc();
                                  final mapDep = {
                                    'inventario2025': nuevoInventarioId,
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
                      Navigator.pop(contextBuilder);
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

// ─────────────────────────────────────────────────────────────────────────────
// CAMBIO 1: Widget selector de mes y año (calendario de meses)
// Muestra un diálogo con grid de meses y selector de año con flechas.
// ─────────────────────────────────────────────────────────────────────────────
Widget _monthYearPicker(
  BuildContext ctx,
  DateTime actual,
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
      int anioTemp = actual.year;
      int mesTemp = actual.month;

      await showDialog(
        context: ctx,
        builder: (dialogCtx) {
          return StatefulBuilder(
            builder: (dialogCtx, setStateDialog) {
              return AlertDialog(
                title: const Text(
                  'PERIODO CONTABLE',
                  style: TextStyle(
                      color: customGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                content: SizedBox(
                  width: 280,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Selector de año con flechas
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
                          final esMesSeleccionado =
                              (index + 1) == mesTemp && anioTemp == actual.year
                                  ? mesTemp == actual.month
                                  : false;
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
                      onSeleccionado(DateTime(anioTemp, mesTemp, 1));
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
              Text(
                'PERIODO CONTABLE',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              Text(
                DateFormat('MM/yyyy').format(actual),
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
          const Icon(Icons.calendar_month, size: 16, color: Color(0xFF164b2d)),
        ],
      ),
    ),
  );
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
