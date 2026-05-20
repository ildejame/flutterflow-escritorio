import '/flutter_flow/flutter_flow_util.dart';
import 'agregar_trabajador_p_j_e_v_widget.dart'
    show AgregarTrabajadorPJEVWidget;
import 'package:flutter/material.dart';

class AgregarTrabajadorPJEVModel
    extends FlutterFlowModel<AgregarTrabajadorPJEVWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Nombre widget.
  FocusNode? nombreFocusNode;
  TextEditingController? nombreTextController;
  String? Function(BuildContext, String?)? nombreTextControllerValidator;
  // State field(s) for Cargo widget.
  FocusNode? cargoFocusNode;
  TextEditingController? cargoTextController;
  String? Function(BuildContext, String?)? cargoTextControllerValidator;
  // Stores action output result for [Custom Action - obtenerDepositarios] action in Button widget.
  List<dynamic>? depositarios;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreFocusNode?.dispose();
    nombreTextController?.dispose();

    cargoFocusNode?.dispose();
    cargoTextController?.dispose();
  }
}
