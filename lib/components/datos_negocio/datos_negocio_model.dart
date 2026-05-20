import '/flutter_flow/flutter_flow_util.dart';
import 'datos_negocio_widget.dart' show DatosNegocioWidget;
import 'package:flutter/material.dart';

class DatosNegocioModel extends FlutterFlowModel<DatosNegocioWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for NombredelNegocio widget.
  final nombredelNegocioKey = GlobalKey();
  FocusNode? nombredelNegocioFocusNode;
  TextEditingController? nombredelNegocioTextController;
  String? nombredelNegocioSelectedOption;
  String? Function(BuildContext, String?)?
      nombredelNegocioTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombredelNegocioFocusNode?.dispose();
  }
}
