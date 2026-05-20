import '/flutter_flow/flutter_flow_util.dart';
import 'agregar_depreciacion_widget.dart' show AgregarDepreciacionWidget;
import 'package:flutter/material.dart';

class AgregarDepreciacionModel
    extends FlutterFlowModel<AgregarDepreciacionWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Nombre widget.
  FocusNode? nombreFocusNode;
  TextEditingController? nombreTextController;
  String? Function(BuildContext, String?)? nombreTextControllerValidator;
  // State field(s) for Depreciacion widget.
  FocusNode? depreciacionFocusNode;
  TextEditingController? depreciacionTextController;
  String? Function(BuildContext, String?)? depreciacionTextControllerValidator;
  // State field(s) for Vidautil widget.
  FocusNode? vidautilFocusNode;
  TextEditingController? vidautilTextController;
  String? Function(BuildContext, String?)? vidautilTextControllerValidator;
  // Stores action output result for [Custom Action - obtenerDepreciacionesPB] action in Button widget.
  List<dynamic>? depreciacion;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreFocusNode?.dispose();
    nombreTextController?.dispose();

    depreciacionFocusNode?.dispose();
    depreciacionTextController?.dispose();

    vidautilFocusNode?.dispose();
    vidautilTextController?.dispose();
  }
}
