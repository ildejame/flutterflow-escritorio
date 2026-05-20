import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InfraccionesRecord extends FirestoreRecord {
  InfraccionesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Oficial" field.
  DocumentReference? _oficial;
  DocumentReference? get oficial => _oficial;
  bool hasOficial() => _oficial != null;

  // "Uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "FechaInf" field.
  DateTime? _fechaInf;
  DateTime? get fechaInf => _fechaInf;
  bool hasFechaInf() => _fechaInf != null;

  // "CodigoInfraccion" field.
  String? _codigoInfraccion;
  String get codigoInfraccion => _codigoInfraccion ?? '';
  bool hasCodigoInfraccion() => _codigoInfraccion != null;

  // "NombreOficial" field.
  String? _nombreOficial;
  String get nombreOficial => _nombreOficial ?? '';
  bool hasNombreOficial() => _nombreOficial != null;

  // "NombreInfractor" field.
  String? _nombreInfractor;
  String get nombreInfractor => _nombreInfractor ?? '';
  bool hasNombreInfractor() => _nombreInfractor != null;

  // "DomicilioInfractor" field.
  String? _domicilioInfractor;
  String get domicilioInfractor => _domicilioInfractor ?? '';
  bool hasDomicilioInfractor() => _domicilioInfractor != null;

  // "Licencia" field.
  String? _licencia;
  String get licencia => _licencia ?? '';
  bool hasLicencia() => _licencia != null;

  // "TipoLicencia" field.
  String? _tipoLicencia;
  String get tipoLicencia => _tipoLicencia ?? '';
  bool hasTipoLicencia() => _tipoLicencia != null;

  // "EstadoEmisionLicencia" field.
  String? _estadoEmisionLicencia;
  String get estadoEmisionLicencia => _estadoEmisionLicencia ?? '';
  bool hasEstadoEmisionLicencia() => _estadoEmisionLicencia != null;

  // "TelefonoInfractor" field.
  int? _telefonoInfractor;
  int get telefonoInfractor => _telefonoInfractor ?? 0;
  bool hasTelefonoInfractor() => _telefonoInfractor != null;

  // "WhatsInfractor" field.
  int? _whatsInfractor;
  int get whatsInfractor => _whatsInfractor ?? 0;
  bool hasWhatsInfractor() => _whatsInfractor != null;

  // "CorreoInfractor" field.
  String? _correoInfractor;
  String get correoInfractor => _correoInfractor ?? '';
  bool hasCorreoInfractor() => _correoInfractor != null;

  // "EvidenciaPrincipal" field.
  String? _evidenciaPrincipal;
  String get evidenciaPrincipal => _evidenciaPrincipal ?? '';
  bool hasEvidenciaPrincipal() => _evidenciaPrincipal != null;

  // "EvidenciaComplementaria" field.
  List<String>? _evidenciaComplementaria;
  List<String> get evidenciaComplementaria =>
      _evidenciaComplementaria ?? const [];
  bool hasEvidenciaComplementaria() => _evidenciaComplementaria != null;

  // "UbicacionInfraccion" field.
  LatLng? _ubicacionInfraccion;
  LatLng? get ubicacionInfraccion => _ubicacionInfraccion;
  bool hasUbicacionInfraccion() => _ubicacionInfraccion != null;

  // "DetallesInfraccion" field.
  String? _detallesInfraccion;
  String get detallesInfraccion => _detallesInfraccion ?? '';
  bool hasDetallesInfraccion() => _detallesInfraccion != null;

  // "ComentariosOficial" field.
  String? _comentariosOficial;
  String get comentariosOficial => _comentariosOficial ?? '';
  bool hasComentariosOficial() => _comentariosOficial != null;

  // "ComentariosInfractor" field.
  String? _comentariosInfractor;
  String get comentariosInfractor => _comentariosInfractor ?? '';
  bool hasComentariosInfractor() => _comentariosInfractor != null;

  // "FirmaOficial" field.
  String? _firmaOficial;
  String get firmaOficial => _firmaOficial ?? '';
  bool hasFirmaOficial() => _firmaOficial != null;

  // "FirmaInfractor" field.
  String? _firmaInfractor;
  String get firmaInfractor => _firmaInfractor ?? '';
  bool hasFirmaInfractor() => _firmaInfractor != null;

  // "UsoVehculo" field.
  String? _usoVehculo;
  String get usoVehculo => _usoVehculo ?? '';
  bool hasUsoVehculo() => _usoVehculo != null;

  // "EmisionPlaca" field.
  String? _emisionPlaca;
  String get emisionPlaca => _emisionPlaca ?? '';
  bool hasEmisionPlaca() => _emisionPlaca != null;

  // "MarcaYModelo" field.
  String? _marcaYModelo;
  String get marcaYModelo => _marcaYModelo ?? '';
  bool hasMarcaYModelo() => _marcaYModelo != null;

  // "NumeroSerie" field.
  String? _numeroSerie;
  String get numeroSerie => _numeroSerie ?? '';
  bool hasNumeroSerie() => _numeroSerie != null;

  // "PlacasInfractor" field.
  String? _placasInfractor;
  String get placasInfractor => _placasInfractor ?? '';
  bool hasPlacasInfractor() => _placasInfractor != null;

  // "ClaveOficial" field.
  String? _claveOficial;
  String get claveOficial => _claveOficial ?? '';
  bool hasClaveOficial() => _claveOficial != null;

  // "NumeroGrua" field.
  String? _numeroGrua;
  String get numeroGrua => _numeroGrua ?? '';
  bool hasNumeroGrua() => _numeroGrua != null;

  // "PlacasPatrullaOGrua" field.
  String? _placasPatrullaOGrua;
  String get placasPatrullaOGrua => _placasPatrullaOGrua ?? '';
  bool hasPlacasPatrullaOGrua() => _placasPatrullaOGrua != null;

  // "CategoriaMulta" field.
  String? _categoriaMulta;
  String get categoriaMulta => _categoriaMulta ?? '';
  bool hasCategoriaMulta() => _categoriaMulta != null;

  // "Folio" field.
  String? _folio;
  String get folio => _folio ?? '';
  bool hasFolio() => _folio != null;

  // "Status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "FechaCambioStatus" field.
  DateTime? _fechaCambioStatus;
  DateTime? get fechaCambioStatus => _fechaCambioStatus;
  bool hasFechaCambioStatus() => _fechaCambioStatus != null;

  // "PapelesScaneo" field.
  List<String>? _papelesScaneo;
  List<String> get papelesScaneo => _papelesScaneo ?? const [];
  bool hasPapelesScaneo() => _papelesScaneo != null;

  void _initializeFields() {
    _oficial = snapshotData['Oficial'] as DocumentReference?;
    _uid = snapshotData['Uid'] as String?;
    _fechaInf = snapshotData['FechaInf'] as DateTime?;
    _codigoInfraccion = snapshotData['CodigoInfraccion'] as String?;
    _nombreOficial = snapshotData['NombreOficial'] as String?;
    _nombreInfractor = snapshotData['NombreInfractor'] as String?;
    _domicilioInfractor = snapshotData['DomicilioInfractor'] as String?;
    _licencia = snapshotData['Licencia'] as String?;
    _tipoLicencia = snapshotData['TipoLicencia'] as String?;
    _estadoEmisionLicencia = snapshotData['EstadoEmisionLicencia'] as String?;
    _telefonoInfractor = castToType<int>(snapshotData['TelefonoInfractor']);
    _whatsInfractor = castToType<int>(snapshotData['WhatsInfractor']);
    _correoInfractor = snapshotData['CorreoInfractor'] as String?;
    _evidenciaPrincipal = snapshotData['EvidenciaPrincipal'] as String?;
    _evidenciaComplementaria =
        getDataList(snapshotData['EvidenciaComplementaria']);
    _ubicacionInfraccion = snapshotData['UbicacionInfraccion'] as LatLng?;
    _detallesInfraccion = snapshotData['DetallesInfraccion'] as String?;
    _comentariosOficial = snapshotData['ComentariosOficial'] as String?;
    _comentariosInfractor = snapshotData['ComentariosInfractor'] as String?;
    _firmaOficial = snapshotData['FirmaOficial'] as String?;
    _firmaInfractor = snapshotData['FirmaInfractor'] as String?;
    _usoVehculo = snapshotData['UsoVehculo'] as String?;
    _emisionPlaca = snapshotData['EmisionPlaca'] as String?;
    _marcaYModelo = snapshotData['MarcaYModelo'] as String?;
    _numeroSerie = snapshotData['NumeroSerie'] as String?;
    _placasInfractor = snapshotData['PlacasInfractor'] as String?;
    _claveOficial = snapshotData['ClaveOficial'] as String?;
    _numeroGrua = snapshotData['NumeroGrua'] as String?;
    _placasPatrullaOGrua = snapshotData['PlacasPatrullaOGrua'] as String?;
    _categoriaMulta = snapshotData['CategoriaMulta'] as String?;
    _folio = snapshotData['Folio'] as String?;
    _status = snapshotData['Status'] as String?;
    _fechaCambioStatus = snapshotData['FechaCambioStatus'] as DateTime?;
    _papelesScaneo = getDataList(snapshotData['PapelesScaneo']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Infracciones');

  static Stream<InfraccionesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => InfraccionesRecord.fromSnapshot(s));

  static Future<InfraccionesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => InfraccionesRecord.fromSnapshot(s));

  static InfraccionesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      InfraccionesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static InfraccionesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      InfraccionesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'InfraccionesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is InfraccionesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createInfraccionesRecordData({
  DocumentReference? oficial,
  String? uid,
  DateTime? fechaInf,
  String? codigoInfraccion,
  String? nombreOficial,
  String? nombreInfractor,
  String? domicilioInfractor,
  String? licencia,
  String? tipoLicencia,
  String? estadoEmisionLicencia,
  int? telefonoInfractor,
  int? whatsInfractor,
  String? correoInfractor,
  String? evidenciaPrincipal,
  LatLng? ubicacionInfraccion,
  String? detallesInfraccion,
  String? comentariosOficial,
  String? comentariosInfractor,
  String? firmaOficial,
  String? firmaInfractor,
  String? usoVehculo,
  String? emisionPlaca,
  String? marcaYModelo,
  String? numeroSerie,
  String? placasInfractor,
  String? claveOficial,
  String? numeroGrua,
  String? placasPatrullaOGrua,
  String? categoriaMulta,
  String? folio,
  String? status,
  DateTime? fechaCambioStatus,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Oficial': oficial,
      'Uid': uid,
      'FechaInf': fechaInf,
      'CodigoInfraccion': codigoInfraccion,
      'NombreOficial': nombreOficial,
      'NombreInfractor': nombreInfractor,
      'DomicilioInfractor': domicilioInfractor,
      'Licencia': licencia,
      'TipoLicencia': tipoLicencia,
      'EstadoEmisionLicencia': estadoEmisionLicencia,
      'TelefonoInfractor': telefonoInfractor,
      'WhatsInfractor': whatsInfractor,
      'CorreoInfractor': correoInfractor,
      'EvidenciaPrincipal': evidenciaPrincipal,
      'UbicacionInfraccion': ubicacionInfraccion,
      'DetallesInfraccion': detallesInfraccion,
      'ComentariosOficial': comentariosOficial,
      'ComentariosInfractor': comentariosInfractor,
      'FirmaOficial': firmaOficial,
      'FirmaInfractor': firmaInfractor,
      'UsoVehculo': usoVehculo,
      'EmisionPlaca': emisionPlaca,
      'MarcaYModelo': marcaYModelo,
      'NumeroSerie': numeroSerie,
      'PlacasInfractor': placasInfractor,
      'ClaveOficial': claveOficial,
      'NumeroGrua': numeroGrua,
      'PlacasPatrullaOGrua': placasPatrullaOGrua,
      'CategoriaMulta': categoriaMulta,
      'Folio': folio,
      'Status': status,
      'FechaCambioStatus': fechaCambioStatus,
    }.withoutNulls,
  );

  return firestoreData;
}

