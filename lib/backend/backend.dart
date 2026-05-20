import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/firebase_auth/auth_util.dart';

import '../flutter_flow/flutter_flow_util.dart';
import 'schema/util/firestore_util.dart';

import 'schema/users_record.dart';
import 'schema/lugares_record.dart';
import 'schema/general_record.dart';
import 'schema/calificacion_record.dart';
import 'schema/lista_push_record.dart';
import 'schema/inf_motos_record.dart';
import 'schema/infracciones_record.dart';
import 'schema/pagos_q_r_record.dart';
import 'schema/establecimientos_record.dart';
import 'schema/rutas_comercio_record.dart';
import 'schema/pagos_diarios_record.dart';
import 'schema/pagos_anuales_record.dart';
import 'schema/parametros_cobros_record.dart';
import 'schema/giros_record.dart';
import 'schema/pagos_adicionales_record.dart';
import 'schema/promociones_record.dart';
import 'schema/recibo_agente_municipal_record.dart';
import 'schema/folios_p_d_fs_altas_record.dart';
import 'schema/comentarios_comercios_record.dart';
import 'schema/documentos_scanner_record.dart';
import 'schema/bienesmuebles_record.dart';
import 'schema/listas_p_j_e_v_record.dart';
import 'schema/empleadospjev_record.dart';
import 'schema/bitacora_record.dart';
import 'schema/oficinas_p_j_e_v_record.dart';
import 'schema/depreciacion_record.dart';
import 'schema/archivocontrolinventarios_record.dart';
import 'schema/valesmovimientos_record.dart';
import 'schema/foliobienes_record.dart';
import 'schema/zonas_record.dart';
import 'schema/vales2_record.dart';
import 'schema/impresionetiquetas_record.dart';
import 'schema/calculodepreciacion_record.dart';
import 'schema/depreciacion2024_record.dart';
import 'schema/controlid_record.dart';
import 'schema/preciouma_record.dart';
import 'schema/foliadorvales_record.dart';
import 'schema/respaldos_record.dart';

export 'dart:async' show StreamSubscription;
export 'package:cloud_firestore/cloud_firestore.dart' hide Order;
export 'package:firebase_core/firebase_core.dart';
export 'schema/index.dart';
export 'schema/util/firestore_util.dart';
export 'schema/util/schema_util.dart';

export 'schema/users_record.dart';
export 'schema/lugares_record.dart';
export 'schema/general_record.dart';
export 'schema/calificacion_record.dart';
export 'schema/lista_push_record.dart';
export 'schema/inf_motos_record.dart';
export 'schema/infracciones_record.dart';
export 'schema/pagos_q_r_record.dart';
export 'schema/establecimientos_record.dart';
export 'schema/rutas_comercio_record.dart';
export 'schema/pagos_diarios_record.dart';
export 'schema/pagos_anuales_record.dart';
export 'schema/parametros_cobros_record.dart';
export 'schema/giros_record.dart';
export 'schema/pagos_adicionales_record.dart';
export 'schema/promociones_record.dart';
export 'schema/recibo_agente_municipal_record.dart';
export 'schema/folios_p_d_fs_altas_record.dart';
export 'schema/comentarios_comercios_record.dart';
export 'schema/documentos_scanner_record.dart';
export 'schema/bienesmuebles_record.dart';
export 'schema/listas_p_j_e_v_record.dart';
export 'schema/empleadospjev_record.dart';
export 'schema/bitacora_record.dart';
export 'schema/oficinas_p_j_e_v_record.dart';
export 'schema/depreciacion_record.dart';
export 'schema/archivocontrolinventarios_record.dart';
export 'schema/valesmovimientos_record.dart';
export 'schema/foliobienes_record.dart';
export 'schema/zonas_record.dart';
export 'schema/vales2_record.dart';
export 'schema/impresionetiquetas_record.dart';
export 'schema/calculodepreciacion_record.dart';
export 'schema/depreciacion2024_record.dart';
export 'schema/controlid_record.dart';
export 'schema/preciouma_record.dart';
export 'schema/foliadorvales_record.dart';
export 'schema/respaldos_record.dart';

/// Functions to query UsersRecords (as a Stream and as a Future).
Future<int> queryUsersRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      UsersRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<UsersRecord>> queryUsersRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      UsersRecord.collection,
      UsersRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<UsersRecord>> queryUsersRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      UsersRecord.collection,
      UsersRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query LugaresRecords (as a Stream and as a Future).
