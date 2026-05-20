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

Future cambiarorganizacion(
    BuildContext context, List<String> nombreempleadoAE) async {
  final TextEditingController inicialController = TextEditingController();
  final TextEditingController finalController = TextEditingController();

  String? organizacionInicial;
  String? organizacionFinal;

  const Color verdeBoton = Color(0xFF1B5E20);
  const Color colorEtiquetas = Color(0xFF1B5E20);

  // 🔹 Paso 1: Diálogo inicial
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text(
          'Cambiar organización',
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
              label: 'Organización a cambiar',
              labelColor: colorEtiquetas,
            ),
            const SizedBox(height: 16),
            _buildCustomAutocomplete(
              controller: finalController,
              options: nombreempleadoAE,
              label: 'Organización nueva',
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
              organizacionInicial = inicialController.text.trim();
              organizacionFinal = finalController.text.trim();
              Navigator.pop(dialogContext);
            },
            child: const Text('ACEPTAR'),
          ),
        ],
      );
    },
  );

  if (organizacionInicial == null ||
      organizacionFinal == null ||
      organizacionInicial!.isEmpty ||
      organizacionFinal!.isEmpty) return;

  // 🔹 Paso 2: Búsqueda
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (c) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Row(
        children: [
          CircularProgressIndicator(color: verdeBoton),
          const SizedBox(width: 20),
          const Text('Analizando registros...'),
        ],
      ),
    ),
  );

  final firestore = FirebaseFirestore.instance;

  try {
    // 2.1 Buscar en Bienes Muebles
    final queryBienes = await firestore
        .collection('bienesmuebles')
        .where('nivel1organizacion', isEqualTo: organizacionInicial)
        .get();

    // 2.2 Buscar en Cálculo Depreciación
    final queryDepre = await firestore
        .collection('calculodepreciacion')
        .where('unidadpresupuestal', isEqualTo: organizacionInicial)
        .get();

    Navigator.pop(context); // cerrar loading

    final totalBienes = queryBienes.docs.length;
    final totalDepre = queryDepre.docs.length;

    if (totalBienes == 0 && totalDepre == 0) {
      _errorMsg(
          context,
          'No se encontraron registros con la organización "$organizacionInicial".',
          verdeBoton);
      return;
    }

    // 🔹 Paso 3: Confirmación e Informe
    bool confirmarCambio = false;
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title:
            const Text('Confirmar Cambio Masivo', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Se trasladará de "$organizacionInicial" a "$organizacionFinal":'),
            const SizedBox(height: 15),
            Text('📦 Bienes detectados: $totalBienes',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('📉 Depreciaciones detectadas: $totalDepre',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Text(
                'Nota: Se actualizarán TODOS los documentos de depreciación vinculados a cada bien (Relación 1 a muchos).'),
            const SizedBox(height: 10),
            const Text('¿Deseas proceder?'),
          ],
        ),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              confirmarCambio = true;
              Navigator.pop(c);
            },
            child: const Text('SÍ, CAMBIAR'),
          ),
        ],
      ),
    );

    if (!confirmarCambio) return;

    // 🔹 Paso 4: Preparación de Datos (CORREGIDO: LISTA DE DOCS)
    // Usamos Map<String, List<DocumentSnapshot>> para soportar múltiples
    // depreciaciones por un mismo ID de bien.
    Map<String, List<DocumentSnapshot>> mapaDepreciaciones = {};

    for (var doc in queryDepre.docs) {
      final data = doc.data();
      if (data.containsKey('inventario2025') &&
          data['inventario2025'] != null) {
        String idVinculo = data['inventario2025'].toString();

        // Si la lista no existe para este ID, la creamos
        if (!mapaDepreciaciones.containsKey(idVinculo)) {
          mapaDepreciaciones[idVinculo] = [];
        }

        // Agregamos el documento a la lista existente
        mapaDepreciaciones[idVinculo]!.add(doc);
      }
    }

    // 🔹 Paso 5: Proceso de actualización
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        int actualizadosBienes = 0;
        int actualizadosDepre = 0;
        double progreso = 0.0;
        bool started = false;

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> procesarBatch() async {
              try {
                const int batchSize = 100;
                final firestore = FirebaseFirestore.instance;

                // Iteramos sobre los bienes
                for (int i = 0; i < totalBienes; i += batchSize) {
                  final slice =
                      queryBienes.docs.skip(i).take(batchSize).toList();
                  final batch = firestore.batch();
                  int opsEnBatch = 0;

                  for (final docBien in slice) {
                    // 1. Actualizar el Bien
                    batch.update(docBien.reference, {
                      'nivel1organizacion': organizacionFinal,
                      'fechademodificacion': FieldValue.serverTimestamp(),
                    });
                    opsEnBatch++;

                    // 2. Buscar y Actualizar TODAS las Depreciaciones vinculadas
                    final dataBien = docBien.data();
                    if (dataBien.containsKey('inventario2025')) {
                      String idBien = dataBien['inventario2025'].toString();

                      if (mapaDepreciaciones.containsKey(idBien)) {
                        // Obtenemos la LISTA de documentos para este bien
                        final listaDocs = mapaDepreciaciones[idBien];

                        // Iteramos sobre CADA documento de la lista
                        if (listaDocs != null) {
                          for (var docDepre in listaDocs) {
                            batch.update(docDepre.reference, {
                              'unidadpresupuestal': organizacionFinal,
                              // Opcional: timestamp
                            });
                            opsEnBatch++;
                            actualizadosDepre++;
                          }
                          // Removemos del mapa para optimizar memoria (opcional)
                          mapaDepreciaciones.remove(idBien);
                        }
                      }
                    }
                  }

                  if (opsEnBatch > 0) {
                    await batch.commit();
                  }

                  actualizadosBienes += slice.length;
                  progreso = (actualizadosBienes / totalBienes);
                  if (progreso > 1.0) progreso = 1.0;

                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 50));
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Éxito: $actualizadosBienes bienes y $actualizadosDepre depreciaciones actualizados.')));
              } catch (e) {
                Navigator.pop(context);
                _errorMsg(context, 'Error actualizando: $e', verdeBoton);
              }
            }

            if (!started) {
              started = true;
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => procesarBatch());
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
                  const SizedBox(height: 8),
                  Text('Bienes: $actualizadosBienes / $totalBienes',
                      style: const TextStyle(fontSize: 13)),
                  Text('Depreciaciones vinculadas: $actualizadosDepre',
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            );
          },
        );
      },
    );
  } catch (e) {
    _errorMsg(context, 'Error en la búsqueda inicial: $e', verdeBoton);
  }
}

// ... Resto de widgets auxiliares (_buildCustomAutocomplete, _errorMsg) igual que antes ...

// Widget Autocomplete
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
      fieldController.addListener(() => controller.text = fieldController.text);

      return Theme(
        data: Theme.of(context).copyWith(
          hoverColor: Colors.transparent,
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
