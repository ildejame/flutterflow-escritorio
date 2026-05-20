import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'reporteporusuario2_widget.dart' show Reporteporusuario2Widget;
import 'package:flutter/material.dart';

class Reporteporusuario2Model
    extends FlutterFlowModel<Reporteporusuario2Widget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Nombre widget.
  FocusNode? nombreFocusNode;
  TextEditingController? nombreTextController;
  String? Function(BuildContext, String?)? nombreTextControllerValidator;
  // State field(s) for Supervisor widget.
  FocusNode? supervisorFocusNode;
  TextEditingController? supervisorTextController;
  String? Function(BuildContext, String?)? supervisorTextControllerValidator;
  // State field(s) for Nivel2 widget.
  FocusNode? nivel2FocusNode;
  TextEditingController? nivel2TextController;
  String? Function(BuildContext, String?)? nivel2TextControllerValidator;
  // State field(s) for Distrito widget.
  String? distritoValue;
  FormFieldController<String>? distritoValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreFocusNode?.dispose();
    nombreTextController?.dispose();

    supervisorFocusNode?.dispose();
    supervisorTextController?.dispose();

    nivel2FocusNode?.dispose();
    nivel2TextController?.dispose();
  }
}
