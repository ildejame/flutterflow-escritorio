import '/flutter_flow/flutter_flow_util.dart';
import 'buscar_infraccion_widget.dart' show BuscarInfraccionWidget;
import 'package:flutter/material.dart';

class BuscarInfraccionModel extends FlutterFlowModel<BuscarInfraccionWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for ClaveQR widget.
  FocusNode? claveQRFocusNode;
  TextEditingController? claveQRTextController;
  String? Function(BuildContext, String?)? claveQRTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    claveQRFocusNode?.dispose();
    claveQRTextController?.dispose();
  }
}
