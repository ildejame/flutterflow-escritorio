import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _CostoM2 = prefs.getDouble('ff_CostoM2') ?? _CostoM2;
    });
    _safeInit(() {
      _nombreempleadosAE =
          prefs.getStringList('ff_nombreempleadosAE') ?? _nombreempleadosAE;
    });
    _safeInit(() {
      _busquedarapidalugares =
          prefs.getStringList('ff_busquedarapidalugares') ??
              _busquedarapidalugares;
    });
    _safeInit(() {
      _ubicacionnivel1 =
          prefs.getStringList('ff_ubicacionnivel1') ?? _ubicacionnivel1;
    });
    _safeInit(() {
      _ubicacionnivel2 =
          prefs.getStringList('ff_ubicacionnivel2') ?? _ubicacionnivel2;
    });
    _safeInit(() {
      _ubicacionnivel3 =
          prefs.getStringList('ff_ubicacionnivel3') ?? _ubicacionnivel3;
    });
    _safeInit(() {
      _almacen = prefs.getStringList('ff_almacen') ?? _almacen;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _imatemp = '';
  String get imatemp => _imatemp;
  set imatemp(String value) {
    _imatemp = value;
  }

  String _imapost = '';
  String get imapost => _imapost;
  set imapost(String value) {
    _imapost = value;
  }

  List<String> _imamult = [];
  List<String> get imamult => _imamult;
  set imamult(List<String> value) {
    _imamult = value;
  }

  void addToImamult(String value) {
    imamult.add(value);
  }

  void removeFromImamult(String value) {
    imamult.remove(value);
  }

  void removeAtIndexFromImamult(int index) {
    imamult.removeAt(index);
  }

  void updateImamultAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    imamult[index] = updateFn(_imamult[index]);
  }

  void insertAtIndexInImamult(int index, String value) {
    imamult.insert(index, value);
  }

  String _portada = '';
  String get portada => _portada;
  set portada(String value) {
    _portada = value;
  }

  String _audio = '';
  String get audio => _audio;
  set audio(String value) {
    _audio = value;
  }

  LatLng? _PosiLocalState;
  LatLng? get PosiLocalState => _PosiLocalState;
  set PosiLocalState(LatLng? value) {
    _PosiLocalState = value;
  }

  String _TipoLugar = '';
  String get TipoLugar => _TipoLugar;
  set TipoLugar(String value) {
    _TipoLugar = value;
  }

  String _audioTempo = '';
  String get audioTempo => _audioTempo;
  set audioTempo(String value) {
    _audioTempo = value;
  }

  double _SalarioMinimo = 172.87;
  double get SalarioMinimo => _SalarioMinimo;
  set SalarioMinimo(double value) {
    _SalarioMinimo = value;
  }

  String _TipoAuto = '';
  String get TipoAuto => _TipoAuto;
  set TipoAuto(String value) {
    _TipoAuto = value;
  }

  int _CodigoBusqueda = 0;
  int get CodigoBusqueda => _CodigoBusqueda;
  set CodigoBusqueda(int value) {
    _CodigoBusqueda = value;
  }

  String _QRComercio = '';
  String get QRComercio => _QRComercio;
  set QRComercio(String value) {
    _QRComercio = value;
  }

  double _CostoM2 = 0.0;
  double get CostoM2 => _CostoM2;
  set CostoM2(double value) {
    _CostoM2 = value;
    prefs.setDouble('ff_CostoM2', value);
  }

  String _NombreNego = '';
  String get NombreNego => _NombreNego;
  set NombreNego(String value) {
    _NombreNego = value;
  }

  DateTime? _fechaadquisicion;
  DateTime? get fechaadquisicion => _fechaadquisicion;
  set fechaadquisicion(DateTime? value) {
    _fechaadquisicion = value;
  }

  List<DocumentReference> _listadebienes = [];
  List<DocumentReference> get listadebienes => _listadebienes;
  set listadebienes(List<DocumentReference> value) {
    _listadebienes = value;
  }

  void addToListadebienes(DocumentReference value) {
    listadebienes.add(value);
  }

  void removeFromListadebienes(DocumentReference value) {
    listadebienes.remove(value);
  }

  void removeAtIndexFromListadebienes(int index) {
    listadebienes.removeAt(index);
  }

  void updateListadebienesAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    listadebienes[index] = updateFn(_listadebienes[index]);
  }

  void insertAtIndexInListadebienes(int index, DocumentReference value) {
    listadebienes.insert(index, value);
  }

  String _catalogo = '';
  String get catalogo => _catalogo;
  set catalogo(String value) {
    _catalogo = value;
  }

  String _filtrocatalogos = '';
  String get filtrocatalogos => _filtrocatalogos;
  set filtrocatalogos(String value) {
    _filtrocatalogos = value;
  }

  List<String> _DocumentosEmpleadosstate = [];
  List<String> get DocumentosEmpleadosstate => _DocumentosEmpleadosstate;
  set DocumentosEmpleadosstate(List<String> value) {
    _DocumentosEmpleadosstate = value;
  }

  void addToDocumentosEmpleadosstate(String value) {
    DocumentosEmpleadosstate.add(value);
  }

  void removeFromDocumentosEmpleadosstate(String value) {
    DocumentosEmpleadosstate.remove(value);
  }

  void removeAtIndexFromDocumentosEmpleadosstate(int index) {
    DocumentosEmpleadosstate.removeAt(index);
  }

  void updateDocumentosEmpleadosstateAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    DocumentosEmpleadosstate[index] =
        updateFn(_DocumentosEmpleadosstate[index]);
  }

  void insertAtIndexInDocumentosEmpleadosstate(int index, String value) {
    DocumentosEmpleadosstate.insert(index, value);
  }

  List<String> _nombreempleadosAE = [];
  List<String> get nombreempleadosAE => _nombreempleadosAE;
  set nombreempleadosAE(List<String> value) {
    _nombreempleadosAE = value;
    prefs.setStringList('ff_nombreempleadosAE', value);
  }

  void addToNombreempleadosAE(String value) {
    nombreempleadosAE.add(value);
    prefs.setStringList('ff_nombreempleadosAE', _nombreempleadosAE);
  }

  void removeFromNombreempleadosAE(String value) {
    nombreempleadosAE.remove(value);
    prefs.setStringList('ff_nombreempleadosAE', _nombreempleadosAE);
  }

  void removeAtIndexFromNombreempleadosAE(int index) {
    nombreempleadosAE.removeAt(index);
    prefs.setStringList('ff_nombreempleadosAE', _nombreempleadosAE);
  }

  void updateNombreempleadosAEAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    nombreempleadosAE[index] = updateFn(_nombreempleadosAE[index]);
    prefs.setStringList('ff_nombreempleadosAE', _nombreempleadosAE);
  }

  void insertAtIndexInNombreempleadosAE(int index, String value) {
    nombreempleadosAE.insert(index, value);
    prefs.setStringList('ff_nombreempleadosAE', _nombreempleadosAE);
  }

  List<String> _busquedarapidalugares = [];
  List<String> get busquedarapidalugares => _busquedarapidalugares;
  set busquedarapidalugares(List<String> value) {
    _busquedarapidalugares = value;
    prefs.setStringList('ff_busquedarapidalugares', value);
  }

  void addToBusquedarapidalugares(String value) {
    busquedarapidalugares.add(value);
    prefs.setStringList('ff_busquedarapidalugares', _busquedarapidalugares);
  }

  void removeFromBusquedarapidalugares(String value) {
    busquedarapidalugares.remove(value);
    prefs.setStringList('ff_busquedarapidalugares', _busquedarapidalugares);
  }

  void removeAtIndexFromBusquedarapidalugares(int index) {
    busquedarapidalugares.removeAt(index);
    prefs.setStringList('ff_busquedarapidalugares', _busquedarapidalugares);
  }

  void updateBusquedarapidalugaresAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    busquedarapidalugares[index] = updateFn(_busquedarapidalugares[index]);
    prefs.setStringList('ff_busquedarapidalugares', _busquedarapidalugares);
  }

  void insertAtIndexInBusquedarapidalugares(int index, String value) {
    busquedarapidalugares.insert(index, value);
    prefs.setStringList('ff_busquedarapidalugares', _busquedarapidalugares);
  }

  List<String> _ubicacionnivel1 = [];
  List<String> get ubicacionnivel1 => _ubicacionnivel1;
  set ubicacionnivel1(List<String> value) {
    _ubicacionnivel1 = value;
    prefs.setStringList('ff_ubicacionnivel1', value);
  }

  void addToUbicacionnivel1(String value) {
    ubicacionnivel1.add(value);
    prefs.setStringList('ff_ubicacionnivel1', _ubicacionnivel1);
  }

  void removeFromUbicacionnivel1(String value) {
    ubicacionnivel1.remove(value);
    prefs.setStringList('ff_ubicacionnivel1', _ubicacionnivel1);
  }

  void removeAtIndexFromUbicacionnivel1(int index) {
    ubicacionnivel1.removeAt(index);
    prefs.setStringList('ff_ubicacionnivel1', _ubicacionnivel1);
  }

  void updateUbicacionnivel1AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    ubicacionnivel1[index] = updateFn(_ubicacionnivel1[index]);
    prefs.setStringList('ff_ubicacionnivel1', _ubicacionnivel1);
  }

  void insertAtIndexInUbicacionnivel1(int index, String value) {
    ubicacionnivel1.insert(index, value);
    prefs.setStringList('ff_ubicacionnivel1', _ubicacionnivel1);
  }

  List<String> _ubicacionnivel2 = [];
  List<String> get ubicacionnivel2 => _ubicacionnivel2;
  set ubicacionnivel2(List<String> value) {
    _ubicacionnivel2 = value;
    prefs.setStringList('ff_ubicacionnivel2', value);
  }

  void addToUbicacionnivel2(String value) {
    ubicacionnivel2.add(value);
    prefs.setStringList('ff_ubicacionnivel2', _ubicacionnivel2);
  }

  void removeFromUbicacionnivel2(String value) {
    ubicacionnivel2.remove(value);
    prefs.setStringList('ff_ubicacionnivel2', _ubicacionnivel2);
  }

  void removeAtIndexFromUbicacionnivel2(int index) {
    ubicacionnivel2.removeAt(index);
    prefs.setStringList('ff_ubicacionnivel2', _ubicacionnivel2);
  }

  void updateUbicacionnivel2AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    ubicacionnivel2[index] = updateFn(_ubicacionnivel2[index]);
    prefs.setStringList('ff_ubicacionnivel2', _ubicacionnivel2);
  }

  void insertAtIndexInUbicacionnivel2(int index, String value) {
    ubicacionnivel2.insert(index, value);
    prefs.setStringList('ff_ubicacionnivel2', _ubicacionnivel2);
  }

  List<String> _ubicacionnivel3 = [];
  List<String> get ubicacionnivel3 => _ubicacionnivel3;
  set ubicacionnivel3(List<String> value) {
    _ubicacionnivel3 = value;
    prefs.setStringList('ff_ubicacionnivel3', value);
  }

  void addToUbicacionnivel3(String value) {
    ubicacionnivel3.add(value);
    prefs.setStringList('ff_ubicacionnivel3', _ubicacionnivel3);
  }

  void removeFromUbicacionnivel3(String value) {
    ubicacionnivel3.remove(value);
    prefs.setStringList('ff_ubicacionnivel3', _ubicacionnivel3);
  }

  void removeAtIndexFromUbicacionnivel3(int index) {
    ubicacionnivel3.removeAt(index);
    prefs.setStringList('ff_ubicacionnivel3', _ubicacionnivel3);
  }

  void updateUbicacionnivel3AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    ubicacionnivel3[index] = updateFn(_ubicacionnivel3[index]);
    prefs.setStringList('ff_ubicacionnivel3', _ubicacionnivel3);
  }

  void insertAtIndexInUbicacionnivel3(int index, String value) {
    ubicacionnivel3.insert(index, value);
    prefs.setStringList('ff_ubicacionnivel3', _ubicacionnivel3);
  }

  String _nombreanexo = '';
  String get nombreanexo => _nombreanexo;
  set nombreanexo(String value) {
    _nombreanexo = value;
  }

  String _depositario = '';
  String get depositario => _depositario;
  set depositario(String value) {
    _depositario = value;
  }

  String _revisor = '';
  String get revisor => _revisor;
  set revisor(String value) {
    _revisor = value;
  }

  String _nivel1 = '';
  String get nivel1 => _nivel1;
  set nivel1(String value) {
    _nivel1 = value;
  }

  String _nivel2 = '';
  String get nivel2 => _nivel2;
  set nivel2(String value) {
    _nivel2 = value;
  }

  String _nivel3 = '';
  String get nivel3 => _nivel3;
  set nivel3(String value) {
    _nivel3 = value;
  }

  String _distrito = '';
  String get distrito => _distrito;
  set distrito(String value) {
    _distrito = value;
  }

  String _filtroanexofirebase = '';
  String get filtroanexofirebase => _filtroanexofirebase;
  set filtroanexofirebase(String value) {
    _filtroanexofirebase = value;
  }

  String _IDinventarios = '';
  String get IDinventarios => _IDinventarios;
  set IDinventarios(String value) {
    _IDinventarios = value;
  }

  String _foliovale = '';
  String get foliovale => _foliovale;
  set foliovale(String value) {
    _foliovale = value;
  }

  String _comentariosvale = '';
  String get comentariosvale => _comentariosvale;
  set comentariosvale(String value) {
    _comentariosvale = value;
  }

  List<DocumentReference> _bienesmasivos = [];
  List<DocumentReference> get bienesmasivos => _bienesmasivos;
  set bienesmasivos(List<DocumentReference> value) {
    _bienesmasivos = value;
  }

  void addToBienesmasivos(DocumentReference value) {
    bienesmasivos.add(value);
  }

  void removeFromBienesmasivos(DocumentReference value) {
    bienesmasivos.remove(value);
  }

  void removeAtIndexFromBienesmasivos(int index) {
    bienesmasivos.removeAt(index);
  }

  void updateBienesmasivosAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    bienesmasivos[index] = updateFn(_bienesmasivos[index]);
  }

  void insertAtIndexInBienesmasivos(int index, DocumentReference value) {
    bienesmasivos.insert(index, value);
  }

  List<DocumentReference> _listabieneseditar = [];
  List<DocumentReference> get listabieneseditar => _listabieneseditar;
  set listabieneseditar(List<DocumentReference> value) {
    _listabieneseditar = value;
  }

  void addToListabieneseditar(DocumentReference value) {
    listabieneseditar.add(value);
  }

  void removeFromListabieneseditar(DocumentReference value) {
    listabieneseditar.remove(value);
  }

  void removeAtIndexFromListabieneseditar(int index) {
    listabieneseditar.removeAt(index);
  }

  void updateListabieneseditarAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    listabieneseditar[index] = updateFn(_listabieneseditar[index]);
  }

  void insertAtIndexInListabieneseditar(int index, DocumentReference value) {
    listabieneseditar.insert(index, value);
  }

  int _contador = 0;
  int get contador => _contador;
  set contador(int value) {
    _contador = value;
  }

  List<String> _almacen = [];
  List<String> get almacen => _almacen;
  set almacen(List<String> value) {
    _almacen = value;
    prefs.setStringList('ff_almacen', value);
  }

  void addToAlmacen(String value) {
    almacen.add(value);
    prefs.setStringList('ff_almacen', _almacen);
  }

  void removeFromAlmacen(String value) {
    almacen.remove(value);
    prefs.setStringList('ff_almacen', _almacen);
  }

  void removeAtIndexFromAlmacen(int index) {
    almacen.removeAt(index);
    prefs.setStringList('ff_almacen', _almacen);
  }

  void updateAlmacenAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    almacen[index] = updateFn(_almacen[index]);
    prefs.setStringList('ff_almacen', _almacen);
  }

  void insertAtIndexInAlmacen(int index, String value) {
    almacen.insert(index, value);
    prefs.setStringList('ff_almacen', _almacen);
  }

  String _almacenpeticion = '';
  String get almacenpeticion => _almacenpeticion;
  set almacenpeticion(String value) {
    _almacenpeticion = value;
  }

  String _buscarfolio = '';
  String get buscarfolio => _buscarfolio;
  set buscarfolio(String value) {
    _buscarfolio = value;
  }

  String _imgBien = '';
  String get imgBien => _imgBien;
  set imgBien(String value) {
    _imgBien = value;
  }

  DateTime? _fechaavaluoAE;
  DateTime? get fechaavaluoAE => _fechaavaluoAE;
  set fechaavaluoAE(DateTime? value) {
    _fechaavaluoAE = value;
  }

  List<String> _idempleadosAPI = [];
  List<String> get idempleadosAPI => _idempleadosAPI;
  set idempleadosAPI(List<String> value) {
    _idempleadosAPI = value;
  }

  void addToIdempleadosAPI(String value) {
    idempleadosAPI.add(value);
  }

  void removeFromIdempleadosAPI(String value) {
    idempleadosAPI.remove(value);
  }

  void removeAtIndexFromIdempleadosAPI(int index) {
    idempleadosAPI.removeAt(index);
  }

  void updateIdempleadosAPIAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    idempleadosAPI[index] = updateFn(_idempleadosAPI[index]);
  }

  void insertAtIndexInIdempleadosAPI(int index, String value) {
    idempleadosAPI.insert(index, value);
  }

  List<dynamic> _listadepositarios = [];
  List<dynamic> get listadepositarios => _listadepositarios;
  set listadepositarios(List<dynamic> value) {
    _listadepositarios = value;
  }

  void addToListadepositarios(dynamic value) {
    listadepositarios.add(value);
  }

  void removeFromListadepositarios(dynamic value) {
    listadepositarios.remove(value);
  }

  void removeAtIndexFromListadepositarios(int index) {
    listadepositarios.removeAt(index);
  }

  void updateListadepositariosAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    listadepositarios[index] = updateFn(_listadepositarios[index]);
  }

  void insertAtIndexInListadepositarios(int index, dynamic value) {
    listadepositarios.insert(index, value);
  }

  List<String> _sugerenciasN1 = [];
  List<String> get sugerenciasN1 => _sugerenciasN1;
  set sugerenciasN1(List<String> value) {
    _sugerenciasN1 = value;
  }

  void addToSugerenciasN1(String value) {
    sugerenciasN1.add(value);
  }

  void removeFromSugerenciasN1(String value) {
    sugerenciasN1.remove(value);
  }

  void removeAtIndexFromSugerenciasN1(int index) {
    sugerenciasN1.removeAt(index);
  }

  void updateSugerenciasN1AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    sugerenciasN1[index] = updateFn(_sugerenciasN1[index]);
  }

  void insertAtIndexInSugerenciasN1(int index, String value) {
    sugerenciasN1.insert(index, value);
  }

  List<String> _sugerenciasN2 = [];
  List<String> get sugerenciasN2 => _sugerenciasN2;
  set sugerenciasN2(List<String> value) {
    _sugerenciasN2 = value;
  }

  void addToSugerenciasN2(String value) {
    sugerenciasN2.add(value);
  }

  void removeFromSugerenciasN2(String value) {
    sugerenciasN2.remove(value);
  }

  void removeAtIndexFromSugerenciasN2(int index) {
    sugerenciasN2.removeAt(index);
  }

  void updateSugerenciasN2AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    sugerenciasN2[index] = updateFn(_sugerenciasN2[index]);
  }

  void insertAtIndexInSugerenciasN2(int index, String value) {
    sugerenciasN2.insert(index, value);
  }

  List<String> _sugerenciasN3 = [];
  List<String> get sugerenciasN3 => _sugerenciasN3;
  set sugerenciasN3(List<String> value) {
    _sugerenciasN3 = value;
  }

  void addToSugerenciasN3(String value) {
    sugerenciasN3.add(value);
  }

  void removeFromSugerenciasN3(String value) {
    sugerenciasN3.remove(value);
  }

  void removeAtIndexFromSugerenciasN3(int index) {
    sugerenciasN3.removeAt(index);
  }

  void updateSugerenciasN3AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    sugerenciasN3[index] = updateFn(_sugerenciasN3[index]);
  }

  void insertAtIndexInSugerenciasN3(int index, String value) {
    sugerenciasN3.insert(index, value);
  }

  List<dynamic> _oficinas = [];
  List<dynamic> get oficinas => _oficinas;
  set oficinas(List<dynamic> value) {
    _oficinas = value;
  }

  void addToOficinas(dynamic value) {
    oficinas.add(value);
  }

  void removeFromOficinas(dynamic value) {
    oficinas.remove(value);
  }

  void removeAtIndexFromOficinas(int index) {
    oficinas.removeAt(index);
  }

  void updateOficinasAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    oficinas[index] = updateFn(_oficinas[index]);
  }

  void insertAtIndexInOficinas(int index, dynamic value) {
    oficinas.insert(index, value);
  }

  List<String> _nombredepreciacion = [];
  List<String> get nombredepreciacion => _nombredepreciacion;
  set nombredepreciacion(List<String> value) {
    _nombredepreciacion = value;
  }

  void addToNombredepreciacion(String value) {
    nombredepreciacion.add(value);
  }

  void removeFromNombredepreciacion(String value) {
    nombredepreciacion.remove(value);
  }

  void removeAtIndexFromNombredepreciacion(int index) {
    nombredepreciacion.removeAt(index);
  }

  void updateNombredepreciacionAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    nombredepreciacion[index] = updateFn(_nombredepreciacion[index]);
  }

  void insertAtIndexInNombredepreciacion(int index, String value) {
    nombredepreciacion.insert(index, value);
  }

  List<dynamic> _depreciacion = [];
  List<dynamic> get depreciacion => _depreciacion;
  set depreciacion(List<dynamic> value) {
    _depreciacion = value;
  }

  void addToDepreciacion(dynamic value) {
    depreciacion.add(value);
  }

  void removeFromDepreciacion(dynamic value) {
    depreciacion.remove(value);
  }

  void removeAtIndexFromDepreciacion(int index) {
    depreciacion.removeAt(index);
  }

  void updateDepreciacionAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    depreciacion[index] = updateFn(_depreciacion[index]);
  }

  void insertAtIndexInDepreciacion(int index, dynamic value) {
    depreciacion.insert(index, value);
  }

  List<dynamic> _distritos = [];
  List<dynamic> get distritos => _distritos;
  set distritos(List<dynamic> value) {
    _distritos = value;
  }

  void addToDistritos(dynamic value) {
    distritos.add(value);
  }

  void removeFromDistritos(dynamic value) {
    distritos.remove(value);
  }

  void removeAtIndexFromDistritos(int index) {
    distritos.removeAt(index);
  }

  void updateDistritosAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    distritos[index] = updateFn(_distritos[index]);
  }

  void insertAtIndexInDistritos(int index, dynamic value) {
    distritos.insert(index, value);
  }

  List<dynamic> _editarlistabienesmuebles = [];
  List<dynamic> get editarlistabienesmuebles => _editarlistabienesmuebles;
  set editarlistabienesmuebles(List<dynamic> value) {
    _editarlistabienesmuebles = value;
  }

  void addToEditarlistabienesmuebles(dynamic value) {
    editarlistabienesmuebles.add(value);
  }

  void removeFromEditarlistabienesmuebles(dynamic value) {
    editarlistabienesmuebles.remove(value);
  }

  void removeAtIndexFromEditarlistabienesmuebles(int index) {
    editarlistabienesmuebles.removeAt(index);
  }

  void updateEditarlistabienesmueblesAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    editarlistabienesmuebles[index] =
        updateFn(_editarlistabienesmuebles[index]);
  }

  void insertAtIndexInEditarlistabienesmuebles(int index, dynamic value) {
    editarlistabienesmuebles.insert(index, value);
  }

  dynamic _bienmueble;
  dynamic get bienmueble => _bienmueble;
  set bienmueble(dynamic value) {
    _bienmueble = value;
  }

  List<dynamic> _valespb = [];
  List<dynamic> get valespb => _valespb;
  set valespb(List<dynamic> value) {
    _valespb = value;
  }

  void addToValespb(dynamic value) {
    valespb.add(value);
  }

  void removeFromValespb(dynamic value) {
    valespb.remove(value);
  }

  void removeAtIndexFromValespb(int index) {
    valespb.removeAt(index);
  }

  void updateValespbAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    valespb[index] = updateFn(_valespb[index]);
  }

  void insertAtIndexInValespb(int index, dynamic value) {
    valespb.insert(index, value);
  }

  List<dynamic> _bienesfolio = [];
  List<dynamic> get bienesfolio => _bienesfolio;
  set bienesfolio(List<dynamic> value) {
    _bienesfolio = value;
  }

  void addToBienesfolio(dynamic value) {
    bienesfolio.add(value);
  }

  void removeFromBienesfolio(dynamic value) {
    bienesfolio.remove(value);
  }

  void removeAtIndexFromBienesfolio(int index) {
    bienesfolio.removeAt(index);
  }

  void updateBienesfolioAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    bienesfolio[index] = updateFn(_bienesfolio[index]);
  }

  void insertAtIndexInBienesfolio(int index, dynamic value) {
    bienesfolio.insert(index, value);
  }

  List<dynamic> _valesfolio = [];
  List<dynamic> get valesfolio => _valesfolio;
  set valesfolio(List<dynamic> value) {
    _valesfolio = value;
  }

  void addToValesfolio(dynamic value) {
    valesfolio.add(value);
  }

  void removeFromValesfolio(dynamic value) {
    valesfolio.remove(value);
  }

  void removeAtIndexFromValesfolio(int index) {
    valesfolio.removeAt(index);
  }

  void updateValesfolioAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    valesfolio[index] = updateFn(_valesfolio[index]);
  }

  void insertAtIndexInValesfolio(int index, dynamic value) {
    valesfolio.insert(index, value);
  }

  String _IDanterior = '';
  String get IDanterior => _IDanterior;
  set IDanterior(String value) {
    _IDanterior = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
