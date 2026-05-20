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

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

Future<bool> borraniveles(
  BuildContext context,
  String authToken,
) async {
  const Color customGreen = Color(0xFF164b2d);
  bool exito = false;

  // ─────────────────────────────────────────────────────────────────────────────
  // Función auxiliar de error
  // ─────────────────────────────────────────────────────────────────────────────
  void showError(BuildContext ctx, String mensaje) {
    showDialog(
      context: ctx,
      builder: (c) => AlertDialog(
        title: const Text(
          'Atención',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child:
                const Text('ENTENDIDO', style: TextStyle(color: customGreen)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PASO 1: Verificar permiso de Administrador
  // ─────────────────────────────────────────────────────────────────────────────
  bool esAdministrador = false;
  try {
    final db = FirebaseFirestore.instance;
    final userDoc = await db.collection('users').doc(currentUserUid).get();
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>? ?? {};
      esAdministrador =
          (data['permiso'] ?? '').toString().trim() == 'Administrador';
    }
  } catch (e) {
    showError(context, 'Error al verificar permisos:\n$e');
    return false;
  }

  if (!esAdministrador) {
    showError(context, 'Solo los administradores pueden borrar niveles.');
    return false;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PASO 2: Diálogo 1 — Selección del nivel a borrar
  // ─────────────────────────────────────────────────────────────────────────────
  int? nivelSeleccionado;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx1) {
      return AlertDialog(
        title: const Text(
          'Borrar Nivel — Poder Judicial del Estado de Veracruz',
          style: TextStyle(
            color: customGreen,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _nivelHeader('SELECCIONE EL NIVEL A BORRAR'),
            const SizedBox(height: 16),
            _nivelBoton(
              label: 'NIVEL 1',
              sublabel: 'Organización',
              icono: Icons.account_balance,
              color: customGreen,
              habilitado: true,
              onTap: () {
                nivelSeleccionado = 1;
                Navigator.pop(ctx1);
              },
            ),
            const SizedBox(height: 10),
            _nivelBoton(
              label: 'NIVEL 2',
              sublabel: 'Dirección',
              icono: Icons.business,
              color: const Color(0xFF1a5c38),
              habilitado: true,
              onTap: () {
                nivelSeleccionado = 2;
                Navigator.pop(ctx1);
              },
            ),
            const SizedBox(height: 10),
            _nivelBoton(
              label: 'NIVEL 3',
              sublabel: 'Jurisdicción',
              icono: Icons.meeting_room,
              color: const Color(0xFF22754a),
              habilitado: true,
              onTap: () {
                nivelSeleccionado = 3;
                Navigator.pop(ctx1);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              nivelSeleccionado = null;
              Navigator.pop(ctx1);
            },
            child: const Text('CANCELAR', style: TextStyle(color: customGreen)),
          ),
        ],
      );
    },
  );

  if (nivelSeleccionado == null) return false;

  // ─────────────────────────────────────────────────────────────────────────────
  // PASO 3: Diálogo 2 — Búsqueda del nombre del nivel (Autocomplete con FFAppState)
  // ─────────────────────────────────────────────────────────────────────────────
  final TextEditingController nombreController = TextEditingController();
  String? nombreSeleccionado;
  List<String> sugerencias = [];

  // Cargar sugerencias según el nivel elegido
  if (nivelSeleccionado == 1) {
    sugerencias = FFAppState().sugerenciasN1;
  } else if (nivelSeleccionado == 2) {
    sugerencias = FFAppState().sugerenciasN2;
  } else {
    sugerencias = FFAppState().sugerenciasN3;
  }

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx2) {
      return StatefulBuilder(
        builder: (ctx2, setState) {
          return AlertDialog(
            title: Text(
              'Buscar Nivel $nivelSeleccionado a eliminar',
              style: const TextStyle(
                color: customGreen,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _nivelHeader(
                    nivelSeleccionado == 1
                        ? 'ORGANIZACIÓN (NIVEL 1)'
                        : nivelSeleccionado == 2
                            ? 'DIRECCIÓN (NIVEL 2)'
                            : 'JURISDICCIÓN (NIVEL 3)',
                  ),
                  const SizedBox(height: 8),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return sugerencias.where((String option) {
                        return option
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      nombreController.text = selection;
                      nombreSeleccionado = selection;
                    },
                    fieldViewBuilder: (context, textEditingController,
                        focusNode, onFieldSubmitted) {
                      // Sincronizar el controlador local con el del Autocomplete
                      if (nombreController.text != textEditingController.text) {
                        nombreController.text = textEditingController.text;
                      }
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Escriba o seleccione el nombre',
                          hintText: 'Ej: CONSEJO DE LA JUDICATURA',
                          prefixIcon: Icon(
                            nivelSeleccionado == 1
                                ? Icons.account_balance
                                : nivelSeleccionado == 2
                                    ? Icons.business
                                    : Icons.meeting_room,
                            size: 18,
                            color: customGreen,
                          ),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              textEditingController.clear();
                              nombreController.clear();
                              nombreSeleccionado = null;
                              setState(() {});
                            },
                          ),
                        ),
                        onChanged: (value) {
                          nombreController.text = value;
                          nombreSeleccionado =
                              value.trim().isEmpty ? null : value;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  nombreSeleccionado = null;
                  Navigator.pop(ctx2);
                },
                child: const Text('CANCELAR',
                    style: TextStyle(color: customGreen)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: customGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final nombre = nombreController.text.trim();
                  if (nombre.isEmpty) {
                    showError(ctx2,
                        'Debe ingresar o seleccionar un nombre de nivel.');
                    return;
                  }
                  nombreSeleccionado = nombre;
                  Navigator.pop(ctx2);
                },
                child: const Text('CONTINUAR'),
              ),
            ],
          );
        },
      );
    },
  );

  if (nombreSeleccionado == null || nombreSeleccionado!.isEmpty) {
    return false;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PASO 4: Confirmación final
  // ─────────────────────────────────────────────────────────────────────────────
  bool confirmar = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('⚠️ Confirmar eliminación'),
          content: Text(
            'Se eliminarán TODOS los registros del Nivel $nivelSeleccionado con el nombre:\n\n'
            '"$nombreSeleccionado"\n\n'
            'Esta acción es irreversible. ¿Desea continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('NO', style: TextStyle(color: Colors.black87)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('SÍ, ELIMINAR',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ) ??
      false;

  if (!confirmar) return false;

  // ─────────────────────────────────────────────────────────────────────────────
  // PASO 5: Eliminación en Firebase y PocketBase
  // ─────────────────────────────────────────────────────────────────────────────
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customGreen),
          ),
          SizedBox(width: 20),
          Text('Eliminando registros...'),
        ],
      ),
    ),
  );

  try {
    final db = FirebaseFirestore.instance;
    final String campoNombre = 'nombre$nivelSeleccionado';
    final String nombreFiltro = nombreSeleccionado!;

    // 1. Obtener todos los documentos de Firebase que coinciden
    final querySnapshot = await db
        .collection('oficinasPJEV')
        .where(campoNombre, isEqualTo: nombreFiltro)
        .get();

    final int totalFirebase = querySnapshot.docs.length;
    if (totalFirebase == 0) {
      Navigator.pop(context); // cerrar loading
      showError(
          context, 'No se encontraron registros con ese nombre en Firebase.');
      return false;
    }

    // Eliminar en Firebase (lote por lote para evitar límites)
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    // 2. Eliminar en PocketBase (API)
    // Primero buscar los IDs mediante GET con filtro
    final String filterUrl =
        'https://api.servidor-inventarios.xyz/fastapi/oficinasPJEV/?filter=($campoNombre%3D%22$nombreFiltro%22)';
    final searchResponse = await http.get(
      Uri.parse(filterUrl),
      headers: {'Authorization': 'Bearer $authToken'},
    ).timeout(const Duration(seconds: 15));

    if (searchResponse.statusCode != 200) {
      throw Exception(
          'Error al buscar registros en API: ${searchResponse.statusCode}');
    }

    final Map<String, dynamic> searchData = jsonDecode(searchResponse.body);
    final List<dynamic> items = searchData['items'] ?? [];
    int eliminadosApi = 0;
    List<String> erroresApi = [];

    for (var item in items) {
      final String id = item['id'];
      final deleteResponse = await http.delete(
        Uri.parse(
            'https://api.servidor-inventarios.xyz/fastapi/oficinasPJEV/$id'),
        headers: {'Authorization': 'Bearer $authToken'},
      ).timeout(const Duration(seconds: 15));

      if (deleteResponse.statusCode == 200 ||
          deleteResponse.statusCode == 204) {
        eliminadosApi++;
      } else {
        erroresApi.add('ID $id: ${deleteResponse.statusCode}');
      }
    }

    // Cerrar diálogo de carga
    Navigator.pop(context);

    // Mostrar resultado final
    if (eliminadosApi == items.length && eliminadosApi > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '✅ Eliminados $totalFirebase registros de Firebase y $eliminadosApi de la API.'),
          backgroundColor: customGreen,
        ),
      );
      exito = true;
    } else if (eliminadosApi > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '⚠️ Eliminados en Firebase: $totalFirebase. En API: $eliminadosApi de ${items.length}. Errores: ${erroresApi.join(', ')}'),
          backgroundColor: Colors.orange,
        ),
      );
      exito = true; // Parcialmente exitoso
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ No se pudo eliminar ningún registro en la API.'),
          backgroundColor: Colors.red,
        ),
      );
      exito = false;
    }
  } catch (e) {
    try {
      Navigator.pop(context);
    } catch (_) {}
    showError(context, 'Error durante la eliminación:\n$e');
    exito = false;
  }

  return exito;
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets auxiliares (iguales a los de crear nivel)
// ─────────────────────────────────────────────────────────────────────────────

Widget _nivelHeader(String t) => Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 6),
      child: Text(
        t,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );

Widget _nivelBoton({
  required String label,
  required String sublabel,
  required IconData icono,
  required Color color,
  required bool habilitado,
  required VoidCallback onTap,
  String tooltipDeshabilitado = '',
}) {
  final Widget boton = AnimatedOpacity(
    opacity: habilitado ? 1.0 : 0.38,
    duration: const Duration(milliseconds: 200),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: habilitado ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: habilitado ? color : Colors.grey.shade400,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
            color: habilitado ? color.withOpacity(0.06) : Colors.grey.shade100,
          ),
          child: Row(
            children: [
              Icon(icono, color: habilitado ? color : Colors.grey, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: habilitado ? color : Colors.grey,
                      ),
                    ),
                    Text(
                      sublabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: habilitado
                            ? color.withOpacity(0.7)
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                habilitado ? Icons.chevron_right : Icons.lock_outline,
                color: habilitado ? color : Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  if (!habilitado && tooltipDeshabilitado.isNotEmpty) {
    return Tooltip(
      message: tooltipDeshabilitado,
      child: boton,
    );
  }
  return boton;
}
