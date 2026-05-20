import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'star4_model.dart';
export 'star4_model.dart';

class Star4Widget extends StatefulWidget {
  const Star4Widget({
    super.key,
    this.star4Par,
  });

  final CalificacionRecord? star4Par;

  @override
  State<Star4Widget> createState() => _Star4WidgetState();
}

class _Star4WidgetState extends State<Star4Widget> {
  late Star4Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Star4Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CalificacionRecord>(
      stream: CalificacionRecord.getDocument(widget.star4Par!.reference),
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

        final rowCalificacionRecord = snapshot.data!;

        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            RatingBar.builder(
              onRatingUpdate: (newValue) =>
                  safeSetState(() => _model.ratingBarValue = newValue),
              itemBuilder: (context, index) => Icon(
                Icons.star_rounded,
                color: FlutterFlowTheme.of(context).secondary,
              ),
              direction: Axis.horizontal,
              initialRating: _model.ratingBarValue ??=
                  rowCalificacionRecord.calificacion.toDouble(),
              unratedColor: Color(0xFF9E9E9E),
              itemCount: 5,
              itemSize: 40.0,
              glowColor: FlutterFlowTheme.of(context).secondary,
            ),
          ],
        );
      },
    );
  }
}