class InfraccionesRecordDocumentEquality
    implements Equality<InfraccionesRecord> {
  const InfraccionesRecordDocumentEquality();

  @override
  bool equals(InfraccionesRecord? e1, InfraccionesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.oficial == e2?.oficial &&
        e1?.uid == e2?.uid &&
        e1?.fechaInf == e2?.fechaInf &&
        e1?.codigoInfraccion == e2?.codigoInfraccion &&
        e1?.nombreOficial == e2?.nombreOficial &&
        e1?.nombreInfractor == e2?.nombreInfractor &&
        e1?.domicilioInfractor == e2?.domicilioInfractor &&
        e1?.licencia == e2?.licencia &&
        e1?.tipoLicencia == e2?.tipoLicencia &&
        e1?.estadoEmisionLicencia == e2?.estadoEmisionLicencia &&
        e1?.telefonoInfractor == e2?.telefonoInfractor &&
        e1?.whatsInfractor == e2?.whatsInfractor &&
        e1?.correoInfractor == e2?.correoInfractor &&
        e1?.evidenciaPrincipal == e2?.evidenciaPrincipal &&
        listEquality.equals(
            e1?.evidenciaComplementaria, e2?.evidenciaComplementaria) &&
        e1?.ubicacionInfraccion == e2?.ubicacionInfraccion &&
        e1?.detallesInfraccion == e2?.detallesInfraccion &&
        e1?.comentariosOficial == e2?.comentariosOficial &&
        e1?.comentariosInfractor == e2?.comentariosInfractor &&
        e1?.firmaOficial == e2?.firmaOficial &&
        e1?.firmaInfractor == e2?.firmaInfractor &&
        e1?.usoVehculo == e2?.usoVehculo &&
        e1?.emisionPlaca == e2?.emisionPlaca &&
        e1?.marcaYModelo == e2?.marcaYModelo &&
        e1?.numeroSerie == e2?.numeroSerie &&
        e1?.placasInfractor == e2?.placasInfractor &&
        e1?.claveOficial == e2?.claveOficial &&
        e1?.numeroGrua == e2?.numeroGrua &&
        e1?.placasPatrullaOGrua == e2?.placasPatrullaOGrua &&
        e1?.categoriaMulta == e2?.categoriaMulta &&
        e1?.folio == e2?.folio &&
        e1?.status == e2?.status &&
        e1?.fechaCambioStatus == e2?.fechaCambioStatus &&
        listEquality.equals(e1?.papelesScaneo, e2?.papelesScaneo);
  }

  @override
  int hash(InfraccionesRecord? e) => const ListEquality().hash([
        e?.oficial,
        e?.uid,
        e?.fechaInf,
        e?.codigoInfraccion,
        e?.nombreOficial,
        e?.nombreInfractor,
        e?.domicilioInfractor,
        e?.licencia,
        e?.tipoLicencia,
        e?.estadoEmisionLicencia,
        e?.telefonoInfractor,
        e?.whatsInfractor,
        e?.correoInfractor,
        e?.evidenciaPrincipal,
        e?.evidenciaComplementaria,
        e?.ubicacionInfraccion,
        e?.detallesInfraccion,
        e?.comentariosOficial,
        e?.comentariosInfractor,
        e?.firmaOficial,
        e?.firmaInfractor,
        e?.usoVehculo,
        e?.emisionPlaca,
        e?.marcaYModelo,
        e?.numeroSerie,
        e?.placasInfractor,
        e?.claveOficial,
        e?.numeroGrua,
        e?.placasPatrullaOGrua,
        e?.categoriaMulta,
        e?.folio,
        e?.status,
        e?.fechaCambioStatus,
        e?.papelesScaneo
      ]);

  @override
  bool isValidKey(Object? o) => o is InfraccionesRecord;
}
