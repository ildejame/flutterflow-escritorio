import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'editar_u_m_a_s_widget.dart' show EditarUMASWidget;
import 'package:flutter/material.dart';

class EditarUMASModel extends FlutterFlowModel<EditarUMASWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for AnioUMA widget.
  FocusNode? anioUMAFocusNode;
  TextEditingController? anioUMATextController;
  String? Function(BuildContext, String?)? anioUMATextControllerValidator;
  // State field(s) for PrecioUMA widget.
  FocusNode? precioUMAFocusNode;
  TextEditingController? precioUMATextController;
  String? Function(BuildContext, String?)? precioUMATextControllerValidator;
  // State field(s) for UMASxM2 widget.
  FocusNode? uMASxM2FocusNode;
  TextEditingController? uMASxM2TextController;
  String? Function(BuildContext, String?)? uMASxM2TextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    anioUMAFocusNode?.dispose();
    anioUMATextController?.dispose();

    precioUMAFocusNode?.dispose();
    precioUMATextController?.dispose();

    uMASxM2FocusNode?.dispose();
    uMASxM2TextController?.dispose();
  }
}
