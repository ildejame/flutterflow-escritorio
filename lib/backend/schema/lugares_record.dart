import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LugaresRecord extends FirestoreRecord {
  LugaresRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "titulo" field.
  String? _titulo;
  String get titulo => _titulo ?? '';
  bool hasTitulo() => _titulo != null;

  // "descripcionlugar" field.
  String? _descripcionlugar;
  String get descripcionlugar => _descripcionlugar ?? '';
  bool hasDescripcionlugar() => _descripcionlugar != null;

  // "historiaslugar" field.
  String? _historiaslugar;
  String get historiaslugar => _historiaslugar ?? '';
  bool hasHistoriaslugar() => _historiaslugar != null;

  // "imagenes" field.
  List<String>? _imagenes;
  List<String> get imagenes => _imagenes ?? const [];
  bool hasImagenes() => _imagenes != null;

  // "esabuelitos" field.
  bool? _esabuelitos;
  bool get esabuelitos => _esabuelitos ?? false;
  bool hasEsabuelitos() => _esabuelitos != null;

  // "esninos" field.
  bool? _esninos;
  bool get esninos => _esninos ?? false;
  bool hasEsninos() => _esninos != null;

  // "portada" field.
  String? _portada;
  String get portada => _portada ?? '';
  bool hasPortada() => _portada != null;

  // "posLugar" field.
  LatLng? _posLugar;
  LatLng? get posLugar => _posLugar;
  bool hasPosLugar() => _posLugar != null;

  // "EsMascotas" field.
  bool? _esMascotas;
  bool get esMascotas => _esMascotas ?? false;
  bool hasEsMascotas() => _esMascotas != null;

  // "EsAdulyAdol" field.
  bool? _esAdulyAdol;
  bool get esAdulyAdol => _esAdulyAdol ?? false;
  bool hasEsAdulyAdol() => _esAdulyAdol != null;

  // "Telefono" field.
  int? _telefono;
  int get telefono => _telefono ?? 0;
  bool hasTelefono() => _telefono != null;

  // "WhatsApp" field.
  int? _whatsApp;
  int get whatsApp => _whatsApp ?? 0;
  bool hasWhatsApp() => _whatsApp != null;

  // "Facebook" field.
  String? _facebook;
  String get facebook => _facebook ?? '';
  bool hasFacebook() => _facebook != null;

  // "Ruta" field.
  String? _ruta;
  String get ruta => _ruta ?? '';
  bool hasRuta() => _ruta != null;

  // "sonido" field.
  String? _sonido;
  String get sonido => _sonido ?? '';
  bool hasSonido() => _sonido != null;

  // "TipoLugar" field.
  String? _tipoLugar;
  String get tipoLugar => _tipoLugar ?? '';
  bool hasTipoLugar() => _tipoLugar != null;

  // "FechaCreacion" field.
  DateTime? _fechaCreacion;
  DateTime? get fechaCreacion => _fechaCreacion;
  bool hasFechaCreacion() => _fechaCreacion != null;

  // "EnglishAudio" field.
  String? _englishAudio;
  String get englishAudio => _englishAudio ?? '';
  bool hasEnglishAudio() => _englishAudio != null;

  // "QuienSube" field.
  String? _quienSube;
  String get quienSube => _quienSube ?? '';
  bool hasQuienSube() => _quienSube != null;

  // "FechaModificacion" field.
  DateTime? _fechaModificacion;
  DateTime? get fechaModificacion => _fechaModificacion;
  bool hasFechaModificacion() => _fechaModificacion != null;

  // "URLYoutube" field.
  double? _uRLYoutube;
  double get uRLYoutube => _uRLYoutube ?? 0.0;
  bool hasURLYoutube() => _uRLYoutube != null;

  // "URLYT" field.
  String? _urlyt;
  String get urlyt => _urlyt ?? '';
  bool hasUrlyt() => _urlyt != null;

  // "Ranking" field.
  int? _ranking;
  int get ranking => _ranking ?? 0;
  bool hasRanking() => _ranking != null;

  // "URLYTString" field.
  String? _uRLYTString;
  String get uRLYTString => _uRLYTString ?? '';
  bool hasURLYTString() => _uRLYTString != null;

  void _initializeFields() {
    _titulo = snapshotData['titulo'] as String?;
    _descripcionlugar = snapshotData['descripcionlugar'] as String?;
    _historiaslugar = snapshotData['historiaslugar'] as String?;
    _imagenes = getDataList(snapshotData['imagenes']);
    _esabuelitos = snapshotData['esabuelitos'] as bool?;
    _esninos = snapshotData['esninos'] as bool?;
    _portada = snapshotData['portada'] as String?;
    _posLugar = snapshotData['posLugar'] as LatLng?;
    _esMascotas = snapshotData['EsMascotas'] as bool?;
    _esAdulyAdol = snapshotData['EsAdulyAdol'] as bool?;
    _telefono = castToType<int>(snapshotData['Telefono']);
    _whatsApp = castToType<int>(snapshotData['WhatsApp']);
    _facebook = snapshotData['Facebook'] as String?;
    _ruta = snapshotData['Ruta'] as String?;
    _sonido = snapshotData['sonido'] as String?;
    _tipoLugar = snapshotData['TipoLugar'] as String?;
    _fechaCreacion = snapshotData['FechaCreacion'] as DateTime?;
    _englishAudio = snapshotData['EnglishAudio'] as String?;
    _quienSube = snapshotData['QuienSube'] as String?;
    _fechaModificacion = snapshotData['FechaModificacion'] as DateTime?;
    _uRLYoutube = castToType<double>(snapshotData['URLYoutube']);
    _urlyt = snapshotData['URLYT'] as String?;
    _ranking = castToType<int>(snapshotData['Ranking']);
    _uRLYTString = snapshotData['URLYTString'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Lugares');

  static Stream<LugaresRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LugaresRecord.fromSnapshot(s));

  static Future<LugaresRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LugaresRecord.fromSnapshot(s));

  static LugaresRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LugaresRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LugaresRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LugaresRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LugaresRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LugaresRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLugaresRecordData({
  String? titulo,
  String? descripcionlugar,
  String? historiaslugar,
  bool? esabuelitos,
  bool? esninos,
  String? portada,
  LatLng? posLugar,
  bool? esMascotas,
  bool? esAdulyAdol,
  int? telefono,
  int? whatsApp,
  String? facebook,
  String? ruta,
  String? sonido,
  String? tipoLugar,
  DateTime? fechaCreacion,
  String? englishAudio,
  String? quienSube,
  DateTime? fechaModificacion,
  double? uRLYoutube,
  String? urlyt,
  int? ranking,
  String? uRLYTString,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'titulo': titulo,
      'descripcionlugar': descripcionlugar,
      'historiaslugar': historiaslugar,
      'esabuelitos': esabuelitos,
      'esninos': esninos,
      'portada': portada,
      'posLugar': posLugar,
      'EsMascotas': esMascotas,
      'EsAdulyAdol': esAdulyAdol,
      'Telefono': telefono,
      'WhatsApp': whatsApp,
      'Facebook': facebook,
      'Ruta': ruta,
      'sonido': sonido,
      'TipoLugar': tipoLugar,
      'FechaCreacion': fechaCreacion,
      'EnglishAudio': englishAudio,
      'QuienSube': quienSube,
      'FechaModificacion': fechaModificacion,
      'URLYoutube': uRLYoutube,
      'URLYT': urlyt,
      'Ranking': ranking,
      'URLYTString': uRLYTString,
    }.withoutNulls,
  );

  return firestoreData;
}

