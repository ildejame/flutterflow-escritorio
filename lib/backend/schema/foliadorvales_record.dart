import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FoliadorvalesRecord extends FirestoreRecord {
  FoliadorvalesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "fechaultimovale" field.
  DateTime? _fechaultimovale;
  DateTime? get fechaultimovale => _fechaultimovale;
  bool hasFechaultimovale() => _fechaultimovale != null;

  // "quiencreaultimo" field.
  String? _quiencreaultimo;
  String get quiencreaultimo => _quiencreaultimo ?? '';
  bool hasQuiencreaultimo() => _quiencreaultimo != null;

  // "folio" field.
  String? _folio;
  String get folio => _folio ?? '';
  bool hasFolio() => _folio != null;

  void _initializeFields() {
    _fechaultimovale = snapshotData['fechaultimovale'] as DateTime?;
    _quiencreaultimo = snapshotData['quiencreaultimo'] as String?;
    _folio = snapshotData['folio'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('foliadorvales');

  static Stream<FoliadorvalesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FoliadorvalesRecord.fromSnapshot(s));

  static Future<FoliadorvalesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FoliadorvalesRecord.fromSnapshot(s));

  static FoliadorvalesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FoliadorvalesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FoliadorvalesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FoliadorvalesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FoliadorvalesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FoliadorvalesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFoliadorvalesRecordData({
  DateTime? fechaultimovale,
  String? quiencreaultimo,
  String? folio,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'fechaultimovale': fechaultimovale,
      'quiencreaultimo': quiencreaultimo,
      'folio': folio,
    }.withoutNulls,
  );

  return firestoreData;
}

class FoliadorvalesRecordDocumentEquality
    implements Equality<FoliadorvalesRecord> {
  const FoliadorvalesRecordDocumentEquality();

  @override
  bool equals(FoliadorvalesRecord? e1, FoliadorvalesRecord? e2) {
    return e1?.fechaultimovale == e2?.fechaultimovale &&
        e1?.quiencreaultimo == e2?.quiencreaultimo &&
        e1?.folio == e2?.folio;
  }

  @override
  int hash(FoliadorvalesRecord? e) => const ListEquality()
      .hash([e?.fechaultimovale, e?.quiencreaultimo, e?.folio]);

  @override
  bool isValidKey(Object? o) => o is FoliadorvalesRecord;
}
