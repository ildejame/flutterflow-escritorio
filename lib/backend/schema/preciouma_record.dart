import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PrecioumaRecord extends FirestoreRecord {
  PrecioumaRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "precio" field.
  double? _precio;
  double get precio => _precio ?? 0.0;
  bool hasPrecio() => _precio != null;

  // "fechaactualizacion" field.
  DateTime? _fechaactualizacion;
  DateTime? get fechaactualizacion => _fechaactualizacion;
  bool hasFechaactualizacion() => _fechaactualizacion != null;

  // "quienactualiza" field.
  String? _quienactualiza;
  String get quienactualiza => _quienactualiza ?? '';
  bool hasQuienactualiza() => _quienactualiza != null;

  void _initializeFields() {
    _precio = castToType<double>(snapshotData['precio']);
    _fechaactualizacion = snapshotData['fechaactualizacion'] as DateTime?;
    _quienactualiza = snapshotData['quienactualiza'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('preciouma');

  static Stream<PrecioumaRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PrecioumaRecord.fromSnapshot(s));

  static Future<PrecioumaRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PrecioumaRecord.fromSnapshot(s));

  static PrecioumaRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PrecioumaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PrecioumaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PrecioumaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PrecioumaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PrecioumaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPrecioumaRecordData({
  double? precio,
  DateTime? fechaactualizacion,
  String? quienactualiza,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'precio': precio,
      'fechaactualizacion': fechaactualizacion,
      'quienactualiza': quienactualiza,
    }.withoutNulls,
  );

  return firestoreData;
}

class PrecioumaRecordDocumentEquality implements Equality<PrecioumaRecord> {
  const PrecioumaRecordDocumentEquality();

  @override
  bool equals(PrecioumaRecord? e1, PrecioumaRecord? e2) {
    return e1?.precio == e2?.precio &&
        e1?.fechaactualizacion == e2?.fechaactualizacion &&
        e1?.quienactualiza == e2?.quienactualiza;
  }

  @override
  int hash(PrecioumaRecord? e) => const ListEquality()
      .hash([e?.precio, e?.fechaactualizacion, e?.quienactualiza]);

  @override
  bool isValidKey(Object? o) => o is PrecioumaRecord;
}
