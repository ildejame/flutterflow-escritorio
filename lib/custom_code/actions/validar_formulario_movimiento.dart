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

Future<bool> validarFormularioMovimiento(
  BuildContext context,
  List<dynamic>? listaBienes,
  String? folio,
  String? nombreSolicitante,
  String? tipoMovimiento,
  String? titular,
  String? depositario,
  String? estadoDelBien,
  String? nivel1,
  String? nivel2,
  String? nivel3,
  String? ubicacion,
  String? pendienteRevision,
) async {
  // ---------------------------------------------------------
  // 1. CAMPOS QUE SIEMPRE SON OBLIGATORIOS (Para cualquier vale)
  // ---------------------------------------------------------
  if (folio == null || folio.isEmpty) {
    _mostrarAlerta(context, "El folio es obligatorio.");
    return false;
  }
  if (nombreSolicitante == null || nombreSolicitante.isEmpty) {
    _mostrarAlerta(context, "El nombre de quien solicita es obligatorio.");
    return false;
  }
  if (tipoMovimiento == null || tipoMovimiento.isEmpty) {
    _mostrarAlerta(context, "Debes seleccionar el Tipo de movimiento.");
    return false;
  }
  // ---------------------------------------------------------
  // 2. CAMPOS CONDICIONALES (Dependen del Tipo de Movimiento)
  // ---------------------------------------------------------
  // EJEMPLO A: Reglas para cuando es una ASIGNACIÓN
  if (tipoMovimiento == 'ASIGNACION') {
    if (titular == null || titular.isEmpty) {
      _mostrarAlerta(
          context, "Para una asignación, el Titular es obligatorio.");
      return false;
    }
    if (nivel1 == null || nivel1.isEmpty) {
      _mostrarAlerta(context,
          "Para una asignación, el Nivel 1 (Organización) es obligatorio.");
      return false;
    }
  }

  // EJEMPLO B: Reglas para cuando es un TRASLADO
  if (tipoMovimiento == 'TRASLADO') {
    if (ubicacion == null || ubicacion.isEmpty) {
      _mostrarAlerta(context, "Para un traslado, la Ubicación es obligatoria.");
      return false;
    }
  }

  // EJEMPLO C: Reglas para cuando es una BAJA
  if (tipoMovimiento == 'BAJA') {
    if (estadoDelBien == null || estadoDelBien.isEmpty) {
      _mostrarAlerta(
          context, "Para dar de baja, debes indicar el Estado del bien.");
      return false;
    }
  }

  // Si el código llega hasta aquí, significa que todo está correcto
  return true;
}

// Función auxiliar para mostrar el mensaje rojo
void _mostrarAlerta(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}
