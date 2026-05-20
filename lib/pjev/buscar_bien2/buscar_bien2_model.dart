import '/flutter_flow/flutter_flow_util.dart';
import 'buscar_bien2_widget.dart' show BuscarBien2Widget;
import 'package:flutter/material.dart';

class BuscarBien2Model extends FlutterFlowModel<BuscarBien2Widget> {
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