class LugaresRecordDocumentEquality implements Equality<LugaresRecord> {
  const LugaresRecordDocumentEquality();

  @override
  bool equals(LugaresRecord? e1, LugaresRecord? e2) {
    const listEquality = ListEquality();
    return e1?.titulo == e2?.titulo &&
        e1?.descripcionlugar == e2?.descripcionlugar &&
        e1?.historiaslugar == e2?.historiaslugar &&
        listEquality.equals(e1?.imagenes, e2?.imagenes) &&
        e1?.esabuelitos == e2?.esabuelitos &&
        e1?.esninos == e2?.esninos &&
        e1?.portada == e2?.portada &&
        e1?.posLugar == e2?.posLugar &&
        e1?.esMascotas == e2?.esMascotas &&
        e1?.esAdulyAdol == e2?.esAdulyAdol &&
        e1?.telefono == e2?.telefono &&
        e1?.whatsApp == e2?.whatsApp &&
        e1?.facebook == e2?.facebook &&
        e1?.ruta == e2?.ruta &&
        e1?.sonido == e2?.sonido &&
        e1?.tipoLugar == e2?.tipoLugar &&
        e1?.fechaCreacion == e2?.fechaCreacion &&
        e1?.englishAudio == e2?.englishAudio &&
        e1?.quienSube == e2?.quienSube &&
        e1?.fechaModificacion == e2?.fechaModificacion &&
        e1?.uRLYoutube == e2?.uRLYoutube &&
        e1?.urlyt == e2?.urlyt &&
        e1?.ranking == e2?.ranking &&
        e1?.uRLYTString == e2?.uRLYTString;
  }

  @override
  int hash(LugaresRecord? e) => const ListEquality().hash([
        e?.titulo,
        e?.descripcionlugar,
        e?.historiaslugar,
        e?.imagenes,
        e?.esabuelitos,
        e?.esninos,
        e?.portada,
        e?.posLugar,
        e?.esMascotas,
        e?.esAdulyAdol,
        e?.telefono,
        e?.whatsApp,
        e?.facebook,
        e?.ruta,
        e?.sonido,
        e?.tipoLugar,
        e?.fechaCreacion,
        e?.englishAudio,
        e?.quienSube,
        e?.fechaModificacion,
        e?.uRLYoutube,
        e?.urlyt,
        e?.ranking,
        e?.uRLYTString
      ]);

  @override
  bool isValidKey(Object? o) => o is LugaresRecord;
}