Future<int> queryLugaresRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      LugaresRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<LugaresRecord>> queryLugaresRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      LugaresRecord.collection,
      LugaresRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<LugaresRecord>> queryLugaresRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      LugaresRecord.collection,
      LugaresRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query GeneralRecords (as a Stream and as a Future).
Future<int> queryGeneralRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      GeneralRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<GeneralRecord>> queryGeneralRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      GeneralRecord.collection,
      GeneralRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<GeneralRecord>> queryGeneralRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      GeneralRecord.collection,
      GeneralRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query CalificacionRecords (as a Stream and as a Future).
Future<int> queryCalificacionRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      CalificacionRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<CalificacionRecord>> queryCalificacionRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      CalificacionRecord.collection,
      CalificacionRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<CalificacionRecord>> queryCalificacionRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      CalificacionRecord.collection,
      CalificacionRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ListaPushRecords (as a Stream and as a Future).
Future<int> queryListaPushRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ListaPushRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ListaPushRecord>> queryListaPushRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ListaPushRecord.collection,
      ListaPushRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ListaPushRecord>> queryListaPushRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ListaPushRecord.collection,
      ListaPushRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query InfMotosRecords (as a Stream and as a Future).
Future<int> queryInfMotosRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      InfMotosRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<InfMotosRecord>> queryInfMotosRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      InfMotosRecord.collection,
      InfMotosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<InfMotosRecord>> queryInfMotosRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      InfMotosRecord.collection,
      InfMotosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query InfraccionesRecords (as a Stream and as a Future).
Future<int> queryInfraccionesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      InfraccionesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<InfraccionesRecord>> queryInfraccionesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      InfraccionesRecord.collection,
      InfraccionesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<InfraccionesRecord>> queryInfraccionesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      InfraccionesRecord.collection,
      InfraccionesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PagosQRRecords (as a Stream and as a Future).
Future<int> queryPagosQRRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PagosQRRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PagosQRRecord>> queryPagosQRRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PagosQRRecord.collection,
      PagosQRRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PagosQRRecord>> queryPagosQRRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PagosQRRecord.collection,
      PagosQRRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query EstablecimientosRecords (as a Stream and as a Future).
Future<int> queryEstablecimientosRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      EstablecimientosRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<EstablecimientosRecord>> queryEstablecimientosRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      EstablecimientosRecord.collection,
      EstablecimientosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<EstablecimientosRecord>> queryEstablecimientosRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      EstablecimientosRecord.collection,
      EstablecimientosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query RutasComercioRecords (as a Stream and as a Future).
Future<int> queryRutasComercioRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      RutasComercioRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<RutasComercioRecord>> queryRutasComercioRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      RutasComercioRecord.collection,
      RutasComercioRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<RutasComercioRecord>> queryRutasComercioRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      RutasComercioRecord.collection,
      RutasComercioRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PagosDiariosRecords (as a Stream and as a Future).
Future<int> queryPagosDiariosRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PagosDiariosRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PagosDiariosRecord>> queryPagosDiariosRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PagosDiariosRecord.collection,
      PagosDiariosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PagosDiariosRecord>> queryPagosDiariosRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PagosDiariosRecord.collection,
      PagosDiariosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PagosAnualesRecords (as a Stream and as a Future).
Future<int> queryPagosAnualesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PagosAnualesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PagosAnualesRecord>> queryPagosAnualesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PagosAnualesRecord.collection,
      PagosAnualesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PagosAnualesRecord>> queryPagosAnualesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PagosAnualesRecord.collection,
      PagosAnualesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ParametrosCobrosRecords (as a Stream and as a Future).
Future<int> queryParametrosCobrosRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ParametrosCobrosRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ParametrosCobrosRecord>> queryParametrosCobrosRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ParametrosCobrosRecord.collection,
      ParametrosCobrosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ParametrosCobrosRecord>> queryParametrosCobrosRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ParametrosCobrosRecord.collection,
      ParametrosCobrosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query GirosRecords (as a Stream and as a Future).
Future<int> queryGirosRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      GirosRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<GirosRecord>> queryGirosRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      GirosRecord.collection,
      GirosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<GirosRecord>> queryGirosRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      GirosRecord.collection,
      GirosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PagosAdicionalesRecords (as a Stream and as a Future).
