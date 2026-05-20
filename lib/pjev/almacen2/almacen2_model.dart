import '/flutter_flow/flutter_flow_util.dart';
import 'almacen2_widget.dart' show Almacen2Widget;
import 'package:flutter/material.dart';

class Almacen2Model extends FlutterFlowModel<Almacen2Widget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Categoria widget.
  FocusNode? categoriaFocusNode;
  TextEditingController? categoriaTextController;
  String? Function(BuildContext, String?)? categoriaTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    categoriaFocusNode?.dispose();
    categoriaTextController?.dispose();
  }
}
