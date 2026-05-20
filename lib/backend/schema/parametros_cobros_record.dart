import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ParametrosCobrosRecord extends FirestoreRecord {
  ParametrosCobrosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "PrecioUMA" field.
  double? _precioUMA;
  double get precioUMA => _precioUMA ?? 0.0;
  bool hasPrecioUMA() => _precioUMA != null;

  // "FechaModificacion" field.
  DateTime? _fechaModificacion;
  DateTime? get fechaModificacion => _fechaModificacion;
  bool hasFechaModificacion() => _fechaModificacion != null;

  // "UsuarioModificacion" field.
  DocumentReference? _usuarioModificacion;
  DocumentReference? get usuarioModificacion => _usuarioModificacion;
  bool hasUsuarioModificacion() => _usuarioModificacion != null;

  // "Nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  bool hasNombre() => _nombre != null;

  // "AnioUMA" field.
  int? _anioUMA;
  int get anioUMA => _anioUMA ?? 0;
  bool hasAnioUMA() => _anioUMA != null;

  // "PrecioM2" field.
  double? _precioM2;
  double get precioM2 => _precioM2 ?? 0.0;
  bool hasPrecioM2() => _precioM2 != null;

  // "UMASDiario" field.
  double? _uMASDiario;
  double get uMASDiario => _uMASDiario ?? 0.0;
  bool hasUMASDiario() => _uMASDiario != null;

  // "UMASSemana" field.
  double? _uMASSemana;
  double get uMASSemana => _uMASSemana ?? 0.0;
  bool hasUMASSemana() => _uMASSemana != null;

  // "UMASQuincena" field.
  double? _uMASQuincena;
  double get uMASQuincena => _uMASQuincena ?? 0.0;
  bool hasUMASQuincena() => _uMASQuincena != null;

  // "UMASMes" field.
  double? _uMASMes;
  double get uMASMes => _uMASMes ?? 0.0;
  bool hasUMASMes() => _uMASMes != null;

  // "UMASBimestre" field.
  double? _uMASBimestre;
  double get uMASBimestre => _uMASBimestre ?? 0.0;
  bool hasUMASBimestre() => _uMASBimestre != null;

  // "UMASTrimestre" field.
  double? _uMASTrimestre;
  double get uMASTrimestre => _uMASTrimestre ?? 0.0;
  bool hasUMASTrimestre() => _uMASTrimestre != null;

  // "UMASSemestre" field.
  double? _uMASSemestre;
  double get uMASSemestre => _uMASSemestre ?? 0.0;
  bool hasUMASSemestre() => _uMASSemestre != null;

  // "UMASAnual" field.
  double? _uMASAnual;
  double get uMASAnual => _uMASAnual ?? 0.0;
  bool hasUMASAnual() => _uMASAnual != null;

  void _initializeFields() {
    _precioUMA = castToType<double>(snapshotData['PrecioUMA']);
    _fechaModificacion = snapshotData['FechaModificacion'] as DateTime?;
    _usuarioModificacion =
        snapshotData['UsuarioModificacion'] as DocumentReference?;
    _nombre = snapshotData['Nombre'] as String?;
    _anioUMA = castToType<int>(snapshotData['AnioUMA']);
    _precioM2 = castToType<double>(snapshotData['PrecioM2']);
    _uMASDiario = castToType<double>(snapshotData['UMASDiario']);
    _uMASSemana = castToType<double>(snapshotData['UMASSemana']);
    _uMASQuincena = castToType<double>(snapshotData['UMASQuincena']);
    _uMASMes = castToType<double>(snapshotData['UMASMes']);
    _uMASBimestre = castToType<double>(snapshotData['UMASBimestre']);
    _uMASTrimestre = castToType<double>(snapshotData['UMASTrimestre']);
    _uMASSemestre = castToType<double>(snapshotData['UMASSemestre']);
    _uMASAnual = castToType<double>(snapshotData['UMASAnual']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('ParametrosCobros');

  static Stream<ParametrosCobrosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ParametrosCobrosRecord.fromSnapshot(s));

  static Future<ParametrosCobrosRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ParametrosCobrosRecord.fromSnapshot(s));

  static ParametrosCobrosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ParametrosCobrosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ParametrosCobrosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ParametrosCobrosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ParametrosCobrosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ParametrosCobrosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createParametrosCobrosRecordData({
  double? precioUMA,
  DateTime? fechaModificacion,
  DocumentReference? usuarioModificacion,
  String? nombre,
  int? anioUMA,
  double? precioM2,
  double? uMASDiario,
  double? uMASSemana,
  double? uMASQuincena,
  double? uMASMes,
  double? uMASBimestre,
  double? uMASTrimestre,
  double? uMASSemestre,
  double? uMASAnual,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'PrecioUMA': precioUMA,
      'FechaModificacion': fechaModificacion,
      'UsuarioModificacion': usuarioModificacion,
      'Nombre': nombre,
      'AnioUMA': anioUMA,
      'PrecioM2': precioM2,
      'UMASDiario': uMASDiario,
      'UMASSemana': uMASSemana,
      'UMASQuincena': uMASQuincena,
      'UMASMes': uMASMes,
      'UMASBimestre': uMASBimestre,
      'UMASTrimestre': uMASTrimestre,
      'UMASSemestre': uMASSemestre,
      'UMASAnual': uMASAnual,
    }.withoutNulls,
  );

  return firestoreData;
}

class ParametrosCobrosRecordDocumentEquality
    implements Equality<ParametrosCobrosRecord> {
  const ParametrosCobrosRecordDocumentEquality();

  @override
  bool equals(ParametrosCobrosRecord? e1, ParametrosCobrosRecord? e2) {
    return e1?.precioUMA == e2?.precioUMA &&
        e1?.fechaModificacion == e2?.fechaModificacion &&
        e1?.usuarioModificacion == e2?.usuarioModificacion &&
        e1?.nombre == e2?.nombre &&
        e1?.anioUMA == e2?.anioUMA &&
        e1?.precioM2 == e2?.precioM2 &&
        e1?.uMASDiario == e2?.uMASDiario &&
        e1?.uMASSemana == e2?.uMASSemana &&
        e1?.uMASQuincena == e2?.uMASQuincena &&
        e1?.uMASMes == e2?.uMASMes &&
        e1?.uMASBimestre == e2?.uMASBimestre &&
        e1?.uMASTrimestre == e2?.uMASTrimestre &&
        e1?.uMASSemestre == e2?.uMASSemestre &&
        e1?.uMASAnual == e2?.uMASAnual;
  }

  @override
  int hash(ParametrosCobrosRecord? e) => const ListEquality().hash([
        e?.precioUMA,
        e?.fechaModificacion,
        e?.usuarioModificacion,
        e?.nombre,
        e?.anioUMA,
        e?.precioM2,
        e?.uMASDiario,
        e?.uMASSemana,
        e?.uMASQuincena,
        e?.uMASMes,
        e?.uMASBimestre,
        e?.uMASTrimestre,
        e?.uMASSemestre,
        e?.uMASAnual
      ]);

  @override
  bool isValidKey(Object? o) => o is ParametrosCobrosRecord;
}
