import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ImpresionetiquetasRecord extends FirestoreRecord {
  ImpresionetiquetasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "bienref" field.
  DocumentReference? _bienref;
  DocumentReference? get bienref => _bienref;
  bool hasBienref() => _bienref != null;

  // "inventario2025" field.
  String? _inventario2025;
  String get inventario2025 => _inventario2025 ?? '';
  bool hasInventario2025() => _inventario2025 != null;

  // "estado" field.
  String? _estado;
  String get estado => _estado ?? '';
  bool hasEstado() => _estado != null;

  // "creadoEn" field.
  DateTime? _creadoEn;
  DateTime? get creadoEn => _creadoEn;
  bool hasCreadoEn() => _creadoEn != null;

  // "impresoEn" field.
  DateTime? _impresoEn;
  DateTime? get impresoEn => _impresoEn;
  bool hasImpresoEn() => _impresoEn != null;

  // "intentos" field.
  int? _intentos;
  int get intentos => _intentos ?? 0;
  bool hasIntentos() => _intentos != null;

  // "error" field.
  String? _error;
  String get error => _error ?? '';
  bool hasError() => _error != null;

  void _initializeFields() {
    _bienref = snapshotData['bienref'] as DocumentReference?;
    _inventario2025 = snapshotData['inventario2025'] as String?;
    _estado = snapshotData['estado'] as String?;
    _creadoEn = snapshotData['creadoEn'] as DateTime?;
    _impresoEn = snapshotData['impresoEn'] as DateTime?;
    _intentos = castToType<int>(snapshotData['intentos']);
    _error = snapshotData['error'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('impresionetiquetas');

  static Stream<ImpresionetiquetasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ImpresionetiquetasRecord.fromSnapshot(s));

  static Future<ImpresionetiquetasRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ImpresionetiquetasRecord.fromSnapshot(s));

  static ImpresionetiquetasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ImpresionetiquetasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ImpresionetiquetasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ImpresionetiquetasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ImpresionetiquetasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ImpresionetiquetasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createImpresionetiquetasRecordData({
  DocumentReference? bienref,
  String? inventario2025,
  String? estado,
  DateTime? creadoEn,
  DateTime? impresoEn,
  int? intentos,
  String? error,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'bienref': bienref,
      'inventario2025': inventario2025,
      'estado': estado,
      'creadoEn': creadoEn,
      'impresoEn': impresoEn,
      'intentos': intentos,
      'error': error,
    }.withoutNulls,
  );

  return firestoreData;
}

class ImpresionetiquetasRecordDocumentEquality
    implements Equality<ImpresionetiquetasRecord> {
  const ImpresionetiquetasRecordDocumentEquality();

  @override
  bool equals(ImpresionetiquetasRecord? e1, ImpresionetiquetasRecord? e2) {
    return e1?.bienref == e2?.bienref &&
        e1?.inventario2025 == e2?.inventario2025 &&
        e1?.estado == e2?.estado &&
        e1?.creadoEn == e2?.creadoEn &&
        e1?.impresoEn == e2?.impresoEn &&
        e1?.intentos == e2?.intentos &&
        e1?.error == e2?.error;
  }

  @override
  int hash(ImpresionetiquetasRecord? e) => const ListEquality().hash([
        e?.bienref,
        e?.inventario2025,
        e?.estado,
        e?.creadoEn,
        e?.impresoEn,
        e?.intentos,
        e?.error
      ]);

  @override
  bool isValidKey(Object? o) => o is ImpresionetiquetasRecord;
}
