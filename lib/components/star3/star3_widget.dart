import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'star3_model.dart';
export 'star3_model.dart';

class Star3Widget extends StatefulWidget {
  const Star3Widget({
    super.key,
    this.star3Par,
  });

  final DocumentReference? star3Par;

  @override
  State<Star3Widget> createState() => _Star3WidgetState();
}

class _Star3WidgetState extends State<Star3Widget> {
  late Star3Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Star3Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
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
              initialRating: _model.ratingBarValue ??= 3.0,
              unratedColor: Color(0xFF9E9E9E),
              itemCount: 5,
              itemSize: 40.0,
              glowColor: FlutterFlowTheme.of(context).secondary,
            ),
          ],
        ),
      ],
    );
  }
}
