import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DocumentosScannerRecord extends FirestoreRecord {
  DocumentosScannerRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "fecha" field.
  DateTime? _fecha;
  DateTime? get fecha => _fecha;
  bool hasFecha() => _fecha != null;

  // "quien_comenta" field.
  String? _quienComenta;
  String get quienComenta => _quienComenta ?? '';
  bool hasQuienComenta() => _quienComenta != null;

  // "id_quien_reporta" field.
  DocumentReference? _idQuienReporta;
  DocumentReference? get idQuienReporta => _idQuienReporta;
  bool hasIdQuienReporta() => _idQuienReporta != null;

  // "comercio" field.
  String? _comercio;
  String get comercio => _comercio ?? '';
  bool hasComercio() => _comercio != null;

  // "id_comercio" field.
  DocumentReference? _idComercio;
  DocumentReference? get idComercio => _idComercio;
  bool hasIdComercio() => _idComercio != null;

  // "comentario" field.
  String? _comentario;
  String get comentario => _comentario ?? '';
  bool hasComentario() => _comentario != null;

  // "imagen" field.
  String? _imagen;
  String get imagen => _imagen ?? '';
  bool hasImagen() => _imagen != null;

  // "pdf_escaneado" field.
  String? _pdfEscaneado;
  String get pdfEscaneado => _pdfEscaneado ?? '';
  bool hasPdfEscaneado() => _pdfEscaneado != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _fecha = snapshotData['fecha'] as DateTime?;
    _quienComenta = snapshotData['quien_comenta'] as String?;
    _idQuienReporta = snapshotData['id_quien_reporta'] as DocumentReference?;
    _comercio = snapshotData['comercio'] as String?;
    _idComercio = snapshotData['id_comercio'] as DocumentReference?;
    _comentario = snapshotData['comentario'] as String?;
    _imagen = snapshotData['imagen'] as String?;
    _pdfEscaneado = snapshotData['pdf_escaneado'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('DocumentosScanner')
          : FirebaseFirestore.instance.collectionGroup('DocumentosScanner');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('DocumentosScanner').doc(id);

  static Stream<DocumentosScannerRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DocumentosScannerRecord.fromSnapshot(s));

  static Future<DocumentosScannerRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => DocumentosScannerRecord.fromSnapshot(s));

  static DocumentosScannerRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DocumentosScannerRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DocumentosScannerRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DocumentosScannerRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DocumentosScannerRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DocumentosScannerRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDocumentosScannerRecordData({
  DateTime? fecha,
  String? quienComenta,
  DocumentReference? idQuienReporta,
  String? comercio,
  DocumentReference? idComercio,
  String? comentario,
  String? imagen,
  String? pdfEscaneado,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'fecha': fecha,
      'quien_comenta': quienComenta,
      'id_quien_reporta': idQuienReporta,
      'comercio': comercio,
      'id_comercio': idComercio,
      'comentario': comentario,
      'imagen': imagen,
      'pdf_escaneado': pdfEscaneado,
    }.withoutNulls,
  );

  return firestoreData;
}

class DocumentosScannerRecordDocumentEquality
    implements Equality<DocumentosScannerRecord> {
  const DocumentosScannerRecordDocumentEquality();

  @override
  bool equals(DocumentosScannerRecord? e1, DocumentosScannerRecord? e2) {
    return e1?.fecha == e2?.fecha &&
        e1?.quienComenta == e2?.quienComenta &&
        e1?.idQuienReporta == e2?.idQuienReporta &&
        e1?.comercio == e2?.comercio &&
        e1?.idComercio == e2?.idComercio &&
        e1?.comentario == e2?.comentario &&
        e1?.imagen == e2?.imagen &&
        e1?.pdfEscaneado == e2?.pdfEscaneado;
  }

  @override
  int hash(DocumentosScannerRecord? e) => const ListEquality().hash([
        e?.fecha,
        e?.quienComenta,
        e?.idQuienReporta,
        e?.comercio,
        e?.idComercio,
        e?.comentario,
        e?.imagen,
        e?.pdfEscaneado
      ]);

  @override
  bool isValidKey(Object? o) => o is DocumentosScannerRecord;
}
