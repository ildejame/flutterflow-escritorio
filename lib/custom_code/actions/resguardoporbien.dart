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
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '/auth/firebase_auth/auth_util.dart'; // Para currentUserDisplayName

// Función auxiliar para limpiar nombres (quitar títulos como LIC., MTRO., etc.)
String limpiarNombre(String nombre) {
  if (nombre.isEmpty) return nombre;

  // Lista de prefijos comunes a eliminar
  final prefijos = [
    'LIC.',
    'LICDA.',
    'MTRO.',
    'MTRA.',
    'DR.',
    'DRA.',
    'M. EN C.',
    'M. EN A.',
    'ING.',
    'ARQ.',
    'PROF.',
    'PROFA.',
    'C.',
    'CD.',
    'SR.',
    'SRA.',
    'SRTA.'
  ];

  String nombreLimpio = nombre.toUpperCase().trim();

  for (var prefijo in prefijos) {
    if (nombreLimpio.startsWith(prefijo.toUpperCase())) {
      nombreLimpio = nombreLimpio.substring(prefijo.length).trim();
    }
  }

  return nombreLimpio;
}

// Función para buscar cargo con múltiples estrategias
Future<String> buscarCargoConEstrategias(
    String nombre, String authToken) async {
  if (nombre.isEmpty) return '';

  const String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';
  final String nombreOriginal = nombre;
  final String nombreLimpio = limpiarNombre(nombre);

  // Estrategia 1: Búsqueda exacta con el nombre original (case-sensitive)
  try {
    final resp = await http.get(
      Uri.parse('$baseUrl/empleadosPJEV/?filter=(nombre="$nombreOriginal")'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        final cargo = data['items'][0]['cargo']?.toString() ?? '';
        if (cargo.isNotEmpty) return cargo;
      }
    }
  } catch (e) {
    print('Error estrategia 1: $e');
  }

  // Estrategia 2: Búsqueda por coincidencia parcial (contiene) con nombre original
  try {
    final resp = await http.get(
      Uri.parse('$baseUrl/empleadosPJEV/?filter=(nombre~"$nombreOriginal")'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        final cargo = data['items'][0]['cargo']?.toString() ?? '';
        if (cargo.isNotEmpty) return cargo;
      }
    }
  } catch (e) {
    print('Error estrategia 2: $e');
  }

  // Estrategia 3: Búsqueda exacta con nombre limpio (sin prefijos)
  try {
    final resp = await http.get(
      Uri.parse('$baseUrl/empleadosPJEV/?filter=(nombre="$nombreLimpio")'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        final cargo = data['items'][0]['cargo']?.toString() ?? '';
        if (cargo.isNotEmpty) return cargo;
      }
    }
  } catch (e) {
    print('Error estrategia 3: $e');
  }

  // Estrategia 4: Búsqueda parcial con nombre limpio
  try {
    final resp = await http.get(
      Uri.parse('$baseUrl/empleadosPJEV/?filter=(nombre~"$nombreLimpio")'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        // Buscar el que más coincida (podría haber varios)
        String mejorCoincidencia = '';
        int maxCoincidencia = 0;

        for (var item in data['items']) {
          final itemNombre = (item['nombre'] ?? '').toString().toUpperCase();
          final cargoItem = item['cargo']?.toString() ?? '';

          // Calcular similitud simple
          int coincidencias = 0;
          final nombreBusqueda = nombreLimpio.toUpperCase();
          for (var i = 0;
              i < nombreBusqueda.length && i < itemNombre.length;
              i++) {
            if (nombreBusqueda[i] == itemNombre[i]) coincidencias++;
          }

          if (coincidencias > maxCoincidencia && cargoItem.isNotEmpty) {
            maxCoincidencia = coincidencias;
            mejorCoincidencia = cargoItem;
          }
        }

        if (mejorCoincidencia.isNotEmpty) return mejorCoincidencia;

        // Si no hay buena coincidencia, tomar el primero
        final cargo = data['items'][0]['cargo']?.toString() ?? '';
        if (cargo.isNotEmpty) return cargo;
      }
    }
  } catch (e) {
    print('Error estrategia 4: $e');
  }

  return '';
}

