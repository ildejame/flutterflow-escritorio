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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

Future<bool> actualizarbien(
  BuildContext context,
  String authToken,
) async {
  const Color customGreen = Color(0xFF164b2d);
  final firestore = FirebaseFirestore.instance;

  // ───────────────────────────────────────────────────────────────────────────
  // 1. Diálogo para ingresar ID de inventario
  // ───────────────────────────────────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();
  final String? inventarioBuscadoRaw = await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: const Text('Buscar Bien por ID-Inventario'),
        content: TextField(
          controller: searchController,
          autofocus: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'ID Inventario',
            hintText: 'Escanee o teclee el código',
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: customGreen, width: 2),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => searchController.clear(),
            ),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.of(context).pop(value.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            style: TextButton.styleFrom(foregroundColor: customGreen),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.trim().isNotEmpty) {
                Navigator.of(context).pop(searchController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: customGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('ACEPTAR'),
          ),
        ],
      );
    },
  );

  if (inventarioBuscadoRaw == null || inventarioBuscadoRaw.isEmpty)
    return false;
  final String inventarioBuscado =
      inventarioBuscadoRaw.trim().replaceAll(RegExp(r'\s+'), '');

  // ───────────────────────────────────────────────────────────────────────────
  // 2. Cargar el bien desde Firestore
  // ───────────────────────────────────────────────────────────────────────────
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          SizedBox(width: 20),
          Expanded(child: Text('Buscando información del bien...')),
        ],
      ),
    ),
  );

  QuerySnapshot<Map<String, dynamic>> snapshot;
  try {
    snapshot = await firestore
        .collection('bienesmuebles')
        .where('inventario2025', isEqualTo: inventarioBuscado)
        .limit(1)
        .get();
  } catch (e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    return false;
  }

  Navigator.of(context).pop();

  if (snapshot.docs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            '⚠️ No se encontró el número de inventario en la base de datos.')));
    return false;
  }

  final doc = snapshot.docs.first;
  final data = doc.data();

  // ───────────────────────────────────────────────────────────────────────────
  // 3. Verificar si el usuario actual es Administrador
  // ───────────────────────────────────────────────────────────────────────────
  bool esAdministrador = false;
  try {
    final userDoc =
        await firestore.collection('users').doc(currentUserUid).get();
    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      esAdministrador =
          (userData['permiso'] ?? '').toString().trim() == 'Administrador';
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Error al verificar permisos: $e'),
          backgroundColor: Colors.red),
    );
    return false;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // 4. Preparar controladores y valores iniciales
  // ───────────────────────────────────────────────────────────────────────────
  final String idAnterior = (data['numeroinventario'] ?? '').toString();
  final String nombreBien = (data['nombre'] ?? '').toString();
  final String quienModificoValue =
      (data['quienmodifico'] ?? 'Sin registro').toString();

  String formatCustomDate(DateTime d) {
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];
    String ampm = d.hour >= 12 ? 'p.m.' : 'a.m.';
    int h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    String m = d.minute.toString().padLeft(2, '0');
    String s = d.second.toString().padLeft(2, '0');
    return "${d.day} de ${meses[d.month - 1]} de ${d.year} a las $h:$m:$s $ampm";
  }

  final String fechaModificoValue = data['fechaultimamodificacion'] != null
      ? formatCustomDate(
          (data['fechaultimamodificacion'] as Timestamp).toDate())
      : 'Sin fecha';

  String estatusActualDB =
      (data['estatusdelbien'] ?? '').toString().toUpperCase();
  String estatusSeleccionado = estatusActualDB.contains('REGULAR')
      ? 'REGULAR'
      : estatusActualDB.contains('MAL')
          ? 'MAL ESTADO'
          : estatusActualDB.contains('INSERVIBLE')
              ? 'INSERVIBLE'
              : 'BUEN ESTADO';
  String anexoActualDB = (data['anexo'] ?? '').toString().toUpperCase();
  String anexoSeleccionado =
      ['ANEXO 1', 'ANEXO 2', 'ANEXO 4'].contains(anexoActualDB)
          ? anexoActualDB
          : 'ANEXO 1';

  final TextEditingController titularController =
      TextEditingController(text: (data['tituladelbien'] ?? '').toString());
  final TextEditingController depositarioController =
      TextEditingController(text: (data['depositario'] ?? '').toString());
  final TextEditingController nivel1Controller = TextEditingController(
      text: (data['nivel1organizacion'] ?? '').toString());
  final TextEditingController nivel2Controller =
      TextEditingController(text: (data['nivel2direccion'] ?? '').toString());
  final TextEditingController nivel3Controller = TextEditingController(
      text: (data['nivel3jurisdiccion'] ?? '').toString());
  final TextEditingController colorController =
      TextEditingController(text: (data['color'] ?? '').toString());
  final TextEditingController ubicacionController =
      TextEditingController(text: (data['ubicacionfisica'] ?? '').toString());

  bool exitoFinal = false;

  // ───────────────────────────────────────────────────────────────────────────
  // 5. Diálogo de edición con campo Nivel 1 condicional
  // ───────────────────────────────────────────────────────────────────────────
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Actualizar Información del Bien'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID INVENTARIO: $inventarioBuscado',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('ID-ANTERIOR: $idAnterior',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('MODIFICADO POR: $quienModificoValue',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('ÚLTIMA MODIFICACIÓN: $fechaModificoValue',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Text('BIEN: $nombreBien',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  const Text('DEPOSITARIO',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  Autocomplete<String>(
                    initialValue:
                        TextEditingValue(text: titularController.text),
                    optionsBuilder: (val) => FFAppState().idempleadosAPI.where(
                        (s) =>
                            s.toLowerCase().contains(val.text.toLowerCase())),
                    onSelected: (s) => titularController.text = s,
                    fieldViewBuilder: (context, ctrl, node, onSub) => TextField(
                      controller: ctrl,
                      focusNode: node,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Buscar depositario...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            ctrl.clear();
                            titularController.clear();
                          },
                        ),
                      ),
                      onChanged: (v) => titularController.text = v,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('USUARIO',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  Autocomplete<String>(
                    initialValue:
                        TextEditingValue(text: depositarioController.text),
                    optionsBuilder: (val) => FFAppState().idempleadosAPI.where(
                        (s) =>
                            s.toLowerCase().contains(val.text.toLowerCase())),
                    onSelected: (s) => depositarioController.text = s,
                    fieldViewBuilder: (context, ctrl, node, onSub) => TextField(
                      controller: ctrl,
                      focusNode: node,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Buscar usuario...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            ctrl.clear();
                            depositarioController.clear();
                          },
                        ),
                      ),
                      onChanged: (v) => depositarioController.text = v,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ─── NIVEL 1 (ORGANIZACIÓN) con restricción de administrador ───
                  const Text('NIVEL 1 (ORGANIZACIÓN)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  if (esAdministrador)
                    Autocomplete<String>(
                      initialValue:
                          TextEditingValue(text: nivel1Controller.text),
                      optionsBuilder: (val) => FFAppState().sugerenciasN1.where(
                          (s) =>
                              s.toLowerCase().contains(val.text.toLowerCase())),
                      onSelected: (s) => nivel1Controller.text = s,
                      fieldViewBuilder: (context, ctrl, node, onSub) =>
                          TextField(
                        controller: ctrl,
                        focusNode: node,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Buscar nivel 1...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              ctrl.clear();
                              nivel1Controller.clear();
                            },
                          ),
                        ),
                        onChanged: (v) => nivel1Controller.text = v,
                      ),
                    )
                  else
                    Tooltip(
                      message: 'Requiere permiso de Administrador',
                      child: TextFormField(
                        controller: nivel1Controller,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Nivel 1 (solo lectura)',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          suffixIcon: const Icon(Icons.lock_outline,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  const Text('NIVEL 2 (DIRECCIÓN)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  Autocomplete<String>(
                    initialValue: TextEditingValue(text: nivel2Controller.text),
                    optionsBuilder: (val) => FFAppState().sugerenciasN2.where(
                        (s) =>
                            s.toLowerCase().contains(val.text.toLowerCase())),
                    onSelected: (s) => nivel2Controller.text = s,
                    fieldViewBuilder: (context, ctrl, node, onSub) => TextField(
                      controller: ctrl,
                      focusNode: node,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Buscar nivel 2...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            ctrl.clear();
                            nivel2Controller.clear();
                          },
                        ),
                      ),
                      onChanged: (v) => nivel2Controller.text = v,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('NIVEL 3 (JURISDICCIÓN)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  Autocomplete<String>(
                    initialValue: TextEditingValue(text: nivel3Controller.text),
                    optionsBuilder: (val) => FFAppState().sugerenciasN3.where(
                        (s) =>
                            s.toLowerCase().contains(val.text.toLowerCase())),
                    onSelected: (s) => nivel3Controller.text = s,
                    fieldViewBuilder: (context, ctrl, node, onSub) => TextField(
                      controller: ctrl,
                      focusNode: node,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Buscar nivel 3...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            ctrl.clear();
                            nivel3Controller.clear();
                          },
                        ),
                      ),
                      onChanged: (v) => nivel3Controller.text = v,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('ESTADO',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  DropdownButtonFormField<String>(
                    value: estatusSeleccionado,
                    isExpanded: true,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    items: [
                      'BUEN ESTADO',
                      'REGULAR',
                      'MAL ESTADO',
                      'INSERVIBLE'
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => estatusSeleccionado = val!),
                  ),
                  const SizedBox(height: 16),

                  const Text('ANEXO',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  DropdownButtonFormField<String>(
                    value: anexoSeleccionado,
                    isExpanded: true,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    items: ['ANEXO 1', 'ANEXO 2', 'ANEXO 4']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => anexoSeleccionado = val!),
                  ),
                  const SizedBox(height: 16),

                  const Text('COLOR',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  TextField(
                      controller: colorController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Agregar color',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => colorController.clear(),
                        ),
                      )),
                  const SizedBox(height: 16),

                  const Text('UBICACIÓN FÍSICA',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: customGreen)),
                  TextField(
                      controller: ubicacionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Agregar ubicación',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => ubicacionController.clear(),
                        ),
                      )),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CANCELAR',
                      style: TextStyle(color: customGreen))),
              ElevatedButton(
                onPressed: () async {
                  bool confirmar = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('¿Confirmar?'),
                          content: const Text(
                              'Se actualizarán los datos en la base de datos.'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('NO')),
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('SÍ')),
                          ],
                        ),
                      ) ??
                      false;

                  if (confirmar) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(customGreen)),
                            SizedBox(width: 20),
                            Expanded(
                                child: Text('Actualizando información...')),
                          ],
                        ),
                      ),
                    );

                    try {
                      // ─── Actualización en Firestore ──────────────────────────
                      final Map<String, dynamic> updateData = {
                        'tituladelbien': titularController.text.trim(),
                        'depositario': depositarioController.text.trim(),
                        'nivel2direccion': nivel2Controller.text.trim(),
                        'nivel3jurisdiccion': nivel3Controller.text.trim(),
                        'estatusdelbien': estatusSeleccionado,
                        'anexo': anexoSeleccionado,
                        'color': colorController.text.trim(),
                        'ubicacionfisica': ubicacionController.text.trim(),
                        'quienmodifico': currentUserDisplayName,
                        'fechaultimamodificacion': FieldValue.serverTimestamp(),
                      };
                      if (esAdministrador) {
                        updateData['nivel1organizacion'] =
                            nivel1Controller.text.trim();
                      }
                      await doc.reference.update(updateData);

                      // ─── Actualizar unidad presupuestal en depreciación solo si es admin ───
                      if (esAdministrador) {
                        final depreciacionSnap = await firestore
                            .collection('calculodepreciacion')
                            .where('inventario2025',
                                isEqualTo: inventarioBuscado)
                            .get();
                        for (var depDoc in depreciacionSnap.docs) {
                          await depDoc.reference.update({
                            'unidadpresupuestal': nivel1Controller.text.trim(),
                          });
                        }
                      }

                      // ─── Sincronización con PocketBase API ────────────────────
                      final String inv = inventarioBuscado.trim();
                      final searchUrl =
                          'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/?filter=(inventario2025%3D%22$inv%22)';
                      final searchResp = await http.get(
                        Uri.parse(searchUrl),
                        headers: {'Authorization': 'Bearer $authToken'},
                      );

                      if (searchResp.statusCode == 200) {
                        final searchData = jsonDecode(searchResp.body);
                        if (searchData['items'] != null &&
                            searchData['items'].isNotEmpty) {
                          final String realId = searchData['items'][0]['id'];
                          final patchUrl =
                              'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/$realId';

                          final Map<String, dynamic> patchData = {
                            'tituladelbien': titularController.text.trim(),
                            'depositario': depositarioController.text.trim(),
                            'nivel2direccion': nivel2Controller.text.trim(),
                            'nivel3jurisdiccion': nivel3Controller.text.trim(),
                            'estatusdelbien': estatusSeleccionado,
                            'anexo': anexoSeleccionado,
                            'color': colorController.text.trim(),
                            'ubicacionfisica': ubicacionController.text.trim(),
                            'quienmodifico':
                                currentUserDisplayName ?? 'Sistema',
                            'fechaultimamodificacion':
                                DateTime.now().toIso8601String(),
                          };
                          if (esAdministrador) {
                            patchData['nivel1organizacion'] =
                                nivel1Controller.text.trim();
                          }

                          final patchResp = await http
                              .patch(
                                Uri.parse(patchUrl),
                                headers: {
                                  'Authorization': 'Bearer $authToken',
                                  'Content-Type': 'application/json',
                                },
                                body: jsonEncode(patchData),
                              )
                              .timeout(const Duration(seconds: 15));

                          if (patchResp.statusCode == 200 ||
                              patchResp.statusCode == 204) {
                            // Actualizar cálculo de depreciación solo si es admin
                            if (esAdministrador) {
                              final searchDepUrl =
                                  'https://api.servidor-inventarios.xyz/fastapi/calculodepreciacion/?filter=(inventario2025%3D%22$inv%22)';
                              final searchDepResp = await http.get(
                                Uri.parse(searchDepUrl),
                                headers: {'Authorization': 'Bearer $authToken'},
                              );
                              if (searchDepResp.statusCode == 200) {
                                final searchDepData =
                                    jsonDecode(searchDepResp.body);
                                if (searchDepData['items'] != null &&
                                    searchDepData['items'].isNotEmpty) {
                                  for (var item in searchDepData['items']) {
                                    final String realIdDep = item['id'];
                                    final patchDepUrl =
                                        'https://api.servidor-inventarios.xyz/fastapi/calculodepreciacion/$realIdDep';
                                    final patchDepResp = await http
                                        .patch(
                                          Uri.parse(patchDepUrl),
                                          headers: {
                                            'Authorization':
                                                'Bearer $authToken',
                                            'Content-Type': 'application/json',
                                          },
                                          body: jsonEncode({
                                            'unidadpresupuestal':
                                                nivel1Controller.text.trim(),
                                          }),
                                        )
                                        .timeout(const Duration(seconds: 15));
                                    if (patchDepResp.statusCode != 200 &&
                                        patchDepResp.statusCode != 204) {
                                      throw Exception(
                                          "Error PATCH en calculodepreciacion: ${patchDepResp.statusCode}");
                                    }
                                  }
                                }
                              } else {
                                throw Exception(
                                    "Error GET en calculodepreciacion: ${searchDepResp.statusCode}");
                              }
                            }

                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('✅ Sincronización exitosa'),
                                    backgroundColor: customGreen));
                            exitoFinal = true;
                          } else {
                            throw Exception(
                                "Error PATCH en bienesmuebles: ${patchResp.statusCode}");
                          }
                        } else {
                          throw Exception(
                              "El inventario $inv no existe en el servidor externo.");
                        }
                      } else {
                        throw Exception(
                            "Error de búsqueda en bienesmuebles (GET): ${searchResp.statusCode}");
                      }
                    } catch (e) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('❌ Error en actualización: $e')));
                    }
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white),
                child: const Text('ACTUALIZAR'),
              ),
            ],
          );
        },
      );
    },
  );

  return exitoFinal;
}
