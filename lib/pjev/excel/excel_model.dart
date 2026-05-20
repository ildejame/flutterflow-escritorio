import '/flutter_flow/flutter_flow_util.dart';
import 'excel_widget.dart' show ExcelWidget;
import 'package:flutter/material.dart';

class ExcelModel extends FlutterFlowModel<ExcelWidget> {
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
