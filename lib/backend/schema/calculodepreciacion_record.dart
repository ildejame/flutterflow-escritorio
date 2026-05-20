import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CalculodepreciacionRecord extends FirestoreRecord {
  CalculodepreciacionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "inventario2025" field.
  String? _inventario2025;
  String get inventario2025 => _inventario2025 ?? '';
  bool hasInventario2025() => _inventario2025 != null;

  // "aniodepreciacion" field.
  int? _aniodepreciacion;
  int get aniodepreciacion => _aniodepreciacion ?? 0;
  bool hasAniodepreciacion() => _aniodepreciacion != null;

  // "fechacalculo" field.
  DateTime? _fechacalculo;
  DateTime? get fechacalculo => _fechacalculo;
  bool hasFechacalculo() => _fechacalculo != null;

  // "depreciacion" field.
  double? _depreciacion;
  double get depreciacion => _depreciacion ?? 0.0;
  bool hasDepreciacion() => _depreciacion != null;

  // "preciooavaluo" field.
  double? _preciooavaluo;
  double get preciooavaluo => _preciooavaluo ?? 0.0;
  bool hasPreciooavaluo() => _preciooavaluo != null;

  // "clasedeactivo" field.
  String? _clasedeactivo;
  String get clasedeactivo => _clasedeactivo ?? '';
  bool hasClasedeactivo() => _clasedeactivo != null;

  // "descripcion" field.
  String? _descripcion;
  String get descripcion => _descripcion ?? '';
  bool hasDescripcion() => _descripcion != null;

  // "unidadpresupuestal" field.
  String? _unidadpresupuestal;
  String get unidadpresupuestal => _unidadpresupuestal ?? '';
  bool hasUnidadpresupuestal() => _unidadpresupuestal != null;

  // "preciocosto" field.
  double? _preciocosto;
  double get preciocosto => _preciocosto ?? 0.0;
  bool hasPreciocosto() => _preciocosto != null;

  // "fechaadquisicion" field.
  DateTime? _fechaadquisicion;
  DateTime? get fechaadquisicion => _fechaadquisicion;
  bool hasFechaadquisicion() => _fechaadquisicion != null;

  // "fechaavaluo" field.
  DateTime? _fechaavaluo;
  DateTime? get fechaavaluo => _fechaavaluo;
  bool hasFechaavaluo() => _fechaavaluo != null;

  void _initializeFields() {
    _inventario2025 = snapshotData['inventario2025'] as String?;
    _aniodepreciacion = castToType<int>(snapshotData['aniodepreciacion']);
    _fechacalculo = snapshotData['fechacalculo'] as DateTime?;
    _depreciacion = castToType<double>(snapshotData['depreciacion']);
    _preciooavaluo = castToType<double>(snapshotData['preciooavaluo']);
    _clasedeactivo = snapshotData['clasedeactivo'] as String?;
    _descripcion = snapshotData['descripcion'] as String?;
    _unidadpresupuestal = snapshotData['unidadpresupuestal'] as String?;
    _preciocosto = castToType<double>(snapshotData['preciocosto']);
    _fechaadquisicion = snapshotData['fechaadquisicion'] as DateTime?;
    _fechaavaluo = snapshotData['fechaavaluo'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('calculodepreciacion');

  static Stream<CalculodepreciacionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CalculodepreciacionRecord.fromSnapshot(s));

  static Future<CalculodepreciacionRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => CalculodepreciacionRecord.fromSnapshot(s));

  static CalculodepreciacionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CalculodepreciacionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CalculodepreciacionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CalculodepreciacionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CalculodepreciacionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CalculodepreciacionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCalculodepreciacionRecordData({
  String? inventario2025,
  int? aniodepreciacion,
  DateTime? fechacalculo,
  double? depreciacion,
  double? preciooavaluo,
  String? clasedeactivo,
  String? descripcion,
  String? unidadpresupuestal,
  double? preciocosto,
  DateTime? fechaadquisicion,
  DateTime? fechaavaluo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'inventario2025': inventario2025,
      'aniodepreciacion': aniodepreciacion,
      'fechacalculo': fechacalculo,
      'depreciacion': depreciacion,
      'preciooavaluo': preciooavaluo,
      'clasedeactivo': clasedeactivo,
      'descripcion': descripcion,
      'unidadpresupuestal': unidadpresupuestal,
      'preciocosto': preciocosto,
      'fechaadquisicion': fechaadquisicion,
      'fechaavaluo': fechaavaluo,
    }.withoutNulls,
  );

  return firestoreData;
}

class CalculodepreciacionRecordDocumentEquality
    implements Equality<CalculodepreciacionRecord> {
  const CalculodepreciacionRecordDocumentEquality();

  @override
  bool equals(CalculodepreciacionRecord? e1, CalculodepreciacionRecord? e2) {
    return e1?.inventario2025 == e2?.inventario2025 &&
        e1?.aniodepreciacion == e2?.aniodepreciacion &&
        e1?.fechacalculo == e2?.fechacalculo &&
        e1?.depreciacion == e2?.depreciacion &&
        e1?.preciooavaluo == e2?.preciooavaluo &&
        e1?.clasedeactivo == e2?.clasedeactivo &&
        e1?.descripcion == e2?.descripcion &&
        e1?.unidadpresupuestal == e2?.unidadpresupuestal &&
        e1?.preciocosto == e2?.preciocosto &&
        e1?.fechaadquisicion == e2?.fechaadquisicion &&
        e1?.fechaavaluo == e2?.fechaavaluo;
  }

  @override
  int hash(CalculodepreciacionRecord? e) => const ListEquality().hash([
        e?.inventario2025,
        e?.aniodepreciacion,
        e?.fechacalculo,
        e?.depreciacion,
        e?.preciooavaluo,
        e?.clasedeactivo,
        e?.descripcion,
        e?.unidadpresupuestal,
        e?.preciocosto,
        e?.fechaadquisicion,
        e?.fechaavaluo
      ]);

  @override
  bool isValidKey(Object? o) => o is CalculodepreciacionRecord;
}
