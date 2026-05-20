import '/flutter_flow/flutter_flow_util.dart';
import 'transferenciamasiva_widget.dart' show TransferenciamasivaWidget;
import 'package:flutter/material.dart';

class TransferenciamasivaModel
    extends FlutterFlowModel<TransferenciamasivaWidget> {
  ///  State fields for stateful widgets in this component.

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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nivel1FocusNode?.dispose();

    nivel2FocusNode?.dispose();

    nivel3FocusNode?.dispose();
  }
}
