import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListasPJEVRecord extends FirestoreRecord {
  ListasPJEVRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Tipodelista" field.
  String? _tipodelista;
  String get tipodelista => _tipodelista ?? '';
  bool hasTipodelista() => _tipodelista != null;

  // "nombredeelemento" field.
  String? _nombredeelemento;
  String get nombredeelemento => _nombredeelemento ?? '';
  bool hasNombredeelemento() => _nombredeelemento != null;

  // "fechacreacion" field.
  DateTime? _fechacreacion;
  DateTime? get fechacreacion => _fechacreacion;
  bool hasFechacreacion() => _fechacreacion != null;

  // "fechamodificacion" field.
  DateTime? _fechamodificacion;
  DateTime? get fechamodificacion => _fechamodificacion;
  bool hasFechamodificacion() => _fechamodificacion != null;

  // "campo1" field.
  String? _campo1;
  String get campo1 => _campo1 ?? '';
  bool hasCampo1() => _campo1 != null;

  // "campo2" field.
  String? _campo2;
  String get campo2 => _campo2 ?? '';
  bool hasCampo2() => _campo2 != null;

  // "campo3" field.
  String? _campo3;
  String get campo3 => _campo3 ?? '';
  bool hasCampo3() => _campo3 != null;

  // "identificador" field.
  String? _identificador;
  String get identificador => _identificador ?? '';
  bool hasIdentificador() => _identificador != null;

  void _initializeFields() {
    _tipodelista = snapshotData['Tipodelista'] as String?;
    _nombredeelemento = snapshotData['nombredeelemento'] as String?;
    _fechacreacion = snapshotData['fechacreacion'] as DateTime?;
    _fechamodificacion = snapshotData['fechamodificacion'] as DateTime?;
    _campo1 = snapshotData['campo1'] as String?;
    _campo2 = snapshotData['campo2'] as String?;
    _campo3 = snapshotData['campo3'] as String?;
    _identificador = snapshotData['identificador'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('ListasPJEV');

  static Stream<ListasPJEVRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ListasPJEVRecord.fromSnapshot(s));

  static Future<ListasPJEVRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ListasPJEVRecord.fromSnapshot(s));

  static ListasPJEVRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ListasPJEVRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ListasPJEVRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ListasPJEVRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ListasPJEVRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ListasPJEVRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createListasPJEVRecordData({
  String? tipodelista,
  String? nombredeelemento,
  DateTime? fechacreacion,
  DateTime? fechamodificacion,
  String? campo1,
  String? campo2,
  String? campo3,
  String? identificador,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Tipodelista': tipodelista,
      'nombredeelemento': nombredeelemento,
      'fechacreacion': fechacreacion,
      'fechamodificacion': fechamodificacion,
      'campo1': campo1,
      'campo2': campo2,
      'campo3': campo3,
      'identificador': identificador,
    }.withoutNulls,
  );

  return firestoreData;
}

class ListasPJEVRecordDocumentEquality implements Equality<ListasPJEVRecord> {
  const ListasPJEVRecordDocumentEquality();

  @override
  bool equals(ListasPJEVRecord? e1, ListasPJEVRecord? e2) {
    return e1?.tipodelista == e2?.tipodelista &&
        e1?.nombredeelemento == e2?.nombredeelemento &&
        e1?.fechacreacion == e2?.fechacreacion &&
        e1?.fechamodificacion == e2?.fechamodificacion &&
        e1?.campo1 == e2?.campo1 &&
        e1?.campo2 == e2?.campo2 &&
        e1?.campo3 == e2?.campo3 &&
        e1?.identificador == e2?.identificador;
  }

  @override
  int hash(ListasPJEVRecord? e) => const ListEquality().hash([
        e?.tipodelista,
        e?.nombredeelemento,
        e?.fechacreacion,
        e?.fechamodificacion,
        e?.campo1,
        e?.campo2,
        e?.campo3,
        e?.identificador
      ]);

  @override
  bool isValidKey(Object? o) => o is ListasPJEVRecord;
}
