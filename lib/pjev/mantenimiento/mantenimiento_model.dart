import '/flutter_flow/flutter_flow_util.dart';
import 'mantenimiento_widget.dart' show MantenimientoWidget;
import 'package:flutter/material.dart';

class MantenimientoModel extends FlutterFlowModel<MantenimientoWidget> {
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
