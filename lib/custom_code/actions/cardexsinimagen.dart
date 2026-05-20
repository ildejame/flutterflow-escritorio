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

import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'dart:math' as math;

Future<int> cardexsinimagen(BuildContext context) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    // ------------------------------------------------------------------------
    // 1. SELECCIÓN DE ARCHIVO
    // ------------------------------------------------------------------------
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('No seleccionaste ningún archivo.')),
      );
      return 0;
    }

    final excelFile = result.files.first;
    if (excelFile.extension?.toLowerCase() != 'xlsx') {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
            content: Text('Debes seleccionar un archivo .xlsx válido.')),
      );
      return 0;
    }

    // ------------------------------------------------------------------------
    // 2. INTERFAZ DE PROGRESO
    // ------------------------------------------------------------------------
    final processingNotifier = ValueNotifier<String>('Iniciando lectura...');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ValueListenableBuilder<String>(
        valueListenable: processingNotifier,
        builder: (context, message, _) => AlertDialog(
          title: const Text('Procesando Inventario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );

    void updateProgress(String message) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        processingNotifier.value = message;
      });
    }

    // ------------------------------------------------------------------------
    // 3. LECTURA DEL EXCEL
    // ------------------------------------------------------------------------
    await Future.delayed(const Duration(milliseconds: 300));
    updateProgress('Analizando estructura del archivo...');

    final excel = Excel.decodeBytes(excelFile.bytes!);
    final sheet = excel.tables[excel.tables.keys.first];

    if (sheet == null || sheet.rows.length <= 1) {
      Navigator.of(context, rootNavigator: true).pop();
      scaffoldMessenger.showSnackBar(
        const SnackBar(
            content: Text('El archivo Excel está vacío o no es válido.')),
      );
      return 0;
    }

    // ------------------------------------------------------------------------
    // 4. CARGA DE CATÁLOGO (VIDAS ÚTILES)
    // ------------------------------------------------------------------------
    updateProgress('Cargando catálogo de depreciación...');
    await Future.delayed(const Duration(milliseconds: 50));

    final Map<String, int> vidaUtilMap = {};
    try {
      final depSnapshot =
          await FirebaseFirestore.instance.collection('depreciacion').get();
      for (var doc in depSnapshot.docs) {
        final data = doc.data();
        String nombreRaw = (data['nombre'] ?? '').toString();
        if (nombreRaw.isEmpty)
          nombreRaw = (data['descripcion'] ?? '').toString();
        final vida = (data['vidautil'] as num?)?.toInt() ?? 0;

        if (nombreRaw.isNotEmpty) {
          String claveLimpia = _generarClaveComparacion(nombreRaw);
          vidaUtilMap[claveLimpia] = vida;
        }
      }
    } catch (e) {
      print('Error cargando vidas útiles: $e');
    }

    // ------------------------------------------------------------------------
    // 4.5 PRE-VALIDACIÓN (DUPLICADOS Y CLASES)
    // ------------------------------------------------------------------------
    updateProgress('Verificando duplicados y clases de activo...');
    await Future.delayed(const Duration(milliseconds: 100));

    final Set<String> idsVistos = {};
    final int totalRows = sheet.rows.length;

    for (int i = 1; i < totalRows; i++) {
      if (i % 100 == 0) {
        updateProgress('Verificando integridad fila $i de $totalRows...');
        await Future.delayed(const Duration(milliseconds: 5));
      }

      final row = sheet.rows[i];
      if (row.isEmpty || row.every((cell) => cell?.value == null)) continue;

      // Validación ID (Columna 0)
      var celdaId = row.isNotEmpty ? row[0] : null;
      // USAR HELPERS DE LIMPIEZA AQUÍ TAMBIÉN
      String id = _obtenerValorLimpio(celdaId);

      if (id.isNotEmpty) {
        if (idsVistos.contains(id)) {
          throw Exception(
              'Fila ${i + 1} Error: El ID "$id" está repetido en el archivo.');
        }
        idsVistos.add(id);
      }

      // Validación Clase (Columna 14) y Depreciable (Columna 33)
      var celdaClase = row.length > 14 ? row[14] : null;
      var celdaDepreciable = row.length > 33 ? row[33] : null;

      String claseRaw = _obtenerValorLimpio(celdaClase);
      String depValRaw = _obtenerValorLimpio(celdaDepreciable);

      String depVal = depValRaw.toUpperCase().replaceAll('.', '');
      bool esDepreciable = ['SI', 'SÍ'].contains(depVal);

      if (esDepreciable && claseRaw.isNotEmpty) {
        String claseLimpia = _generarClaveComparacion(claseRaw);
        bool existe = false;
        if (vidaUtilMap.containsKey(claseLimpia)) {
          existe = true;
        } else {
          String sinNumeros = claseLimpia.replaceAll(RegExp(r'^[0-9]+ '), '');
          if (vidaUtilMap.containsKey(sinNumeros)) {
            existe = true;
          } else {
            for (var key in vidaUtilMap.keys) {
              if (key.contains(claseLimpia) || claseLimpia.contains(key)) {
                existe = true;
                break;
              }
            }
          }
        }

        if (!existe) {
          throw Exception(
              'Fila ${i + 1} Error: No se encontró la clase "$claseRaw" en Firebase.');
        }
      }
    }

    // ------------------------------------------------------------------------
    // 5. MAPEO Y LIMPIEZA DE DATOS (LA SOLUCIÓN PRINCIPAL)
    // ------------------------------------------------------------------------

    List<Map<String, dynamic>> filasValidadas = [];
    const fieldNames = [
      'inventario2025', // 0
      'numeroinventario', // 1
      'nombre', // 2
      'marcacomercial', // 3
      'modelo', // 4
      'numeroseriedelbien', // 5
      'color', // 6
      'importeinicialbien', // 7
      'estatusdelbien', // 8
      'aniofiscal', // 9
      'nivel1organizacion', // 10
      'nivel2direccion', // 11
      'nivel3jurisdiccion', // 12
      'distrito', // 13
      'clasedeactivo', // 14
      'descripciondelbien', // 15
      'tituladelbien', // 16
      'origenrecurso', // 17
      'factura', // 18
      'fechaadquisicion', // 19
      'nombredelprovedor', // 20
      'tiporecurso', // 21
      'licitacion', // 22
      'origenrecurso', // 23 (Nota: origenrecurso está repetido en tu lista original, pero mantenemos el índice)
      'pif', // 24
      'placa', // 25
      'cargotitular', // 26
      'anexo', // 27
      'ubicacionfisica', // 28
      'depositario', // 29
      'avaluo', // 30
      'fechaavaluo', // 31
      'cotejodoc', // 32
      'depreciable' // 33
    ];

    final cutoff2020 = DateTime(2020, 1, 1);

    for (int i = 1; i < sheet.rows.length; i++) {
      if (i % 50 == 0) {
        updateProgress('Validando datos fila $i de $totalRows...');
        await Future.delayed(const Duration(milliseconds: 8));
      }

      final row = sheet.rows[i];
      if (row.isEmpty || row.every((cell) => cell?.value == null)) continue;

      final data = <String, dynamic>{};

      for (int j = 0; j < fieldNames.length; j++) {
        final fieldName = fieldNames[j];
        final cell = j < row.length ? row[j] : null;

        // --- AQUÍ ESTÁ LA CORRECCIÓN CLAVE ---
        // Obtenemos el valor limpio usando la función auxiliar que detecta .0
        String rawValue = _obtenerValorLimpio(cell);

        switch (fieldName) {
          case 'fechaadquisicion':
          case 'fechaavaluo':
            // Pasamos el valor limpio al parser de fecha
            data[fieldName] = _parsearFechaConHoraFija(rawValue);
            break;

          case 'importeinicialbien':
          case 'avaluo':
          case 'aniofiscal':
            data[fieldName] = _parsearValorMonetario(rawValue);
            break;

          case 'depreciable':
            if (rawValue.isEmpty) {
              throw Exception(
                  'Fila ${i + 1} Error: Columna "Depreciable" vacía.');
            }
            String depVal = rawValue.toUpperCase().replaceAll('.', '');
            if (['SI', 'SÍ'].contains(depVal))
              data[fieldName] = 'SI';
            else if (['NO'].contains(depVal))
              data[fieldName] = 'NO';
            else
              throw Exception(
                  'Fila ${i + 1} Error: Valor inválido en "Depreciable" ($rawValue).');
            break;

          default:
            // Para todos los demás campos de texto (inventario, nombre, etc.)
            // rawValue ya viene sin .0 y sin espacios extra.
            data[fieldName] = rawValue;
        }
      }

      bool esDepreciable = data['depreciable'] == 'SI';
      double costo = data['importeinicialbien'] as double? ?? 0.0;
      double avaluo = data['avaluo'] as double? ?? 0.0;
      DateTime? fAdq = data['fechaadquisicion'] as DateTime?;
      DateTime? fAval = data['fechaavaluo'] as DateTime?;

      bool tieneAlmenosUnMonto = (costo > 0 || avaluo > 0);
      bool tieneAlmenosUnaFecha = (fAdq != null || fAval != null);

      if (!tieneAlmenosUnMonto)
        throw Exception('Fila ${i + 1} Error: Falta MONTO ($costo / $avaluo).');
      if (!tieneAlmenosUnaFecha)
        throw Exception('Fila ${i + 1} Error: Falta FECHA.');

      bool usarAvaluo = false;
      if (fAdq == null)
        usarAvaluo = true;
      else if (fAdq.isBefore(cutoff2020)) {
        if (avaluo > 0 && fAval != null) usarAvaluo = true;
      } else {
        if (costo <= 0 && avaluo > 0 && fAval != null) usarAvaluo = true;
      }

      double montoBase = usarAvaluo ? avaluo : costo;
      DateTime? fechaInicio = usarAvaluo ? fAval : fAdq;

      data['_montoBaseCalculado'] = montoBase;
      data['_fechaInicioCalculada'] = fechaInicio;
      data['fechaalta'] = FieldValue.serverTimestamp();

      filasValidadas.add(data);
    }

    // ------------------------------------------------------------------------
    // 6. PROCESAMIENTO MASIVO (SUBIDA)
    // ------------------------------------------------------------------------

    int bienesSubidos = 0;
    WriteBatch currentBatch = FirebaseFirestore.instance.batch();
    int batchCount = 0;
    const int BATCH_LIMIT = 250;
    final DateTime fechaActualCalculo = DateTime.now();

    for (int k = 0; k < filasValidadas.length; k++) {
      if (k % 50 == 0) {
        updateProgress(
            'Subiendo registro ${k + 1} de ${filasValidadas.length}...');
        await Future.delayed(const Duration(milliseconds: 5));
      }

      final data = filasValidadas[k];
      final docRefBien =
          FirebaseFirestore.instance.collection('bienesmuebles').doc();

      double montoBase = data['_montoBaseCalculado'];
      DateTime? fechaInicio = data['_fechaInicioCalculada'];

      // Limpiamos los campos temporales antes de subir
      data.remove('_montoBaseCalculado');
      data.remove('_fechaInicioCalculada');

      currentBatch.set(docRefBien, data);
      batchCount++;
      bienesSubidos++;

      // LOGICA DEPRECIACIÓN
      if (data['depreciable'] == 'SI' && montoBase > 0 && fechaInicio != null) {
        String claseRaw = data['clasedeactivo'].toString();
        String claseLimpia = _generarClaveComparacion(claseRaw);

        int vidaUtilAnios = 0;
        if (vidaUtilMap.containsKey(claseLimpia)) {
          vidaUtilAnios = vidaUtilMap[claseLimpia]!;
        } else {
          String sinNumeros = claseLimpia.replaceAll(RegExp(r'^[0-9]+ '), '');
          if (vidaUtilMap.containsKey(sinNumeros))
            vidaUtilAnios = vidaUtilMap[sinNumeros]!;
          else {
            for (var entry in vidaUtilMap.entries) {
              if (entry.key.contains(claseLimpia) ||
                  claseLimpia.contains(entry.key)) {
                vidaUtilAnios = entry.value;
                break;
              }
            }
          }
        }

        if (vidaUtilAnios > 0) {
          DateTime fechaContable;
          if (fechaInicio.day > 15) {
            fechaContable =
                DateTime(fechaInicio.year, fechaInicio.month + 1, 1);
          } else {
            fechaContable = DateTime(fechaInicio.year, fechaInicio.month, 1);
          }

          final int totalMesesVida = vidaUtilAnios * 12;
          final double cuotaMensual = montoBase / totalMesesVida;

          double sumaDepreciada = 0.0;
          int mesesAcumulados = 0;
          int anioCalculo = fechaContable.year;
          int mesInicioAnual = fechaContable.month;

          while (mesesAcumulados < totalMesesVida) {
            if (batchCount % 100 == 0) {
              await Future.delayed(const Duration(milliseconds: 1));
            }

            int mesesEnEsteAno = 0;
            if (anioCalculo == fechaContable.year) {
              mesesEnEsteAno = 12 - mesInicioAnual + 1;
            } else {
              mesesEnEsteAno = 12;
            }

            int mesesRestantes = totalMesesVida - mesesAcumulados;
            mesesEnEsteAno = math.min(mesesEnEsteAno, mesesRestantes);

            if (mesesEnEsteAno > 0) {
              double montoEsteAno;
              bool esUltimoTramo =
                  (mesesAcumulados + mesesEnEsteAno) >= totalMesesVida;

              if (esUltimoTramo) {
                montoEsteAno = montoBase - sumaDepreciada;
                if (montoEsteAno < 0) montoEsteAno = 0;
                montoEsteAno = _round2(montoEsteAno);
              } else {
                montoEsteAno = _trunc2(cuotaMensual * mesesEnEsteAno);
              }

              sumaDepreciada += montoEsteAno;
              mesesAcumulados += mesesEnEsteAno;

              final docRefDep = FirebaseFirestore.instance
                  .collection('calculodepreciacion')
                  .doc();
              final mapDep = {
                'inventario2025': data['inventario2025'] ?? '',
                'aniodepreciacion': anioCalculo,
                'fechacalculo': fechaActualCalculo,
                'depreciacion': montoEsteAno,
                'precioavaluo': data['avaluo'] ?? 0.0,
                'preciocosto': data['importeinicialbien'] ?? 0.0,
                'descripcion': data['nombre'] ?? '',
                'unidadpresupuestal': data['nivel1organizacion'] ?? '',
                'fechaadquisicion': data['fechaadquisicion'],
                'fechaavaluo': data['fechaavaluo'],
                'clasedeactivo': claseRaw,
                'bien_ref': docRefBien.id,
              };
              currentBatch.set(docRefDep, mapDep);
              batchCount++;
            }
            anioCalculo++;
          }
        }
      }

      if (batchCount >= BATCH_LIMIT) {
        updateProgress('Guardando en base de datos...');
        await currentBatch.commit();
        await Future.delayed(const Duration(milliseconds: 100));
        batchCount = 0;
        currentBatch = FirebaseFirestore.instance.batch();
      }
    }

    if (batchCount > 0) {
      updateProgress('Finalizando últimos registros...');
      await currentBatch.commit();
    }

    Navigator.of(context, rootNavigator: true).pop();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Proceso Completado!'),
        content: Text(
            'Se registraron exitosamente $bienesSubidos bienes muebles.\n(Bienes con vida útil 0 fueron registrados sin depreciación)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF164B2D))),
          ),
        ],
      ),
    );
    return bienesSubidos;
  } catch (e) {
    if (Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validación Fallida'),
        content: SingleChildScrollView(
            child: Text(
          e.toString().replaceAll('Exception: ', ''),
          style: const TextStyle(color: Colors.red),
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
    return 0;
  }
}

// ============================================================================
// UTILIDADES (HELPERS)
// ============================================================================

// NUEVA FUNCIÓN DE LIMPIEZA MAESTRA
String _obtenerValorLimpio(Data? cell) {
  if (cell == null || cell.value == null) return '';

  var val = cell.value;
  String result = '';

  // Si es un número (ej. 1042.0), verificamos si es entero
  if (val is double) {
    if (val % 1 == 0) {
      // Es un entero disfrazado de double (1042.0 -> "1042")
      result = val.toInt().toString();
    } else {
      // Es realmente decimal
      result = val.toString();
    }
  } else {
    // Es texto u otro tipo
    result = val.toString();
  }

  // Limpieza de caracteres extraños y espacios
  result = result.trim();
  result = result.replaceAll('\u00A0', ' '); // Espacio de no separación
  result = result.replaceAll(RegExp(r'\s+'), ' '); // Dobles espacios a uno

  // Seguridad extra por si quedó un .0 al final en un string
  if (result.endsWith('.0')) {
    result = result.substring(0, result.length - 2);
  }

  return result;
}

String _generarClaveComparacion(String texto) {
  if (texto.isEmpty) return '';
  String t = texto.toUpperCase();
  t = t.replaceAll('\u00A0', ' ');
  t = t.replaceAll('\u200B', '');
  t = t
      .replaceAll('Á', 'A')
      .replaceAll('É', 'E')
      .replaceAll('Í', 'I')
      .replaceAll('Ó', 'O')
      .replaceAll('Ú', 'U')
      .replaceAll('Ü', 'U')
      .replaceAll('Ñ', 'N');
  t = t.replaceAll(RegExp(r'[^A-Z0-9 ]'), '');
  t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
  return t;
}

double _trunc2(double val) {
  return (val * 100).truncateToDouble() / 100;
}

double _round2(double val) {
  return (val * 100).roundToDouble() / 100;
}

double _parsearValorMonetario(String? value) {
  if (value == null || value.isEmpty) return 0.0;
  try {
    // Eliminamos todo lo que no sea dígito, punto o guion
    final cleaned = value.replaceAll(RegExp(r'[^\d.,-]'), '');
    // Si tiene comas, las quitamos para parsear
    final number = double.tryParse(cleaned.replaceAll(',', ''));
    return number ?? 0.0;
  } catch (_) {
    return 0.0;
  }
}

DateTime? _parsearFechaConHoraFija(String? value) {
  if (value == null || value.trim().isEmpty) return null;

  String limpio = value.trim().toUpperCase();
  DateTime? fechaBase = DateTime.tryParse(limpio);

  if (fechaBase == null) {
    final excelDate = double.tryParse(limpio);
    if (excelDate != null) {
      fechaBase = DateTime.fromMillisecondsSinceEpoch(
        ((excelDate - 25569) * 86400000).round(),
        isUtc: true,
      );
    }
  }

  if (fechaBase == null) {
    try {
      String normalizado = limpio.replaceAll('T', ' ');
      normalizado = normalizado.replaceAll('/', '-');
      if (normalizado.contains(' ')) {
        normalizado = normalizado.split(' ')[0];
      }

      List<String> partes = normalizado.split('-');
      if (partes.length == 3) {
        int p1 = int.parse(partes[0]);
        int p2 = int.parse(partes[1]);
        int p3 = int.parse(partes[2]);

        if (p1 > 1000) {
          fechaBase = DateTime(p1, p2, p3);
        } else {
          if (p3 < 100) p3 += 2000;
          fechaBase = DateTime(p3, p2, p1);
        }
      }
    } catch (_) {}
  }

  if (fechaBase == null) return null;
  return DateTime(fechaBase.year, fechaBase.month, fechaBase.day, 12, 0, 0);
}
