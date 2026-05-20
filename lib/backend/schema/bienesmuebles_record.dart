import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BienesmueblesRecord extends FirestoreRecord {
  BienesmueblesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  bool hasNombre() => _nombre != null;

  // "fechaalta" field.
  DateTime? _fechaalta;
  DateTime? get fechaalta => _fechaalta;
  bool hasFechaalta() => _fechaalta != null;

  // "fechaadquisicion" field.
  DateTime? _fechaadquisicion;
  DateTime? get fechaadquisicion => _fechaadquisicion;
  bool hasFechaadquisicion() => _fechaadquisicion != null;

  // "fechademodificacion" field.
  DateTime? _fechademodificacion;
  DateTime? get fechademodificacion => _fechademodificacion;
  bool hasFechademodificacion() => _fechademodificacion != null;

  // "fechadebaja" field.
  DateTime? _fechadebaja;
  DateTime? get fechadebaja => _fechadebaja;
  bool hasFechadebaja() => _fechadebaja != null;

  // "estatusdelbien" field.
  String? _estatusdelbien;
  String get estatusdelbien => _estatusdelbien ?? '';
  bool hasEstatusdelbien() => _estatusdelbien != null;

  // "escontable" field.
  bool? _escontable;
  bool get escontable => _escontable ?? false;
  bool hasEscontable() => _escontable != null;

  // "numeroinventario" field.
  String? _numeroinventario;
  String get numeroinventario => _numeroinventario ?? '';
  bool hasNumeroinventario() => _numeroinventario != null;

  // "depositario" field.
  String? _depositario;
  String get depositario => _depositario ?? '';
  bool hasDepositario() => _depositario != null;

  // "importeinicialbien" field.
  double? _importeinicialbien;
  double get importeinicialbien => _importeinicialbien ?? 0.0;
  bool hasImporteinicialbien() => _importeinicialbien != null;

  // "tituladelbien" field.
  String? _tituladelbien;
  String get tituladelbien => _tituladelbien ?? '';
  bool hasTituladelbien() => _tituladelbien != null;

  // "numeroseriedelbien" field.
  String? _numeroseriedelbien;
  String get numeroseriedelbien => _numeroseriedelbien ?? '';
  bool hasNumeroseriedelbien() => _numeroseriedelbien != null;

  // "aniofiscal" field.
  int? _aniofiscal;
  int get aniofiscal => _aniofiscal ?? 0;
  bool hasAniofiscal() => _aniofiscal != null;

  // "ubicacionfisica" field.
  String? _ubicacionfisica;
  String get ubicacionfisica => _ubicacionfisica ?? '';
  bool hasUbicacionfisica() => _ubicacionfisica != null;

  // "factura" field.
  String? _factura;
  String get factura => _factura ?? '';
  bool hasFactura() => _factura != null;

  // "nombredelprovedor" field.
  String? _nombredelprovedor;
  String get nombredelprovedor => _nombredelprovedor ?? '';
  bool hasNombredelprovedor() => _nombredelprovedor != null;

  // "cuentacontable" field.
  String? _cuentacontable;
  String get cuentacontable => _cuentacontable ?? '';
  bool hasCuentacontable() => _cuentacontable != null;

  // "marcacomercial" field.
  String? _marcacomercial;
  String get marcacomercial => _marcacomercial ?? '';
  bool hasMarcacomercial() => _marcacomercial != null;

  // "color" field.
  String? _color;
  String get color => _color ?? '';
  bool hasColor() => _color != null;

  // "origenrecurso" field.
  String? _origenrecurso;
  String get origenrecurso => _origenrecurso ?? '';
  bool hasOrigenrecurso() => _origenrecurso != null;

  // "licitacion" field.
  String? _licitacion;
  String get licitacion => _licitacion ?? '';
  bool hasLicitacion() => _licitacion != null;

  // "categoria" field.
  String? _categoria;
  String get categoria => _categoria ?? '';
  bool hasCategoria() => _categoria != null;

  // "descripciondeubicacion" field.
  String? _descripciondeubicacion;
  String get descripciondeubicacion => _descripciondeubicacion ?? '';
  bool hasDescripciondeubicacion() => _descripciondeubicacion != null;

  // "distrito" field.
  String? _distrito;
  String get distrito => _distrito ?? '';
  bool hasDistrito() => _distrito != null;

  // "placa" field.
  String? _placa;
  String get placa => _placa ?? '';
  bool hasPlaca() => _placa != null;

  // "descripciondelbien" field.
  String? _descripciondelbien;
  String get descripciondelbien => _descripciondelbien ?? '';
  bool hasDescripciondelbien() => _descripciondelbien != null;

  // "comentarioadicional" field.
  String? _comentarioadicional;
  String get comentarioadicional => _comentarioadicional ?? '';
  bool hasComentarioadicional() => _comentarioadicional != null;

  // "nombredelproveedor" field.
  String? _nombredelproveedor;
  String get nombredelproveedor => _nombredelproveedor ?? '';
  bool hasNombredelproveedor() => _nombredelproveedor != null;

  // "encargado" field.
  String? _encargado;
  String get encargado => _encargado ?? '';
  bool hasEncargado() => _encargado != null;

  // "verificavs" field.
  String? _verificavs;
  String get verificavs => _verificavs ?? '';
  bool hasVerificavs() => _verificavs != null;

  // "folioresguardo" field.
  String? _folioresguardo;
  String get folioresguardo => _folioresguardo ?? '';
  bool hasFolioresguardo() => _folioresguardo != null;

  // "cotejodoc" field.
  String? _cotejodoc;
  String get cotejodoc => _cotejodoc ?? '';
  bool hasCotejodoc() => _cotejodoc != null;

  // "inventario" field.
  String? _inventario;
  String get inventario => _inventario ?? '';
  bool hasInventario() => _inventario != null;

  // "modelo" field.
  String? _modelo;
  String get modelo => _modelo ?? '';
  bool hasModelo() => _modelo != null;

  // "adquisicion" field.
  String? _adquisicion;
  String get adquisicion => _adquisicion ?? '';
  bool hasAdquisicion() => _adquisicion != null;

  // "tiporecurso" field.
  String? _tiporecurso;
  String get tiporecurso => _tiporecurso ?? '';
  bool hasTiporecurso() => _tiporecurso != null;

  // "depreciacion" field.
  double? _depreciacion;
  double get depreciacion => _depreciacion ?? 0.0;
  bool hasDepreciacion() => _depreciacion != null;

  // "clasedeactivo" field.
  String? _clasedeactivo;
  String get clasedeactivo => _clasedeactivo ?? '';
  bool hasClasedeactivo() => _clasedeactivo != null;

  // "nivel1organizacion" field.
  String? _nivel1organizacion;
  String get nivel1organizacion => _nivel1organizacion ?? '';
  bool hasNivel1organizacion() => _nivel1organizacion != null;

  // "nivel2direccion" field.
  String? _nivel2direccion;
  String get nivel2direccion => _nivel2direccion ?? '';
  bool hasNivel2direccion() => _nivel2direccion != null;

  // "nivel3jurisdiccion" field.
  String? _nivel3jurisdiccion;
  String get nivel3jurisdiccion => _nivel3jurisdiccion ?? '';
  bool hasNivel3jurisdiccion() => _nivel3jurisdiccion != null;

  // "inmueble" field.
  String? _inmueble;
  String get inmueble => _inmueble ?? '';
  bool hasInmueble() => _inmueble != null;

  // "zona" field.
  String? _zona;
  String get zona => _zona ?? '';
  bool hasZona() => _zona != null;

  // "cargo" field.
  String? _cargo;
  String get cargo => _cargo ?? '';
  bool hasCargo() => _cargo != null;

  // "serimonitor" field.
  String? _serimonitor;
  String get serimonitor => _serimonitor ?? '';
  bool hasSerimonitor() => _serimonitor != null;

  // "serieteclado" field.
  String? _serieteclado;
  String get serieteclado => _serieteclado ?? '';
  bool hasSerieteclado() => _serieteclado != null;

  // "seriemouse" field.
  String? _seriemouse;
  String get seriemouse => _seriemouse ?? '';
  bool hasSeriemouse() => _seriemouse != null;

  // "cargotitular" field.
  String? _cargotitular;
  String get cargotitular => _cargotitular ?? '';
  bool hasCargotitular() => _cargotitular != null;

  // "quienactualiza" field.
  String? _quienactualiza;
  String get quienactualiza => _quienactualiza ?? '';
  bool hasQuienactualiza() => _quienactualiza != null;

  // "quienactualizaid" field.
  DocumentReference? _quienactualizaid;
  DocumentReference? get quienactualizaid => _quienactualizaid;
  bool hasQuienactualizaid() => _quienactualizaid != null;

  // "anexo" field.
  String? _anexo;
  String get anexo => _anexo ?? '';
  bool hasAnexo() => _anexo != null;

  // "inventario2025" field.
  String? _inventario2025;
  String get inventario2025 => _inventario2025 ?? '';
  bool hasInventario2025() => _inventario2025 != null;

  // "estadodelvale" field.
  String? _estadodelvale;
  String get estadodelvale => _estadodelvale ?? '';
  bool hasEstadodelvale() => _estadodelvale != null;

  // "foliovale" field.
  String? _foliovale;
  String get foliovale => _foliovale ?? '';
  bool hasFoliovale() => _foliovale != null;

  // "imagenbien" field.
  String? _imagenbien;
  String get imagenbien => _imagenbien ?? '';
  bool hasImagenbien() => _imagenbien != null;

  // "foliocontable" field.
  String? _foliocontable;
  String get foliocontable => _foliocontable ?? '';
  bool hasFoliocontable() => _foliocontable != null;

  // "pif" field.
  String? _pif;
  String get pif => _pif ?? '';
  bool hasPif() => _pif != null;

  // "seriedvd" field.
  String? _seriedvd;
  String get seriedvd => _seriedvd ?? '';
  bool hasSeriedvd() => _seriedvd != null;

  // "avaluo" field.
  double? _avaluo;
  double get avaluo => _avaluo ?? 0.0;
  bool hasAvaluo() => _avaluo != null;

  // "fechaavaluo" field.
  DateTime? _fechaavaluo;
  DateTime? get fechaavaluo => _fechaavaluo;
  bool hasFechaavaluo() => _fechaavaluo != null;

  // "depreciacionacumulada" field.
  double? _depreciacionacumulada;
  double get depreciacionacumulada => _depreciacionacumulada ?? 0.0;
  bool hasDepreciacionacumulada() => _depreciacionacumulada != null;

  // "origenbodega" field.
  String? _origenbodega;
  String get origenbodega => _origenbodega ?? '';
  bool hasOrigenbodega() => _origenbodega != null;

  // "depreciable" field.
  String? _depreciable;
  String get depreciable => _depreciable ?? '';
  bool hasDepreciable() => _depreciable != null;

  // "quienmodifico" field.
  String? _quienmodifico;
  String get quienmodifico => _quienmodifico ?? '';
  bool hasQuienmodifico() => _quienmodifico != null;

  // "fechaultimamodificacion" field.
  DateTime? _fechaultimamodificacion;
  DateTime? get fechaultimamodificacion => _fechaultimamodificacion;
  bool hasFechaultimamodificacion() => _fechaultimamodificacion != null;

  // "recurso" field.
  String? _recurso;
  String get recurso => _recurso ?? '';
  bool hasRecurso() => _recurso != null;

  // "periodocontable" field.
  DateTime? _periodocontable;
  DateTime? get periodocontable => _periodocontable;
  bool hasPeriodocontable() => _periodocontable != null;

  // "nopartida" field.
  String? _nopartida;
  String get nopartida => _nopartida ?? '';
  bool hasNopartida() => _nopartida != null;

  void _initializeFields() {
    _nombre = snapshotData['nombre'] as String?;
    _fechaalta = snapshotData['fechaalta'] as DateTime?;
    _fechaadquisicion = snapshotData['fechaadquisicion'] as DateTime?;
    _fechademodificacion = snapshotData['fechademodificacion'] as DateTime?;
    _fechadebaja = snapshotData['fechadebaja'] as DateTime?;
    _estatusdelbien = snapshotData['estatusdelbien'] as String?;
    _escontable = snapshotData['escontable'] as bool?;
    _numeroinventario = snapshotData['numeroinventario'] as String?;
    _depositario = snapshotData['depositario'] as String?;
    _importeinicialbien =
        castToType<double>(snapshotData['importeinicialbien']);
    _tituladelbien = snapshotData['tituladelbien'] as String?;
    _numeroseriedelbien = snapshotData['numeroseriedelbien'] as String?;
    _aniofiscal = castToType<int>(snapshotData['aniofiscal']);
    _ubicacionfisica = snapshotData['ubicacionfisica'] as String?;
    _factura = snapshotData['factura'] as String?;
    _nombredelprovedor = snapshotData['nombredelprovedor'] as String?;
    _cuentacontable = snapshotData['cuentacontable'] as String?;
    _marcacomercial = snapshotData['marcacomercial'] as String?;
    _color = snapshotData['color'] as String?;
    _origenrecurso = snapshotData['origenrecurso'] as String?;
    _licitacion = snapshotData['licitacion'] as String?;
    _categoria = snapshotData['categoria'] as String?;
    _descripciondeubicacion = snapshotData['descripciondeubicacion'] as String?;
    _distrito = snapshotData['distrito'] as String?;
    _placa = snapshotData['placa'] as String?;
    _descripciondelbien = snapshotData['descripciondelbien'] as String?;
    _comentarioadicional = snapshotData['comentarioadicional'] as String?;
    _nombredelproveedor = snapshotData['nombredelproveedor'] as String?;
    _encargado = snapshotData['encargado'] as String?;
    _verificavs = snapshotData['verificavs'] as String?;
    _folioresguardo = snapshotData['folioresguardo'] as String?;
    _cotejodoc = snapshotData['cotejodoc'] as String?;
    _inventario = snapshotData['inventario'] as String?;
    _modelo = snapshotData['modelo'] as String?;
    _adquisicion = snapshotData['adquisicion'] as String?;
    _tiporecurso = snapshotData['tiporecurso'] as String?;
    _depreciacion = castToType<double>(snapshotData['depreciacion']);
    _clasedeactivo = snapshotData['clasedeactivo'] as String?;
    _nivel1organizacion = snapshotData['nivel1organizacion'] as String?;
    _nivel2direccion = snapshotData['nivel2direccion'] as String?;
    _nivel3jurisdiccion = snapshotData['nivel3jurisdiccion'] as String?;
    _inmueble = snapshotData['inmueble'] as String?;
    _zona = snapshotData['zona'] as String?;
    _cargo = snapshotData['cargo'] as String?;
    _serimonitor = snapshotData['serimonitor'] as String?;
    _serieteclado = snapshotData['serieteclado'] as String?;
    _seriemouse = snapshotData['seriemouse'] as String?;
    _cargotitular = snapshotData['cargotitular'] as String?;
    _quienactualiza = snapshotData['quienactualiza'] as String?;
    _quienactualizaid = snapshotData['quienactualizaid'] as DocumentReference?;
    _anexo = snapshotData['anexo'] as String?;
    _inventario2025 = snapshotData['inventario2025'] as String?;
    _estadodelvale = snapshotData['estadodelvale'] as String?;
    _foliovale = snapshotData['foliovale'] as String?;
    _imagenbien = snapshotData['imagenbien'] as String?;
    _foliocontable = snapshotData['foliocontable'] as String?;
    _pif = snapshotData['pif'] as String?;
    _seriedvd = snapshotData['seriedvd'] as String?;
    _avaluo = castToType<double>(snapshotData['avaluo']);
    _fechaavaluo = snapshotData['fechaavaluo'] as DateTime?;
    _depreciacionacumulada =
        castToType<double>(snapshotData['depreciacionacumulada']);
    _origenbodega = snapshotData['origenbodega'] as String?;
    _depreciable = snapshotData['depreciable'] as String?;
    _quienmodifico = snapshotData['quienmodifico'] as String?;
    _fechaultimamodificacion =
        snapshotData['fechaultimamodificacion'] as DateTime?;
    _recurso = snapshotData['recurso'] as String?;
    _periodocontable = snapshotData['periodocontable'] as DateTime?;
    _nopartida = snapshotData['nopartida'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('bienesmuebles');

  static Stream<BienesmueblesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BienesmueblesRecord.fromSnapshot(s));

  static Future<BienesmueblesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BienesmueblesRecord.fromSnapshot(s));

  static BienesmueblesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BienesmueblesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BienesmueblesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BienesmueblesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BienesmueblesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BienesmueblesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBienesmueblesRecordData({
  String? nombre,
  DateTime? fechaalta,
  DateTime? fechaadquisicion,
  DateTime? fechademodificacion,
  DateTime? fechadebaja,
  String? estatusdelbien,
  bool? escontable,
  String? numeroinventario,
  String? depositario,
  double? importeinicialbien,
  String? tituladelbien,
  String? numeroseriedelbien,
  int? aniofiscal,
  String? ubicacionfisica,
  String? factura,
  String? nombredelprovedor,
  String? cuentacontable,
  String? marcacomercial,
  String? color,
  String? origenrecurso,
  String? licitacion,
  String? categoria,
  String? descripciondeubicacion,
  String? distrito,
  String? placa,
  String? descripciondelbien,
  String? comentarioadicional,
  String? nombredelproveedor,
  String? encargado,
  String? verificavs,
  String? folioresguardo,
  String? cotejodoc,
  String? inventario,
  String? modelo,
  String? adquisicion,
  String? tiporecurso,
  double? depreciacion,
  String? clasedeactivo,
  String? nivel1organizacion,
  String? nivel2direccion,
  String? nivel3jurisdiccion,
  String? inmueble,
  String? zona,
  String? cargo,
  String? serimonitor,
  String? serieteclado,
  String? seriemouse,
  String? cargotitular,
  String? quienactualiza,
  DocumentReference? quienactualizaid,
  String? anexo,
  String? inventario2025,
  String? estadodelvale,
  String? foliovale,
  String? imagenbien,
  String? foliocontable,
  String? pif,
  String? seriedvd,
  double? avaluo,
  DateTime? fechaavaluo,
  double? depreciacionacumulada,
  String? origenbodega,
  String? depreciable,
  String? quienmodifico,
  DateTime? fechaultimamodificacion,
  String? recurso,
  DateTime? periodocontable,
  String? nopartida,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nombre': nombre,
      'fechaalta': fechaalta,
      'fechaadquisicion': fechaadquisicion,
      'fechademodificacion': fechademodificacion,
      'fechadebaja': fechadebaja,
      'estatusdelbien': estatusdelbien,
      'escontable': escontable,
      'numeroinventario': numeroinventario,
      'depositario': depositario,
      'importeinicialbien': importeinicialbien,
      'tituladelbien': tituladelbien,
      'numeroseriedelbien': numeroseriedelbien,
      'aniofiscal': aniofiscal,
      'ubicacionfisica': ubicacionfisica,
      'factura': factura,
      'nombredelprovedor': nombredelprovedor,
      'cuentacontable': cuentacontable,
      'marcacomercial': marcacomercial,
      'color': color,
      'origenrecurso': origenrecurso,
      'licitacion': licitacion,
      'categoria': categoria,
      'descripciondeubicacion': descripciondeubicacion,
      'distrito': distrito,
      'placa': placa,
      'descripciondelbien': descripciondelbien,
      'comentarioadicional': comentarioadicional,
      'nombredelproveedor': nombredelproveedor,
      'encargado': encargado,
      'verificavs': verificavs,
      'folioresguardo': folioresguardo,
      'cotejodoc': cotejodoc,
      'inventario': inventario,
      'modelo': modelo,
      'adquisicion': adquisicion,
      'tiporecurso': tiporecurso,
      'depreciacion': depreciacion,
      'clasedeactivo': clasedeactivo,
      'nivel1organizacion': nivel1organizacion,
      'nivel2direccion': nivel2direccion,
      'nivel3jurisdiccion': nivel3jurisdiccion,
      'inmueble': inmueble,
      'zona': zona,
      'cargo': cargo,
      'serimonitor': serimonitor,
      'serieteclado': serieteclado,
      'seriemouse': seriemouse,
      'cargotitular': cargotitular,
      'quienactualiza': quienactualiza,
      'quienactualizaid': quienactualizaid,
      'anexo': anexo,
      'inventario2025': inventario2025,
      'estadodelvale': estadodelvale,
      'foliovale': foliovale,
      'imagenbien': imagenbien,
      'foliocontable': foliocontable,
      'pif': pif,
      'seriedvd': seriedvd,
      'avaluo': avaluo,
      'fechaavaluo': fechaavaluo,
      'depreciacionacumulada': depreciacionacumulada,
      'origenbodega': origenbodega,
      'depreciable': depreciable,
      'quienmodifico': quienmodifico,
      'fechaultimamodificacion': fechaultimamodificacion,
      'recurso': recurso,
      'periodocontable': periodocontable,
      'nopartida': nopartida,
    }.withoutNulls,
  );

  return firestoreData;
}

