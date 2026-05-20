import '/flutter_flow/flutter_flow_util.dart';
import 'buscar_bien_copy_widget.dart' show BuscarBienCopyWidget;
import 'package:flutter/material.dart';

class BuscarBienCopyModel extends FlutterFlowModel<BuscarBienCopyWidget> {
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
