import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GirosRecord extends FirestoreRecord {
  GirosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "FechaCreacion" field.
  DateTime? _fechaCreacion;
  DateTime? get fechaCreacion => _fechaCreacion;
  bool hasFechaCreacion() => _fechaCreacion != null;

  // "IDCreacion" field.
  String? _iDCreacion;
  String get iDCreacion => _iDCreacion ?? '';
  bool hasIDCreacion() => _iDCreacion != null;

  // "NombrePersonal" field.
  String? _nombrePersonal;
  String get nombrePersonal => _nombrePersonal ?? '';
  bool hasNombrePersonal() => _nombrePersonal != null;

  // "ReferenciaUsuario" field.
  DocumentReference? _referenciaUsuario;
  DocumentReference? get referenciaUsuario => _referenciaUsuario;
  bool hasReferenciaUsuario() => _referenciaUsuario != null;

  // "NombreCategoriaNegocio" field.
  String? _nombreCategoriaNegocio;
  String get nombreCategoriaNegocio => _nombreCategoriaNegocio ?? '';
  bool hasNombreCategoriaNegocio() => _nombreCategoriaNegocio != null;

  // "NumeroUMAS" field.
  double? _numeroUMAS;
  double get numeroUMAS => _numeroUMAS ?? 0.0;
  bool hasNumeroUMAS() => _numeroUMAS != null;

  // "UMASRefrendo" field.
  double? _uMASRefrendo;
  double get uMASRefrendo => _uMASRefrendo ?? 0.0;
  bool hasUMASRefrendo() => _uMASRefrendo != null;

  void _initializeFields() {
    _fechaCreacion = snapshotData['FechaCreacion'] as DateTime?;
    _iDCreacion = snapshotData['IDCreacion'] as String?;
    _nombrePersonal = snapshotData['NombrePersonal'] as String?;
    _referenciaUsuario =
        snapshotData['ReferenciaUsuario'] as DocumentReference?;
    _nombreCategoriaNegocio = snapshotData['NombreCategoriaNegocio'] as String?;
    _numeroUMAS = castToType<double>(snapshotData['NumeroUMAS']);
    _uMASRefrendo = castToType<double>(snapshotData['UMASRefrendo']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Giros');

  static Stream<GirosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GirosRecord.fromSnapshot(s));

  static Future<GirosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GirosRecord.fromSnapshot(s));

  static GirosRecord fromSnapshot(DocumentSnapshot snapshot) => GirosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GirosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GirosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GirosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GirosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGirosRecordData({
  DateTime? fechaCreacion,
  String? iDCreacion,
  String? nombrePersonal,
  DocumentReference? referenciaUsuario,
  String? nombreCategoriaNegocio,
  double? numeroUMAS,
  double? uMASRefrendo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'FechaCreacion': fechaCreacion,
      'IDCreacion': iDCreacion,
      'NombrePersonal': nombrePersonal,
      'ReferenciaUsuario': referenciaUsuario,
      'NombreCategoriaNegocio': nombreCategoriaNegocio,
      'NumeroUMAS': numeroUMAS,
      'UMASRefrendo': uMASRefrendo,
    }.withoutNulls,
  );

  return firestoreData;
}

class GirosRecordDocumentEquality implements Equality<GirosRecord> {
  const GirosRecordDocumentEquality();

  @override
  bool equals(GirosRecord? e1, GirosRecord? e2) {
    return e1?.fechaCreacion == e2?.fechaCreacion &&
        e1?.iDCreacion == e2?.iDCreacion &&
        e1?.nombrePersonal == e2?.nombrePersonal &&
        e1?.referenciaUsuario == e2?.referenciaUsuario &&
        e1?.nombreCategoriaNegocio == e2?.nombreCategoriaNegocio &&
        e1?.numeroUMAS == e2?.numeroUMAS &&
        e1?.uMASRefrendo == e2?.uMASRefrendo;
  }

  @override
  int hash(GirosRecord? e) => const ListEquality().hash([
        e?.fechaCreacion,
        e?.iDCreacion,
        e?.nombrePersonal,
        e?.referenciaUsuario,
        e?.nombreCategoriaNegocio,
        e?.numeroUMAS,
        e?.uMASRefrendo
      ]);

  @override
  bool isValidKey(Object? o) => o is GirosRecord;
}
