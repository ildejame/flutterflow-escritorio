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

Future<bool> creanivel(
  BuildContext context,
  String authToken,
) async {
  const Color customGreen = Color(0xFF164b2d);
  bool registroExitoso = false;

  // ─────────────────────────────────────────────────────────────────────────────
  // Función auxiliar de error (mismo estilo que la acción de referencia)
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
  // PASO 1: Verificar si el usuario autenticado tiene permiso "Administrador"
  // Se consulta la colección "users" filtrando por el UID del usuario actual.
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

  // ─────────────────────────────────────────────────────────────────────────────
  // PASO 2: Diálogo 1 — Selección de nivel (3 botones)
  // El botón Nivel 1 solo está habilitado si es Administrador.
  // ─────────────────────────────────────────────────────────────────────────────
  int? nivelSeleccionado;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx1) {
      return AlertDialog(
        title: const Text(
          'Crear Nivel — Poder Judicial del Estado de Veracruz',
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
            _nivelHeader('SELECCIONE EL NIVEL A CREAR'),
            const SizedBox(height: 16),

            // ── Botón NIVEL 1 ──────────────────────────────────────────────
            _nivelBoton(
              label: 'NIVEL 1',
              sublabel: 'Organización',
              icono: Icons.account_balance,
              color: customGreen,
              habilitado: esAdministrador,
              tooltipDeshabilitado: 'Requiere permiso de Administrador',
              onTap: () {
                nivelSeleccionado = 1;
                Navigator.pop(ctx1);
              },
            ),
            const SizedBox(height: 10),

            // ── Botón NIVEL 2 ──────────────────────────────────────────────
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

            // ── Botón NIVEL 3 ──────────────────────────────────────────────
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

            // Aviso si no es Administrador
            if (!esAdministrador) ...[
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'El Nivel 1 requiere permiso de Administrador.',
                        style: TextStyle(
                            fontSize: 11, color: Colors.orange.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  // Si el usuario canceló o no seleccionó nivel, se termina
  if (nivelSeleccionado == null) return false;

  // ─────────────────────────────────────────────────────────────────────────────
  // PASO 3: Diálogo 2 — Captura del nombre del nivel elegido
  // ─────────────────────────────────────────────────────────────────────────────
  final nombreNivelController = TextEditingController();
  bool confirmoGuardar = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx2) {
      return StatefulBuilder(
        builder: (ctx2, setState) {
          return AlertDialog(
            title: Text(
              'Nombre del Nivel $nivelSeleccionado',
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
                  _txt(
                    nombreNivelController,
                    nivelSeleccionado == 1
                        ? 'Ej: CONSEJO DE LA JUDICATURA'
                        : nivelSeleccionado == 2
                            ? 'Ej: JUZGADO DÉCIMO SEGUNDO FAMILIAR EN MINATITLAN'
                            : 'Ej: MESA V',
                    nivelSeleccionado == 1
                        ? Icons.account_balance
                        : nivelSeleccionado == 2
                            ? Icons.business
                            : Icons.meeting_room,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  confirmoGuardar = false;
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
                  if (nombreNivelController.text.trim().isEmpty) {
                    showError(ctx2, 'Debe ingresar un nombre para el nivel.');
                    return;
                  }
                  confirmoGuardar = true;
                  Navigator.pop(ctx2);
                },
                child: const Text('GUARDAR'),
              ),
            ],
          );
        },
      );
    },
  );

  if (!confirmoGuardar) return false;

  // ─────────────────────────────────────────────────────────────────────────────
  // PASO 4: Confirmación final antes de guardar
  // ─────────────────────────────────────────────────────────────────────────────
  bool confirmar = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('¿Confirmar Registro?'),
          content: Text(
            'Se creará el Nivel $nivelSeleccionado con el nombre:\n\n'
            '"${nombreNivelController.text.trim()}"',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('NO', style: TextStyle(color: Colors.black87)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('SÍ', style: TextStyle(color: customGreen)),
            ),
          ],
        ),
      ) ??
      false;

  if (!confirmar) return false;

  // ─────────────────────────────────────────────────────────────────────────────
  // PASO 5: Guardar en Firebase y PocketBase (API REST)
  // ─────────────────────────────────────────────────────────────────────────────

  // Diálogo de carga
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
          Text('Guardando...'),
        ],
      ),
    ),
  );

  try {
    final db = FirebaseFirestore.instance;
    final ahora = DateTime.now();

    // Construir el mapa — solo el campo nombre del nivel elegido se llena,
    // los otros dos quedan como cadena vacía.
    final Map<String, dynamic> data = {
      'fechacreacion': Timestamp.fromDate(ahora),
      'nombre1':
          nivelSeleccionado == 1 ? nombreNivelController.text.trim() : '',
      'nombre2':
          nivelSeleccionado == 2 ? nombreNivelController.text.trim() : '',
      'nombre3':
          nivelSeleccionado == 3 ? nombreNivelController.text.trim() : '',
    };

    // ── Firebase ──────────────────────────────────────────────────────────
    await db.collection('oficinasPJEV').add(data);

    // ── PocketBase / FastAPI ───────────────────────────────────────────────
    // Se serializa fechacreacion a ISO 8601 para la API REST.
    // El campo 'nombre' lleva el texto capturado (igual que en crearOficinaPJEV).
    // URL con mayúsculas y barra final, tal como lo acepta el servidor.
    final String nombreCapturado = nombreNivelController.text.trim();
    final Map<String, dynamic> apiData = {
      'fechacreacion': ahora.toIso8601String(),
      'nombre': nombreCapturado,
      'nombre1': nivelSeleccionado == 1 ? nombreCapturado : '',
      'nombre2': nivelSeleccionado == 2 ? nombreCapturado : '',
      'nombre3': nivelSeleccionado == 3 ? nombreCapturado : '',
    };

    final res = await http
        .post(
          Uri.parse(
              'https://api.servidor-inventarios.xyz/fastapi/oficinasPJEV/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(apiData),
        )
        .timeout(const Duration(seconds: 15));

    // Cerrar loading
    Navigator.pop(context);

    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Nivel guardado correctamente'),
          backgroundColor: customGreen,
        ),
      );
      registroExitoso = true;
    } else {
      throw Exception('Error en la API: ${res.statusCode}\n${res.body}');
    }
  } catch (e) {
    // Cerrar loading si sigue abierto
    try {
      Navigator.pop(context);
    } catch (_) {}
    showError(context, 'Error al guardar:\n$e');
  }

  return registroExitoso;
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets auxiliares privados (mismo estilo que la acción de referencia)
// ─────────────────────────────────────────────────────────────────────────────

/// Encabezado de sección en gris con letras pequeñas en mayúsculas
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

/// Campo de texto con ícono y botón de limpiar (igual que _txt en referencia)
Widget _txt(TextEditingController c, String label, IconData icono) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: c,
        textCapitalization: TextCapitalization.characters,
        cursorColor: Colors.black87,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          floatingLabelStyle: const TextStyle(color: Colors.black87),
          prefixIcon: Icon(icono, size: 18, color: const Color(0xFF164b2d)),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 1.5),
          ),
          contentPadding: const EdgeInsets.all(12),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, size: 18, color: Colors.black45),
            onPressed: () => c.clear(),
          ),
        ),
      ),
    );

/// Botón de selección de nivel con estilo consistente.
/// Si [habilitado] es false, se muestra deshabilitado visualmente
/// y muestra un Tooltip con [tooltipDeshabilitado].
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
