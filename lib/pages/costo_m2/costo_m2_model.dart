import '/flutter_flow/flutter_flow_util.dart';
import 'costo_m2_widget.dart' show CostoM2Widget;
import 'package:flutter/material.dart';

class CostoM2Model extends FlutterFlowModel<CostoM2Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for CostoM widget.
  FocusNode? costoMFocusNode;
  TextEditingController? costoMTextController;
  String? Function(BuildContext, String?)? costoMTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    costoMFocusNode?.dispose();
    costoMTextController?.dispose();
  }
}
