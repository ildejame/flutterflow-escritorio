import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BitacoraRecord extends FirestoreRecord {
  BitacoraRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nombrebitacora" field.
  String? _nombrebitacora;
  String get nombrebitacora => _nombrebitacora ?? '';
  bool hasNombrebitacora() => _nombrebitacora != null;

  // "fechabitacora" field.
  DateTime? _fechabitacora;
  DateTime? get fechabitacora => _fechabitacora;
  bool hasFechabitacora() => _fechabitacora != null;

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  bool hasNombre() => _nombre != null;

  // "tipoaccion" field.
  String? _tipoaccion;
  String get tipoaccion => _tipoaccion ?? '';
  bool hasTipoaccion() => _tipoaccion != null;

  // "iddocumento" field.
  DocumentReference? _iddocumento;
  DocumentReference? get iddocumento => _iddocumento;
  bool hasIddocumento() => _iddocumento != null;

  // "idempleado" field.
  DocumentReference? _idempleado;
  DocumentReference? get idempleado => _idempleado;
  bool hasIdempleado() => _idempleado != null;

  // "miid" field.
  DocumentReference? _miid;
  DocumentReference? get miid => _miid;
  bool hasMiid() => _miid != null;

  // "nombre2" field.
  String? _nombre2;
  String get nombre2 => _nombre2 ?? '';
  bool hasNombre2() => _nombre2 != null;

  void _initializeFields() {
    _nombrebitacora = snapshotData['nombrebitacora'] as String?;
    _fechabitacora = snapshotData['fechabitacora'] as DateTime?;
    _nombre = snapshotData['nombre'] as String?;
    _tipoaccion = snapshotData['tipoaccion'] as String?;
    _iddocumento = snapshotData['iddocumento'] as DocumentReference?;
    _idempleado = snapshotData['idempleado'] as DocumentReference?;
    _miid = snapshotData['miid'] as DocumentReference?;
    _nombre2 = snapshotData['nombre2'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('bitacora');

  static Stream<BitacoraRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BitacoraRecord.fromSnapshot(s));

  static Future<BitacoraRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BitacoraRecord.fromSnapshot(s));

  static BitacoraRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BitacoraRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BitacoraRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BitacoraRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BitacoraRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BitacoraRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBitacoraRecordData({
  String? nombrebitacora,
  DateTime? fechabitacora,
  String? nombre,
  String? tipoaccion,
  DocumentReference? iddocumento,
  DocumentReference? idempleado,
  DocumentReference? miid,
  String? nombre2,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nombrebitacora': nombrebitacora,
      'fechabitacora': fechabitacora,
      'nombre': nombre,
      'tipoaccion': tipoaccion,
      'iddocumento': iddocumento,
      'idempleado': idempleado,
      'miid': miid,
      'nombre2': nombre2,
    }.withoutNulls,
  );

  return firestoreData;
}

class BitacoraRecordDocumentEquality implements Equality<BitacoraRecord> {
  const BitacoraRecordDocumentEquality();

  @override
  bool equals(BitacoraRecord? e1, BitacoraRecord? e2) {
    return e1?.nombrebitacora == e2?.nombrebitacora &&
        e1?.fechabitacora == e2?.fechabitacora &&
        e1?.nombre == e2?.nombre &&
        e1?.tipoaccion == e2?.tipoaccion &&
        e1?.iddocumento == e2?.iddocumento &&
        e1?.idempleado == e2?.idempleado &&
        e1?.miid == e2?.miid &&
        e1?.nombre2 == e2?.nombre2;
  }

  @override
  int hash(BitacoraRecord? e) => const ListEquality().hash([
        e?.nombrebitacora,
        e?.fechabitacora,
        e?.nombre,
        e?.tipoaccion,
        e?.iddocumento,
        e?.idempleado,
        e?.miid,
        e?.nombre2
      ]);

  @override
  bool isValidKey(Object? o) => o is BitacoraRecord;
}
