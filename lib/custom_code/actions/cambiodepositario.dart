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
import 'package:cloud_firestore/cloud_firestore.dart';

Future cambiodepositario(
  BuildContext context,
  List<String> nombreempleadoAE,
) async {
  String seleccionInicial = '';
  String seleccionFinal = '';

  const Color verdeBoton = Color(0xFF1B5E20);
  const Color colorEtiquetas = Color(0xFF1B5E20);

  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text(
          'Cambio de depositario',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 20, color: Colors.black),
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCustomAutocomplete(
                options: nombreempleadoAE,
                label: 'Depositario actual (Origen)',
                labelColor: colorEtiquetas,
                onSelected: (val) => seleccionInicial = val,
              ),
              const SizedBox(height: 16),
              _buildCustomAutocomplete(
                options: nombreempleadoAE,
                label: 'Nuevo depositario (Destino)',
                labelColor: colorEtiquetas,
                onSelected: (val) => seleccionFinal = val,
              ),
            ],
          ),
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
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('GENERAR'),
          ),
        ],
      );
    },
  ).then((confirmed) async {
    if (confirmed == null || !confirmed) return;
    if (seleccionInicial.isEmpty || seleccionFinal.isEmpty) return;
    _ejecutarTransferencia(
        context, seleccionInicial, seleccionFinal, verdeBoton);
  });
}

Widget _buildCustomAutocomplete({
  required List<String> options,
  required String label,
  required Color labelColor,
  required Function(String) onSelected,
}) {
  return Autocomplete<String>(
    optionsBuilder: (textEditingValue) {
      if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
      return options.where((option) =>
          option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
    },
    onSelected: onSelected,
    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
      return Theme(
        data: ThemeData(
          hoverColor: Colors.transparent,
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          // ESTO DEFINE EL ESTILO DEL TEXTO QUE ESCRIBE EL USUARIO
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: 15,
          ),
          cursorColor: labelColor,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
                color: labelColor, fontSize: 14, fontWeight: FontWeight.normal),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: labelColor, width: 2.0),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          onChanged: (value) => onSelected(value),
        ),
      );
    },
  );
}

// ... Funciones _ejecutarTransferencia y _errorMsg se mantienen igual
Future<void> _ejecutarTransferencia(
    BuildContext context, String inicial, String destino, Color verde) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (c) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Row(
        children: [
          CircularProgressIndicator(color: verde),
          const SizedBox(width: 20),
          const Text('Procesando...')
        ],
      ),
    ),
  );

  try {
    final query = await FirebaseFirestore.instance
        .collection('bienesmuebles')
        .where('tituladelbien', isEqualTo: inicial)
        .get();

    Navigator.pop(context);

    if (query.docs.isEmpty) {
      _errorMsg(context, 'No se encontraron bienes.', verde);
      return;
    }

    bool? proceder = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text('Confirmar', textAlign: TextAlign.center),
        content: Text('Se transferirán ${query.docs.length} bienes.'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: verde),
            onPressed: () => Navigator.pop(c, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: verde,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Sí, transferir'),
          ),
        ],
      ),
    );

    if (proceder != true) return;

    final batch = FirebaseFirestore.instance.batch();
    for (var doc in query.docs) {
      batch.update(doc.reference, {
        'tituladelbien': destino,
        'fechademodificacion': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transferencia completada con éxito')));
  } catch (e) {
    if (Navigator.canPop(context)) Navigator.pop(context);
    _errorMsg(context, 'Error: $e', verde);
  }
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
