import '/flutter_flow/flutter_flow_util.dart';
import 'bajavale_widget.dart' show BajavaleWidget;
import 'package:flutter/material.dart';

class BajavaleModel extends FlutterFlowModel<BajavaleWidget> {
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
