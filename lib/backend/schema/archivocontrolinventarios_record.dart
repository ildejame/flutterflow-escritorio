import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ArchivocontrolinventariosRecord extends FirestoreRecord {
  ArchivocontrolinventariosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "fechaactualizacion" field.
  DateTime? _fechaactualizacion;
  DateTime? get fechaactualizacion => _fechaactualizacion;
  bool hasFechaactualizacion() => _fechaactualizacion != null;

  // "numerobienes" field.
  int? _numerobienes;
  int get numerobienes => _numerobienes ?? 0;
  bool hasNumerobienes() => _numerobienes != null;

  // "quienactualiza" field.
  String? _quienactualiza;
  String get quienactualiza => _quienactualiza ?? '';
  bool hasQuienactualiza() => _quienactualiza != null;

  void _initializeFields() {
    _fechaactualizacion = snapshotData['fechaactualizacion'] as DateTime?;
    _numerobienes = castToType<int>(snapshotData['numerobienes']);
    _quienactualiza = snapshotData['quienactualiza'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('archivocontrolinventarios');

  static Stream<ArchivocontrolinventariosRecord> getDocument(
          DocumentReference ref) =>
      ref
          .snapshots()
          .map((s) => ArchivocontrolinventariosRecord.fromSnapshot(s));

  static Future<ArchivocontrolinventariosRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ArchivocontrolinventariosRecord.fromSnapshot(s));

  static ArchivocontrolinventariosRecord fromSnapshot(
          DocumentSnapshot snapshot) =>
      ArchivocontrolinventariosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ArchivocontrolinventariosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ArchivocontrolinventariosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ArchivocontrolinventariosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ArchivocontrolinventariosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createArchivocontrolinventariosRecordData({
  DateTime? fechaactualizacion,
  int? numerobienes,
  String? quienactualiza,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'fechaactualizacion': fechaactualizacion,
      'numerobienes': numerobienes,
      'quienactualiza': quienactualiza,
    }.withoutNulls,
  );

  return firestoreData;
}

class ArchivocontrolinventariosRecordDocumentEquality
    implements Equality<ArchivocontrolinventariosRecord> {
  const ArchivocontrolinventariosRecordDocumentEquality();

  @override
  bool equals(ArchivocontrolinventariosRecord? e1,
      ArchivocontrolinventariosRecord? e2) {
    return e1?.fechaactualizacion == e2?.fechaactualizacion &&
        e1?.numerobienes == e2?.numerobienes &&
        e1?.quienactualiza == e2?.quienactualiza;
  }

  @override
  int hash(ArchivocontrolinventariosRecord? e) => const ListEquality()
      .hash([e?.fechaactualizacion, e?.numerobienes, e?.quienactualiza]);

  @override
  bool isValidKey(Object? o) => o is ArchivocontrolinventariosRecord;
}
