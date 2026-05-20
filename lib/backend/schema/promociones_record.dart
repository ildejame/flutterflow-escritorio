import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PromocionesRecord extends FirestoreRecord {
  PromocionesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "FechaCreacion" field.
  DateTime? _fechaCreacion;
  DateTime? get fechaCreacion => _fechaCreacion;
  bool hasFechaCreacion() => _fechaCreacion != null;

  // "FechaModificacion" field.
  DateTime? _fechaModificacion;
  DateTime? get fechaModificacion => _fechaModificacion;
  bool hasFechaModificacion() => _fechaModificacion != null;

  // "UsuarioModificacion" field.
  DocumentReference? _usuarioModificacion;
  DocumentReference? get usuarioModificacion => _usuarioModificacion;
  bool hasUsuarioModificacion() => _usuarioModificacion != null;

  // "Descripcion" field.
  String? _descripcion;
  String get descripcion => _descripcion ?? '';
  bool hasDescripcion() => _descripcion != null;

  // "PorcentajeDescuento" field.
  double? _porcentajeDescuento;
  double get porcentajeDescuento => _porcentajeDescuento ?? 0.0;
  bool hasPorcentajeDescuento() => _porcentajeDescuento != null;

  // "CantidadDescuentoPesos" field.
  double? _cantidadDescuentoPesos;
  double get cantidadDescuentoPesos => _cantidadDescuentoPesos ?? 0.0;
  bool hasCantidadDescuentoPesos() => _cantidadDescuentoPesos != null;

  // "Periodo" field.
  String? _periodo;
  String get periodo => _periodo ?? '';
  bool hasPeriodo() => _periodo != null;

  // "FechaInicioVigencia" field.
  DateTime? _fechaInicioVigencia;
  DateTime? get fechaInicioVigencia => _fechaInicioVigencia;
  bool hasFechaInicioVigencia() => _fechaInicioVigencia != null;

  // "FechaFinVigencia" field.
  DateTime? _fechaFinVigencia;
  DateTime? get fechaFinVigencia => _fechaFinVigencia;
  bool hasFechaFinVigencia() => _fechaFinVigencia != null;

  void _initializeFields() {
    _fechaCreacion = snapshotData['FechaCreacion'] as DateTime?;
    _fechaModificacion = snapshotData['FechaModificacion'] as DateTime?;
    _usuarioModificacion =
        snapshotData['UsuarioModificacion'] as DocumentReference?;
    _descripcion = snapshotData['Descripcion'] as String?;
    _porcentajeDescuento =
        castToType<double>(snapshotData['PorcentajeDescuento']);
    _cantidadDescuentoPesos =
        castToType<double>(snapshotData['CantidadDescuentoPesos']);
    _periodo = snapshotData['Periodo'] as String?;
    _fechaInicioVigencia = snapshotData['FechaInicioVigencia'] as DateTime?;
    _fechaFinVigencia = snapshotData['FechaFinVigencia'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Promociones');

  static Stream<PromocionesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PromocionesRecord.fromSnapshot(s));

  static Future<PromocionesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PromocionesRecord.fromSnapshot(s));

  static PromocionesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PromocionesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PromocionesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PromocionesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PromocionesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PromocionesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPromocionesRecordData({
  DateTime? fechaCreacion,
  DateTime? fechaModificacion,
  DocumentReference? usuarioModificacion,
  String? descripcion,
  double? porcentajeDescuento,
  double? cantidadDescuentoPesos,
  String? periodo,
  DateTime? fechaInicioVigencia,
  DateTime? fechaFinVigencia,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'FechaCreacion': fechaCreacion,
      'FechaModificacion': fechaModificacion,
      'UsuarioModificacion': usuarioModificacion,
      'Descripcion': descripcion,
      'PorcentajeDescuento': porcentajeDescuento,
      'CantidadDescuentoPesos': cantidadDescuentoPesos,
      'Periodo': periodo,
      'FechaInicioVigencia': fechaInicioVigencia,
      'FechaFinVigencia': fechaFinVigencia,
    }.withoutNulls,
  );

  return firestoreData;
}

class PromocionesRecordDocumentEquality implements Equality<PromocionesRecord> {
  const PromocionesRecordDocumentEquality();

  @override
  bool equals(PromocionesRecord? e1, PromocionesRecord? e2) {
    return e1?.fechaCreacion == e2?.fechaCreacion &&
        e1?.fechaModificacion == e2?.fechaModificacion &&
        e1?.usuarioModificacion == e2?.usuarioModificacion &&
        e1?.descripcion == e2?.descripcion &&
        e1?.porcentajeDescuento == e2?.porcentajeDescuento &&
        e1?.cantidadDescuentoPesos == e2?.cantidadDescuentoPesos &&
        e1?.periodo == e2?.periodo &&
        e1?.fechaInicioVigencia == e2?.fechaInicioVigencia &&
        e1?.fechaFinVigencia == e2?.fechaFinVigencia;
  }

  @override
  int hash(PromocionesRecord? e) => const ListEquality().hash([
        e?.fechaCreacion,
        e?.fechaModificacion,
        e?.usuarioModificacion,
        e?.descripcion,
        e?.porcentajeDescuento,
        e?.cantidadDescuentoPesos,
        e?.periodo,
        e?.fechaInicioVigencia,
        e?.fechaFinVigencia
      ]);

  @override
  bool isValidKey(Object? o) => o is PromocionesRecord;
}
