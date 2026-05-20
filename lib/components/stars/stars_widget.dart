import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'stars_model.dart';
export 'stars_model.dart';

class StarsWidget extends StatefulWidget {
  const StarsWidget({
    super.key,
    this.parametrosComponCalif,
  });

  final DocumentReference? parametrosComponCalif;

  @override
  State<StarsWidget> createState() => _StarsWidgetState();
}

class _StarsWidgetState extends State<StarsWidget> {
  late StarsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StarsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CalificacionRecord>>(
      stream: queryCalificacionRecord(
        queryBuilder: (calificacionRecord) => calificacionRecord.where(
          'LugarServicio',
          isEqualTo: widget.parametrosComponCalif,
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
        List<CalificacionRecord> columnCalificacionRecordList = snapshot.data!;

        return Column(
          mainAxisSize: MainAxisSize.max,
          children:
              List.generate(columnCalificacionRecordList.length, (columnIndex) {
            final columnCalificacionRecord =
                columnCalificacionRecordList[columnIndex];
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
                  child: RatingBarIndicator(
                    itemBuilder: (context, index) => Icon(
                      Icons.star_rounded,
                      color: Color(0xFFF8BF00),
                    ),
                    direction: Axis.horizontal,
                    rating: columnCalificacionRecord.calificacion.toDouble(),
                    unratedColor: Color(0xFF9E9E9E),
                    itemCount: 5,
                    itemSize: 40.0,
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
