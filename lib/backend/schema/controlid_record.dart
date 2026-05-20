import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ControlidRecord extends FirestoreRecord {
  ControlidRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "fechaultimaasignacion" field.
  DateTime? _fechaultimaasignacion;
  DateTime? get fechaultimaasignacion => _fechaultimaasignacion;
  bool hasFechaultimaasignacion() => _fechaultimaasignacion != null;

  // "ultimoid" field.
  String? _ultimoid;
  String get ultimoid => _ultimoid ?? '';
  bool hasUltimoid() => _ultimoid != null;

  // "quienasignoultimo" field.
  String? _quienasignoultimo;
  String get quienasignoultimo => _quienasignoultimo ?? '';
  bool hasQuienasignoultimo() => _quienasignoultimo != null;

  void _initializeFields() {
    _fechaultimaasignacion = snapshotData['fechaultimaasignacion'] as DateTime?;
    _ultimoid = snapshotData['ultimoid'] as String?;
    _quienasignoultimo = snapshotData['quienasignoultimo'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('controlid');

  static Stream<ControlidRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ControlidRecord.fromSnapshot(s));

  static Future<ControlidRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ControlidRecord.fromSnapshot(s));

  static ControlidRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ControlidRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ControlidRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ControlidRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ControlidRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ControlidRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createControlidRecordData({
  DateTime? fechaultimaasignacion,
  String? ultimoid,
  String? quienasignoultimo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'fechaultimaasignacion': fechaultimaasignacion,
      'ultimoid': ultimoid,
      'quienasignoultimo': quienasignoultimo,
    }.withoutNulls,
  );

  return firestoreData;
}

class ControlidRecordDocumentEquality implements Equality<ControlidRecord> {
  const ControlidRecordDocumentEquality();

  @override
  bool equals(ControlidRecord? e1, ControlidRecord? e2) {
    return e1?.fechaultimaasignacion == e2?.fechaultimaasignacion &&
        e1?.ultimoid == e2?.ultimoid &&
        e1?.quienasignoultimo == e2?.quienasignoultimo;
  }

  @override
  int hash(ControlidRecord? e) => const ListEquality()
      .hash([e?.fechaultimaasignacion, e?.ultimoid, e?.quienasignoultimo]);

  @override
  bool isValidKey(Object? o) => o is ControlidRecord;
}
