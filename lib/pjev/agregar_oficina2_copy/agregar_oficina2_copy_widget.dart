import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'agregar_oficina2_copy_model.dart';
export 'agregar_oficina2_copy_model.dart';

class AgregarOficina2CopyWidget extends StatefulWidget {
  const AgregarOficina2CopyWidget({super.key});

  @override
  State<AgregarOficina2CopyWidget> createState() =>
      _AgregarOficina2CopyWidgetState();
}

class _AgregarOficina2CopyWidgetState extends State<AgregarOficina2CopyWidget> {
  late AgregarOficina2CopyModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AgregarOficina2CopyModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE7E7BD),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'sn14zswi' /* Sincronizar en caso de que
alg... */
                          ,
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .displaySmall
                            .override(
                              font: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .fontStyle,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<List<OficinasPJEVRecord>>(
                        stream: queryOficinasPJEVRecord(),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).accent3,
                                  ),
                                ),
                              ),
                            );
                          }
                          List<OficinasPJEVRecord>
                              buttonOficinasPJEVRecordList = snapshot.data!;

                          return FFButtonWidget(
                            onPressed: () async {
                              FFAppState().busquedarapidalugares = [];
                              FFAppState().ubicacionnivel1 = [];
                              FFAppState().ubicacionnivel2 = [];
                              FFAppState().ubicacionnivel3 = [];
                              FFAppState().busquedarapidalugares =
                                  buttonOficinasPJEVRecordList
                                      .map((e) => valueOrDefault<String>(
                                            e.nombre,
                                            'Sin información adicional',
                                          ))
                                      .toList()
                                      .cast<String>();
                              FFAppState().ubicacionnivel1 = functions
                                  .getlistfilter(buttonOficinasPJEVRecordList
                                      .map((e) => valueOrDefault<String>(
                                            e.nombre1,
                                            'Sin información adicional',
                                          ))
                                      .toList())!
                                  .toList()
                                  .cast<String>();
                              FFAppState().ubicacionnivel2 = functions
                                  .getlistfilter(buttonOficinasPJEVRecordList
                                      .map((e) => valueOrDefault<String>(
                                            e.nombre2,
                                            'Sin información adicional',
                                          ))
                                      .toList())!
                                  .toList()
                                  .cast<String>();
                              FFAppState().ubicacionnivel3 = functions
                                  .getlistfilter(buttonOficinasPJEVRecordList
                                      .map((e) => valueOrDefault<String>(
                                            e.nombre3,
                                            'Sin información adicional',
                                          ))
                                      .toList())!
                                  .toList()
                                  .cast<String>();
                              Navigator.pop(context);
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('Terminado'),
                                    content: Text(
                                        'Las ubicaciones se han actualizado correctamente'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            text: FFLocalizations.of(context).getText(
                              '25jjmc8o' /* Sincronizar */,
                            ),
                            icon: Icon(
                              Icons.system_update_alt,
                              size: 15.0,
                            ),
                            options: FFButtonOptions(
                              width: 180.0,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 2.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).accent3,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
