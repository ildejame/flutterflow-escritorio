import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReciboAgenteMunicipalRecord extends FirestoreRecord {
  ReciboAgenteMunicipalRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "NombreAgenteMunicipal" field.
  String? _nombreAgenteMunicipal;
  String get nombreAgenteMunicipal => _nombreAgenteMunicipal ?? '';
  bool hasNombreAgenteMunicipal() => _nombreAgenteMunicipal != null;

  // "IDAgenteMunicipal" field.
  String? _iDAgenteMunicipal;
  String get iDAgenteMunicipal => _iDAgenteMunicipal ?? '';
  bool hasIDAgenteMunicipal() => _iDAgenteMunicipal != null;

  // "DocumentoReferencia" field.
  DocumentReference? _documentoReferencia;
  DocumentReference? get documentoReferencia => _documentoReferencia;
  bool hasDocumentoReferencia() => _documentoReferencia != null;

  // "Fecha" field.
  DateTime? _fecha;
  DateTime? get fecha => _fecha;
  bool hasFecha() => _fecha != null;

  // "PagoAgenteAlMunicipio" field.
  double? _pagoAgenteAlMunicipio;
  double get pagoAgenteAlMunicipio => _pagoAgenteAlMunicipio ?? 0.0;
  bool hasPagoAgenteAlMunicipio() => _pagoAgenteAlMunicipio != null;

  // "Tipo" field.
  String? _tipo;
  String get tipo => _tipo ?? '';
  bool hasTipo() => _tipo != null;

  // "SoloFecha" field.
  String? _soloFecha;
  String get soloFecha => _soloFecha ?? '';
  bool hasSoloFecha() => _soloFecha != null;

  void _initializeFields() {
    _nombreAgenteMunicipal = snapshotData['NombreAgenteMunicipal'] as String?;
    _iDAgenteMunicipal = snapshotData['IDAgenteMunicipal'] as String?;
    _documentoReferencia =
        snapshotData['DocumentoReferencia'] as DocumentReference?;
    _fecha = snapshotData['Fecha'] as DateTime?;
    _pagoAgenteAlMunicipio =
        castToType<double>(snapshotData['PagoAgenteAlMunicipio']);
    _tipo = snapshotData['Tipo'] as String?;
    _soloFecha = snapshotData['SoloFecha'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('ReciboAgenteMunicipal');

  static Stream<ReciboAgenteMunicipalRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => ReciboAgenteMunicipalRecord.fromSnapshot(s));

  static Future<ReciboAgenteMunicipalRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ReciboAgenteMunicipalRecord.fromSnapshot(s));

  static ReciboAgenteMunicipalRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ReciboAgenteMunicipalRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ReciboAgenteMunicipalRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReciboAgenteMunicipalRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ReciboAgenteMunicipalRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ReciboAgenteMunicipalRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createReciboAgenteMunicipalRecordData({
  String? nombreAgenteMunicipal,
  String? iDAgenteMunicipal,
  DocumentReference? documentoReferencia,
  DateTime? fecha,
  double? pagoAgenteAlMunicipio,
  String? tipo,
  String? soloFecha,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'NombreAgenteMunicipal': nombreAgenteMunicipal,
      'IDAgenteMunicipal': iDAgenteMunicipal,
      'DocumentoReferencia': documentoReferencia,
      'Fecha': fecha,
      'PagoAgenteAlMunicipio': pagoAgenteAlMunicipio,
      'Tipo': tipo,
      'SoloFecha': soloFecha,
    }.withoutNulls,
  );

  return firestoreData;
}

class ReciboAgenteMunicipalRecordDocumentEquality
    implements Equality<ReciboAgenteMunicipalRecord> {
  const ReciboAgenteMunicipalRecordDocumentEquality();

  @override
  bool equals(
      ReciboAgenteMunicipalRecord? e1, ReciboAgenteMunicipalRecord? e2) {
    return e1?.nombreAgenteMunicipal == e2?.nombreAgenteMunicipal &&
        e1?.iDAgenteMunicipal == e2?.iDAgenteMunicipal &&
        e1?.documentoReferencia == e2?.documentoReferencia &&
        e1?.fecha == e2?.fecha &&
        e1?.pagoAgenteAlMunicipio == e2?.pagoAgenteAlMunicipio &&
        e1?.tipo == e2?.tipo &&
        e1?.soloFecha == e2?.soloFecha;
  }

  @override
  int hash(ReciboAgenteMunicipalRecord? e) => const ListEquality().hash([
        e?.nombreAgenteMunicipal,
        e?.iDAgenteMunicipal,
        e?.documentoReferencia,
        e?.fecha,
        e?.pagoAgenteAlMunicipio,
        e?.tipo,
        e?.soloFecha
      ]);

  @override
  bool isValidKey(Object? o) => o is ReciboAgenteMunicipalRecord;
}
