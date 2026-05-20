import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Vales2Record extends FirestoreRecord {
  Vales2Record._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "tipovale" field.
  String? _tipovale;
  String get tipovale => _tipovale ?? '';
  bool hasTipovale() => _tipovale != null;

  // "idbien" field.
  String? _idbien;
  String get idbien => _idbien ?? '';
  bool hasIdbien() => _idbien != null;

  // "fecha" field.
  DateTime? _fecha;
  DateTime? get fecha => _fecha;
  bool hasFecha() => _fecha != null;

  // "foliovale" field.
  String? _foliovale;
  String get foliovale => _foliovale ?? '';
  bool hasFoliovale() => _foliovale != null;

  // "nombresolicitante" field.
  String? _nombresolicitante;
  String get nombresolicitante => _nombresolicitante ?? '';
  bool hasNombresolicitante() => _nombresolicitante != null;

  // "quienrealizamovimiento" field.
  String? _quienrealizamovimiento;
  String get quienrealizamovimiento => _quienrealizamovimiento ?? '';
  bool hasQuienrealizamovimiento() => _quienrealizamovimiento != null;

  // "depositario" field.
  String? _depositario;
  String get depositario => _depositario ?? '';
  bool hasDepositario() => _depositario != null;

  // "usuario" field.
  String? _usuario;
  String get usuario => _usuario ?? '';
  bool hasUsuario() => _usuario != null;

  // "nivel1" field.
  String? _nivel1;
  String get nivel1 => _nivel1 ?? '';
  bool hasNivel1() => _nivel1 != null;

  // "nivel2" field.
  String? _nivel2;
  String get nivel2 => _nivel2 ?? '';
  bool hasNivel2() => _nivel2 != null;

  // "nivel3" field.
  String? _nivel3;
  String get nivel3 => _nivel3 ?? '';
  bool hasNivel3() => _nivel3 != null;

  // "ubicacionfisica" field.
  String? _ubicacionfisica;
  String get ubicacionfisica => _ubicacionfisica ?? '';
  bool hasUbicacionfisica() => _ubicacionfisica != null;

  // "estado" field.
  String? _estado;
  String get estado => _estado ?? '';
  bool hasEstado() => _estado != null;

  // "pendientebodega" field.
  String? _pendientebodega;
  String get pendientebodega => _pendientebodega ?? '';
  bool hasPendientebodega() => _pendientebodega != null;

  void _initializeFields() {
    _tipovale = snapshotData['tipovale'] as String?;
    _idbien = snapshotData['idbien'] as String?;
    _fecha = snapshotData['fecha'] as DateTime?;
    _foliovale = snapshotData['foliovale'] as String?;
    _nombresolicitante = snapshotData['nombresolicitante'] as String?;
    _quienrealizamovimiento = snapshotData['quienrealizamovimiento'] as String?;
    _depositario = snapshotData['depositario'] as String?;
    _usuario = snapshotData['usuario'] as String?;
    _nivel1 = snapshotData['nivel1'] as String?;
    _nivel2 = snapshotData['nivel2'] as String?;
    _nivel3 = snapshotData['nivel3'] as String?;
    _ubicacionfisica = snapshotData['ubicacionfisica'] as String?;
    _estado = snapshotData['estado'] as String?;
    _pendientebodega = snapshotData['pendientebodega'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('vales2');

  static Stream<Vales2Record> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => Vales2Record.fromSnapshot(s));

  static Future<Vales2Record> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => Vales2Record.fromSnapshot(s));

  static Vales2Record fromSnapshot(DocumentSnapshot snapshot) => Vales2Record._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static Vales2Record getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      Vales2Record._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'Vales2Record(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is Vales2Record &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVales2RecordData({
  String? tipovale,
  String? idbien,
  DateTime? fecha,
  String? foliovale,
  String? nombresolicitante,
  String? quienrealizamovimiento,
  String? depositario,
  String? usuario,
  String? nivel1,
  String? nivel2,
  String? nivel3,
  String? ubicacionfisica,
  String? estado,
  String? pendientebodega,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'tipovale': tipovale,
      'idbien': idbien,
      'fecha': fecha,
      'foliovale': foliovale,
      'nombresolicitante': nombresolicitante,
      'quienrealizamovimiento': quienrealizamovimiento,
      'depositario': depositario,
      'usuario': usuario,
      'nivel1': nivel1,
      'nivel2': nivel2,
      'nivel3': nivel3,
      'ubicacionfisica': ubicacionfisica,
      'estado': estado,
      'pendientebodega': pendientebodega,
    }.withoutNulls,
  );

  return firestoreData;
}

class Vales2RecordDocumentEquality implements Equality<Vales2Record> {
  const Vales2RecordDocumentEquality();

  @override
  bool equals(Vales2Record? e1, Vales2Record? e2) {
    return e1?.tipovale == e2?.tipovale &&
        e1?.idbien == e2?.idbien &&
        e1?.fecha == e2?.fecha &&
        e1?.foliovale == e2?.foliovale &&
        e1?.nombresolicitante == e2?.nombresolicitante &&
        e1?.quienrealizamovimiento == e2?.quienrealizamovimiento &&
        e1?.depositario == e2?.depositario &&
        e1?.usuario == e2?.usuario &&
        e1?.nivel1 == e2?.nivel1 &&
        e1?.nivel2 == e2?.nivel2 &&
        e1?.nivel3 == e2?.nivel3 &&
        e1?.ubicacionfisica == e2?.ubicacionfisica &&
        e1?.estado == e2?.estado &&
        e1?.pendientebodega == e2?.pendientebodega;
  }

  @override
  int hash(Vales2Record? e) => const ListEquality().hash([
        e?.tipovale,
        e?.idbien,
        e?.fecha,
        e?.foliovale,
        e?.nombresolicitante,
        e?.quienrealizamovimiento,
        e?.depositario,
        e?.usuario,
        e?.nivel1,
        e?.nivel2,
        e?.nivel3,
        e?.ubicacionfisica,
        e?.estado,
        e?.pendientebodega
      ]);

  @override
  bool isValidKey(Object? o) => o is Vales2Record;
}