// ------------------------------------------------------------
// NUEVA FUNCIÓN PRINCIPAL: resguardoporbien (múltiples bienes)
// ------------------------------------------------------------
Future<void> resguardoporbien(
  BuildContext context,
  String authToken,
) async {
  const Color customGreen = Color(0xFF164b2d);
  const String baseUrl = 'https://api.servidor-inventarios.xyz/fastapi';

  // 1. Función auxiliar para buscar un bien por ID y devolver sus datos
  Future<Map<String, dynamic>?> buscarBienPorId(String idInventario) async {
    try {
      final resp = await http.get(
        Uri.parse(
            '$baseUrl/bienesmuebles/?filter=(inventario2025="$idInventario")'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          return data['items'][0] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print('Error buscando bien: $e');
    }
    return null;
  }

  // Lista de bienes seleccionados (cada elemento es un Map<String, dynamic>)
  List<Map<String, dynamic>> bienesSeleccionados = [];

  // Datos comunes (se inicializarán con el primer bien, luego editables)
  String depositarioNombre = '';
  String depositarioCargo = '';
  String revisorNombre = currentUserDisplayName ?? 'Usuario Actual';
  String revisorCargo = '';
  String adscripcion = '';
  String area = '';
  String ubicacionFisica = '';
  String distrito = '';

  // Controladores para los campos comunes
  late TextEditingController depNomCtrl;
  late TextEditingController depCargoCtrl;
  late TextEditingController revNomCtrl;
  late TextEditingController revCargoCtrl;
  late TextEditingController adscripcionCtrl;
  late TextEditingController areaCtrl;
  late TextEditingController ubiCtrl;
  late TextEditingController distCtrl;

  // Lista de distritos (para autocompletar si no viene predefinido)
  List<String> distritosList = [];

  // ----------------------
  // PRIMER BIEN (obligatorio)
  // ----------------------
  final String? primerId = await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      final TextEditingController searchController = TextEditingController();
      return AlertDialog(
        title: const Text('Buscar Bien para Resguardo'),
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
            child: const Text('BUSCAR'),
          ),
        ],
      );
    },
  );

  if (primerId == null || primerId.isEmpty) return;
  final String idLimpio = primerId.trim().replaceAll(RegExp(r'\s+'), '');

  // Mostrar loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen)),
          SizedBox(width: 20),
          Expanded(child: Text('Consultando base de datos...')),
        ],
      ),
    ),
  );

  Map<String, dynamic>? primerBien = await buscarBienPorId(idLimpio);
  if (primerBien == null) {
    Navigator.of(context).pop(); // cerrar loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
              '⚠️ No se encontró el número de inventario en base de datos.')),
    );
    return;
  }

  // Prellenar datos comunes desde el primer bien
  String depDb = (primerBien['depositario'] ?? '').toString().trim();
  String titDb = (primerBien['tituladelbien'] ?? '').toString().trim();
  depositarioNombre = depDb.isNotEmpty ? depDb : titDb;
  ubicacionFisica = (primerBien['ubicacionfisica'] ?? '').toString().trim();
  distrito = (primerBien['distrito'] ?? '').toString().trim();
  adscripcion = (primerBien['nivel2direccion'] ?? '').toString().trim();
  area = (primerBien['nivel3jurisdiccion'] ?? '').toString().trim();

  // Buscar cargos
  depositarioCargo =
      await buscarCargoConEstrategias(depositarioNombre, authToken);
  revisorCargo = await buscarCargoConEstrategias(revisorNombre, authToken);

  // Obtener lista de distritos si no hay distrito predefinido
  if (distrito.isEmpty) {
    try {
      final distResp = await http.get(
        Uri.parse('$baseUrl/ListasPJEV/?filter=(Tipodelista="Distritos")'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      if (distResp.statusCode == 200) {
        final distData = jsonDecode(distResp.body);
        if (distData['items'] != null) {
          for (var item in distData['items']) {
            distritosList.add((item['nombredeelemento'] ?? '').toString());
          }
        }
      }
    } catch (e) {
      print('Error cargando distritos: $e');
    }
  }

  // Inicializar la lista de bienes con el primero
  bienesSeleccionados.add(primerBien);

  // Inicializar controladores con los valores prellenados
  depNomCtrl = TextEditingController(text: depositarioNombre);
  depCargoCtrl = TextEditingController(text: depositarioCargo);
  revNomCtrl = TextEditingController(text: revisorNombre);
  revCargoCtrl = TextEditingController(text: revisorCargo);
  adscripcionCtrl = TextEditingController(text: adscripcion);
  areaCtrl = TextEditingController(text: area);
  ubiCtrl = TextEditingController(text: ubicacionFisica);
  distCtrl = TextEditingController(text: distrito);

  Navigator.of(context).pop(); // cerrar loading

  // ------------------------------------------------------
  // DIÁLOGO PRINCIPAL (lista de bienes + campos comunes)
  // ------------------------------------------------------
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          // Función para agregar un nuevo bien (diálogo estilo inicial)
          Future<void> agregarNuevoBien() async {
            final String? nuevoId = await showDialog<String>(
              context: ctx,
              barrierDismissible: true,
              builder: (dialogContext) {
                final TextEditingController idController =
                    TextEditingController();
                return AlertDialog(
                  title: const Text('Agregar otro bien'),
                  content: TextField(
                    controller: idController,
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
                        onPressed: () => idController.clear(),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        Navigator.of(dialogContext).pop(value.trim());
                      }
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(null),
                      style: TextButton.styleFrom(foregroundColor: customGreen),
                      child: const Text('CANCELAR'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (idController.text.trim().isNotEmpty) {
                          Navigator.of(dialogContext)
                              .pop(idController.text.trim());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('BUSCAR'),
                    ),
                  ],
                );
              },
            );

            if (nuevoId == null || nuevoId.isEmpty) return;

            // Verificar duplicado
            if (bienesSeleccionados.any(
                (b) => (b['inventario2025'] ?? '').toString() == nuevoId)) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                    content: Text('⚠️ Este ID ya fue agregado al resguardo.')),
              );
              return;
            }

            // Mostrar loading
            showDialog(
              context: ctx,
              barrierDismissible: false,
              builder: (_) => const AlertDialog(
                content: Row(children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text('Buscando bien...')
                ]),
              ),
            );

            final nuevoBien = await buscarBienPorId(nuevoId);
            Navigator.of(ctx).pop(); // cerrar loading

            if (nuevoBien == null) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                    content:
                        Text('⚠️ No se encontró el número de inventario.')),
              );
              return;
            }

            // Agregar a la lista y actualizar UI
            setState(() {
              bienesSeleccionados.add(nuevoBien);
            });
          }

          // Función para eliminar un bien
          void eliminarBien(int index) {
            setState(() {
              bienesSeleccionados.removeAt(index);
            });
          }

          return AlertDialog(
            title: Text(
                'Resguardo de Bienes (${bienesSeleccionados.length} bienes)'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campos comunes (depositario, revisor, etc.)
                  const Text('DEPOSITARIO',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: customGreen,
                          fontSize: 12)),
                  TextField(
                      controller: depNomCtrl,
                      decoration: const InputDecoration(
                          isDense: true, labelText: 'Nombre')),
                  const SizedBox(height: 8),
                  TextField(
                      controller: depCargoCtrl,
                      decoration: const InputDecoration(
                          isDense: true, labelText: 'Cargo')),
                  const SizedBox(height: 16),

                  const Text('REVISOR (CONTROL INVENTARIOS)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: customGreen,
                          fontSize: 12)),
                  TextField(
                      controller: revNomCtrl,
                      decoration: const InputDecoration(
                          isDense: true, labelText: 'Nombre')),
                  const SizedBox(height: 8),
                  TextField(
                      controller: revCargoCtrl,
                      decoration: const InputDecoration(
                          isDense: true, labelText: 'Cargo')),
                  const SizedBox(height: 16),

                  const Text('UBICACIÓN Y ÁREA',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: customGreen,
                          fontSize: 12)),
                  TextField(
                      controller: adscripcionCtrl,
                      decoration: const InputDecoration(
                          isDense: true, labelText: 'Adscripción')),
                  const SizedBox(height: 8),
                  TextField(
                      controller: areaCtrl,
                      decoration: const InputDecoration(
                          isDense: true, labelText: 'Área')),
                  const SizedBox(height: 8),
                  TextField(
                      controller: ubiCtrl,
                      decoration: const InputDecoration(
                          isDense: true, labelText: 'Ubicación Física'),
                      maxLines: 2),
                  const SizedBox(height: 8),

                  // Distrito (autocompletar si no viene predefinido)
                  if (distrito.isEmpty)
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue val) =>
                          distritosList.where((s) =>
                              s.toLowerCase().contains(val.text.toLowerCase())),
                      onSelected: (s) => distCtrl.text = s,
                      fieldViewBuilder: (ctx2, ctrl, node, onSub) => TextField(
                        controller: ctrl,
                        focusNode: node,
                        decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Distrito (Autocompletar)'),
                        onChanged: (v) => distCtrl.text = v,
                      ),
                    )
                  else
                    TextField(
                        controller: distCtrl,
                        decoration: const InputDecoration(
                            isDense: true, labelText: 'Distrito')),

                  const SizedBox(height: 16),
                  const Divider(thickness: 1),
                  const Text('BIENES AGREGADOS',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: customGreen,
                          fontSize: 12)),
                  const SizedBox(height: 8),

                  // Lista de bienes sin líneas de separación (sin Card)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bienesSeleccionados.length,
                    itemBuilder: (context, index) {
                      final bien = bienesSeleccionados[index];
                      final idInv =
                          bien['inventario2025']?.toString() ?? 'Sin ID';
                      final nombreBien =
                          bien['nombre']?.toString() ?? 'Sin nombre';
                      final titulo = bien['tituladelbien']?.toString() ?? '';
                      final usuario = bien['depositario']?.toString() ?? '';
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.inventory,
                                color: customGreen, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: $idInv',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                                  Text(nombreBien,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  if (titulo.isNotEmpty)
                                    Text('Título: $titulo',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey)),
                                  if (usuario.isNotEmpty)
                                    Text('Usuario: $usuario',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red, size: 20),
                              onPressed: () => eliminarBien(index),
                              tooltip: 'Eliminar bien',
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: agregarNuevoBien,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('AGREGAR OTRO BIEN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('CANCELAR',
                    style: TextStyle(color: customGreen)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (bienesSeleccionados.isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Debe agregar al menos un bien para generar el resguardo.')),
                    );
                    return;
                  }
                  Navigator.of(ctx).pop(); // cerrar diálogo principal
                  await _generarPDFResguardoMultiple(
                    context,
                    bienesSeleccionados,
                    depNomCtrl.text.trim(),
                    depCargoCtrl.text.trim(),
                    revNomCtrl.text.trim(),
                    revCargoCtrl.text.trim(),
                    ubiCtrl.text.trim(),
                    adscripcionCtrl.text.trim(),
                    areaCtrl.text.trim(),
                    distCtrl.text.trim(),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white),
                child: const Text('GENERAR RESGUARDO'),
              ),
            ],
          );
        },
      );
    },
  );
}

