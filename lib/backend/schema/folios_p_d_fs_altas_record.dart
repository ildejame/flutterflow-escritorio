import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FoliosPDFsAltasRecord extends FirestoreRecord {
  FoliosPDFsAltasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "FechaUltimoFolio" field.
  DateTime? _fechaUltimoFolio;
  DateTime? get fechaUltimoFolio => _fechaUltimoFolio;
  bool hasFechaUltimoFolio() => _fechaUltimoFolio != null;

  // "NumeroFolio" field.
  int? _numeroFolio;
  int get numeroFolio => _numeroFolio ?? 0;
  bool hasNumeroFolio() => _numeroFolio != null;

  void _initializeFields() {
    _fechaUltimoFolio = snapshotData['FechaUltimoFolio'] as DateTime?;
    _numeroFolio = castToType<int>(snapshotData['NumeroFolio']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('FoliosPDFsAltas');

  static Stream<FoliosPDFsAltasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FoliosPDFsAltasRecord.fromSnapshot(s));

  static Future<FoliosPDFsAltasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FoliosPDFsAltasRecord.fromSnapshot(s));

  static FoliosPDFsAltasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FoliosPDFsAltasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FoliosPDFsAltasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FoliosPDFsAltasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FoliosPDFsAltasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FoliosPDFsAltasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFoliosPDFsAltasRecordData({
  DateTime? fechaUltimoFolio,
  int? numeroFolio,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'FechaUltimoFolio': fechaUltimoFolio,
      'NumeroFolio': numeroFolio,
    }.withoutNulls,
  );

  return firestoreData;
}

class FoliosPDFsAltasRecordDocumentEquality
    implements Equality<FoliosPDFsAltasRecord> {
  const FoliosPDFsAltasRecordDocumentEquality();

  @override
  bool equals(FoliosPDFsAltasRecord? e1, FoliosPDFsAltasRecord? e2) {
    return e1?.fechaUltimoFolio == e2?.fechaUltimoFolio &&
        e1?.numeroFolio == e2?.numeroFolio;
  }

  @override
  int hash(FoliosPDFsAltasRecord? e) =>
      const ListEquality().hash([e?.fechaUltimoFolio, e?.numeroFolio]);

  @override
  bool isValidKey(Object? o) => o is FoliosPDFsAltasRecord;
}
