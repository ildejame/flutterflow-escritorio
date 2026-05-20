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

import 'package:cloud_firestore/cloud_firestore.dart';

Future actualizarclase(
    BuildContext context, List<String> nombreempleadoAE) async {
  final TextEditingController inicialController = TextEditingController();
  final TextEditingController finalController = TextEditingController();

  String? partidaInicial;
  String? partidaFinal;

  // Configuración de colores institucional
  const Color verdeBoton = Color(0xFF1B5E20);
  const Color colorEtiquetas = Color(0xFF1B5E20);

  // 🔹 Paso 1: Diálogo de selección de partidas
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text(
          'Cambio de partida',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 20, color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCustomAutocomplete(
              controller: inicialController,
              options: nombreempleadoAE,
              label: 'Partida a cambiar',
              labelColor: colorEtiquetas,
            ),
            const SizedBox(height: 16),
            _buildCustomAutocomplete(
              controller: finalController,
              options: nombreempleadoAE,
              label: 'Partida nueva',
              labelColor: colorEtiquetas,
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: verdeBoton),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: verdeBoton,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () {
              partidaInicial = inicialController.text.trim();
              partidaFinal = finalController.text.trim();
              Navigator.pop(dialogContext);
            },
            child: const Text('ACEPTAR'),
          ),
        ],
      );
    },
  );

  if (partidaInicial == null ||
      partidaFinal == null ||
      partidaInicial!.isEmpty ||
      partidaFinal!.isEmpty) return;

  // 🔹 Paso 2: Diálogo de búsqueda (Loading)
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (c) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Row(
        children: [
          CircularProgressIndicator(color: verdeBoton),
          const SizedBox(width: 20),
          const Text('Buscando bienes...'),
        ],
      ),
    ),
  );

  final querySnapshot = await FirebaseFirestore.instance
      .collection('bienesmuebles')
      .where('clasedeactivo', isEqualTo: partidaInicial)
      .get();

  Navigator.pop(context); // Cerrar loading

  final totalBienes = querySnapshot.docs.length;

  if (totalBienes == 0) {
    _errorMsg(
        context,
        'No se encontraron bienes con la partida "$partidaInicial".',
        verdeBoton);
    return;
  }

  // 🔹 Paso 3: Informe previo y confirmación
  bool confirmarCambio = false;
  await showDialog(
    context: context,
    builder: (c) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Text('Confirmar actualización', textAlign: TextAlign.center),
      content: Text(
          'Se encontraron $totalBienes bienes.\n\n¿Deseas asignarles la nueva partida "$partidaFinal"?'),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: verdeBoton),
          onPressed: () => Navigator.pop(c),
          child: const Text('CANCELAR'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: verdeBoton,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            confirmarCambio = true;
            Navigator.pop(c);
          },
          child: const Text('SÍ, ACTUALIZAR'),
        ),
      ],
    ),
  );

  if (!confirmarCambio) return;

  // 🔹 Paso 4: Proceso de actualización masiva con barra de progreso
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      int actualizados = 0;
      double progreso = 0.0;
      bool started = false;

      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> procesarBatch() async {
            try {
              const int batchSize = 100;
              final firestore = FirebaseFirestore.instance;

              for (int i = 0; i < totalBienes; i += batchSize) {
                final slice =
                    querySnapshot.docs.skip(i).take(batchSize).toList();
                final batch = firestore.batch();

                for (final doc in slice) {
                  batch.update(doc.reference, {
                    'clasedeactivo': partidaFinal,
                    'fechademodificacion': FieldValue.serverTimestamp(),
                  });
                }

                await batch.commit();
                actualizados += slice.length;
                progreso = (actualizados / totalBienes);
                setState(() {});
                await Future.delayed(const Duration(milliseconds: 100));
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Actualización completada con éxito')));
            } catch (e) {
              Navigator.pop(context);
              _errorMsg(context, 'Error: $e', verdeBoton);
            }
          }

          if (!started) {
            started = true;
            WidgetsBinding.instance
                .addPostFrameCallback((_) => procesarBatch());
          }

          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Actualizando...', textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                    value: progreso,
                    color: verdeBoton,
                    backgroundColor: Colors.grey[200]),
                const SizedBox(height: 16),
                Text('${(progreso * 100).toStringAsFixed(0)} %'),
                Text('Bienes: $actualizados / $totalBienes',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      );
    },
  );
}

// Widget de Autocomplete con Opción 1 aplicada (hoverColor transparente)
Widget _buildCustomAutocomplete({
  required TextEditingController controller,
  required List<String> options,
  required String label,
  required Color labelColor,
}) {
  return Autocomplete<String>(
    optionsBuilder: (textEditingValue) {
      if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
      return options.where((option) =>
          option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
    },
    onSelected: (val) => controller.text = val,
    fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
      // Sincronización de controladores
      fieldController.addListener(() => controller.text = fieldController.text);

      return Theme(
        data: Theme.of(context).copyWith(
          hoverColor: Colors.transparent, // <--- OPCIÓN 1 APLICADA
        ),
        child: TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          style: const TextStyle(color: Colors.black, fontSize: 15),
          cursorColor: labelColor,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: labelColor, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: labelColor, width: 2.0),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      );
    },
  );
}

void _errorMsg(BuildContext context, String msg, Color verde) {
  showDialog(
    context: context,
    builder: (c) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Text('Aviso', textAlign: TextAlign.center),
      content: Text(msg),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: verde),
          onPressed: () => Navigator.pop(c),
          child: const Text('OK'),
        )
      ],
    ),
  );
}
