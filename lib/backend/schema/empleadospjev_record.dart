import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EmpleadospjevRecord extends FirestoreRecord {
  EmpleadospjevRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  bool hasNombre() => _nombre != null;

  // "idempleado" field.
  String? _idempleado;
  String get idempleado => _idempleado ?? '';
  bool hasIdempleado() => _idempleado != null;

  // "fechacreacion" field.
  DateTime? _fechacreacion;
  DateTime? get fechacreacion => _fechacreacion;
  bool hasFechacreacion() => _fechacreacion != null;

  // "fechamodificacion" field.
  DateTime? _fechamodificacion;
  DateTime? get fechamodificacion => _fechamodificacion;
  bool hasFechamodificacion() => _fechamodificacion != null;

  // "estatus" field.
  String? _estatus;
  String get estatus => _estatus ?? '';
  bool hasEstatus() => _estatus != null;

  // "ubicacion" field.
  String? _ubicacion;
  String get ubicacion => _ubicacion ?? '';
  bool hasUbicacion() => _ubicacion != null;

  // "resguardosid" field.
  List<DocumentReference>? _resguardosid;
  List<DocumentReference> get resguardosid => _resguardosid ?? const [];
  bool hasResguardosid() => _resguardosid != null;

  // "cargo" field.
  String? _cargo;
  String get cargo => _cargo ?? '';
  bool hasCargo() => _cargo != null;

  // "celular" field.
  int? _celular;
  int get celular => _celular ?? 0;
  bool hasCelular() => _celular != null;

  void _initializeFields() {
    _nombre = snapshotData['nombre'] as String?;
    _idempleado = snapshotData['idempleado'] as String?;
    _fechacreacion = snapshotData['fechacreacion'] as DateTime?;
    _fechamodificacion = snapshotData['fechamodificacion'] as DateTime?;
    _estatus = snapshotData['estatus'] as String?;
    _ubicacion = snapshotData['ubicacion'] as String?;
    _resguardosid = getDataList(snapshotData['resguardosid']);
    _cargo = snapshotData['cargo'] as String?;
    _celular = castToType<int>(snapshotData['celular']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('empleadospjev');

  static Stream<EmpleadospjevRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EmpleadospjevRecord.fromSnapshot(s));

  static Future<EmpleadospjevRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EmpleadospjevRecord.fromSnapshot(s));

  static EmpleadospjevRecord fromSnapshot(DocumentSnapshot snapshot) =>
      EmpleadospjevRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EmpleadospjevRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EmpleadospjevRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EmpleadospjevRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EmpleadospjevRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEmpleadospjevRecordData({
  String? nombre,
  String? idempleado,
  DateTime? fechacreacion,
  DateTime? fechamodificacion,
  String? estatus,
  String? ubicacion,
  String? cargo,
  int? celular,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nombre': nombre,
      'idempleado': idempleado,
      'fechacreacion': fechacreacion,
      'fechamodificacion': fechamodificacion,
      'estatus': estatus,
      'ubicacion': ubicacion,
      'cargo': cargo,
      'celular': celular,
    }.withoutNulls,
  );

  return firestoreData;
}

class EmpleadospjevRecordDocumentEquality
    implements Equality<EmpleadospjevRecord> {
  const EmpleadospjevRecordDocumentEquality();

  @override
  bool equals(EmpleadospjevRecord? e1, EmpleadospjevRecord? e2) {
    const listEquality = ListEquality();
    return e1?.nombre == e2?.nombre &&
        e1?.idempleado == e2?.idempleado &&
        e1?.fechacreacion == e2?.fechacreacion &&
        e1?.fechamodificacion == e2?.fechamodificacion &&
        e1?.estatus == e2?.estatus &&
        e1?.ubicacion == e2?.ubicacion &&
        listEquality.equals(e1?.resguardosid, e2?.resguardosid) &&
        e1?.cargo == e2?.cargo &&
        e1?.celular == e2?.celular;
  }

  @override
  int hash(EmpleadospjevRecord? e) => const ListEquality().hash([
        e?.nombre,
        e?.idempleado,
        e?.fechacreacion,
        e?.fechamodificacion,
        e?.estatus,
        e?.ubicacion,
        e?.resguardosid,
        e?.cargo,
        e?.celular
      ]);

  @override
  bool isValidKey(Object? o) => o is EmpleadospjevRecord;
}
