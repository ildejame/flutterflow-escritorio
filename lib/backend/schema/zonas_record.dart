import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ZonasRecord extends FirestoreRecord {
  ZonasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "fechacracion" field.
  DateTime? _fechacracion;
  DateTime? get fechacracion => _fechacracion;
  bool hasFechacracion() => _fechacracion != null;

  // "nombrezona" field.
  String? _nombrezona;
  String get nombrezona => _nombrezona ?? '';
  bool hasNombrezona() => _nombrezona != null;

  // "responsable" field.
  String? _responsable;
  String get responsable => _responsable ?? '';
  bool hasResponsable() => _responsable != null;

  void _initializeFields() {
    _fechacracion = snapshotData['fechacracion'] as DateTime?;
    _nombrezona = snapshotData['nombrezona'] as String?;
    _responsable = snapshotData['responsable'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('zonas');

  static Stream<ZonasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ZonasRecord.fromSnapshot(s));

  static Future<ZonasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ZonasRecord.fromSnapshot(s));

  static ZonasRecord fromSnapshot(DocumentSnapshot snapshot) => ZonasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ZonasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ZonasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ZonasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ZonasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createZonasRecordData({
  DateTime? fechacracion,
  String? nombrezona,
  String? responsable,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'fechacracion': fechacracion,
      'nombrezona': nombrezona,
      'responsable': responsable,
    }.withoutNulls,
  );

  return firestoreData;
}

class ZonasRecordDocumentEquality implements Equality<ZonasRecord> {
  const ZonasRecordDocumentEquality();

  @override
  bool equals(ZonasRecord? e1, ZonasRecord? e2) {
    return e1?.fechacracion == e2?.fechacracion &&
        e1?.nombrezona == e2?.nombrezona &&
        e1?.responsable == e2?.responsable;
  }

  @override
  int hash(ZonasRecord? e) => const ListEquality()
      .hash([e?.fechacracion, e?.nombrezona, e?.responsable]);

  @override
  bool isValidKey(Object? o) => o is ZonasRecord;
}
