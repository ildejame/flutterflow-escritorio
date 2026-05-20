import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EstablecimientosRecord extends FirestoreRecord {
  EstablecimientosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Fecha" field.
  DateTime? _fecha;
  DateTime? get fecha => _fecha;
  bool hasFecha() => _fecha != null;

  // "CodigoQR" field.
  String? _codigoQR;
  String get codigoQR => _codigoQR ?? '';
  bool hasCodigoQR() => _codigoQR != null;

  // "Posicion" field.
  LatLng? _posicion;
  LatLng? get posicion => _posicion;
  bool hasPosicion() => _posicion != null;

  // "NombrePropietario" field.
  String? _nombrePropietario;
  String get nombrePropietario => _nombrePropietario ?? '';
  bool hasNombrePropietario() => _nombrePropietario != null;

  // "DomicilioParticular" field.
  String? _domicilioParticular;
  String get domicilioParticular => _domicilioParticular ?? '';
  bool hasDomicilioParticular() => _domicilioParticular != null;

  // "Nacionalidad" field.
  String? _nacionalidad;
  String get nacionalidad => _nacionalidad ?? '';
  bool hasNacionalidad() => _nacionalidad != null;

  // "TipoPersonaSAT" field.
  String? _tipoPersonaSAT;
  String get tipoPersonaSAT => _tipoPersonaSAT ?? '';
  bool hasTipoPersonaSAT() => _tipoPersonaSAT != null;

  // "RFC" field.
  String? _rfc;
  String get rfc => _rfc ?? '';
  bool hasRfc() => _rfc != null;

  // "CalleLocal" field.
  String? _calleLocal;
  String get calleLocal => _calleLocal ?? '';
  bool hasCalleLocal() => _calleLocal != null;

  // "ColoniLocal" field.
  String? _coloniLocal;
  String get coloniLocal => _coloniLocal ?? '';
  bool hasColoniLocal() => _coloniLocal != null;

  // "NumeroLocal" field.
  String? _numeroLocal;
  String get numeroLocal => _numeroLocal ?? '';
  bool hasNumeroLocal() => _numeroLocal != null;

  // "SuperficieM2" field.
  double? _superficieM2;
  double get superficieM2 => _superficieM2 ?? 0.0;
  bool hasSuperficieM2() => _superficieM2 != null;

  // "DescripcionActividadComercial" field.
  String? _descripcionActividadComercial;
  String get descripcionActividadComercial =>
      _descripcionActividadComercial ?? '';
  bool hasDescripcionActividadComercial() =>
      _descripcionActividadComercial != null;

  // "Denominacion" field.
  String? _denominacion;
  String get denominacion => _denominacion ?? '';
  bool hasDenominacion() => _denominacion != null;

  // "NombreEstablecimiento" field.
  String? _nombreEstablecimiento;
  String get nombreEstablecimiento => _nombreEstablecimiento ?? '';
  bool hasNombreEstablecimiento() => _nombreEstablecimiento != null;

  // "Celular" field.
  int? _celular;
  int get celular => _celular ?? 0;
  bool hasCelular() => _celular != null;

  // "Correo" field.
  String? _correo;
  String get correo => _correo ?? '';
  bool hasCorreo() => _correo != null;

  // "FechaInicioOperaciones" field.
  String? _fechaInicioOperaciones;
  String get fechaInicioOperaciones => _fechaInicioOperaciones ?? '';
  bool hasFechaInicioOperaciones() => _fechaInicioOperaciones != null;

  // "FotoLocal" field.
  String? _fotoLocal;
  String get fotoLocal => _fotoLocal ?? '';
  bool hasFotoLocal() => _fotoLocal != null;

  // "FotosComplementarias" field.
  List<String>? _fotosComplementarias;
  List<String> get fotosComplementarias => _fotosComplementarias ?? const [];
  bool hasFotosComplementarias() => _fotosComplementarias != null;

  // "FirmaAutoridadMunicipal" field.
  String? _firmaAutoridadMunicipal;
  String get firmaAutoridadMunicipal => _firmaAutoridadMunicipal ?? '';
  bool hasFirmaAutoridadMunicipal() => _firmaAutoridadMunicipal != null;

  // "NombreAutoridadMunicipal" field.
  String? _nombreAutoridadMunicipal;
  String get nombreAutoridadMunicipal => _nombreAutoridadMunicipal ?? '';
  bool hasNombreAutoridadMunicipal() => _nombreAutoridadMunicipal != null;

  // "IdAutoridadMunicipal" field.
  DocumentReference? _idAutoridadMunicipal;
  DocumentReference? get idAutoridadMunicipal => _idAutoridadMunicipal;
  bool hasIdAutoridadMunicipal() => _idAutoridadMunicipal != null;

  // "FirmaDuenoEnargado" field.
  String? _firmaDuenoEnargado;
  String get firmaDuenoEnargado => _firmaDuenoEnargado ?? '';
  bool hasFirmaDuenoEnargado() => _firmaDuenoEnargado != null;

  // "Ruta" field.
  String? _ruta;
  String get ruta => _ruta ?? '';
  bool hasRuta() => _ruta != null;

  // "TipoPago" field.
  String? _tipoPago;
  String get tipoPago => _tipoPago ?? '';
  bool hasTipoPago() => _tipoPago != null;

  // "FechadeUltimoPago" field.
  DateTime? _fechadeUltimoPago;
  DateTime? get fechadeUltimoPago => _fechadeUltimoPago;
  bool hasFechadeUltimoPago() => _fechadeUltimoPago != null;

  // "FechaUltimoPagoDiario" field.
  DateTime? _fechaUltimoPagoDiario;
  DateTime? get fechaUltimoPagoDiario => _fechaUltimoPagoDiario;
  bool hasFechaUltimoPagoDiario() => _fechaUltimoPagoDiario != null;

  // "SoloFecha" field.
  String? _soloFecha;
  String get soloFecha => _soloFecha ?? '';
  bool hasSoloFecha() => _soloFecha != null;

  // "PagoAdicional" field.
  String? _pagoAdicional;
  String get pagoAdicional => _pagoAdicional ?? '';
  bool hasPagoAdicional() => _pagoAdicional != null;

  // "ReferenciaPagoAdicional" field.
  DocumentReference? _referenciaPagoAdicional;
  DocumentReference? get referenciaPagoAdicional => _referenciaPagoAdicional;
  bool hasReferenciaPagoAdicional() => _referenciaPagoAdicional != null;

  // "Deuda" field.
  double? _deuda;
  double get deuda => _deuda ?? 0.0;
  bool hasDeuda() => _deuda != null;

  // "ReferenciaGiro" field.
  DocumentReference? _referenciaGiro;
  DocumentReference? get referenciaGiro => _referenciaGiro;
  bool hasReferenciaGiro() => _referenciaGiro != null;

  // "GiroDeColeccion" field.
  String? _giroDeColeccion;
  String get giroDeColeccion => _giroDeColeccion ?? '';
  bool hasGiroDeColeccion() => _giroDeColeccion != null;

  // "Movimiento" field.
  String? _movimiento;
  String get movimiento => _movimiento ?? '';
  bool hasMovimiento() => _movimiento != null;

  void _initializeFields() {
    _fecha = snapshotData['Fecha'] as DateTime?;
    _codigoQR = snapshotData['CodigoQR'] as String?;
    _posicion = snapshotData['Posicion'] as LatLng?;
    _nombrePropietario = snapshotData['NombrePropietario'] as String?;
    _domicilioParticular = snapshotData['DomicilioParticular'] as String?;
    _nacionalidad = snapshotData['Nacionalidad'] as String?;
    _tipoPersonaSAT = snapshotData['TipoPersonaSAT'] as String?;
    _rfc = snapshotData['RFC'] as String?;
    _calleLocal = snapshotData['CalleLocal'] as String?;
    _coloniLocal = snapshotData['ColoniLocal'] as String?;
    _numeroLocal = snapshotData['NumeroLocal'] as String?;
    _superficieM2 = castToType<double>(snapshotData['SuperficieM2']);
    _descripcionActividadComercial =
        snapshotData['DescripcionActividadComercial'] as String?;
    _denominacion = snapshotData['Denominacion'] as String?;
    _nombreEstablecimiento = snapshotData['NombreEstablecimiento'] as String?;
    _celular = castToType<int>(snapshotData['Celular']);
    _correo = snapshotData['Correo'] as String?;
    _fechaInicioOperaciones = snapshotData['FechaInicioOperaciones'] as String?;
    _fotoLocal = snapshotData['FotoLocal'] as String?;
    _fotosComplementarias = getDataList(snapshotData['FotosComplementarias']);
    _firmaAutoridadMunicipal =
        snapshotData['FirmaAutoridadMunicipal'] as String?;
    _nombreAutoridadMunicipal =
        snapshotData['NombreAutoridadMunicipal'] as String?;
    _idAutoridadMunicipal =
        snapshotData['IdAutoridadMunicipal'] as DocumentReference?;
    _firmaDuenoEnargado = snapshotData['FirmaDuenoEnargado'] as String?;
    _ruta = snapshotData['Ruta'] as String?;
    _tipoPago = snapshotData['TipoPago'] as String?;
    _fechadeUltimoPago = snapshotData['FechadeUltimoPago'] as DateTime?;
    _fechaUltimoPagoDiario = snapshotData['FechaUltimoPagoDiario'] as DateTime?;
    _soloFecha = snapshotData['SoloFecha'] as String?;
    _pagoAdicional = snapshotData['PagoAdicional'] as String?;
    _referenciaPagoAdicional =
        snapshotData['ReferenciaPagoAdicional'] as DocumentReference?;
    _deuda = castToType<double>(snapshotData['Deuda']);
    _referenciaGiro = snapshotData['ReferenciaGiro'] as DocumentReference?;
    _giroDeColeccion = snapshotData['GiroDeColeccion'] as String?;
    _movimiento = snapshotData['Movimiento'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Establecimientos');

  static Stream<EstablecimientosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EstablecimientosRecord.fromSnapshot(s));

  static Future<EstablecimientosRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => EstablecimientosRecord.fromSnapshot(s));

  static EstablecimientosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      EstablecimientosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EstablecimientosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EstablecimientosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EstablecimientosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EstablecimientosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEstablecimientosRecordData({
  DateTime? fecha,
  String? codigoQR,
  LatLng? posicion,
  String? nombrePropietario,
  String? domicilioParticular,
  String? nacionalidad,
  String? tipoPersonaSAT,
  String? rfc,
  String? calleLocal,
  String? coloniLocal,
  String? numeroLocal,
  double? superficieM2,
  String? descripcionActividadComercial,
  String? denominacion,
  String? nombreEstablecimiento,
  int? celular,
  String? correo,
  String? fechaInicioOperaciones,
  String? fotoLocal,
  String? firmaAutoridadMunicipal,
  String? nombreAutoridadMunicipal,
  DocumentReference? idAutoridadMunicipal,
  String? firmaDuenoEnargado,
  String? ruta,
  String? tipoPago,
  DateTime? fechadeUltimoPago,
  DateTime? fechaUltimoPagoDiario,
  String? soloFecha,
  String? pagoAdicional,
  DocumentReference? referenciaPagoAdicional,
  double? deuda,
  DocumentReference? referenciaGiro,
  String? giroDeColeccion,
  String? movimiento,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Fecha': fecha,
      'CodigoQR': codigoQR,
      'Posicion': posicion,
      'NombrePropietario': nombrePropietario,
      'DomicilioParticular': domicilioParticular,
      'Nacionalidad': nacionalidad,
      'TipoPersonaSAT': tipoPersonaSAT,
      'RFC': rfc,
      'CalleLocal': calleLocal,
      'ColoniLocal': coloniLocal,
      'NumeroLocal': numeroLocal,
      'SuperficieM2': superficieM2,
      'DescripcionActividadComercial': descripcionActividadComercial,
      'Denominacion': denominacion,
      'NombreEstablecimiento': nombreEstablecimiento,
      'Celular': celular,
      'Correo': correo,
      'FechaInicioOperaciones': fechaInicioOperaciones,
      'FotoLocal': fotoLocal,
      'FirmaAutoridadMunicipal': firmaAutoridadMunicipal,
      'NombreAutoridadMunicipal': nombreAutoridadMunicipal,
      'IdAutoridadMunicipal': idAutoridadMunicipal,
      'FirmaDuenoEnargado': firmaDuenoEnargado,
      'Ruta': ruta,
      'TipoPago': tipoPago,
      'FechadeUltimoPago': fechadeUltimoPago,
      'FechaUltimoPagoDiario': fechaUltimoPagoDiario,
      'SoloFecha': soloFecha,
      'PagoAdicional': pagoAdicional,
      'ReferenciaPagoAdicional': referenciaPagoAdicional,
      'Deuda': deuda,
      'ReferenciaGiro': referenciaGiro,
      'GiroDeColeccion': giroDeColeccion,
      'Movimiento': movimiento,
    }.withoutNulls,
  );

  return firestoreData;
}

