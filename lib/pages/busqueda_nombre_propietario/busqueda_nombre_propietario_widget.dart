import '/backend/backend.dart';
import '/components/busqueda_nombre/busqueda_nombre_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'busqueda_nombre_propietario_model.dart';
export 'busqueda_nombre_propietario_model.dart';

class BusquedaNombrePropietarioWidget extends StatefulWidget {
  const BusquedaNombrePropietarioWidget({super.key});

  static String routeName = 'BusquedaNombrePropietario';
  static String routePath = 'busquedaPorPropietario';

  @override
  State<BusquedaNombrePropietarioWidget> createState() =>
      _BusquedaNombrePropietarioWidgetState();
}

class _BusquedaNombrePropietarioWidgetState
    extends State<BusquedaNombrePropietarioWidget> {
  late BusquedaNombrePropietarioModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BusquedaNombrePropietarioModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EstablecimientosRecord>>(
      stream: queryEstablecimientosRecord(),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).accent3,
                  ),
                ),
              ),
            ),
          );
        }
        List<EstablecimientosRecord>
            busquedaNombrePropietarioEstablecimientosRecordList =
            snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
            appBar: AppBar(
              backgroundColor: Color(0xFF285C4D),
              automaticallyImplyLeading: true,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.keyboard_backspace_sharp,
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                  size: 30.0,
                ),
                onPressed: () async {
                  FFAppState().TipoAuto = '';
                  FFAppState().update(() {});
                  context.pop();
                },
              ),
              title: Text(
                FFLocalizations.of(context).getText(
                  'zyo87z5s' /* Establecimiento */,
                ),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.poppins(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: Colors.white,
                      fontSize: 24.0,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
              actions: [],
              centerTitle: true,
              elevation: 2.0,
            ),
            body: SafeArea(
              top: true,
              child: wrapWithModel(
                model: _model.busquedaNombreModel,
                updateCallback: () => safeSetState(() {}),
                child: BusquedaNombreWidget(),
              ),
            ),
          ),
        );
      },
    );
  }
}
