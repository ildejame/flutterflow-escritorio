import '/flutter_flow/flutter_flow_util.dart';
import 'reporteporresponsable_copy_widget.dart'
    show ReporteporresponsableCopyWidget;
import 'package:flutter/material.dart';

class ReporteporresponsableCopyModel
    extends FlutterFlowModel<ReporteporresponsableCopyWidget> {
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreFocusNode?.dispose();

    supervisorFocusNode?.dispose();
  }
}
