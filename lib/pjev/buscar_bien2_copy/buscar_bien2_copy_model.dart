import '/flutter_flow/flutter_flow_util.dart';
import 'buscar_bien2_copy_widget.dart' show BuscarBien2CopyWidget;
import 'package:flutter/material.dart';

class BuscarBien2CopyModel extends FlutterFlowModel<BuscarBien2CopyWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Nombre widget.
  FocusNode? nombreFocusNode;
  TextEditingController? nombreTextController;
  String? Function(BuildContext, String?)? nombreTextControllerValidator;
  // Stores action output result for [Custom Action - buscarBienMueble] action in Button widget.
  dynamic idbuscar;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreFocusNode?.dispose();
    nombreTextController?.dispose();
  }
}
