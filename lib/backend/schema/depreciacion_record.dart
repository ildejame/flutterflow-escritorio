import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DepreciacionRecord extends FirestoreRecord {
  DepreciacionRecord._(
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

  // "porcentajedepreciacion" field.
  double? _porcentajedepreciacion;
  double get porcentajedepreciacion => _porcentajedepreciacion ?? 0.0;
  bool hasPorcentajedepreciacion() => _porcentajedepreciacion != null;

  // "vidautil" field.
  double? _vidautil;
  double get vidautil => _vidautil ?? 0.0;
  bool hasVidautil() => _vidautil != null;

  // "clavearmonizada" field.
  String? _clavearmonizada;
  String get clavearmonizada => _clavearmonizada ?? '';
  bool hasClavearmonizada() => _clavearmonizada != null;

  // "cuentaarmonizada" field.
  String? _cuentaarmonizada;
  String get cuentaarmonizada => _cuentaarmonizada ?? '';
  bool hasCuentaarmonizada() => _cuentaarmonizada != null;

  void _initializeFields() {
    _nombre = snapshotData['nombre'] as String?;
    _fechaalta = snapshotData['fechaalta'] as DateTime?;
    _porcentajedepreciacion =
        castToType<double>(snapshotData['porcentajedepreciacion']);
    _vidautil = castToType<double>(snapshotData['vidautil']);
    _clavearmonizada = snapshotData['clavearmonizada'] as String?;
    _cuentaarmonizada = snapshotData['cuentaarmonizada'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('depreciacion');

  static Stream<DepreciacionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DepreciacionRecord.fromSnapshot(s));

  static Future<DepreciacionRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DepreciacionRecord.fromSnapshot(s));

  static DepreciacionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DepreciacionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DepreciacionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DepreciacionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DepreciacionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DepreciacionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDepreciacionRecordData({
  String? nombre,
  DateTime? fechaalta,
  double? porcentajedepreciacion,
  double? vidautil,
  String? clavearmonizada,
  String? cuentaarmonizada,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nombre': nombre,
      'fechaalta': fechaalta,
      'porcentajedepreciacion': porcentajedepreciacion,
      'vidautil': vidautil,
      'clavearmonizada': clavearmonizada,
      'cuentaarmonizada': cuentaarmonizada,
    }.withoutNulls,
  );

  return firestoreData;
}

class DepreciacionRecordDocumentEquality
    implements Equality<DepreciacionRecord> {
  const DepreciacionRecordDocumentEquality();

  @override
  bool equals(DepreciacionRecord? e1, DepreciacionRecord? e2) {
    return e1?.nombre == e2?.nombre &&
        e1?.fechaalta == e2?.fechaalta &&
        e1?.porcentajedepreciacion == e2?.porcentajedepreciacion &&
        e1?.vidautil == e2?.vidautil &&
        e1?.clavearmonizada == e2?.clavearmonizada &&
        e1?.cuentaarmonizada == e2?.cuentaarmonizada;
  }

  @override
  int hash(DepreciacionRecord? e) => const ListEquality().hash([
        e?.nombre,
        e?.fechaalta,
        e?.porcentajedepreciacion,
        e?.vidautil,
        e?.clavearmonizada,
        e?.cuentaarmonizada
      ]);

  @override
  bool isValidKey(Object? o) => o is DepreciacionRecord;
}
