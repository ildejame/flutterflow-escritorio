import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'iniciarvale_widget.dart' show IniciarvaleWidget;
import 'package:flutter/material.dart';

class IniciarvaleModel extends FlutterFlowModel<IniciarvaleWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - obtenerNombresEmpleados] action in Iniciarvale widget.
  List<String>? resultadoNombres;
  // Stores action output result for [Custom Action - obtenerOficinas] action in Iniciarvale widget.
  dynamic resultadoAPI;
  // State field(s) for Folio widget.
  FocusNode? folioFocusNode;
  TextEditingController? folioTextController;
  String? Function(BuildContext, String?)? folioTextControllerValidator;
  // State field(s) for Nombresolicitante widget.
  FocusNode? nombresolicitanteFocusNode;
  TextEditingController? nombresolicitanteTextController;
  String? Function(BuildContext, String?)?
      nombresolicitanteTextControllerValidator;
  // State field(s) for Tipomovimiento widget.
  String? tipomovimientoValue;
  FormFieldController<String>? tipomovimientoValueController;
  // State field(s) for Titular widget.
  final titularKey = GlobalKey();
  FocusNode? titularFocusNode;
  TextEditingController? titularTextController;
  String? titularSelectedOption;
  String? Function(BuildContext, String?)? titularTextControllerValidator;
  // State field(s) for Depositario widget.
  final depositarioKey = GlobalKey();
  FocusNode? depositarioFocusNode;
  TextEditingController? depositarioTextController;
  String? depositarioSelectedOption;
  String? Function(BuildContext, String?)? depositarioTextControllerValidator;
  // State field(s) for Estadodelbien widget.
  String? estadodelbienValue;
  FormFieldController<String>? estadodelbienValueController;
  // State field(s) for PendienteBodega widget.
  String? pendienteBodegaValue;
  FormFieldController<String>? pendienteBodegaValueController;
  // State field(s) for Nivel1 widget.
  final nivel1Key = GlobalKey();
  FocusNode? nivel1FocusNode;
  TextEditingController? nivel1TextController;
  String? nivel1SelectedOption;
  String? Function(BuildContext, String?)? nivel1TextControllerValidator;
  // State field(s) for Nivel2 widget.
  final nivel2Key = GlobalKey();
  FocusNode? nivel2FocusNode;
  TextEditingController? nivel2TextController;
  String? nivel2SelectedOption;
  String? Function(BuildContext, String?)? nivel2TextControllerValidator;
  // State field(s) for Nivel3 widget.
  final nivel3Key = GlobalKey();
  FocusNode? nivel3FocusNode;
  TextEditingController? nivel3TextController;
  String? nivel3SelectedOption;
  String? Function(BuildContext, String?)? nivel3TextControllerValidator;
  // State field(s) for Ubicacion widget.
  final ubicacionKey = GlobalKey();
  FocusNode? ubicacionFocusNode;
  TextEditingController? ubicacionTextController;
  String? ubicacionSelectedOption;
  String? Function(BuildContext, String?)? ubicacionTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    folioFocusNode?.dispose();
    folioTextController?.dispose();

    nombresolicitanteFocusNode?.dispose();
    nombresolicitanteTextController?.dispose();

    titularFocusNode?.dispose();

    depositarioFocusNode?.dispose();

    nivel1FocusNode?.dispose();

    nivel2FocusNode?.dispose();

    nivel3FocusNode?.dispose();

    ubicacionFocusNode?.dispose();
  }
}
