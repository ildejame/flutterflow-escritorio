import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CalificacionRecord extends FirestoreRecord {
  CalificacionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "LugarServicio" field.
  DocumentReference? _lugarServicio;
  DocumentReference? get lugarServicio => _lugarServicio;
  bool hasLugarServicio() => _lugarServicio != null;

  // "Calificacion" field.
  int? _calificacion;
  int get calificacion => _calificacion ?? 0;
  bool hasCalificacion() => _calificacion != null;

  // "comentario" field.
  String? _comentario;
  String get comentario => _comentario ?? '';
  bool hasComentario() => _comentario != null;

  // "UsuarioReporte" field.
  String? _usuarioReporte;
  String get usuarioReporte => _usuarioReporte ?? '';
  bool hasUsuarioReporte() => _usuarioReporte != null;

  // "Aprobado" field.
  bool? _aprobado;
  bool get aprobado => _aprobado ?? false;
  bool hasAprobado() => _aprobado != null;

  // "Fecha" field.
  DateTime? _fecha;
  DateTime? get fecha => _fecha;
  bool hasFecha() => _fecha != null;

  // "Ubicacion" field.
  LatLng? _ubicacion;
  LatLng? get ubicacion => _ubicacion;
  bool hasUbicacion() => _ubicacion != null;

  void _initializeFields() {
    _lugarServicio = snapshotData['LugarServicio'] as DocumentReference?;
    _calificacion = castToType<int>(snapshotData['Calificacion']);
    _comentario = snapshotData['comentario'] as String?;
    _usuarioReporte = snapshotData['UsuarioReporte'] as String?;
    _aprobado = snapshotData['Aprobado'] as bool?;
    _fecha = snapshotData['Fecha'] as DateTime?;
    _ubicacion = snapshotData['Ubicacion'] as LatLng?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Calificacion');

  static Stream<CalificacionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CalificacionRecord.fromSnapshot(s));

  static Future<CalificacionRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CalificacionRecord.fromSnapshot(s));

  static CalificacionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CalificacionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CalificacionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CalificacionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CalificacionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CalificacionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCalificacionRecordData({
  DocumentReference? lugarServicio,
  int? calificacion,
  String? comentario,
  String? usuarioReporte,
  bool? aprobado,
  DateTime? fecha,
  LatLng? ubicacion,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'LugarServicio': lugarServicio,
      'Calificacion': calificacion,
      'comentario': comentario,
      'UsuarioReporte': usuarioReporte,
      'Aprobado': aprobado,
      'Fecha': fecha,
      'Ubicacion': ubicacion,
    }.withoutNulls,
  );

  return firestoreData;
}

class CalificacionRecordDocumentEquality
    implements Equality<CalificacionRecord> {
  const CalificacionRecordDocumentEquality();

  @override
  bool equals(CalificacionRecord? e1, CalificacionRecord? e2) {
    return e1?.lugarServicio == e2?.lugarServicio &&
        e1?.calificacion == e2?.calificacion &&
        e1?.comentario == e2?.comentario &&
        e1?.usuarioReporte == e2?.usuarioReporte &&
        e1?.aprobado == e2?.aprobado &&
        e1?.fecha == e2?.fecha &&
        e1?.ubicacion == e2?.ubicacion;
  }

  @override
  int hash(CalificacionRecord? e) => const ListEquality().hash([
        e?.lugarServicio,
        e?.calificacion,
        e?.comentario,
        e?.usuarioReporte,
        e?.aprobado,
        e?.fecha,
        e?.ubicacion
      ]);

  @override
  bool isValidKey(Object? o) => o is CalificacionRecord;
}
