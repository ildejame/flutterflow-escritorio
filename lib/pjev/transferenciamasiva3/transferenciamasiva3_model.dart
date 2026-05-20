import '/flutter_flow/flutter_flow_util.dart';
import 'transferenciamasiva3_widget.dart' show Transferenciamasiva3Widget;
import 'package:flutter/material.dart';

class Transferenciamasiva3Model
    extends FlutterFlowModel<Transferenciamasiva3Widget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Nivel1 widget.
  FocusNode? nivel1FocusNode;
  TextEditingController? nivel1TextController;
  String? Function(BuildContext, String?)? nivel1TextControllerValidator;
  // State field(s) for Nivel2 widget.
  FocusNode? nivel2FocusNode;
  TextEditingController? nivel2TextController;
  String? Function(BuildContext, String?)? nivel2TextControllerValidator;
  // State field(s) for Nivel3 widget.
  FocusNode? nivel3FocusNode;
  TextEditingController? nivel3TextController;
  String? Function(BuildContext, String?)? nivel3TextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nivel1FocusNode?.dispose();
    nivel1TextController?.dispose();

    nivel2FocusNode?.dispose();
    nivel2TextController?.dispose();

    nivel3FocusNode?.dispose();
    nivel3TextController?.dispose();
  }
}