// -------------------------------------------------------------------------
// NUEVA FUNCIÓN PARA GENERAR PDF CON MÚLTIPLES BIENES
// -------------------------------------------------------------------------
Future<void> _generarPDFResguardoMultiple(
  BuildContext context,
  List<Map<String, dynamic>> bienes,
  String depositarioNombre,
  String depositarioCargo,
  String revisorNombre,
  String revisorCargo,
  String
      ubicacionFisica, // Nota: este parámetro ya no se usa en el encabezado? Realmente la ubicación física de cada bien está en cada fila.
  String adscripcion,
  String area,
  String distrito,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(children: [
        CircularProgressIndicator(),
        SizedBox(width: 20),
        Text('Generando PDF...')
      ]),
    ),
  );

  final ByteData logoData = await rootBundle.load('assets/images/logopjev.png');
  final Uint8List logoBytes = logoData.buffer.asUint8List();

  final pdf = pw.Document();
  final headerTextStyle =
      pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
  final tableHeaderStyle =
      pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8);
  final cellTextStyle = pw.TextStyle(fontSize: 7);
  final totalRowStyle =
      pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8);

  final formatoMoneda =
      NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 2);
  final fechaActual =
      DateFormat("dd 'de' MMMM 'de' yyyy", 'es').format(DateTime.now());

  double totalCosto = 0.0;
  for (var bien in bienes) {
    double costo = 0.0;
    if (bien['importeinicialbien'] != null) {
      costo = double.tryParse(bien['importeinicialbien'].toString()) ?? 0.0;
    }
    totalCosto += costo;
  }
  final totalCostoFormateado = formatoMoneda.format(totalCosto);
  final totalBienes = bienes.length;

  pw.Widget buildProtectedTextCell(String? text, pw.TextStyle style) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Container(
        alignment: pw.Alignment.center,
        child: pw.Text(text ?? "Sin información",
            textAlign: pw.TextAlign.center, style: style, softWrap: true),
      ),
    );
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.letter.landscape
          .copyWith(marginLeft: 20, marginRight: 20, marginBottom: 30),
      header: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(pw.MemoryImage(logoBytes), width: 120, height: 60),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text("PODER JUDICIAL DEL ESTADO DE VERACRUZ",
                        style: headerTextStyle, textAlign: pw.TextAlign.center),
                    pw.Text("RESGUARDO DE BIENES MUEBLES",
                        style: headerTextStyle, textAlign: pw.TextAlign.center),
                    pw.Text("ÓRGANO DE ADMINISTRACIÓN JUDICIAL",
                        style: headerTextStyle, textAlign: pw.TextAlign.center),
                  ],
                ),
                pw.SizedBox(width: 120, height: 60),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(5),
              color: PdfColors.grey300,
              width: double.infinity,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Fecha: $fechaActual",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Text("Adscripción: $adscripcion",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Text("Área: $area",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Text("Depositario: $depositarioNombre",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Text("Distrito: $distrito",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 10)),
                ],
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Table(
              border: const pw.TableBorder(),
              columnWidths: const {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(3),
                2: pw.FlexColumnWidth(2),
                3: pw.FlexColumnWidth(2),
                4: pw.FlexColumnWidth(2),
                5: pw.FlexColumnWidth(2),
                6: pw.FlexColumnWidth(2),
                7: pw.FlexColumnWidth(3),
                8: pw.FlexColumnWidth(3)
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                      border: pw.Border(
                          left: pw.BorderSide(),
                          top: pw.BorderSide(),
                          right: pw.BorderSide(),
                          bottom: pw.BorderSide())),
                  children: [
                    pw.Text("ID",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center),
                    pw.Text("nombre",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center),
                    pw.Text("Marca",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center),
                    pw.Text("Modelo",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center),
                    pw.Text("Serie",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center),
                    pw.Text("Costo",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center),
                    pw.Text("Estado",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center),
                    pw.Text("Ubicación",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center),
                    pw.Text("Usuario",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center),
                  ],
                ),
              ],
            ),
          ],
        );
      },
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text('Página ${context.pageNumber}/${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 7)),
        );
      },
      build: (pw.Context context) {
        List<pw.Widget> widgets = [];

        // Filas de datos: una por cada bien
        for (var bien in bienes) {
          double costoBien = 0.0;
          if (bien['importeinicialbien'] != null) {
            costoBien =
                double.tryParse(bien['importeinicialbien'].toString()) ?? 0.0;
          }
          final costoFormateado = formatoMoneda.format(costoBien);

          widgets.add(
            pw.Table(
              border: const pw.TableBorder(
                  horizontalInside: pw.BorderSide.none,
                  verticalInside: pw.BorderSide.none,
                  top: pw.BorderSide.none,
                  bottom: pw.BorderSide()),
              columnWidths: const {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(3),
                2: pw.FlexColumnWidth(2),
                3: pw.FlexColumnWidth(2),
                4: pw.FlexColumnWidth(2),
                5: pw.FlexColumnWidth(2),
                6: pw.FlexColumnWidth(2),
                7: pw.FlexColumnWidth(3),
                8: pw.FlexColumnWidth(3)
              },
              children: [
                pw.TableRow(
                  verticalAlignment: pw.TableCellVerticalAlignment.middle,
                  children: [
                    buildProtectedTextCell(
                        bien['inventario2025']?.toString(), cellTextStyle),
                    buildProtectedTextCell(
                        bien['nombre']?.toString(), cellTextStyle),
                    buildProtectedTextCell(
                        bien['marcacomercial']?.toString(), cellTextStyle),
                    buildProtectedTextCell(
                        bien['modelo']?.toString(), cellTextStyle),
                    buildProtectedTextCell(
                        bien['numeroseriedelbien']?.toString(), cellTextStyle),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Text(costoFormateado,
                          textAlign: pw.TextAlign.center, style: cellTextStyle),
                    ),
                    buildProtectedTextCell(
                        bien['estatusdelbien']?.toString(), cellTextStyle),
                    buildProtectedTextCell(
                        bien['ubicacionfisica']?.toString(), cellTextStyle),
                    buildProtectedTextCell(depositarioNombre, cellTextStyle),
                  ],
                ),
              ],
            ),
          );
        }

        // Fila de totales (cambiamos "Total depto.:" por "Total:")
        widgets.add(pw.Table(
          border: const pw.TableBorder(
              left: pw.BorderSide(),
              right: pw.BorderSide(),
              bottom: pw.BorderSide()),
          columnWidths: const {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(3),
            2: pw.FlexColumnWidth(2),
            3: pw.FlexColumnWidth(2),
            4: pw.FlexColumnWidth(2),
            5: pw.FlexColumnWidth(2),
            6: pw.FlexColumnWidth(2),
            7: pw.FlexColumnWidth(3),
            8: pw.FlexColumnWidth(3)
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                for (int i = 0; i < 4; i++) pw.Container(child: pw.Text("")),
                pw.Container(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text("Total: ", style: totalRowStyle)),
                pw.Container(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(totalCostoFormateado, style: totalRowStyle)),
                pw.Container(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text("Total bienes: ", style: totalRowStyle)),
                pw.Container(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text('$totalBienes', style: totalRowStyle)),
              ],
            ),
          ],
        ));

        // Firmas y texto legal
        widgets.add(pw.Container(
          margin: const pw.EdgeInsets.only(top: 20),
          child: pw.Column(
            children: [
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("DEPOSITARIO/USUARIO",
                          style: const pw.TextStyle(fontSize: 8)),
                      pw.SizedBox(height: 20),
                      pw.Container(
                          width: 150, height: 1, color: PdfColors.black),
                      pw.Text(depositarioNombre,
                          style: const pw.TextStyle(fontSize: 8),
                          textAlign: pw.TextAlign.center),
                      pw.Text(depositarioCargo,
                          style: const pw.TextStyle(fontSize: 8),
                          textAlign: pw.TextAlign.center),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("REVISÓ", style: const pw.TextStyle(fontSize: 8)),
                      pw.SizedBox(height: 20),
                      pw.Container(
                          width: 150, height: 1, color: PdfColors.black),
                      pw.Text(revisorNombre,
                          style: const pw.TextStyle(fontSize: 8),
                          textAlign: pw.TextAlign.center),
                      pw.Text(revisorCargo,
                          style: const pw.TextStyle(fontSize: 8),
                          textAlign: pw.TextAlign.center),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Container(
                padding: const pw.EdgeInsets.all(4),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(color: PdfColors.black),
                    top: pw.BorderSide(color: PdfColors.black),
                    right: pw.BorderSide(color: PdfColors.black),
                    bottom: pw.BorderSide(color: PdfColors.black),
                  ),
                ),
                child: pw.Text(
                  "El Depositario/usuario es el responsable del cuidado, uso adecuado de los bienes y de notificar al Departamento de Inventarios, de cualquier modificación que afecte al presente resguardo. Así como de notificar la pérdida, extravío, daño o menoscabo de los bienes enlistados, en observancia a los artículos 5 de la Ley de Responsabilidades Administrativas para el Estado de Veracruz de Ignacio de la Llave; 88, fracción II, 93 de la Ley de Adquisiciones, Arrendamientos, Administración y enajenación de bienes muebles del Estado de Veracruz de Ignacio de la Llave; y 31 del Reglamento Interior de la Dirección de administración del Órgano de Administración Judicial del Poder Judicial del Estado de Veracruz.",
                  style:
                      const pw.TextStyle(fontSize: 6, color: PdfColors.black),
                  textAlign: pw.TextAlign.justify,
                ),
              ),
            ],
          ),
        ));

        return widgets;
      },
    ),
  );

  final bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..target = 'webbrowser'
    ..download = 'Resguardo_$depositarioNombre.pdf'
    ..click();
  html.Url.revokeObjectUrl(url);

  Navigator.of(context).pop(); // cerrar diálogo de generación
}
