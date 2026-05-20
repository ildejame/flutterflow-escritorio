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

import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart' hide Border;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

Future<void> exportarBienesMueblesExcel(BuildContext context) async {
  if (!kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('❌ Esta función solo está disponible en Web')),
    );
    return;
  }

  // Color personalizado
  const Color customGreen = Color(0xFF164b2d);

  // Mostrar diálogo de carga mientras se obtienen las oficinas
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customGreen),
          ),
          const SizedBox(width: 20),
          const Expanded(child: Text('Cargando opciones...')),
        ],
      ),
    ),
  );

  // Obtener unidades presupuestales desde Firebase
  final firestore = FirebaseFirestore.instance;
  List<String> unidadesDisponibles = ['TODOS'];

  try {
    final oficinasSnapshot =
        await firestore.collection('oficinasPJEV').orderBy('nombre1').get();

    for (var doc in oficinasSnapshot.docs) {
      final nombre1 = (doc.data()['nombre1'] ?? '').toString().trim();
      if (nombre1.isNotEmpty && !unidadesDisponibles.contains(nombre1)) {
        unidadesDisponibles.add(nombre1);
      }
    }
  } catch (e) {
    debugPrint('Error al cargar unidades presupuestales: $e');
  }

  // Cerrar diálogo de carga
  Navigator.of(context).pop();

  // Variables para guardar selección
  String filtroAnexo = 'TODOS';
  String filtroNivel1 = 'TODOS';
  String filtroClaseActivo = 'TODOS';
  String filtroPrecio = 'TODOS';
  double umaValue = 113.14; // Valor actual de la UMA en MXN
  bool excluirNoInventariables = true;

  // Mostrar diálogo de selección y esperar que termine
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String localAnexo = filtroAnexo;
      String localNivel1 = filtroNivel1;
      String localClaseActivo = filtroClaseActivo;
      String localFiltroPrecio = filtroPrecio;
      double localUmaValue = umaValue;
      bool localExcluirNoInventariables = excluirNoInventariables;
      List<String> clasesDeActivo = ['TODOS'];

      return StatefulBuilder(
        builder: (context, setState) {
          if (clasesDeActivo.length == 1) {
            FirebaseFirestore.instance
                .collection('depreciacion')
                .get()
                .then((snapshot) {
              final nombres = snapshot.docs
                  .map((doc) => doc.get('nombre') as String)
                  .toSet()
                  .toList();
              nombres.sort();
              setState(() {
                clasesDeActivo.addAll(nombres);
              });
            });
          }

          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: customGreen,
                secondary: customGreen,
              ),
              radioTheme: RadioThemeData(
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return customGreen;
                  }
                  return Colors.grey;
                }),
              ),
              checkboxTheme: CheckboxThemeData(
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return customGreen;
                  }
                  return Colors.grey;
                }),
              ),
            ),
            child: AlertDialog(
              title: const Text('Selecciona filtros para exportar'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Filtro Anexo:'),
                    ),
                    ...[
                      'TODOS',
                      'Localizados',
                      'NO Localizados',
                      'Alta',
                      'Propuesta Baja'
                    ].map(
                      (opcion) => RadioListTile<String>(
                        dense: true,
                        title: Text(opcion),
                        value: opcion,
                        groupValue: localAnexo,
                        onChanged: (val) => setState(() => localAnexo = val!),
                      ),
                    ),
                    const Divider(),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Filtro Unidad Presupuestal:'),
                    ),
                    const SizedBox(height: 8),
                    ...unidadesDisponibles.map((unidadNombre) {
                      return RadioListTile<String>(
                        dense: true,
                        title: Text(unidadNombre),
                        value: unidadNombre,
                        groupValue: localNivel1,
                        onChanged: (val) => setState(() => localNivel1 = val!),
                      );
                    }),
                    const Divider(),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Clase de Activo:'),
                    ),
                    DropdownButton<String>(
                      value: localClaseActivo,
                      isExpanded: true,
                      items: clasesDeActivo.map((clase) {
                        return DropdownMenuItem(
                          value: clase,
                          child: Text(clase),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => localClaseActivo = val!);
                      },
                    ),
                    const Divider(),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Filtro por Precio (en UMA):'),
                    ),
                    const SizedBox(height: 4),
                    ...['TODOS', 'MENOS A 20 UMAS', 'MAYOR A 20 UMAS'].map(
                      (opcion) => RadioListTile<String>(
                        dense: true,
                        title: Text(opcion),
                        value: opcion,
                        groupValue: localFiltroPrecio,
                        onChanged: (val) =>
                            setState(() => localFiltroPrecio = val!),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: TextEditingController(
                        text: localUmaValue.toStringAsFixed(2),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Valor de la UMA (MXN)',
                        hintText: 'Ej. 113.14',
                        suffixText: 'MXN',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customGreen, width: 2),
                        ),
                        labelStyle: const TextStyle(
                          color: customGreen,
                        ),
                      ),
                      onChanged: (val) {
                        final newValue =
                            double.tryParse(val.replaceAll(',', '.'));
                        if (newValue != null && newValue > 0) {
                          setState(() => localUmaValue = newValue);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '20 UMAS = ${(localUmaValue * 20).toStringAsFixed(2)} MXN',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: customGreen,
                      ),
                    ),
                    const Divider(),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Excluir NO inventariables'),
                      value: localExcluirNoInventariables,
                      onChanged: (v) => setState(
                          () => localExcluirNoInventariables = v ?? true),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  style: TextButton.styleFrom(
                    foregroundColor: customGreen,
                  ),
                  child: const Text('CANCELAR'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop({
                    'anexo': localAnexo,
                    'nivel1': localNivel1,
                    'clase': localClaseActivo,
                    'filtroPrecio': localFiltroPrecio,
                    'umaValue': localUmaValue,
                    'excluirNoInventariables': localExcluirNoInventariables,
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('DESCARGAR'),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (result == null) return;
  filtroAnexo = result['anexo'] as String;
  filtroNivel1 = result['nivel1'] as String;
  filtroClaseActivo = result['clase'] as String;
  filtroPrecio = result['filtroPrecio'] as String;
  umaValue = (result['umaValue'] as double?) ?? 113.14;
  excluirNoInventariables =
      (result['excluirNoInventariables'] as bool?) ?? true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customGreen),
            ),
            const SizedBox(width: 20),
            const Expanded(
                child: Text('Procesando y generando archivos Excel...')),
          ],
        ),
      );
    },
  );

  try {
    // Cargar datos de depreciación UNA SOLA VEZ (Solo cargar vida útil)
    final depreciacionSnapshot =
        await firestore.collection('depreciacion').get();
    final Map<String, int> vidaUtilData = {};

    for (final doc in depreciacionSnapshot.docs) {
      final data = doc.data();
      final nombre = data['nombre'] as String;
      final vidaUtil = (data['vidautil'] as num?)?.toInt() ?? 0;
      vidaUtilData[nombre] = vidaUtil;
    }

    // CONTAR PRIMERO cuántos registros totales hay
    Query queryBase = firestore.collection('bienesmuebles');

    if (filtroAnexo != 'TODOS') {
      String valorAnexo = '';
      switch (filtroAnexo) {
        case 'Localizados':
          valorAnexo = 'ANEXO 1';
          break;
        case 'NO Localizados':
          valorAnexo = 'ANEXO 2';
          break;
        case 'Alta':
          valorAnexo = 'ANEXO 3';
          break;
        case 'Propuesta Baja':
          valorAnexo = 'ANEXO 4';
          break;
      }
      if (valorAnexo.isNotEmpty) {
        queryBase = queryBase.where('anexo', isEqualTo: valorAnexo);
      }
    }

    if (filtroNivel1 != 'TODOS') {
      queryBase =
          queryBase.where('nivel1organizacion', isEqualTo: filtroNivel1);
    }

    if (filtroClaseActivo != 'TODOS') {
      queryBase =
          queryBase.where('clasedeactivo', isEqualTo: filtroClaseActivo);
    }

    // Contar registros totales (aproximado)
    final countSnapshot = await queryBase.limit(1).get();
    if (countSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ No se encontraron registros.')),
      );
      Navigator.of(context).pop();
      return;
    }

    // Configuración de lotes
    const int REGISTROS_POR_LOTE = 15000; // Límite por archivo Excel
    const int REGISTROS_POR_CONSULTA = 500; // Para evitar timeouts de Firestore

    // Variables para procesar por lotes
    int numeroArchivo = 1;
    int totalProcesados = 0;
    int excluidosNoInventariablesCount = 0;
    QueryDocumentSnapshot? ultimoDocumento;
    bool hayMasDatos = true;

    while (hayMasDatos) {
      List<QueryDocumentSnapshot> loteActual = [];

      // Recopilar datos para este lote (hasta REGISTROS_POR_LOTE)
      while (loteActual.length < REGISTROS_POR_LOTE && hayMasDatos) {
        Query query = queryBase
            .orderBy('fechaadquisicion', descending: false)
            .orderBy('inventario2025', descending: false)
            .limit(REGISTROS_POR_CONSULTA);

        if (ultimoDocumento != null) {
          query = query.startAfterDocument(ultimoDocumento);
        }

        final snapshot = await query.get();

        if (snapshot.docs.isEmpty) {
          hayMasDatos = false;
          break;
        }

        // Agregar directamente al lote actual (respetando el límite)
        final espacioDisponible = REGISTROS_POR_LOTE - loteActual.length;
        final documentosParaAgregar =
            snapshot.docs.take(espacioDisponible).toList();

        loteActual.addAll(documentosParaAgregar);
        ultimoDocumento = snapshot.docs.last;

        // Si llenamos el lote, salir del while interno
        if (loteActual.length >= REGISTROS_POR_LOTE) {
          break;
        }

        // Pequeña pausa para no sobrecargar Firestore
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (loteActual.isEmpty) break;

      // PROCESAR Y GENERAR EXCEL PARA ESTE LOTE
      final resultadoLote = await _generarExcelParaLote(
        context,
        loteActual,
        numeroArchivo,
        filtroNivel1,
        excluirNoInventariables,
      );

      totalProcesados += resultadoLote['procesados'] as int;
      excluidosNoInventariablesCount += resultadoLote['excluidos'] as int;
      numeroArchivo++;

      // Mostrar progreso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '📄 Archivo $numeroArchivo generado. Procesados: ${resultadoLote['procesados']} (Excluidos: ${resultadoLote['excluidos']})'),
          duration: const Duration(seconds: 2),
        ),
      );

      // IMPORTANTE: Limpiar memoria del lote procesado
      loteActual.clear();

      // Pausa para liberar memoria
      await Future.delayed(const Duration(milliseconds: 500));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '✅ Exportación completada! $totalProcesados registros en ${numeroArchivo - 1} archivos\n'
            'Excluidos (NO inventariables): $excluidosNoInventariablesCount'),
        duration: const Duration(seconds: 6),
      ),
    );
  } catch (e, st) {
    debugPrint('❌ Error al exportar: $e\n$st');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Error al exportar datos: $e')),
    );
  } finally {
    Navigator.of(context).pop();
  }
}

