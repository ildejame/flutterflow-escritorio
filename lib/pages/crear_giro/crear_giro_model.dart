import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'crear_giro_widget.dart' show CrearGiroWidget;
import 'package:flutter/material.dart';

class CrearGiroModel extends FlutterFlowModel<CrearGiroWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for NombreCategoriaNegocio widget.
  FocusNode? nombreCategoriaNegocioFocusNode;
  TextEditingController? nombreCategoriaNegocioTextController;
  String? Function(BuildContext, String?)?
      nombreCategoriaNegocioTextControllerValidator;
  // State field(s) for NumeroUMAS widget.
  FocusNode? numeroUMASFocusNode;
  TextEditingController? numeroUMASTextController;
  String? Function(BuildContext, String?)? numeroUMASTextControllerValidator;
  // State field(s) for UMASRefrendo widget.
  FocusNode? uMASRefrendoFocusNode;
  TextEditingController? uMASRefrendoTextController;
  String? Function(BuildContext, String?)? uMASRefrendoTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreCategoriaNegocioFocusNode?.dispose();
    nombreCategoriaNegocioTextController?.dispose();

    numeroUMASFocusNode?.dispose();
    numeroUMASTextController?.dispose();

    uMASRefrendoFocusNode?.dispose();
    uMASRefrendoTextController?.dispose();
  }
}
