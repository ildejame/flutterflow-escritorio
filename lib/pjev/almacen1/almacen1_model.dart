import '/flutter_flow/flutter_flow_util.dart';
import 'almacen1_widget.dart' show Almacen1Widget;
import 'package:flutter/material.dart';

class Almacen1Model extends FlutterFlowModel<Almacen1Widget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Categoria widget.
  final categoriaKey = GlobalKey();
  FocusNode? categoriaFocusNode;
  TextEditingController? categoriaTextController;
  String? categoriaSelectedOption;
  String? Function(BuildContext, String?)? categoriaTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    categoriaFocusNode?.dispose();
  }
}