Future<int> queryPagosAdicionalesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PagosAdicionalesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PagosAdicionalesRecord>> queryPagosAdicionalesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PagosAdicionalesRecord.collection,
      PagosAdicionalesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PagosAdicionalesRecord>> queryPagosAdicionalesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PagosAdicionalesRecord.collection,
      PagosAdicionalesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PromocionesRecords (as a Stream and as a Future).
Future<int> queryPromocionesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PromocionesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PromocionesRecord>> queryPromocionesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PromocionesRecord.collection,
      PromocionesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PromocionesRecord>> queryPromocionesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PromocionesRecord.collection,
      PromocionesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ReciboAgenteMunicipalRecords (as a Stream and as a Future).
Future<int> queryReciboAgenteMunicipalRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ReciboAgenteMunicipalRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ReciboAgenteMunicipalRecord>> queryReciboAgenteMunicipalRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ReciboAgenteMunicipalRecord.collection,
      ReciboAgenteMunicipalRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ReciboAgenteMunicipalRecord>> queryReciboAgenteMunicipalRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ReciboAgenteMunicipalRecord.collection,
      ReciboAgenteMunicipalRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query FoliosPDFsAltasRecords (as a Stream and as a Future).
Future<int> queryFoliosPDFsAltasRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      FoliosPDFsAltasRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<FoliosPDFsAltasRecord>> queryFoliosPDFsAltasRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      FoliosPDFsAltasRecord.collection,
      FoliosPDFsAltasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<FoliosPDFsAltasRecord>> queryFoliosPDFsAltasRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      FoliosPDFsAltasRecord.collection,
      FoliosPDFsAltasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ComentariosComerciosRecords (as a Stream and as a Future).
