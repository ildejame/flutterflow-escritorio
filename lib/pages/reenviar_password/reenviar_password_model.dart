import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'reenviar_password_widget.dart' show ReenviarPasswordWidget;
import 'package:flutter/material.dart';

class ReenviarPasswordModel extends FlutterFlowModel<ReenviarPasswordWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();
  }
}
