import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FoliobienesRecord extends FirestoreRecord {
  FoliobienesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "fechaactualizacion" field.
  DateTime? _fechaactualizacion;
  DateTime? get fechaactualizacion => _fechaactualizacion;
  bool hasFechaactualizacion() => _fechaactualizacion != null;

  // "ultimofolio" field.
  String? _ultimofolio;
  String get ultimofolio => _ultimofolio ?? '';
  bool hasUltimofolio() => _ultimofolio != null;

  // "quienmodifica" field.
  String? _quienmodifica;
  String get quienmodifica => _quienmodifica ?? '';
  bool hasQuienmodifica() => _quienmodifica != null;

  void _initializeFields() {
    _fechaactualizacion = snapshotData['fechaactualizacion'] as DateTime?;
    _ultimofolio = snapshotData['ultimofolio'] as String?;
    _quienmodifica = snapshotData['quienmodifica'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('foliobienes');

  static Stream<FoliobienesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FoliobienesRecord.fromSnapshot(s));

  static Future<FoliobienesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FoliobienesRecord.fromSnapshot(s));

  static FoliobienesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FoliobienesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FoliobienesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FoliobienesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FoliobienesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FoliobienesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFoliobienesRecordData({
  DateTime? fechaactualizacion,
  String? ultimofolio,
  String? quienmodifica,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'fechaactualizacion': fechaactualizacion,
      'ultimofolio': ultimofolio,
      'quienmodifica': quienmodifica,
    }.withoutNulls,
  );

  return firestoreData;
}

class FoliobienesRecordDocumentEquality implements Equality<FoliobienesRecord> {
  const FoliobienesRecordDocumentEquality();

  @override
  bool equals(FoliobienesRecord? e1, FoliobienesRecord? e2) {
    return e1?.fechaactualizacion == e2?.fechaactualizacion &&
        e1?.ultimofolio == e2?.ultimofolio &&
        e1?.quienmodifica == e2?.quienmodifica;
  }

  @override
  int hash(FoliobienesRecord? e) => const ListEquality()
      .hash([e?.fechaactualizacion, e?.ultimofolio, e?.quienmodifica]);

  @override
  bool isValidKey(Object? o) => o is FoliobienesRecord;
}
