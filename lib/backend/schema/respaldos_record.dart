import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RespaldosRecord extends FirestoreRecord {
  RespaldosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "fechacreacion" field.
  DateTime? _fechacreacion;
  DateTime? get fechacreacion => _fechacreacion;
  bool hasFechacreacion() => _fechacreacion != null;

  // "nombrereporte" field.
  String? _nombrereporte;
  String get nombrereporte => _nombrereporte ?? '';
  bool hasNombrereporte() => _nombrereporte != null;

  // "filtroumas" field.
  String? _filtroumas;
  String get filtroumas => _filtroumas ?? '';
  bool hasFiltroumas() => _filtroumas != null;

  // "periodocontable" field.
  String? _periodocontable;
  String get periodocontable => _periodocontable ?? '';
  bool hasPeriodocontable() => _periodocontable != null;

  // "periodocompras" field.
  String? _periodocompras;
  String get periodocompras => _periodocompras ?? '';
  bool hasPeriodocompras() => _periodocompras != null;

  // "clasedeactivo" field.
  List<String>? _clasedeactivo;
  List<String> get clasedeactivo => _clasedeactivo ?? const [];
  bool hasClasedeactivo() => _clasedeactivo != null;

  // "numerobienes" field.
  List<int>? _numerobienes;
  List<int> get numerobienes => _numerobienes ?? const [];
  bool hasNumerobienes() => _numerobienes != null;

  // "valorenlibros" field.
  List<double>? _valorenlibros;
  List<double> get valorenlibros => _valorenlibros ?? const [];
  bool hasValorenlibros() => _valorenlibros != null;

  void _initializeFields() {
    _fechacreacion = snapshotData['fechacreacion'] as DateTime?;
    _nombrereporte = snapshotData['nombrereporte'] as String?;
    _filtroumas = snapshotData['filtroumas'] as String?;
    _periodocontable = snapshotData['periodocontable'] as String?;
    _periodocompras = snapshotData['periodocompras'] as String?;
    _clasedeactivo = getDataList(snapshotData['clasedeactivo']);
    _numerobienes = getDataList(snapshotData['numerobienes']);
    _valorenlibros = getDataList(snapshotData['valorenlibros']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('respaldos');

  static Stream<RespaldosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RespaldosRecord.fromSnapshot(s));

  static Future<RespaldosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RespaldosRecord.fromSnapshot(s));

  static RespaldosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RespaldosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RespaldosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RespaldosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RespaldosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RespaldosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRespaldosRecordData({
  DateTime? fechacreacion,
  String? nombrereporte,
  String? filtroumas,
  String? periodocontable,
  String? periodocompras,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'fechacreacion': fechacreacion,
      'nombrereporte': nombrereporte,
      'filtroumas': filtroumas,
      'periodocontable': periodocontable,
      'periodocompras': periodocompras,
    }.withoutNulls,
  );

  return firestoreData;
}

class RespaldosRecordDocumentEquality implements Equality<RespaldosRecord> {
  const RespaldosRecordDocumentEquality();

  @override
  bool equals(RespaldosRecord? e1, RespaldosRecord? e2) {
    const listEquality = ListEquality();
    return e1?.fechacreacion == e2?.fechacreacion &&
        e1?.nombrereporte == e2?.nombrereporte &&
        e1?.filtroumas == e2?.filtroumas &&
        e1?.periodocontable == e2?.periodocontable &&
        e1?.periodocompras == e2?.periodocompras &&
        listEquality.equals(e1?.clasedeactivo, e2?.clasedeactivo) &&
        listEquality.equals(e1?.numerobienes, e2?.numerobienes) &&
        listEquality.equals(e1?.valorenlibros, e2?.valorenlibros);
  }

  @override
  int hash(RespaldosRecord? e) => const ListEquality().hash([
        e?.fechacreacion,
        e?.nombrereporte,
        e?.filtroumas,
        e?.periodocontable,
        e?.periodocompras,
        e?.clasedeactivo,
        e?.numerobienes,
        e?.valorenlibros
      ]);

  @override
  bool isValidKey(Object? o) => o is RespaldosRecord;
}
