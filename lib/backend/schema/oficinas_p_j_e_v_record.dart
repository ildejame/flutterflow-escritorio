import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OficinasPJEVRecord extends FirestoreRecord {
  OficinasPJEVRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "fechacreacion" field.
  DateTime? _fechacreacion;
  DateTime? get fechacreacion => _fechacreacion;
  bool hasFechacreacion() => _fechacreacion != null;

  // "quiencrea" field.
  DocumentReference? _quiencrea;
  DocumentReference? get quiencrea => _quiencrea;
  bool hasQuiencrea() => _quiencrea != null;

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  bool hasNombre() => _nombre != null;

  // "nivel1ID" field.
  DocumentReference? _nivel1ID;
  DocumentReference? get nivel1ID => _nivel1ID;
  bool hasNivel1ID() => _nivel1ID != null;

  // "nombre1" field.
  String? _nombre1;
  String get nombre1 => _nombre1 ?? '';
  bool hasNombre1() => _nombre1 != null;

  // "nivel2ID" field.
  DocumentReference? _nivel2ID;
  DocumentReference? get nivel2ID => _nivel2ID;
  bool hasNivel2ID() => _nivel2ID != null;

  // "nombre2" field.
  String? _nombre2;
  String get nombre2 => _nombre2 ?? '';
  bool hasNombre2() => _nombre2 != null;

  // "nivel3ID" field.
  DocumentReference? _nivel3ID;
  DocumentReference? get nivel3ID => _nivel3ID;
  bool hasNivel3ID() => _nivel3ID != null;

  // "nombre3" field.
  String? _nombre3;
  String get nombre3 => _nombre3 ?? '';
  bool hasNombre3() => _nombre3 != null;

  // "nivel4ID" field.
  DocumentReference? _nivel4ID;
  DocumentReference? get nivel4ID => _nivel4ID;
  bool hasNivel4ID() => _nivel4ID != null;

  // "nombre4" field.
  String? _nombre4;
  String get nombre4 => _nombre4 ?? '';
  bool hasNombre4() => _nombre4 != null;

  void _initializeFields() {
    _fechacreacion = snapshotData['fechacreacion'] as DateTime?;
    _quiencrea = snapshotData['quiencrea'] as DocumentReference?;
    _nombre = snapshotData['nombre'] as String?;
    _nivel1ID = snapshotData['nivel1ID'] as DocumentReference?;
    _nombre1 = snapshotData['nombre1'] as String?;
    _nivel2ID = snapshotData['nivel2ID'] as DocumentReference?;
    _nombre2 = snapshotData['nombre2'] as String?;
    _nivel3ID = snapshotData['nivel3ID'] as DocumentReference?;
    _nombre3 = snapshotData['nombre3'] as String?;
    _nivel4ID = snapshotData['nivel4ID'] as DocumentReference?;
    _nombre4 = snapshotData['nombre4'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('oficinasPJEV');

  static Stream<OficinasPJEVRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OficinasPJEVRecord.fromSnapshot(s));

  static Future<OficinasPJEVRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OficinasPJEVRecord.fromSnapshot(s));

  static OficinasPJEVRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OficinasPJEVRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OficinasPJEVRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OficinasPJEVRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OficinasPJEVRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OficinasPJEVRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOficinasPJEVRecordData({
  DateTime? fechacreacion,
  DocumentReference? quiencrea,
  String? nombre,
  DocumentReference? nivel1ID,
  String? nombre1,
  DocumentReference? nivel2ID,
  String? nombre2,
  DocumentReference? nivel3ID,
  String? nombre3,
  DocumentReference? nivel4ID,
  String? nombre4,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'fechacreacion': fechacreacion,
      'quiencrea': quiencrea,
      'nombre': nombre,
      'nivel1ID': nivel1ID,
      'nombre1': nombre1,
      'nivel2ID': nivel2ID,
      'nombre2': nombre2,
      'nivel3ID': nivel3ID,
      'nombre3': nombre3,
      'nivel4ID': nivel4ID,
      'nombre4': nombre4,
    }.withoutNulls,
  );

  return firestoreData;
}

class OficinasPJEVRecordDocumentEquality
    implements Equality<OficinasPJEVRecord> {
  const OficinasPJEVRecordDocumentEquality();

  @override
  bool equals(OficinasPJEVRecord? e1, OficinasPJEVRecord? e2) {
    return e1?.fechacreacion == e2?.fechacreacion &&
        e1?.quiencrea == e2?.quiencrea &&
        e1?.nombre == e2?.nombre &&
        e1?.nivel1ID == e2?.nivel1ID &&
        e1?.nombre1 == e2?.nombre1 &&
        e1?.nivel2ID == e2?.nivel2ID &&
        e1?.nombre2 == e2?.nombre2 &&
        e1?.nivel3ID == e2?.nivel3ID &&
        e1?.nombre3 == e2?.nombre3 &&
        e1?.nivel4ID == e2?.nivel4ID &&
        e1?.nombre4 == e2?.nombre4;
  }

  @override
  int hash(OficinasPJEVRecord? e) => const ListEquality().hash([
        e?.fechacreacion,
        e?.quiencrea,
        e?.nombre,
        e?.nivel1ID,
        e?.nombre1,
        e?.nivel2ID,
        e?.nombre2,
        e?.nivel3ID,
        e?.nombre3,
        e?.nivel4ID,
        e?.nombre4
      ]);

  @override
  bool isValidKey(Object? o) => o is OficinasPJEVRecord;
}
