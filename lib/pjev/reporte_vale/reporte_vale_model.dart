import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'reporte_vale_widget.dart' show ReporteValeWidget;
import 'package:flutter/material.dart';

class ReporteValeModel extends FlutterFlowModel<ReporteValeWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Folio widget.
  FocusNode? folioFocusNode;
  TextEditingController? folioTextController;
  String? Function(BuildContext, String?)? folioTextControllerValidator;
  // State field(s) for Atencion widget.
  FocusNode? atencionFocusNode;
  TextEditingController? atencionTextController;
  String? Function(BuildContext, String?)? atencionTextControllerValidator;
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
  // State field(s) for Nivel1 widget.
  final nivel1Key = GlobalKey();
  FocusNode? nivel1FocusNode;
  TextEditingController? nivel1TextController;
  String? nivel1SelectedOption;
  String? Function(BuildContext, String?)? nivel1TextControllerValidator;
  // State field(s) for Nivel2 widget.
  final nivel2Key = GlobalKey();
  FocusNode? nivel2FocusNode;
  TextEditingController? nivel2TextController;
  String? nivel2SelectedOption;
  String? Function(BuildContext, String?)? nivel2TextControllerValidator;
  // State field(s) for Nivel3 widget.
  final nivel3Key = GlobalKey();
  FocusNode? nivel3FocusNode;
  TextEditingController? nivel3TextController;
  String? nivel3SelectedOption;
  String? Function(BuildContext, String?)? nivel3TextControllerValidator;
  // State field(s) for Distrito widget.
  String? distritoValue;
  FormFieldController<String>? distritoValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    folioFocusNode?.dispose();
    folioTextController?.dispose();

    atencionFocusNode?.dispose();
    atencionTextController?.dispose();

    nombreFocusNode?.dispose();

    supervisorFocusNode?.dispose();

    nivel1FocusNode?.dispose();

    nivel2FocusNode?.dispose();

    nivel3FocusNode?.dispose();
  }
}
