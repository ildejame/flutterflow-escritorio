import '/backend/backend.dart';
import '/components/raiting/raiting_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calif_componente_copy_copy_model.dart';
export 'calif_componente_copy_copy_model.dart';

class CalifComponenteCopyCopyWidget extends StatefulWidget {
  const CalifComponenteCopyCopyWidget({
    super.key,
    this.parametrosComponCalif,
  });

  final LugaresRecord? parametrosComponCalif;

  @override
  State<CalifComponenteCopyCopyWidget> createState() =>
      _CalifComponenteCopyCopyWidgetState();
}

class _CalifComponenteCopyCopyWidgetState
    extends State<CalifComponenteCopyCopyWidget> {
  late CalifComponenteCopyCopyModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalifComponenteCopyCopyModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'ka52libp' /* Calif. Promedio */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        '9jrylh0d' /* Hello World */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StreamBuilder<List<CalificacionRecord>>(
          stream: queryCalificacionRecord(
            queryBuilder: (calificacionRecord) => calificacionRecord.where(
              'LugarServicio',
              isEqualTo: widget.parametrosComponCalif?.reference,
            ),
          ),
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
            List<CalificacionRecord> raitingCalificacionRecordList =
                snapshot.data!;

            return wrapWithModel(
              model: _model.raitingModel,
              updateCallback: () => safeSetState(() {}),
              child: RaitingWidget(
                raitingParam: widget.parametrosComponCalif?.reference,
              ),
            );
          },
        ),
      ],
    );
  }
}
