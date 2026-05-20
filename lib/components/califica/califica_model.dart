import '/flutter_flow/flutter_flow_util.dart';
import 'califica_widget.dart' show CalificaWidget;
import 'package:flutter/material.dart';

class CalificaModel extends FlutterFlowModel<CalificaWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for RatingBar widget.
  double? ratingBarValue1;
  // State field(s) for Actu widget.
  FocusNode? actuFocusNode;
  TextEditingController? actuTextController;
  String? Function(BuildContext, String?)? actuTextControllerValidator;
  // State field(s) for RatingBar widget.
  double? ratingBarValue2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    actuFocusNode?.dispose();
    actuTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController2?.dispose();
  }
}
