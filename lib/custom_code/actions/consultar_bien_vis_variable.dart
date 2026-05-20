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

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<bool> consultarBienVisVariable(
  BuildContext context,
  String authToken,
  String idInventario,
) async {
  const Color customGreen = Color(0xFF164b2d);

  // Verificamos que el ID no venga vacío
  if (idInventario.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('⚠️ El ID de inventario proporcionado está vacío.')),
    );
    return false;
  }

  // Limpiamos el ID de espacios en blanco
  final String inventarioBuscado =
      idInventario.trim().replaceAll(RegExp(r'\s+'), '');

  // Mostramos indicador de carga
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          SizedBox(width: 20),
          Expanded(child: Text('Consultando información en el servidor...')),
        ],
      ),
    ),
  );

  Map<String, dynamic>? data;

  // 1. Consulta a PocketBase / FastAPI usando el parámetro idInventario
  try {
    final searchUrl =
        'https://api.servidor-inventarios.xyz/fastapi/bienesmuebles/?filter=(inventario2025%3D%22$inventarioBuscado%22)';
    final searchResp = await http.get(
      Uri.parse(searchUrl),
      headers: {'Authorization': 'Bearer $authToken'},
    ).timeout(const Duration(seconds: 15));

    if (Navigator.canPop(context)) {
      Navigator.of(context).pop(); // Cerrar indicador de carga
    }

    if (searchResp.statusCode == 200) {
      final searchData = jsonDecode(searchResp.body);
      if (searchData['items'] != null && searchData['items'].isNotEmpty) {
        data = searchData['items'][0];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('⚠️ No se encontró el registro con el ID especificado.')));
        return false;
      }
    } else {
      throw Exception('Error en API: ${searchResp.statusCode}');
    }
  } catch (e) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al conectar con el servidor: $e')));
    return false;
  }

  if (data == null) return false;

  // Funciones auxiliares para formato de fechas y periodos
  String dateToStr(dynamic val) {
    if (val == null || val.toString().isEmpty) return 'N/A';
    try {
      DateTime dt = DateTime.parse(val.toString());
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (e) {
      return val.toString();
    }
  }

  String monthYearToStr(dynamic val) {
    if (val == null || val.toString().isEmpty) return 'N/A';
    try {
      DateTime dt = DateTime.parse(val.toString());
      return DateFormat('MM/yyyy').format(dt);
    } catch (e) {
      return val.toString();
    }
  }

  // 2. Componentes visuales del formulario de Solo Lectura
  Widget _header(String t) => Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(t,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2)));

  Widget _txtRO(String val, String l, IconData i, {int maxLines = 1}) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TextFormField(
              initialValue: (val == 'null' || val.isEmpty) ? 'N/A' : val,
              readOnly: true,
              maxLines: maxLines,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              decoration: InputDecoration(
                labelText: l,
                prefixIcon: Icon(i, size: 18, color: customGreen),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(12),
                fillColor: Colors.grey.shade100,
                filled: true,
              )));

  // 3. Mostrar el formulario con la información encontrada
  await showDialog(
    context: context,
    builder: (contextBuilder) {
      return AlertDialog(
        title: const Text('Detalle del Bien',
            style: TextStyle(color: customGreen, fontWeight: FontWeight.bold)),
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
                        child: _txtRO(
                            (data!['inventario2025'] ?? '').toString(),
                            "ID - INVENTARIO",
                            Icons.tag)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _txtRO(
                            (data!['numeroinventario'] ?? '').toString(),
                            "ID - ANTERIOR",
                            Icons.history)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: _txtRO(monthYearToStr(data!['periodocontable']),
                            "PERIODO CONTABLE", Icons.calendar_month)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _txtRO((data!['depreciable'] ?? '').toString(),
                            "ES BIEN DEPRECIABLE", Icons.trending_down)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: _txtRO(
                            (data!['importeinicialbien'] ?? '0').toString(),
                            "IMPORTE INICIAL",
                            Icons.attach_money)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _txtRO(dateToStr(data!['fechaadquisicion']),
                            "F. ADQUISICIÓN", Icons.calendar_today)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: _txtRO((data!['avaluo'] ?? '0').toString(),
                            "VALOR AVALÚO", Icons.analytics)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _txtRO(dateToStr(data!['fechaavaluo']),
                            "F. AVALÚO", Icons.calendar_today)),
                  ],
                ),
                _header("DATOS DEL BIEN"),
                _txtRO((data!['nombre'] ?? '').toString(), "NOMBRE DEL BIEN",
                    Icons.inventory_2),
                _txtRO((data!['descripciondelbien'] ?? '').toString(),
                    "DESCRIPCIÓN DETALLADA", Icons.notes),
                _txtRO((data!['nombredelprovedor'] ?? '').toString(),
                    "NOMBRE DEL PROVEEDOR", Icons.local_shipping),
                _txtRO((data!['recurso'] ?? '').toString(), "RECURSO",
                    Icons.account_balance),
                _txtRO((data!['nopartida'] ?? '').toString(), "No. DE PARTIDA",
                    Icons.format_list_numbered),
                _txtRO((data!['factura'] ?? '').toString(), "FACTURA",
                    Icons.format_list_numbered),
                _txtRO((data!['clasedeactivo'] ?? '').toString(),
                    "CLASE DE ACTIVO", Icons.category),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _txtRO(
                            (data!['marcacomercial'] ?? '').toString(),
                            "MARCA",
                            Icons.branding_watermark)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _txtRO((data!['modelo'] ?? '').toString(),
                            "MODELO", Icons.devices)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: _txtRO(
                            (data!['numeroseriedelbien'] ?? '').toString(),
                            "SERIE (PRINCIPAL)",
                            Icons.confirmation_number)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _txtRO((data!['color'] ?? '').toString(),
                            "COLOR", Icons.color_lens)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: _txtRO((data!['serieteclado'] ?? '').toString(),
                            "SERIE TECLADO", Icons.keyboard)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _txtRO((data!['seriemouse'] ?? '').toString(),
                            "SERIE MOUSE", Icons.mouse)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _txtRO((data!['cotejodoc'] ?? '').toString(),
                            "INVENTARIABLE", Icons.fact_check)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _txtRO(
                            (data!['estatusdelbien'] ?? '').toString(),
                            "ESTATUS",
                            Icons.info_outline)),
                  ],
                ),
                _header("UBICACIÓN Y RESGUARDO"),
                _txtRO((data!['tituladelbien'] ?? '').toString(), "DEPOSITARIO",
                    Icons.person),
                _txtRO((data!['depositario'] ?? '').toString(), "USUARIO",
                    Icons.person_outline),
                _txtRO((data!['nivel1organizacion'] ?? '').toString(),
                    "NIVEL 1 (ORGANIZACIÓN)", Icons.account_tree),
                _txtRO((data!['nivel2direccion'] ?? '').toString(),
                    "NIVEL 2 (DIRECCIÓN)", Icons.account_tree),
                _txtRO((data!['nivel3jurisdiccion'] ?? '').toString(),
                    "NIVEL 3 (JURISDICCIÓN)", Icons.account_tree),
                const SizedBox(height: 10),
                _txtRO((data!['ubicacionfisica'] ?? '').toString(),
                    "UBICACIÓN FÍSICA", Icons.map),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: customGreen, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(contextBuilder),
            child: const Text('CERRAR'),
          ),
        ],
      );
    },
  );

  return true;
}
