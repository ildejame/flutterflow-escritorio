import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PagosAnualesRecord extends FirestoreRecord {
  PagosAnualesRecord._(
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

  // "SoloFechaAnual" field.
  String? _soloFechaAnual;
  String get soloFechaAnual => _soloFechaAnual ?? '';
  bool hasSoloFechaAnual() => _soloFechaAnual != null;

  // "QRAnualTicket" field.
  String? _qRAnualTicket;
  String get qRAnualTicket => _qRAnualTicket ?? '';
  bool hasQRAnualTicket() => _qRAnualTicket != null;

  void _initializeFields() {
    _comercioRef = snapshotData['ComercioRef'] as DocumentReference?;
    _fecha = snapshotData['Fecha'] as DateTime?;
    _cobrador = snapshotData['Cobrador'] as DocumentReference?;
    _iDCobrador = snapshotData['IDCobrador'] as String?;
    _cantidad = castToType<double>(snapshotData['Cantidad']);
    _contador = castToType<int>(snapshotData['Contador']);
    _nombreCobrador = snapshotData['NombreCobrador'] as String?;
    _soloFechaAnual = snapshotData['SoloFechaAnual'] as String?;
    _qRAnualTicket = snapshotData['QRAnualTicket'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('PagosAnuales');

  static Stream<PagosAnualesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PagosAnualesRecord.fromSnapshot(s));

  static Future<PagosAnualesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PagosAnualesRecord.fromSnapshot(s));

  static PagosAnualesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PagosAnualesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PagosAnualesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PagosAnualesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PagosAnualesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PagosAnualesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPagosAnualesRecordData({
  DocumentReference? comercioRef,
  DateTime? fecha,
  DocumentReference? cobrador,
  String? iDCobrador,
  double? cantidad,
  int? contador,
  String? nombreCobrador,
  String? soloFechaAnual,
  String? qRAnualTicket,
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
      'SoloFechaAnual': soloFechaAnual,
      'QRAnualTicket': qRAnualTicket,
    }.withoutNulls,
  );

  return firestoreData;
}

class PagosAnualesRecordDocumentEquality
    implements Equality<PagosAnualesRecord> {
  const PagosAnualesRecordDocumentEquality();

  @override
  bool equals(PagosAnualesRecord? e1, PagosAnualesRecord? e2) {
    return e1?.comercioRef == e2?.comercioRef &&
        e1?.fecha == e2?.fecha &&
        e1?.cobrador == e2?.cobrador &&
        e1?.iDCobrador == e2?.iDCobrador &&
        e1?.cantidad == e2?.cantidad &&
        e1?.contador == e2?.contador &&
        e1?.nombreCobrador == e2?.nombreCobrador &&
        e1?.soloFechaAnual == e2?.soloFechaAnual &&
        e1?.qRAnualTicket == e2?.qRAnualTicket;
  }

  @override
  int hash(PagosAnualesRecord? e) => const ListEquality().hash([
        e?.comercioRef,
        e?.fecha,
        e?.cobrador,
        e?.iDCobrador,
        e?.cantidad,
        e?.contador,
        e?.nombreCobrador,
        e?.soloFechaAnual,
        e?.qRAnualTicket
      ]);

  @override
  bool isValidKey(Object? o) => o is PagosAnualesRecord;
}