class BienesmueblesRecordDocumentEquality
    implements Equality<BienesmueblesRecord> {
  const BienesmueblesRecordDocumentEquality();

  @override
  bool equals(BienesmueblesRecord? e1, BienesmueblesRecord? e2) {
    return e1?.nombre == e2?.nombre &&
        e1?.fechaalta == e2?.fechaalta &&
        e1?.fechaadquisicion == e2?.fechaadquisicion &&
        e1?.fechademodificacion == e2?.fechademodificacion &&
        e1?.fechadebaja == e2?.fechadebaja &&
        e1?.estatusdelbien == e2?.estatusdelbien &&
        e1?.escontable == e2?.escontable &&
        e1?.numeroinventario == e2?.numeroinventario &&
        e1?.depositario == e2?.depositario &&
        e1?.importeinicialbien == e2?.importeinicialbien &&
        e1?.tituladelbien == e2?.tituladelbien &&
        e1?.numeroseriedelbien == e2?.numeroseriedelbien &&
        e1?.aniofiscal == e2?.aniofiscal &&
        e1?.ubicacionfisica == e2?.ubicacionfisica &&
        e1?.factura == e2?.factura &&
        e1?.nombredelprovedor == e2?.nombredelprovedor &&
        e1?.cuentacontable == e2?.cuentacontable &&
        e1?.marcacomercial == e2?.marcacomercial &&
        e1?.color == e2?.color &&
        e1?.origenrecurso == e2?.origenrecurso &&
        e1?.licitacion == e2?.licitacion &&
        e1?.categoria == e2?.categoria &&
        e1?.descripciondeubicacion == e2?.descripciondeubicacion &&
        e1?.distrito == e2?.distrito &&
        e1?.placa == e2?.placa &&
        e1?.descripciondelbien == e2?.descripciondelbien &&
        e1?.comentarioadicional == e2?.comentarioadicional &&
        e1?.nombredelproveedor == e2?.nombredelproveedor &&
        e1?.encargado == e2?.encargado &&
        e1?.verificavs == e2?.verificavs &&
        e1?.folioresguardo == e2?.folioresguardo &&
        e1?.cotejodoc == e2?.cotejodoc &&
        e1?.inventario == e2?.inventario &&
        e1?.modelo == e2?.modelo &&
        e1?.adquisicion == e2?.adquisicion &&
        e1?.tiporecurso == e2?.tiporecurso &&
        e1?.depreciacion == e2?.depreciacion &&
        e1?.clasedeactivo == e2?.clasedeactivo &&
        e1?.nivel1organizacion == e2?.nivel1organizacion &&
        e1?.nivel2direccion == e2?.nivel2direccion &&
        e1?.nivel3jurisdiccion == e2?.nivel3jurisdiccion &&
        e1?.inmueble == e2?.inmueble &&
        e1?.zona == e2?.zona &&
        e1?.cargo == e2?.cargo &&
        e1?.serimonitor == e2?.serimonitor &&
        e1?.serieteclado == e2?.serieteclado &&
        e1?.seriemouse == e2?.seriemouse &&
        e1?.cargotitular == e2?.cargotitular &&
        e1?.quienactualiza == e2?.quienactualiza &&
        e1?.quienactualizaid == e2?.quienactualizaid &&
        e1?.anexo == e2?.anexo &&
        e1?.inventario2025 == e2?.inventario2025 &&
        e1?.estadodelvale == e2?.estadodelvale &&
        e1?.foliovale == e2?.foliovale &&
        e1?.imagenbien == e2?.imagenbien &&
        e1?.foliocontable == e2?.foliocontable &&
        e1?.pif == e2?.pif &&
        e1?.seriedvd == e2?.seriedvd &&
        e1?.avaluo == e2?.avaluo &&
        e1?.fechaavaluo == e2?.fechaavaluo &&
        e1?.depreciacionacumulada == e2?.depreciacionacumulada &&
        e1?.origenbodega == e2?.origenbodega &&
        e1?.depreciable == e2?.depreciable &&
        e1?.quienmodifico == e2?.quienmodifico &&
        e1?.fechaultimamodificacion == e2?.fechaultimamodificacion &&
        e1?.recurso == e2?.recurso &&
        e1?.periodocontable == e2?.periodocontable &&
        e1?.nopartida == e2?.nopartida;
  }

  @override
  int hash(BienesmueblesRecord? e) => const ListEquality().hash([
        e?.nombre,
        e?.fechaalta,
        e?.fechaadquisicion,
        e?.fechademodificacion,
        e?.fechadebaja,
        e?.estatusdelbien,
        e?.escontable,
        e?.numeroinventario,
        e?.depositario,
        e?.importeinicialbien,
        e?.tituladelbien,
        e?.numeroseriedelbien,
        e?.aniofiscal,
        e?.ubicacionfisica,
        e?.factura,
        e?.nombredelprovedor,
        e?.cuentacontable,
        e?.marcacomercial,
        e?.color,
        e?.origenrecurso,
        e?.licitacion,
        e?.categoria,
        e?.descripciondeubicacion,
        e?.distrito,
        e?.placa,
        e?.descripciondelbien,
        e?.comentarioadicional,
        e?.nombredelproveedor,
        e?.encargado,
        e?.verificavs,
        e?.folioresguardo,
        e?.cotejodoc,
        e?.inventario,
        e?.modelo,
        e?.adquisicion,
        e?.tiporecurso,
        e?.depreciacion,
        e?.clasedeactivo,
        e?.nivel1organizacion,
        e?.nivel2direccion,
        e?.nivel3jurisdiccion,
        e?.inmueble,
        e?.zona,
        e?.cargo,
        e?.serimonitor,
        e?.serieteclado,
        e?.seriemouse,
        e?.cargotitular,
        e?.quienactualiza,
        e?.quienactualizaid,
        e?.anexo,
        e?.inventario2025,
        e?.estadodelvale,
        e?.foliovale,
        e?.imagenbien,
        e?.foliocontable,
        e?.pif,
        e?.seriedvd,
        e?.avaluo,
        e?.fechaavaluo,
        e?.depreciacionacumulada,
        e?.origenbodega,
        e?.depreciable,
        e?.quienmodifico,
        e?.fechaultimamodificacion,
        e?.recurso,
        e?.periodocontable,
        e?.nopartida
      ]);

  @override
  bool isValidKey(Object? o) => o is BienesmueblesRecord;
}
