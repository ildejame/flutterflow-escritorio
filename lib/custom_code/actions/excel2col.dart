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

import 'dart:html' as html;
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> excel2col(BuildContext context) async {
  // 1. Verificación de entorno Web
  if (!kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❌ Esta función solo está disponible en Web'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // 2. Solicitar el AÑO
  final yearController = TextEditingController(text: '2025');
  int? anioSeleccionado;
  final formKey = GlobalKey<FormState>();

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (alertDialogContext) {
      return AlertDialog(
        title: const Text('Descarga UNIFICADA'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Se eliminarán duplicados normalizando IDs (ej: 20820.0 = 20820).'),
              const SizedBox(height: 15),
              TextFormField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Año (ej. 2025)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresa un año';
                  final n = int.tryParse(value);
                  if (n == null) return 'Debe ser un número';
                  if (n < 2000) return 'Año inválido';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                anioSeleccionado = int.tryParse(yearController.text);
                Navigator.pop(alertDialogContext);
              }
            },
            child: const Text('DESCARGAR'),
          ),
        ],
      );
    },
  );

  yearController.dispose();
  if (anioSeleccionado == null) return;

  // 3. PROCESO DE DESCARGA
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          Expanded(
              child: Text(
                  'Procesando y normalizando datos del $anioSeleccionado...')),
        ],
      ),
    ),
  );

  try {
    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('calculodepreciacion');

    // MAPA PARA DATOS ÚNICOS
    // Clave: ID Normalizado (String), Valor: Datos
    final Map<String, Map<String, dynamic>> datosUnicos = {};

    const int TAMANO_LOTE = 2000;
    QueryDocumentSnapshot? ultimoDocumento;
    bool hayMasDatos = true;
    int totalDescargados = 0;

    while (hayMasDatos) {
      // Ordenamos por DocumentID para estabilidad total en la descarga
      Query query = collectionRef
          .where('aniodepreciacion', isEqualTo: anioSeleccionado)
          .orderBy(FieldPath.documentId)
          .limit(TAMANO_LOTE);

      if (ultimoDocumento != null) {
        query = query.startAfterDocument(ultimoDocumento);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        hayMasDatos = false;
        break;
      }

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // --- AQUÍ ESTÁ LA SOLUCIÓN (LA TRITURADORA) ---
        // Normalizamos el ID para que "20820.0", " 20820 " y 20820 sean lo mismo.
        final rawId = data['inventario2025'];
        final idNormalizado = _normalizarID(rawId);

        if (idNormalizado.isNotEmpty) {
          // Si NO existe, lo agregamos. Si YA existe (aunque viniera con formato distinto), lo ignoramos.
          if (!datosUnicos.containsKey(idNormalizado)) {
            datosUnicos[idNormalizado] = data;
          }
        }
        totalDescargados++;
      }

      ultimoDocumento = snapshot.docs.last;

      if (snapshot.docs.length < TAMANO_LOTE) {
        hayMasDatos = false;
      }

      await Future.delayed(const Duration(milliseconds: 20));
    }

    if (datosUnicos.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('⚠️ No se encontraron datos para $anioSeleccionado.')),
      );
      return;
    }

    // 4. GENERAR EXCEL
    final excel = Excel.createExcel();
    final sheetName = excel.tables.keys.first;
    final sheet = excel[sheetName];

    // Encabezados
    final headers = ['INVENTARIO', 'DEPRECIACION'];
    for (int i = 0; i < headers.length; i++) {
      final cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = headers[i];
      cell.cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          backgroundColorHex: '#E0E0E0');
    }

    // 5. ORDENAR DATOS (Numéricamente si es posible)
    final listaIds = datosUnicos.keys.toList();
    listaIds.sort((a, b) {
      final numA = num.tryParse(a);
      final numB = num.tryParse(b);
      if (numA != null && numB != null) {
        return numA.compareTo(numB);
      }
      return a.compareTo(b);
    });

    int rowIndex = 1;
    for (final id in listaIds) {
      final data = datosUnicos[id]!;

      // Col 1: INVENTARIO (Ya normalizado)
      final cellInv = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      // Intentamos ponerlo como número en Excel para que se alinee a la derecha
      final numId = num.tryParse(id);
      cellInv.value = numId ?? id;

      // Col 2: DEPRECIACION
      final cellDep = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      final rawDep = data['depreciacion'];

      if (rawDep is num) {
        cellDep.value = rawDep;
      } else if (rawDep is String) {
        cellDep.value = double.tryParse(rawDep) ?? 0.0;
      } else {
        cellDep.value = 0.0;
      }

      rowIndex++;
    }

    sheet.setColAutoFit(0);
    sheet.setColAutoFit(1);

    final fileBytes = excel.encode();
    if (fileBytes != null) {
      final fileName = 'Depreciacion_${anioSeleccionado}_Unificado.xlsx';
      final blob = html.Blob([fileBytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    }

    Navigator.pop(context); // Cerrar loading

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '✅ Éxito: ${datosUnicos.length} registros únicos (Limpieza: ${totalDescargados - datosUnicos.length} eliminados).'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 8),
      ),
    );
  } catch (e) {
    Navigator.pop(context);
    debugPrint('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Error: $e')),
    );
  }
}

// --- FUNCIÓN AUXILIAR DE NORMALIZACIÓN (LA CLAVE) ---
String _normalizarID(dynamic input) {
  if (input == null) return '';
  String str = input.toString().trim();
  if (str.isEmpty) return '';

  // Intentar parsear como número para unificar formatos
  // Esto convierte "20820.0" -> 20820 -> "20820"
  final numero = num.tryParse(str);
  if (numero != null) {
    return numero.toInt().toString();
  }

  return str;
}
