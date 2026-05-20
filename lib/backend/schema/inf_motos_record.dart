import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InfMotosRecord extends FirestoreRecord {
  InfMotosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "Title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "Description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "Articuls" field.
  String? _articuls;
  String get articuls => _articuls ?? '';
  bool hasArticuls() => _articuls != null;

  // "Clave" field.
  int? _clave;
  int get clave => _clave ?? 0;
  bool hasClave() => _clave != null;

  // "TipoMulta" field.
  String? _tipoMulta;
  String get tipoMulta => _tipoMulta ?? '';
  bool hasTipoMulta() => _tipoMulta != null;

  // "TipoVehiculo" field.
  String? _tipoVehiculo;
  String get tipoVehiculo => _tipoVehiculo ?? '';
  bool hasTipoVehiculo() => _tipoVehiculo != null;

  // "UMAS" field.
  double? _umas;
  double get umas => _umas ?? 0.0;
  bool hasUmas() => _umas != null;

  void _initializeFields() {
    _date = snapshotData['Date'] as DateTime?;
    _title = snapshotData['Title'] as String?;
    _description = snapshotData['Description'] as String?;
    _articuls = snapshotData['Articuls'] as String?;
    _clave = castToType<int>(snapshotData['Clave']);
    _tipoMulta = snapshotData['TipoMulta'] as String?;
    _tipoVehiculo = snapshotData['TipoVehiculo'] as String?;
    _umas = castToType<double>(snapshotData['UMAS']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('InfMotos');

  static Stream<InfMotosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => InfMotosRecord.fromSnapshot(s));

  static Future<InfMotosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => InfMotosRecord.fromSnapshot(s));

  static InfMotosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      InfMotosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static InfMotosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      InfMotosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'InfMotosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is InfMotosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createInfMotosRecordData({
  DateTime? date,
  String? title,
  String? description,
  String? articuls,
  int? clave,
  String? tipoMulta,
  String? tipoVehiculo,
  double? umas,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Date': date,
      'Title': title,
      'Description': description,
      'Articuls': articuls,
      'Clave': clave,
      'TipoMulta': tipoMulta,
      'TipoVehiculo': tipoVehiculo,
      'UMAS': umas,
    }.withoutNulls,
  );

  return firestoreData;
}

class InfMotosRecordDocumentEquality implements Equality<InfMotosRecord> {
  const InfMotosRecordDocumentEquality();

  @override
  bool equals(InfMotosRecord? e1, InfMotosRecord? e2) {
    return e1?.date == e2?.date &&
        e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        e1?.articuls == e2?.articuls &&
        e1?.clave == e2?.clave &&
        e1?.tipoMulta == e2?.tipoMulta &&
        e1?.tipoVehiculo == e2?.tipoVehiculo &&
        e1?.umas == e2?.umas;
  }

  @override
  int hash(InfMotosRecord? e) => const ListEquality().hash([
        e?.date,
        e?.title,
        e?.description,
        e?.articuls,
        e?.clave,
        e?.tipoMulta,
        e?.tipoVehiculo,
        e?.umas
      ]);

  @override
  bool isValidKey(Object? o) => o is InfMotosRecord;
}
