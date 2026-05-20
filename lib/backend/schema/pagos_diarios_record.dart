import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PagosDiariosRecord extends FirestoreRecord {
  PagosDiariosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "ComercioRef" field.
  DocumentReference? _comercioRef;
  DocumentReference? get comercioRef => _comercioRef;
  bool hasComercioRef() => _comercioRef != null;

  // "Fecha" field.
  DateTime? _fecha;
  DateTime? get fecha => _fecha;
  bool hasFecha() => _fecha != null;

  // "Cobrador" field.
  DocumentReference? _cobrador;
  DocumentReference? get cobrador => _cobrador;
  bool hasCobrador() => _cobrador != null;

  // "IDCobrador" field.
  String? _iDCobrador;
  String get iDCobrador => _iDCobrador ?? '';
  bool hasIDCobrador() => _iDCobrador != null;

  // "Cantidad" field.
  double? _cantidad;
  double get cantidad => _cantidad ?? 0.0;
  bool hasCantidad() => _cantidad != null;

  // "Contador" field.
  int? _contador;
  int get contador => _contador ?? 0;
  bool hasContador() => _contador != null;

  // "NombreCobrador" field.
  String? _nombreCobrador;
  String get nombreCobrador => _nombreCobrador ?? '';
  bool hasNombreCobrador() => _nombreCobrador != null;

  // "SoloFecha" field.
  String? _soloFecha;
  String get soloFecha => _soloFecha ?? '';
  bool hasSoloFecha() => _soloFecha != null;

  // "RandomString" field.
  String? _randomString;
  String get randomString => _randomString ?? '';
  bool hasRandomString() => _randomString != null;

  // "NombreLocal" field.
  String? _nombreLocal;
  String get nombreLocal => _nombreLocal ?? '';
  bool hasNombreLocal() => _nombreLocal != null;

  void _initializeFields() {
    _comercioRef = snapshotData['ComercioRef'] as DocumentReference?;
    _fecha = snapshotData['Fecha'] as DateTime?;
    _cobrador = snapshotData['Cobrador'] as DocumentReference?;
    _iDCobrador = snapshotData['IDCobrador'] as String?;
    _cantidad = castToType<double>(snapshotData['Cantidad']);
    _contador = castToType<int>(snapshotData['Contador']);
    _nombreCobrador = snapshotData['NombreCobrador'] as String?;
    _soloFecha = snapshotData['SoloFecha'] as String?;
    _randomString = snapshotData['RandomString'] as String?;
    _nombreLocal = snapshotData['NombreLocal'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('PagosDiarios');

  static Stream<PagosDiariosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PagosDiariosRecord.fromSnapshot(s));

  static Future<PagosDiariosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PagosDiariosRecord.fromSnapshot(s));

  static PagosDiariosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PagosDiariosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PagosDiariosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PagosDiariosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PagosDiariosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PagosDiariosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPagosDiariosRecordData({
  DocumentReference? comercioRef,
  DateTime? fecha,
  DocumentReference? cobrador,
  String? iDCobrador,
  double? cantidad,
  int? contador,
  String? nombreCobrador,
  String? soloFecha,
  String? randomString,
  String? nombreLocal,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'ComercioRef': comercioRef,
      'Fecha': fecha,
      'Cobrador': cobrador,
      'IDCobrador': iDCobrador,
      'Cantidad': cantidad,
      'Contador': contador,
      'NombreCobrador': nombreCobrador,
      'SoloFecha': soloFecha,
      'RandomString': randomString,
      'NombreLocal': nombreLocal,
    }.withoutNulls,
  );

  return firestoreData;
}

class PagosDiariosRecordDocumentEquality
    implements Equality<PagosDiariosRecord> {
  const PagosDiariosRecordDocumentEquality();

  @override
  bool equals(PagosDiariosRecord? e1, PagosDiariosRecord? e2) {
    return e1?.comercioRef == e2?.comercioRef &&
        e1?.fecha == e2?.fecha &&
        e1?.cobrador == e2?.cobrador &&
        e1?.iDCobrador == e2?.iDCobrador &&
        e1?.cantidad == e2?.cantidad &&
        e1?.contador == e2?.contador &&
        e1?.nombreCobrador == e2?.nombreCobrador &&
        e1?.soloFecha == e2?.soloFecha &&
        e1?.randomString == e2?.randomString &&
        e1?.nombreLocal == e2?.nombreLocal;
  }

  @override
  int hash(PagosDiariosRecord? e) => const ListEquality().hash([
        e?.comercioRef,
        e?.fecha,
        e?.cobrador,
        e?.iDCobrador,
        e?.cantidad,
        e?.contador,
        e?.nombreCobrador,
        e?.soloFecha,
        e?.randomString,
        e?.nombreLocal
      ]);

  @override
  bool isValidKey(Object? o) => o is PagosDiariosRecord;
}