Future<int> queryComentariosComerciosRecordCount({
  DocumentReference? parent,
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ComentariosComerciosRecord.collection(parent),
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ComentariosComerciosRecord>> queryComentariosComerciosRecord({
  DocumentReference? parent,
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ComentariosComerciosRecord.collection(parent),
      ComentariosComerciosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ComentariosComerciosRecord>> queryComentariosComerciosRecordOnce({
  DocumentReference? parent,
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ComentariosComerciosRecord.collection(parent),
      ComentariosComerciosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query DocumentosScannerRecords (as a Stream and as a Future).
Future<int> queryDocumentosScannerRecordCount({
  DocumentReference? parent,
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      DocumentosScannerRecord.collection(parent),
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<DocumentosScannerRecord>> queryDocumentosScannerRecord({
  DocumentReference? parent,
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      DocumentosScannerRecord.collection(parent),
      DocumentosScannerRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<DocumentosScannerRecord>> queryDocumentosScannerRecordOnce({
  DocumentReference? parent,
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      DocumentosScannerRecord.collection(parent),
      DocumentosScannerRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query BienesmueblesRecords (as a Stream and as a Future).
Future<int> queryBienesmueblesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      BienesmueblesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<BienesmueblesRecord>> queryBienesmueblesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      BienesmueblesRecord.collection,
      BienesmueblesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<BienesmueblesRecord>> queryBienesmueblesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      BienesmueblesRecord.collection,
      BienesmueblesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ListasPJEVRecords (as a Stream and as a Future).
Future<int> queryListasPJEVRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ListasPJEVRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ListasPJEVRecord>> queryListasPJEVRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ListasPJEVRecord.collection,
      ListasPJEVRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ListasPJEVRecord>> queryListasPJEVRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ListasPJEVRecord.collection,
      ListasPJEVRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query EmpleadospjevRecords (as a Stream and as a Future).
Future<int> queryEmpleadospjevRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      EmpleadospjevRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<EmpleadospjevRecord>> queryEmpleadospjevRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      EmpleadospjevRecord.collection,
      EmpleadospjevRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<EmpleadospjevRecord>> queryEmpleadospjevRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      EmpleadospjevRecord.collection,
      EmpleadospjevRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query BitacoraRecords (as a Stream and as a Future).
Future<int> queryBitacoraRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      BitacoraRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<BitacoraRecord>> queryBitacoraRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      BitacoraRecord.collection,
      BitacoraRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<BitacoraRecord>> queryBitacoraRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      BitacoraRecord.collection,
      BitacoraRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query OficinasPJEVRecords (as a Stream and as a Future).
Future<int> queryOficinasPJEVRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      OficinasPJEVRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<OficinasPJEVRecord>> queryOficinasPJEVRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      OficinasPJEVRecord.collection,
      OficinasPJEVRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<OficinasPJEVRecord>> queryOficinasPJEVRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      OficinasPJEVRecord.collection,
      OficinasPJEVRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query DepreciacionRecords (as a Stream and as a Future).
Future<int> queryDepreciacionRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      DepreciacionRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<DepreciacionRecord>> queryDepreciacionRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      DepreciacionRecord.collection,
      DepreciacionRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<DepreciacionRecord>> queryDepreciacionRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      DepreciacionRecord.collection,
      DepreciacionRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ArchivocontrolinventariosRecords (as a Stream and as a Future).
Future<int> queryArchivocontrolinventariosRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ArchivocontrolinventariosRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ArchivocontrolinventariosRecord>>
    queryArchivocontrolinventariosRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
        queryCollection(
          ArchivocontrolinventariosRecord.collection,
          ArchivocontrolinventariosRecord.fromSnapshot,
          queryBuilder: queryBuilder,
          limit: limit,
          singleRecord: singleRecord,
        );

Future<List<ArchivocontrolinventariosRecord>>
    queryArchivocontrolinventariosRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
        queryCollectionOnce(
          ArchivocontrolinventariosRecord.collection,
          ArchivocontrolinventariosRecord.fromSnapshot,
          queryBuilder: queryBuilder,
          limit: limit,
          singleRecord: singleRecord,
        );

/// Functions to query ValesmovimientosRecords (as a Stream and as a Future).
Future<int> queryValesmovimientosRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ValesmovimientosRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ValesmovimientosRecord>> queryValesmovimientosRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ValesmovimientosRecord.collection,
      ValesmovimientosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ValesmovimientosRecord>> queryValesmovimientosRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ValesmovimientosRecord.collection,
      ValesmovimientosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query FoliobienesRecords (as a Stream and as a Future).
Future<int> queryFoliobienesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      FoliobienesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<FoliobienesRecord>> queryFoliobienesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      FoliobienesRecord.collection,
      FoliobienesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<FoliobienesRecord>> queryFoliobienesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      FoliobienesRecord.collection,
      FoliobienesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ZonasRecords (as a Stream and as a Future).
Future<int> queryZonasRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ZonasRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ZonasRecord>> queryZonasRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ZonasRecord.collection,
      ZonasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ZonasRecord>> queryZonasRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ZonasRecord.collection,
      ZonasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query Vales2Records (as a Stream and as a Future).
Future<int> queryVales2RecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      Vales2Record.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<Vales2Record>> queryVales2Record({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      Vales2Record.collection,
      Vales2Record.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<Vales2Record>> queryVales2RecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      Vales2Record.collection,
      Vales2Record.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ImpresionetiquetasRecords (as a Stream and as a Future).
Future<int> queryImpresionetiquetasRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ImpresionetiquetasRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ImpresionetiquetasRecord>> queryImpresionetiquetasRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ImpresionetiquetasRecord.collection,
      ImpresionetiquetasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ImpresionetiquetasRecord>> queryImpresionetiquetasRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ImpresionetiquetasRecord.collection,
      ImpresionetiquetasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query CalculodepreciacionRecords (as a Stream and as a Future).
Future<int> queryCalculodepreciacionRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      CalculodepreciacionRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<CalculodepreciacionRecord>> queryCalculodepreciacionRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      CalculodepreciacionRecord.collection,
      CalculodepreciacionRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<CalculodepreciacionRecord>> queryCalculodepreciacionRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      CalculodepreciacionRecord.collection,
      CalculodepreciacionRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query Depreciacion2024Records (as a Stream and as a Future).
Future<int> queryDepreciacion2024RecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      Depreciacion2024Record.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<Depreciacion2024Record>> queryDepreciacion2024Record({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      Depreciacion2024Record.collection,
      Depreciacion2024Record.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<Depreciacion2024Record>> queryDepreciacion2024RecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      Depreciacion2024Record.collection,
      Depreciacion2024Record.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ControlidRecords (as a Stream and as a Future).
Future<int> queryControlidRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ControlidRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ControlidRecord>> queryControlidRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ControlidRecord.collection,
      ControlidRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ControlidRecord>> queryControlidRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ControlidRecord.collection,
      ControlidRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PrecioumaRecords (as a Stream and as a Future).
Future<int> queryPrecioumaRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PrecioumaRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PrecioumaRecord>> queryPrecioumaRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PrecioumaRecord.collection,
      PrecioumaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PrecioumaRecord>> queryPrecioumaRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PrecioumaRecord.collection,
      PrecioumaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query FoliadorvalesRecords (as a Stream and as a Future).
Future<int> queryFoliadorvalesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      FoliadorvalesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<FoliadorvalesRecord>> queryFoliadorvalesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      FoliadorvalesRecord.collection,
      FoliadorvalesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<FoliadorvalesRecord>> queryFoliadorvalesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      FoliadorvalesRecord.collection,
      FoliadorvalesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query RespaldosRecords (as a Stream and as a Future).
Future<int> queryRespaldosRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      RespaldosRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<RespaldosRecord>> queryRespaldosRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      RespaldosRecord.collection,
      RespaldosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<RespaldosRecord>> queryRespaldosRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      RespaldosRecord.collection,
      RespaldosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<int> queryCollectionCount(
  Query collection, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0) {
    query = query.limit(limit);
  }

  return query.count().get().catchError((err) {
    print('Error querying $collection: $err');
  }).then((value) => value.count!);
}

Stream<List<T>> queryCollection<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.snapshots().handleError((err) {
    print('Error querying $collection: $err');
  }).map((s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

Future<List<T>> queryCollectionOnce<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.get().then((s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

Filter filterIn(String field, List? list) => (list?.isEmpty ?? true)
    ? Filter(field, whereIn: null)
    : Filter(field, whereIn: list);

Filter filterArrayContainsAny(String field, List? list) =>
    (list?.isEmpty ?? true)
        ? Filter(field, arrayContainsAny: null)
        : Filter(field, arrayContainsAny: list);

extension QueryExtension on Query {
  Query whereIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereIn: null)
      : where(field, whereIn: list);

  Query whereNotIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereNotIn: null)
      : where(field, whereNotIn: list);

  Query whereArrayContainsAny(String field, List? list) =>
      (list?.isEmpty ?? true)
          ? where(field, arrayContainsAny: null)
          : where(field, arrayContainsAny: list);
}

class FFFirestorePage<T> {
  final List<T> data;
  final Stream<List<T>>? dataStream;
  final QueryDocumentSnapshot? nextPageMarker;

  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
}

Future<FFFirestorePage<T>> queryCollectionPage<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) async {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection).limit(pageSize);
  if (nextPageMarker != null) {
    query = query.startAfterDocument(nextPageMarker);
  }
  Stream<QuerySnapshot>? docSnapshotStream;
  QuerySnapshot docSnapshot;
  if (isStream) {
    docSnapshotStream = query.snapshots();
    docSnapshot = await docSnapshotStream.first;
  } else {
    docSnapshot = await query.get();
  }
  final getDocs = (QuerySnapshot s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList();
  final data = getDocs(docSnapshot);
  final dataStream = docSnapshotStream?.map(getDocs);
  final nextPageToken = docSnapshot.docs.isEmpty ? null : docSnapshot.docs.last;
  return FFFirestorePage(data, dataStream, nextPageToken);
}

// Creates a Firestore document representing the logged in user if it doesn't yet exist
Future maybeCreateUser(User user) async {
  final userRecord = UsersRecord.collection.doc(user.uid);
  final userExists = await userRecord.get().then((u) => u.exists);
  if (userExists) {
    currentUserDocument = await UsersRecord.getDocumentOnce(userRecord);
    return;
  }

  final userData = createUsersRecordData(
    email: user.email ??
        FirebaseAuth.instance.currentUser?.email ??
        user.providerData.firstOrNull?.email,
    displayName:
        user.displayName ?? FirebaseAuth.instance.currentUser?.displayName,
    photoUrl: user.photoURL,
    uid: user.uid,
    phoneNumber: user.phoneNumber,
    createdTime: getCurrentTimestamp,
  );

  await userRecord.set(userData);
  currentUserDocument = UsersRecord.getDocumentFromData(userData, userRecord);
}

Future updateUserDocument({String? email}) async {
  await currentUserDocument?.reference
      .update(createUsersRecordData(email: email));
}
