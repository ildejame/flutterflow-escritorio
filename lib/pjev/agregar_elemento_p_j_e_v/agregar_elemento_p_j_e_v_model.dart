import '/flutter_flow/flutter_flow_util.dart';
import 'agregar_elemento_p_j_e_v_widget.dart' show AgregarElementoPJEVWidget;
import 'package:flutter/material.dart';

class AgregarElementoPJEVModel
    extends FlutterFlowModel<AgregarElementoPJEVWidget> {
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
