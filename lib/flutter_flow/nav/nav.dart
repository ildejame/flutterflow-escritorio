import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';

import '/auth/base_auth_user_provider.dart';

import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? HomeWidget() : LoginPJEVWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) =>
              appStateNotifier.loggedIn ? HomeWidget() : LoginPJEVWidget(),
          routes: [
            FFRoute(
              name: CrearCuentaWidget.routeName,
              path: CrearCuentaWidget.routePath,
              builder: (context, params) => CrearCuentaWidget(),
            ),
            FFRoute(
              name: UbicaLugarWidget.routeName,
              path: UbicaLugarWidget.routePath,
              builder: (context, params) => UbicaLugarWidget(),
            ),
            FFRoute(
              name: InfraccionesMotosWidget.routeName,
              path: InfraccionesMotosWidget.routePath,
              builder: (context, params) => InfraccionesMotosWidget(),
            ),
            FFRoute(
              name: Parametros1Widget.routeName,
              path: Parametros1Widget.routePath,
              builder: (context, params) => Parametros1Widget(
                carrusel: params.getParam(
                  'carrusel',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Infracciones'],
                ),
              ),
            ),
            FFRoute(
              name: InfraccionesBusquedaWidget.routeName,
              path: InfraccionesBusquedaWidget.routePath,
              builder: (context, params) => InfraccionesBusquedaWidget(),
            ),
            FFRoute(
              name: EditarDatosPersonalesWidget.routeName,
              path: EditarDatosPersonalesWidget.routePath,
              builder: (context, params) => EditarDatosPersonalesWidget(
                usersParam: params.getParam(
                  'usersParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['users'],
                ),
              ),
            ),
            FFRoute(
              name: ActivosWidget.routeName,
              path: ActivosWidget.routePath,
              builder: (context, params) => ActivosWidget(),
            ),
            FFRoute(
              name: ListaComerciosWidget.routeName,
              path: ListaComerciosWidget.routePath,
              builder: (context, params) => ListaComerciosWidget(),
            ),
            FFRoute(
              name: VerComercioWidget.routeName,
              path: VerComercioWidget.routePath,
              builder: (context, params) => VerComercioWidget(
                vercomercioParam: params.getParam(
                  'vercomercioParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: PrecioM2Widget.routeName,
              path: PrecioM2Widget.routePath,
              builder: (context, params) => PrecioM2Widget(
                usersParam: params.getParam(
                  'usersParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['users'],
                ),
              ),
            ),
            FFRoute(
              name: EdicionWidget.routeName,
              path: EdicionWidget.routePath,
              builder: (context, params) => EdicionWidget(
                edicionParametros: params.getParam(
                  'edicionParametros',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: FormatoComercioWidget.routeName,
              path: FormatoComercioWidget.routePath,
              builder: (context, params) => FormatoComercioWidget(
                infracParam: params.getParam(
                  'infracParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['InfMotos'],
                ),
              ),
            ),
            FFRoute(
              name: EditComercioWidget.routeName,
              path: EditComercioWidget.routePath,
              builder: (context, params) => EditComercioWidget(
                vercomercioParam: params.getParam(
                  'vercomercioParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: CostoM2Widget.routeName,
              path: CostoM2Widget.routePath,
              builder: (context, params) => CostoM2Widget(
                usersParam: params.getParam(
                  'usersParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['users'],
                ),
              ),
            ),
            FFRoute(
              name: QRPageWidget.routeName,
              path: QRPageWidget.routePath,
              builder: (context, params) => QRPageWidget(),
            ),
            FFRoute(
              name: ReenviarPasswordWidget.routeName,
              path: ReenviarPasswordWidget.routePath,
              builder: (context, params) => ReenviarPasswordWidget(),
            ),
            FFRoute(
              name: CuentaDiarioWidget.routeName,
              path: CuentaDiarioWidget.routePath,
              builder: (context, params) => CuentaDiarioWidget(),
            ),
            FFRoute(
              name: EditarUMASWidget.routeName,
              path: EditarUMASWidget.routePath,
              builder: (context, params) => EditarUMASWidget(
                usersParam: params.getParam(
                  'usersParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['users'],
                ),
              ),
            ),
            FFRoute(
              name: VencidosWidget.routeName,
              path: VencidosWidget.routePath,
              builder: (context, params) => VencidosWidget(),
            ),
            FFRoute(
              name: PagosDiariosWidget.routeName,
              path: PagosDiariosWidget.routePath,
              builder: (context, params) => PagosDiariosWidget(),
            ),
            FFRoute(
              name: ComercioInicioWidget.routeName,
              path: ComercioInicioWidget.routePath,
              builder: (context, params) => ComercioInicioWidget(),
            ),
            FFRoute(
              name: CrearBienWidget.routeName,
              path: CrearBienWidget.routePath,
              builder: (context, params) => CrearBienWidget(
                usersParam: params.getParam(
                  'usersParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['users'],
                ),
              ),
            ),
            FFRoute(
              name: QRPageNombreNegocioWidget.routeName,
              path: QRPageNombreNegocioWidget.routePath,
              builder: (context, params) => QRPageNombreNegocioWidget(),
            ),
            FFRoute(
              name: BusquedaNombreNegocioWidget.routeName,
              path: BusquedaNombreNegocioWidget.routePath,
              builder: (context, params) => BusquedaNombreNegocioWidget(),
            ),
            FFRoute(
              name: EditPortadaWidget.routeName,
              path: EditPortadaWidget.routePath,
              builder: (context, params) => EditPortadaWidget(
                vercomercioParam: params.getParam(
                  'vercomercioParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: EditUbicacionWidget.routeName,
              path: EditUbicacionWidget.routePath,
              builder: (context, params) => EditUbicacionWidget(
                vercomercioParam: params.getParam(
                  'vercomercioParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: EditFotosCompWidget.routeName,
              path: EditFotosCompWidget.routePath,
              builder: (context, params) => EditFotosCompWidget(
                vercomercioParam: params.getParam(
                  'vercomercioParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: CrearGiroWidget.routeName,
              path: CrearGiroWidget.routePath,
              builder: (context, params) => CrearGiroWidget(
                usersParam: params.getParam(
                  'usersParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['users'],
                ),
              ),
            ),
            FFRoute(
              name: DescripcionRutaWidget.routeName,
              path: DescripcionRutaWidget.routePath,
              builder: (context, params) => DescripcionRutaWidget(),
            ),
            FFRoute(
              name: TotalComerciosWidget.routeName,
              path: TotalComerciosWidget.routePath,
              builder: (context, params) => TotalComerciosWidget(),
            ),
            FFRoute(
              name: DescripcionRutaCopyWidget.routeName,
              path: DescripcionRutaCopyWidget.routePath,
              builder: (context, params) => DescripcionRutaCopyWidget(),
            ),
            FFRoute(
              name: VerComercioImprimirWidget.routeName,
              path: VerComercioImprimirWidget.routePath,
              builder: (context, params) => VerComercioImprimirWidget(
                vercomercioParam: params.getParam(
                  'vercomercioParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: BusquedaNombrePropietarioWidget.routeName,
              path: BusquedaNombrePropietarioWidget.routePath,
              builder: (context, params) => BusquedaNombrePropietarioWidget(),
            ),
            FFRoute(
              name: DescargaWidget.routeName,
              path: DescargaWidget.routePath,
              builder: (context, params) => DescargaWidget(),
            ),
            FFRoute(
              name: MapaColoresWidget.routeName,
              path: MapaColoresWidget.routePath,
              builder: (context, params) => MapaColoresWidget(),
            ),
            FFRoute(
              name: DescargaCopyWidget.routeName,
              path: DescargaCopyWidget.routePath,
              builder: (context, params) => DescargaCopyWidget(),
            ),
            FFRoute(
              name: ArchivoInfraccionesWidget.routeName,
              path: ArchivoInfraccionesWidget.routePath,
              builder: (context, params) => ArchivoInfraccionesWidget(),
            ),
            FFRoute(
              name: FiltrosGiroWidget.routeName,
              path: FiltrosGiroWidget.routePath,
              builder: (context, params) => FiltrosGiroWidget(),
            ),
            FFRoute(
              name: PendientesAnualWidget.routeName,
              path: PendientesAnualWidget.routePath,
              builder: (context, params) => PendientesAnualWidget(),
            ),
            FFRoute(
              name: PagosDiariosCopyWidget.routeName,
              path: PagosDiariosCopyWidget.routePath,
              builder: (context, params) => PagosDiariosCopyWidget(),
            ),
            FFRoute(
              name: PagosDiaWidget.routeName,
              path: PagosDiaWidget.routePath,
              builder: (context, params) => PagosDiaWidget(),
            ),
            FFRoute(
              name: CuentaDiarioCopyCopyWidget.routeName,
              path: CuentaDiarioCopyCopyWidget.routePath,
              builder: (context, params) => CuentaDiarioCopyCopyWidget(),
            ),
            FFRoute(
              name: ListaPagosAnualesWidget.routeName,
              path: ListaPagosAnualesWidget.routePath,
              builder: (context, params) => ListaPagosAnualesWidget(),
            ),
            FFRoute(
              name: ListaPagosAnualesCopyWidget.routeName,
              path: ListaPagosAnualesCopyWidget.routePath,
              builder: (context, params) => ListaPagosAnualesCopyWidget(),
            ),
            FFRoute(
              name: VerComentariosWidget.routeName,
              path: VerComentariosWidget.routePath,
              builder: (context, params) => VerComentariosWidget(
                comercioParam: params.getParam(
                  'comercioParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: EscanearDocumentoWidget.routeName,
              path: EscanearDocumentoWidget.routePath,
              builder: (context, params) => EscanearDocumentoWidget(
                comercioParam: params.getParam(
                  'comercioParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: VerEscaneoWidget.routeName,
              path: VerEscaneoWidget.routePath,
              builder: (context, params) => VerEscaneoWidget(
                comercioParam: params.getParam(
                  'comercioParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: AnualRecordatorioWidget.routeName,
              path: AnualRecordatorioWidget.routePath,
              builder: (context, params) => AnualRecordatorioWidget(),
            ),
            FFRoute(
              name: VerEscaneoCopyWidget.routeName,
              path: VerEscaneoCopyWidget.routePath,
              builder: (context, params) => VerEscaneoCopyWidget(
                comercioParam: params.getParam(
                  'comercioParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['Establecimientos'],
                ),
              ),
            ),
            FFRoute(
              name: PendientesAnualCopyWidget.routeName,
              path: PendientesAnualCopyWidget.routePath,
              builder: (context, params) => PendientesAnualCopyWidget(),
            ),
            FFRoute(
              name: InfoUsuariosWidget.routeName,
              path: InfoUsuariosWidget.routePath,
              builder: (context, params) => InfoUsuariosWidget(),
            ),
            FFRoute(
              name: LoginPJEVWidget.routeName,
              path: LoginPJEVWidget.routePath,
              builder: (context, params) => LoginPJEVWidget(),
            ),
            FFRoute(
              name: BitacoraWidget.routeName,
              path: BitacoraWidget.routePath,
              builder: (context, params) => BitacoraWidget(),
            ),
            FFRoute(
              name: EditarBienWidget.routeName,
              path: EditarBienWidget.routePath,
              asyncParams: {
                'paramBien':
                    getDoc(['bienesmuebles'], BienesmueblesRecord.fromSnapshot),
              },
              builder: (context, params) => EditarBienWidget(
                paramBien: params.getParam(
                  'paramBien',
                  ParamType.Document,
                ),
              ),
            ),
            FFRoute(
              name: CatalogosWidget.routeName,
              path: CatalogosWidget.routePath,
              builder: (context, params) => CatalogosWidget(),
            ),
            FFRoute(
              name: DepositariosWidget.routeName,
              path: DepositariosWidget.routePath,
              builder: (context, params) => DepositariosWidget(),
            ),
            FFRoute(
              name: DepreciacionWidget.routeName,
              path: DepreciacionWidget.routePath,
              builder: (context, params) => DepreciacionWidget(),
            ),
            FFRoute(
              name: UbicacionesWidget.routeName,
              path: UbicacionesWidget.routePath,
              builder: (context, params) => UbicacionesWidget(),
            ),
            FFRoute(
              name: ReportesWidget.routeName,
              path: ReportesWidget.routePath,
              builder: (context, params) => ReportesWidget(),
            ),
            FFRoute(
              name: CrearBienCopyWidget.routeName,
              path: CrearBienCopyWidget.routePath,
              builder: (context, params) => CrearBienCopyWidget(
                usersParam: params.getParam(
                  'usersParam',
                  ParamType.DocumentReference,
                  isList: false,
                  collectionNamePath: ['users'],
                ),
              ),
            ),
            FFRoute(
              name: HomeWidget.routeName,
              path: HomeWidget.routePath,
              builder: (context, params) => HomeWidget(),
            ),
            FFRoute(
              name: BajaWidget.routeName,
              path: BajaWidget.routePath,
              asyncParams: {
                'editbienes':
                    getDoc(['bienesmuebles'], BienesmueblesRecord.fromSnapshot),
              },
              builder: (context, params) => BajaWidget(
                editbienes: params.getParam(
                  'editbienes',
                  ParamType.Document,
                ),
              ),
            ),
            FFRoute(
              name: ValesWidget.routeName,
              path: ValesWidget.routePath,
              builder: (context, params) => ValesWidget(),
            ),
            FFRoute(
              name: VerbienWidget.routeName,
              path: VerbienWidget.routePath,
              builder: (context, params) => VerbienWidget(),
            ),
            FFRoute(
              name: AltaRepTransMantWidget.routeName,
              path: AltaRepTransMantWidget.routePath,
              asyncParams: {
                'editbienes':
                    getDoc(['bienesmuebles'], BienesmueblesRecord.fromSnapshot),
              },
              builder: (context, params) => AltaRepTransMantWidget(
                editbienes: params.getParam(
                  'editbienes',
                  ParamType.Document,
                ),
              ),
            ),
            FFRoute(
              name: MantenimientoValeWidget.routeName,
              path: MantenimientoValeWidget.routePath,
              asyncParams: {
                'editbienes':
                    getDoc(['bienesmuebles'], BienesmueblesRecord.fromSnapshot),
              },
              builder: (context, params) => MantenimientoValeWidget(
                editbienes: params.getParam(
                  'editbienes',
                  ParamType.Document,
                ),
              ),
            ),
            FFRoute(
              name: TransferenciaWidget.routeName,
              path: TransferenciaWidget.routePath,
              asyncParams: {
                'editbienes':
                    getDoc(['bienesmuebles'], BienesmueblesRecord.fromSnapshot),
              },
              builder: (context, params) => TransferenciaWidget(
                editbienes: params.getParam(
                  'editbienes',
                  ParamType.Document,
                ),
              ),
            ),
            FFRoute(
              name: VerbienCopyWidget.routeName,
              path: VerbienCopyWidget.routePath,
              asyncParams: {
                'editbienes':
                    getDoc(['bienesmuebles'], BienesmueblesRecord.fromSnapshot),
              },
              builder: (context, params) => VerbienCopyWidget(
                editbienes: params.getParam(
                  'editbienes',
                  ParamType.Document,
                ),
              ),
            ),
            FFRoute(
              name: Transferenciamasiva2Widget.routeName,
              path: Transferenciamasiva2Widget.routePath,
              builder: (context, params) => Transferenciamasiva2Widget(),
            ),
            FFRoute(
              name: Verbien2Widget.routeName,
              path: Verbien2Widget.routePath,
              builder: (context, params) => Verbien2Widget(),
            ),
            FFRoute(
              name: BajaCopyWidget.routeName,
              path: BajaCopyWidget.routePath,
              asyncParams: {
                'editbienes':
                    getDoc(['bienesmuebles'], BienesmueblesRecord.fromSnapshot),
              },
              builder: (context, params) => BajaCopyWidget(
                editbienes: params.getParam(
                  'editbienes',
                  ParamType.Document,
                ),
              ),
            ),
            FFRoute(
              name: IniciarvaleWidget.routeName,
              path: IniciarvaleWidget.routePath,
              asyncParams: {
                'editbienes':
                    getDoc(['bienesmuebles'], BienesmueblesRecord.fromSnapshot),
              },
              builder: (context, params) => IniciarvaleWidget(
                editbienes: params.getParam(
                  'editbienes',
                  ParamType.Document,
                ),
              ),
            ),
            FFRoute(
              name: Almacen3Widget.routeName,
              path: Almacen3Widget.routePath,
              builder: (context, params) => Almacen3Widget(),
            ),
            FFRoute(
              name: InicioWidget.routeName,
              path: InicioWidget.routePath,
              builder: (context, params) => InicioWidget(),
            ),
            FFRoute(
              name: UsuariosWidget.routeName,
              path: UsuariosWidget.routePath,
              builder: (context, params) => UsuariosWidget(),
            ),
            FFRoute(
              name: Vales02Widget.routeName,
              path: Vales02Widget.routePath,
              builder: (context, params) => Vales02Widget(),
            ),
            FFRoute(
              name: HomeRespaldoWidget.routeName,
              path: HomeRespaldoWidget.routePath,
              builder: (context, params) => HomeRespaldoWidget(),
            ),
            FFRoute(
              name: HomeDiciembre2025Widget.routeName,
              path: HomeDiciembre2025Widget.routePath,
              builder: (context, params) => HomeDiciembre2025Widget(),
            ),
            FFRoute(
              name: ActivosrespaldoWidget.routeName,
              path: ActivosrespaldoWidget.routePath,
              builder: (context, params) => ActivosrespaldoWidget(),
            ),
            FFRoute(
              name: Homeenero2026Widget.routeName,
              path: Homeenero2026Widget.routePath,
              builder: (context, params) => Homeenero2026Widget(),
            ),
            FFRoute(
              name: HomefebreroWidget.routeName,
              path: HomefebreroWidget.routePath,
              builder: (context, params) => HomefebreroWidget(),
            ),
            FFRoute(
              name: IniciarvaleCopyWidget.routeName,
              path: IniciarvaleCopyWidget.routePath,
              asyncParams: {
                'editbienes':
                    getDoc(['bienesmuebles'], BienesmueblesRecord.fromSnapshot),
              },
              builder: (context, params) => IniciarvaleCopyWidget(
                editbienes: params.getParam(
                  'editbienes',
                  ParamType.Document,
                ),
              ),
            ),
            FFRoute(
              name: VerbienCopy2Widget.routeName,
              path: VerbienCopy2Widget.routePath,
              builder: (context, params) => VerbienCopy2Widget(),
            ),
            FFRoute(
              name: EditarBienCopyWidget.routeName,
              path: EditarBienCopyWidget.routePath,
              asyncParams: {
                'paramBien':
                    getDoc(['bienesmuebles'], BienesmueblesRecord.fromSnapshot),
              },
              builder: (context, params) => EditarBienCopyWidget(
                paramBien: params.getParam(
                  'paramBien',
                  ParamType.Document,
                ),
              ),
            ),
            FFRoute(
              name: UbicacionesCopyWidget.routeName,
              path: UbicacionesCopyWidget.routePath,
              builder: (context, params) => UbicacionesCopyWidget(),
            )
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
      observers: [routeObserver],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/loginPJEV';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Image.asset(
                      'assets/images/logopjev.png',
                      width: 300.0,
                      height: 200.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
