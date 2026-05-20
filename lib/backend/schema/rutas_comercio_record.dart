import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RutasComercioRecord extends FirestoreRecord {
  RutasComercioRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "NombreRuta" field.
  String? _nombreRuta;
  String get nombreRuta => _nombreRuta ?? '';
  bool hasNombreRuta() => _nombreRuta != null;

  // "DescripcionRuta" field.
  String? _descripcionRuta;
  String get descripcionRuta => _descripcionRuta ?? '';
  bool hasDescripcionRuta() => _descripcionRuta != null;

  // "Fecha" field.
  DateTime? _fecha;
  DateTime? get fecha => _fecha;
  bool hasFecha() => _fecha != null;

  void _initializeFields() {
    _nombreRuta = snapshotData['NombreRuta'] as String?;
    _descripcionRuta = snapshotData['DescripcionRuta'] as String?;
    _fecha = snapshotData['Fecha'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('RutasComercio');

  static Stream<RutasComercioRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RutasComercioRecord.fromSnapshot(s));

  static Future<RutasComercioRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RutasComercioRecord.fromSnapshot(s));

  static RutasComercioRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RutasComercioRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RutasComercioRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RutasComercioRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RutasComercioRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RutasComercioRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRutasComercioRecordData({
  String? nombreRuta,
  String? descripcionRuta,
  DateTime? fecha,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'NombreRuta': nombreRuta,
      'DescripcionRuta': descripcionRuta,
      'Fecha': fecha,
    }.withoutNulls,
  );

  return firestoreData;
}

class RutasComercioRecordDocumentEquality
    implements Equality<RutasComercioRecord> {
  const RutasComercioRecordDocumentEquality();

  @override
  bool equals(RutasComercioRecord? e1, RutasComercioRecord? e2) {
    return e1?.nombreRuta == e2?.nombreRuta &&
        e1?.descripcionRuta == e2?.descripcionRuta &&
        e1?.fecha == e2?.fecha;
  }

  @override
  int hash(RutasComercioRecord? e) =>
      const ListEquality().hash([e?.nombreRuta, e?.descripcionRuta, e?.fecha]);

  @override
  bool isValidKey(Object? o) => o is RutasComercioRecord;
}
