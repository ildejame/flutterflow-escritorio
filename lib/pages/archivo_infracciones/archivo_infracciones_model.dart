import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'archivo_infracciones_widget.dart' show ArchivoInfraccionesWidget;
import 'package:flutter/material.dart';

class ArchivoInfraccionesModel
    extends FlutterFlowModel<ArchivoInfraccionesWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
