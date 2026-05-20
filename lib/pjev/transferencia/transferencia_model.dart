import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'transferencia_widget.dart' show TransferenciaWidget;
import 'package:flutter/material.dart';

class TransferenciaModel extends FlutterFlowModel<TransferenciaWidget> {
  ///  State fields for stateful widgets in this page.

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
  // State field(s) for Numeroinventarioid widget.
  FocusNode? numeroinventarioidFocusNode;
  TextEditingController? numeroinventarioidTextController;
  String? Function(BuildContext, String?)?
      numeroinventarioidTextControllerValidator;
  // State field(s) for Importe widget.
  FocusNode? importeFocusNode;
  TextEditingController? importeTextController;
  String? Function(BuildContext, String?)? importeTextControllerValidator;
  // State field(s) for Articulo widget.
  final articuloKey = GlobalKey();
  FocusNode? articuloFocusNode;
  TextEditingController? articuloTextController;
  String? articuloSelectedOption;
  String? Function(BuildContext, String?)? articuloTextControllerValidator;
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
  // State field(s) for Descripcionbien widget.
  FocusNode? descripcionbienFocusNode;
  TextEditingController? descripcionbienTextController;
  String? Function(BuildContext, String?)?
      descripcionbienTextControllerValidator;
  // State field(s) for Estadodelbien widget.
  String? estadodelbienValue;
  FormFieldController<String>? estadodelbienValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    folioFocusNode?.dispose();
    folioTextController?.dispose();

    nombresolicitanteFocusNode?.dispose();
    nombresolicitanteTextController?.dispose();

    numeroinventarioidFocusNode?.dispose();
    numeroinventarioidTextController?.dispose();

    importeFocusNode?.dispose();
    importeTextController?.dispose();

    articuloFocusNode?.dispose();

    titularFocusNode?.dispose();

    depositarioFocusNode?.dispose();

    nivel1FocusNode?.dispose();

    nivel2FocusNode?.dispose();

    nivel3FocusNode?.dispose();

    descripcionbienFocusNode?.dispose();
    descripcionbienTextController?.dispose();
  }
}