class EstablecimientosRecordDocumentEquality
    implements Equality<EstablecimientosRecord> {
  const EstablecimientosRecordDocumentEquality();

  @override
  bool equals(EstablecimientosRecord? e1, EstablecimientosRecord? e2) {
    const listEquality = ListEquality();
    return e1?.fecha == e2?.fecha &&
        e1?.codigoQR == e2?.codigoQR &&
        e1?.posicion == e2?.posicion &&
        e1?.nombrePropietario == e2?.nombrePropietario &&
        e1?.domicilioParticular == e2?.domicilioParticular &&
        e1?.nacionalidad == e2?.nacionalidad &&
        e1?.tipoPersonaSAT == e2?.tipoPersonaSAT &&
        e1?.rfc == e2?.rfc &&
        e1?.calleLocal == e2?.calleLocal &&
        e1?.coloniLocal == e2?.coloniLocal &&
        e1?.numeroLocal == e2?.numeroLocal &&
        e1?.superficieM2 == e2?.superficieM2 &&
        e1?.descripcionActividadComercial ==
            e2?.descripcionActividadComercial &&
        e1?.denominacion == e2?.denominacion &&
        e1?.nombreEstablecimiento == e2?.nombreEstablecimiento &&
        e1?.celular == e2?.celular &&
        e1?.correo == e2?.correo &&
        e1?.fechaInicioOperaciones == e2?.fechaInicioOperaciones &&
        e1?.fotoLocal == e2?.fotoLocal &&
        listEquality.equals(
            e1?.fotosComplementarias, e2?.fotosComplementarias) &&
        e1?.firmaAutoridadMunicipal == e2?.firmaAutoridadMunicipal &&
        e1?.nombreAutoridadMunicipal == e2?.nombreAutoridadMunicipal &&
        e1?.idAutoridadMunicipal == e2?.idAutoridadMunicipal &&
        e1?.firmaDuenoEnargado == e2?.firmaDuenoEnargado &&
        e1?.ruta == e2?.ruta &&
        e1?.tipoPago == e2?.tipoPago &&
        e1?.fechadeUltimoPago == e2?.fechadeUltimoPago &&
        e1?.fechaUltimoPagoDiario == e2?.fechaUltimoPagoDiario &&
        e1?.soloFecha == e2?.soloFecha &&
        e1?.pagoAdicional == e2?.pagoAdicional &&
        e1?.referenciaPagoAdicional == e2?.referenciaPagoAdicional &&
        e1?.deuda == e2?.deuda &&
        e1?.referenciaGiro == e2?.referenciaGiro &&
        e1?.giroDeColeccion == e2?.giroDeColeccion &&
        e1?.movimiento == e2?.movimiento;
  }

  @override
  int hash(EstablecimientosRecord? e) => const ListEquality().hash([
        e?.fecha,
        e?.codigoQR,
        e?.posicion,
        e?.nombrePropietario,
        e?.domicilioParticular,
        e?.nacionalidad,
        e?.tipoPersonaSAT,
        e?.rfc,
        e?.calleLocal,
        e?.coloniLocal,
        e?.numeroLocal,
        e?.superficieM2,
        e?.descripcionActividadComercial,
        e?.denominacion,
        e?.nombreEstablecimiento,
        e?.celular,
        e?.correo,
        e?.fechaInicioOperaciones,
        e?.fotoLocal,
        e?.fotosComplementarias,
        e?.firmaAutoridadMunicipal,
        e?.nombreAutoridadMunicipal,
        e?.idAutoridadMunicipal,
        e?.firmaDuenoEnargado,
        e?.ruta,
        e?.tipoPago,
        e?.fechadeUltimoPago,
        e?.fechaUltimoPagoDiario,
        e?.soloFecha,
        e?.pagoAdicional,
        e?.referenciaPagoAdicional,
        e?.deuda,
        e?.referenciaGiro,
        e?.giroDeColeccion,
        e?.movimiento
      ]);

  @override
  bool isValidKey(Object? o) => o is EstablecimientosRecord;
}
