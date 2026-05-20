import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'busqueda_nombre_negocio_widget.dart' show BusquedaNombreNegocioWidget;
import 'package:flutter/material.dart';

class BusquedaNombreNegocioModel
    extends FlutterFlowModel<BusquedaNombreNegocioWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Buscar widget.
  final buscarKey = GlobalKey();
  FocusNode? buscarFocusNode;
  TextEditingController? buscarTextController;
  String? buscarSelectedOption;
  String? Function(BuildContext, String?)? buscarTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    buscarFocusNode?.dispose();
  }
}
