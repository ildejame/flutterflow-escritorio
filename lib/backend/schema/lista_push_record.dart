import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListaPushRecord extends FirestoreRecord {
  ListaPushRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "ListaUsers" field.
  List<DocumentReference>? _listaUsers;
  List<DocumentReference> get listaUsers => _listaUsers ?? const [];
  bool hasListaUsers() => _listaUsers != null;

  void _initializeFields() {
    _listaUsers = getDataList(snapshotData['ListaUsers']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('ListaPush');

  static Stream<ListaPushRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ListaPushRecord.fromSnapshot(s));

  static Future<ListaPushRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ListaPushRecord.fromSnapshot(s));

  static ListaPushRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ListaPushRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ListaPushRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ListaPushRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ListaPushRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ListaPushRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createListaPushRecordData() {
  final firestoreData = mapToFirestore(
    <String, dynamic>{}.withoutNulls,
  );

  return firestoreData;
}

class ListaPushRecordDocumentEquality implements Equality<ListaPushRecord> {
  const ListaPushRecordDocumentEquality();

  @override
  bool equals(ListaPushRecord? e1, ListaPushRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.listaUsers, e2?.listaUsers);
  }

  @override
  int hash(ListaPushRecord? e) => const ListEquality().hash([e?.listaUsers]);

  @override
  bool isValidKey(Object? o) => o is ListaPushRecord;
}
