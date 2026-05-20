import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Depreciacion2024Record extends FirestoreRecord {
  Depreciacion2024Record._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "clasdeactivo" field.
  String? _clasdeactivo;
  String get clasdeactivo => _clasdeactivo ?? '';
  bool hasClasdeactivo() => _clasdeactivo != null;

  // "depreciacion2024" field.
  double? _depreciacion2024;
  double get depreciacion2024 => _depreciacion2024 ?? 0.0;
  bool hasDepreciacion2024() => _depreciacion2024 != null;

  // "numerobienes" field.
  int? _numerobienes;
  int get numerobienes => _numerobienes ?? 0;
  bool hasNumerobienes() => _numerobienes != null;

  // "unidadpresupuestal" field.
  String? _unidadpresupuestal;
  String get unidadpresupuestal => _unidadpresupuestal ?? '';
  bool hasUnidadpresupuestal() => _unidadpresupuestal != null;

  void _initializeFields() {
    _clasdeactivo = snapshotData['clasdeactivo'] as String?;
    _depreciacion2024 = castToType<double>(snapshotData['depreciacion2024']);
    _numerobienes = castToType<int>(snapshotData['numerobienes']);
    _unidadpresupuestal = snapshotData['unidadpresupuestal'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('depreciacion2024');

  static Stream<Depreciacion2024Record> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => Depreciacion2024Record.fromSnapshot(s));

  static Future<Depreciacion2024Record> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => Depreciacion2024Record.fromSnapshot(s));

  static Depreciacion2024Record fromSnapshot(DocumentSnapshot snapshot) =>
      Depreciacion2024Record._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static Depreciacion2024Record getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      Depreciacion2024Record._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'Depreciacion2024Record(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is Depreciacion2024Record &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDepreciacion2024RecordData({
  String? clasdeactivo,
  double? depreciacion2024,
  int? numerobienes,
  String? unidadpresupuestal,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'clasdeactivo': clasdeactivo,
      'depreciacion2024': depreciacion2024,
      'numerobienes': numerobienes,
      'unidadpresupuestal': unidadpresupuestal,
    }.withoutNulls,
  );

  return firestoreData;
}

class Depreciacion2024RecordDocumentEquality
    implements Equality<Depreciacion2024Record> {
  const Depreciacion2024RecordDocumentEquality();

  @override
  bool equals(Depreciacion2024Record? e1, Depreciacion2024Record? e2) {
    return e1?.clasdeactivo == e2?.clasdeactivo &&
        e1?.depreciacion2024 == e2?.depreciacion2024 &&
        e1?.numerobienes == e2?.numerobienes &&
        e1?.unidadpresupuestal == e2?.unidadpresupuestal;
  }

  @override
  int hash(Depreciacion2024Record? e) => const ListEquality().hash([
        e?.clasdeactivo,
        e?.depreciacion2024,
        e?.numerobienes,
        e?.unidadpresupuestal
      ]);

  @override
  bool isValidKey(Object? o) => o is Depreciacion2024Record;
}
