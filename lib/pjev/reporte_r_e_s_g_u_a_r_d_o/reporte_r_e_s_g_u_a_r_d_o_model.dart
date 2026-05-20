import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'reporte_r_e_s_g_u_a_r_d_o_widget.dart' show ReporteRESGUARDOWidget;
import 'package:flutter/material.dart';

class ReporteRESGUARDOModel extends FlutterFlowModel<ReporteRESGUARDOWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Folio widget.
  FocusNode? folioFocusNode;
  TextEditingController? folioTextController;
  String? Function(BuildContext, String?)? folioTextControllerValidator;
  // State field(s) for Atencion widget.
  FocusNode? atencionFocusNode;
  TextEditingController? atencionTextController;
  String? Function(BuildContext, String?)? atencionTextControllerValidator;
  // State field(s) for Filtro widget.
  FocusNode? filtroFocusNode;
  TextEditingController? filtroTextController;
  String? Function(BuildContext, String?)? filtroTextControllerValidator;
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
    folioFocusNode?.dispose();
    folioTextController?.dispose();

    atencionFocusNode?.dispose();
    atencionTextController?.dispose();

    filtroFocusNode?.dispose();
    filtroTextController?.dispose();

    nombreFocusNode?.dispose();

    supervisorFocusNode?.dispose();

    nivel2FocusNode?.dispose();
  }
}
