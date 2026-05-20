import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GeneralRecord extends FirestoreRecord {
  GeneralRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "usuario" field.
  String? _usuario;
  String get usuario => _usuario ?? '';
  bool hasUsuario() => _usuario != null;

  // "procedencia" field.
  LatLng? _procedencia;
  LatLng? get procedencia => _procedencia;
  bool hasProcedencia() => _procedencia != null;

  // "FechaCreacion" field.
  DateTime? _fechaCreacion;
  DateTime? get fechaCreacion => _fechaCreacion;
  bool hasFechaCreacion() => _fechaCreacion != null;

  // "usuario3" field.
  DocumentReference? _usuario3;
  DocumentReference? get usuario3 => _usuario3;
  bool hasUsuario3() => _usuario3 != null;

  void _initializeFields() {
    _usuario = snapshotData['usuario'] as String?;
    _procedencia = snapshotData['procedencia'] as LatLng?;
    _fechaCreacion = snapshotData['FechaCreacion'] as DateTime?;
    _usuario3 = snapshotData['usuario3'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('general');

  static Stream<GeneralRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GeneralRecord.fromSnapshot(s));

  static Future<GeneralRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GeneralRecord.fromSnapshot(s));

  static GeneralRecord fromSnapshot(DocumentSnapshot snapshot) =>
      GeneralRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GeneralRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GeneralRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GeneralRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GeneralRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGeneralRecordData({
  String? usuario,
  LatLng? procedencia,
  DateTime? fechaCreacion,
  DocumentReference? usuario3,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'usuario': usuario,
      'procedencia': procedencia,
      'FechaCreacion': fechaCreacion,
      'usuario3': usuario3,
    }.withoutNulls,
  );

  return firestoreData;
}

class GeneralRecordDocumentEquality implements Equality<GeneralRecord> {
  const GeneralRecordDocumentEquality();

  @override
  bool equals(GeneralRecord? e1, GeneralRecord? e2) {
    return e1?.usuario == e2?.usuario &&
        e1?.procedencia == e2?.procedencia &&
        e1?.fechaCreacion == e2?.fechaCreacion &&
        e1?.usuario3 == e2?.usuario3;
  }

  @override
  int hash(GeneralRecord? e) => const ListEquality()
      .hash([e?.usuario, e?.procedencia, e?.fechaCreacion, e?.usuario3]);

  @override
  bool isValidKey(Object? o) => o is GeneralRecord;
}
