import '/flutter_flow/flutter_flow_util.dart';
import 'cantidad_nueva_widget.dart' show CantidadNuevaWidget;
import 'package:flutter/material.dart';

class CantidadNuevaModel extends FlutterFlowModel<CantidadNuevaWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Actu widget.
  FocusNode? actuFocusNode;
  TextEditingController? actuTextController;
  String? Function(BuildContext, String?)? actuTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    actuFocusNode?.dispose();
    actuTextController?.dispose();
  }
}
