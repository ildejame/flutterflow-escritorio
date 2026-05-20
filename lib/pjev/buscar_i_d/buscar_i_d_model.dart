import '/flutter_flow/flutter_flow_util.dart';
import 'buscar_i_d_widget.dart' show BuscarIDWidget;
import 'package:flutter/material.dart';

class BuscarIDModel extends FlutterFlowModel<BuscarIDWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Nombre widget.
  FocusNode? nombreFocusNode;
  TextEditingController? nombreTextController;
  String? Function(BuildContext, String?)? nombreTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreFocusNode?.dispose();
    nombreTextController?.dispose();
  }
}
