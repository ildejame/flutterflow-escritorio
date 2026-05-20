import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'reporteporusuario_widget.dart' show ReporteporusuarioWidget;
import 'package:flutter/material.dart';

class ReporteporusuarioModel extends FlutterFlowModel<ReporteporusuarioWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Nombre widget.
  final nombreKey = GlobalKey();
  FocusNode? nombreFocusNode;
  TextEditingController? nombreTextController;
  String? nombreSelectedOption;
  String? Function(BuildContext, String?)? nombreTextControllerValidator;
  // State field(s) for Supervisor widget.
  final supervisorKey = GlobalKey();
  FocusNode? supervisorFocusNode;
  TextEditingController? supervisorTextController;
  String? supervisorSelectedOption;
  String? Function(BuildContext, String?)? supervisorTextControllerValidator;
  // State field(s) for Nivel2 widget.
  final nivel2Key = GlobalKey();
  FocusNode? nivel2FocusNode;
  TextEditingController? nivel2TextController;
  String? nivel2SelectedOption;
  String? Function(BuildContext, String?)? nivel2TextControllerValidator;
  // State field(s) for Distrito widget.
  String? distritoValue;
  FormFieldController<String>? distritoValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreFocusNode?.dispose();

    supervisorFocusNode?.dispose();

    nivel2FocusNode?.dispose();
  }
}
