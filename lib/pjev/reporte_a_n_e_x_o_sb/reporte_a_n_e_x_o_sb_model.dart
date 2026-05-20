import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'reporte_a_n_e_x_o_sb_widget.dart' show ReporteANEXOSbWidget;
import 'package:flutter/material.dart';

class ReporteANEXOSbModel extends FlutterFlowModel<ReporteANEXOSbWidget> {
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
  // State field(s) for Distrito widget.
  String? distritoValue;
  FormFieldController<String>? distritoValueController;

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