// Función separada para generar cada archivo Excel
Future<Map<String, dynamic>> _generarExcelParaLote(
  BuildContext context,
  List<QueryDocumentSnapshot> documentos,
  int numeroArchivo,
  String? filtroNivel1,
  bool excluirNoInventariables,
) async {
  final excel = Excel.createExcel();
  final hoja = excel.tables.keys.first;
  final sheet = excel[hoja];

  // Encabezados MODIFICADOS
  final encabezados = [
    'NÚMERO ID',
    'ID ANTERIOR',
    'NOMBRE', // CAMBIADO DE "DESCRIPCIÓN" A "NOMBRE"
    'MARCA',
    'MODELO',
    'SERIE',
    'COSTO \$',
    'AVALUO \$', // NUEVA COLUMNA
    'FECHA AVALUO', // NUEVA COLUMNA
    'ESTADO FÍSICO',
    'DESCRIPCIÓN', // ESTA ES LA DESCRIPCIÓN DEL BIEN
    'UBICACIÓN',
    'USUARIO',
    'COLOR',
    'FECHA ADQUISICIÓN',
    'LICITACION',
    'ORIGEN RECURSO',
    'TIPO RECURSO',
    'FACTURA',
    'PROVEEDOR',
    'CLASE DE ACTIVO',
    'AÑO FISCAL',
    'NIVEL 1. ORGANIZACIÓN',
    'NIVEL 2. DIRECCIÓN',
    'NIVEL 3. JURISDICCIÓN',
    'SERIE MONITOR',
    'SERIE TECLADO',
    'SERIE MOUSE',
    'PLACA',
    'DEPOSITARIO',
    'CARGO DEPOSITARIO',
    'TIPO DE ANEXO',
  ];

  final campos = [
    'inventario2025',
    'numeroinventario',
    'nombre',
    'marcacomercial',
    'modelo',
    'numeroseriedelbien',
    'importeinicialbien',
    'avaluo', // NUEVA COLUMNA
    'fechaavaluo', // NUEVA COLUMNA
    'estatusdelbien',
    'descripciondelbien',
    'ubicacionfisica',
    'depositario',
    'color',
    'fechaadquisicion',
    'licitacion',
    'origenrecurso',
    'tiporecurso',
    'factura',
    'nombredelprovedor',
    'clasedeactivo',
    'aniofiscal',
    'nivel1organizacion',
    'nivel2direccion',
    'nivel3jurisdiccion',
    'serimonitor',
    'serieteclado',
    'seriemouse',
    'placa',
    'tituladelbien',
    'cargotitular',
    'anexo',
  ];

  // Aplicar formato a los encabezados
  for (int col = 0; col < encabezados.length; col++) {
    final cell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
    cell.value = encabezados[col];
    cell.cellStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );
  }

  // Filtrar documentos por "NO inventariables" si es necesario
  List<QueryDocumentSnapshot> documentosFiltrados = [];
  int excluidosCount = 0;

  for (final doc in documentos) {
    final data = doc.data() as Map<String, dynamic>;

    if (excluirNoInventariables) {
      final cotejo = (data['cotejodoc'] ?? '').toString().trim().toUpperCase();
      if (cotejo == 'NO') {
        excluidosCount++;
        continue;
      }
    }

    documentosFiltrados.add(doc);
  }

  // Procesar cada documento filtrado
  for (int i = 0; i < documentosFiltrados.length; i++) {
    final data = documentosFiltrados[i].data() as Map<String, dynamic>;

    // Llenar fila
    for (int j = 0; j < campos.length; j++) {
      final cell = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1));

      dynamic valor = data[campos[j]];

      if (valor is Timestamp) {
        cell.value = DateFormat('dd/MM/yyyy').format(valor.toDate());
      } else if (valor == null ||
          valor.toString().trim().isEmpty ||
          valor == 'null' ||
          valor.toString().toLowerCase() == 'null') {
        cell.value = '-----';
      } else {
        switch (campos[j]) {
          case 'inventario2025':
          case 'numeroinventario':
          case 'importeinicialbien':
          case 'avaluo':
          case 'aniofiscal':
            if (valor is num) {
              cell.value = valor;
            } else if (valor is String &&
                valor.isNotEmpty &&
                valor != '-----') {
              final numValue = num.tryParse(valor.replaceAll(',', ''));
              cell.value = numValue ?? valor;
            } else {
              cell.value = valor;
            }
            break;
          default:
            cell.value = valor.toString();
        }
      }

      cell.cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
      );
    }
  }

  // Ajustar el ancho de las columnas
  for (var i = 0; i < encabezados.length; i++) {
    sheet.setColAutoFit(i);
  }

  // Generar nombre de archivo basado en filtro de Unidad Presupuestal
  String prefijo;
  if (filtroNivel1 == null || filtroNivel1 == 'TODOS') {
    prefijo = 'BienesMuebles';
  } else {
    prefijo = filtroNivel1!;
  }

  String sufijo = '';
  if (numeroArchivo > 1) {
    sufijo = '_Parte$numeroArchivo';
  }

  final fileName =
      '${prefijo}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}$sufijo.xlsx';

  // Exportar archivo
  final bytes = excel.encode();
  if (bytes == null) throw Exception('Error al codificar Excel');

  final blob = html.Blob([bytes],
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(url);

  // Retornar estadísticas
  return {
    'procesados': documentosFiltrados.length,
    'excluidos': excluidosCount,
  };
}
