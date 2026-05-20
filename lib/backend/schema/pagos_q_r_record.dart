import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PagosQRRecord extends FirestoreRecord {
  PagosQRRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Comercio" field.
  DocumentReference? _comercio;
  DocumentReference? get comercio => _comercio;
  bool hasComercio() => _comercio != null;

  // "Time" field.
  DateTime? _time;
  DateTime? get time => _time;
  bool hasTime() => _time != null;

  // "Pago" field.
  double? _pago;
  double get pago => _pago ?? 0.0;
  bool hasPago() => _pago != null;

  // "PosicionCobrador" field.
  LatLng? _posicionCobrador;
  LatLng? get posicionCobrador => _posicionCobrador;
  bool hasPosicionCobrador() => _posicionCobrador != null;

  // "ReferenciaCobrador" field.
  DocumentReference? _referenciaCobrador;
  DocumentReference? get referenciaCobrador => _referenciaCobrador;
  bool hasReferenciaCobrador() => _referenciaCobrador != null;

  // "IdCobrador" field.
  String? _idCobrador;
  String get idCobrador => _idCobrador ?? '';
  bool hasIdCobrador() => _idCobrador != null;

  // "NombreCobrador" field.
  String? _nombreCobrador;
  String get nombreCobrador => _nombreCobrador ?? '';
  bool hasNombreCobrador() => _nombreCobrador != null;

  // "NombreComercio" field.
  String? _nombreComercio;
  String get nombreComercio => _nombreComercio ?? '';
  bool hasNombreComercio() => _nombreComercio != null;

  void _initializeFields() {
    _comercio = snapshotData['Comercio'] as DocumentReference?;
    _time = snapshotData['Time'] as DateTime?;
    _pago = castToType<double>(snapshotData['Pago']);
    _posicionCobrador = snapshotData['PosicionCobrador'] as LatLng?;
    _referenciaCobrador =
        snapshotData['ReferenciaCobrador'] as DocumentReference?;
    _idCobrador = snapshotData['IdCobrador'] as String?;
    _nombreCobrador = snapshotData['NombreCobrador'] as String?;
    _nombreComercio = snapshotData['NombreComercio'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('PagosQR');

  static Stream<PagosQRRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PagosQRRecord.fromSnapshot(s));

  static Future<PagosQRRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PagosQRRecord.fromSnapshot(s));

  static PagosQRRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PagosQRRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PagosQRRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PagosQRRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PagosQRRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PagosQRRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPagosQRRecordData({
  DocumentReference? comercio,
  DateTime? time,
  double? pago,
  LatLng? posicionCobrador,
  DocumentReference? referenciaCobrador,
  String? idCobrador,
  String? nombreCobrador,
  String? nombreComercio,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Comercio': comercio,
      'Time': time,
      'Pago': pago,
      'PosicionCobrador': posicionCobrador,
      'ReferenciaCobrador': referenciaCobrador,
      'IdCobrador': idCobrador,
      'NombreCobrador': nombreCobrador,
      'NombreComercio': nombreComercio,
    }.withoutNulls,
  );

  return firestoreData;
}

class PagosQRRecordDocumentEquality implements Equality<PagosQRRecord> {
  const PagosQRRecordDocumentEquality();

  @override
  bool equals(PagosQRRecord? e1, PagosQRRecord? e2) {
    return e1?.comercio == e2?.comercio &&
        e1?.time == e2?.time &&
        e1?.pago == e2?.pago &&
        e1?.posicionCobrador == e2?.posicionCobrador &&
        e1?.referenciaCobrador == e2?.referenciaCobrador &&
        e1?.idCobrador == e2?.idCobrador &&
        e1?.nombreCobrador == e2?.nombreCobrador &&
        e1?.nombreComercio == e2?.nombreComercio;
  }

  @override
  int hash(PagosQRRecord? e) => const ListEquality().hash([
        e?.comercio,
        e?.time,
        e?.pago,
        e?.posicionCobrador,
        e?.referenciaCobrador,
        e?.idCobrador,
        e?.nombreCobrador,
        e?.nombreComercio
      ]);

  @override
  bool isValidKey(Object? o) => o is PagosQRRecord;
}
