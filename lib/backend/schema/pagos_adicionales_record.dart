import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PagosAdicionalesRecord extends FirestoreRecord {
  PagosAdicionalesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "FechaCreacion" field.
  DateTime? _fechaCreacion;
  DateTime? get fechaCreacion => _fechaCreacion;
  bool hasFechaCreacion() => _fechaCreacion != null;

  // "FechaModificacion" field.
  DateTime? _fechaModificacion;
  DateTime? get fechaModificacion => _fechaModificacion;
  bool hasFechaModificacion() => _fechaModificacion != null;

  // "Concepto" field.
  String? _concepto;
  String get concepto => _concepto ?? '';
  bool hasConcepto() => _concepto != null;

  // "CantidadPesos" field.
  double? _cantidadPesos;
  double get cantidadPesos => _cantidadPesos ?? 0.0;
  bool hasCantidadPesos() => _cantidadPesos != null;

  // "CantidadEnUMAS" field.
  double? _cantidadEnUMAS;
  double get cantidadEnUMAS => _cantidadEnUMAS ?? 0.0;
  bool hasCantidadEnUMAS() => _cantidadEnUMAS != null;

  // "Periodicidad" field.
  String? _periodicidad;
  String get periodicidad => _periodicidad ?? '';
  bool hasPeriodicidad() => _periodicidad != null;

  // "ReferenciaCreacion" field.
  DocumentReference? _referenciaCreacion;
  DocumentReference? get referenciaCreacion => _referenciaCreacion;
  bool hasReferenciaCreacion() => _referenciaCreacion != null;

  void _initializeFields() {
    _fechaCreacion = snapshotData['FechaCreacion'] as DateTime?;
    _fechaModificacion = snapshotData['FechaModificacion'] as DateTime?;
    _concepto = snapshotData['Concepto'] as String?;
    _cantidadPesos = castToType<double>(snapshotData['CantidadPesos']);
    _cantidadEnUMAS = castToType<double>(snapshotData['CantidadEnUMAS']);
    _periodicidad = snapshotData['Periodicidad'] as String?;
    _referenciaCreacion =
        snapshotData['ReferenciaCreacion'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('PagosAdicionales');

  static Stream<PagosAdicionalesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PagosAdicionalesRecord.fromSnapshot(s));

  static Future<PagosAdicionalesRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => PagosAdicionalesRecord.fromSnapshot(s));

  static PagosAdicionalesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PagosAdicionalesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PagosAdicionalesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PagosAdicionalesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PagosAdicionalesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PagosAdicionalesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPagosAdicionalesRecordData({
  DateTime? fechaCreacion,
  DateTime? fechaModificacion,
  String? concepto,
  double? cantidadPesos,
  double? cantidadEnUMAS,
  String? periodicidad,
  DocumentReference? referenciaCreacion,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'FechaCreacion': fechaCreacion,
      'FechaModificacion': fechaModificacion,
      'Concepto': concepto,
      'CantidadPesos': cantidadPesos,
      'CantidadEnUMAS': cantidadEnUMAS,
      'Periodicidad': periodicidad,
      'ReferenciaCreacion': referenciaCreacion,
    }.withoutNulls,
  );

  return firestoreData;
}

class PagosAdicionalesRecordDocumentEquality
    implements Equality<PagosAdicionalesRecord> {
  const PagosAdicionalesRecordDocumentEquality();

  @override
  bool equals(PagosAdicionalesRecord? e1, PagosAdicionalesRecord? e2) {
    return e1?.fechaCreacion == e2?.fechaCreacion &&
        e1?.fechaModificacion == e2?.fechaModificacion &&
        e1?.concepto == e2?.concepto &&
        e1?.cantidadPesos == e2?.cantidadPesos &&
        e1?.cantidadEnUMAS == e2?.cantidadEnUMAS &&
        e1?.periodicidad == e2?.periodicidad &&
        e1?.referenciaCreacion == e2?.referenciaCreacion;
  }

  @override
  int hash(PagosAdicionalesRecord? e) => const ListEquality().hash([
        e?.fechaCreacion,
        e?.fechaModificacion,
        e?.concepto,
        e?.cantidadPesos,
        e?.cantidadEnUMAS,
        e?.periodicidad,
        e?.referenciaCreacion
      ]);

  @override
  bool isValidKey(Object? o) => o is PagosAdicionalesRecord;
}
