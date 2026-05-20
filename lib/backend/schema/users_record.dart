import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "usuario" field.
  String? _usuario;
  String get usuario => _usuario ?? '';
  bool hasUsuario() => _usuario != null;

  // "PermisoEditar" field.
  bool? _permisoEditar;
  bool get permisoEditar => _permisoEditar ?? false;
  bool hasPermisoEditar() => _permisoEditar != null;

  // "Foto" field.
  String? _foto;
  String get foto => _foto ?? '';
  bool hasFoto() => _foto != null;

  // "Firma" field.
  String? _firma;
  String get firma => _firma ?? '';
  bool hasFirma() => _firma != null;

  // "ClaveOficial" field.
  String? _claveOficial;
  String get claveOficial => _claveOficial ?? '';
  bool hasClaveOficial() => _claveOficial != null;

  // "WathsApp" field.
  int? _wathsApp;
  int get wathsApp => _wathsApp ?? 0;
  bool hasWathsApp() => _wathsApp != null;

  // "Administrador" field.
  String? _administrador;
  String get administrador => _administrador ?? '';
  bool hasAdministrador() => _administrador != null;

  // "AdminYN" field.
  bool? _adminYN;
  bool get adminYN => _adminYN ?? false;
  bool hasAdminYN() => _adminYN != null;

  // "responsable" field.
  String? _responsable;
  String get responsable => _responsable ?? '';
  bool hasResponsable() => _responsable != null;

  // "permiso" field.
  String? _permiso;
  String get permiso => _permiso ?? '';
  bool hasPermiso() => _permiso != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _usuario = snapshotData['usuario'] as String?;
    _permisoEditar = snapshotData['PermisoEditar'] as bool?;
    _foto = snapshotData['Foto'] as String?;
    _firma = snapshotData['Firma'] as String?;
    _claveOficial = snapshotData['ClaveOficial'] as String?;
    _wathsApp = castToType<int>(snapshotData['WathsApp']);
    _administrador = snapshotData['Administrador'] as String?;
    _adminYN = snapshotData['AdminYN'] as bool?;
    _responsable = snapshotData['responsable'] as String?;
    _permiso = snapshotData['permiso'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? usuario,
  bool? permisoEditar,
  String? foto,
  String? firma,
  String? claveOficial,
  int? wathsApp,
  String? administrador,
  bool? adminYN,
  String? responsable,
  String? permiso,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'usuario': usuario,
      'PermisoEditar': permisoEditar,
      'Foto': foto,
      'Firma': firma,
      'ClaveOficial': claveOficial,
      'WathsApp': wathsApp,
      'Administrador': administrador,
      'AdminYN': adminYN,
      'responsable': responsable,
      'permiso': permiso,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.usuario == e2?.usuario &&
        e1?.permisoEditar == e2?.permisoEditar &&
        e1?.foto == e2?.foto &&
        e1?.firma == e2?.firma &&
        e1?.claveOficial == e2?.claveOficial &&
        e1?.wathsApp == e2?.wathsApp &&
        e1?.administrador == e2?.administrador &&
        e1?.adminYN == e2?.adminYN &&
        e1?.responsable == e2?.responsable &&
        e1?.permiso == e2?.permiso;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.usuario,
        e?.permisoEditar,
        e?.foto,
        e?.firma,
        e?.claveOficial,
        e?.wathsApp,
        e?.administrador,
        e?.adminYN,
        e?.responsable,
        e?.permiso
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
