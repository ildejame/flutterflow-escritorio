import '/flutter_flow/flutter_flow_util.dart';
import 'busqueda_nombre_widget.dart' show BusquedaNombreWidget;
import 'package:flutter/material.dart';

class BusquedaNombreModel extends FlutterFlowModel<BusquedaNombreWidget> {
  ///  State fields for stateful widgets in this component.

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
