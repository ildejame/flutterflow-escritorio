import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'mantenimiento_vale_widget.dart' show MantenimientoValeWidget;
import 'package:flutter/material.dart';

class MantenimientoValeModel extends FlutterFlowModel<MantenimientoValeWidget> {
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
  FocusNode? titularFocusNode;
  TextEditingController? titularTextController;
  String? Function(BuildContext, String?)? titularTextControllerValidator;
  // State field(s) for Depositario widget.
  FocusNode? depositarioFocusNode;
  TextEditingController? depositarioTextController;
  String? Function(BuildContext, String?)? depositarioTextControllerValidator;
  // State field(s) for Descripcionbien widget.
  FocusNode? descripcionbienFocusNode;
  TextEditingController? descripcionbienTextController;
  String? Function(BuildContext, String?)?
      descripcionbienTextControllerValidator;

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
    titularTextController?.dispose();

    depositarioFocusNode?.dispose();
    depositarioTextController?.dispose();

    descripcionbienFocusNode?.dispose();
    descripcionbienTextController?.dispose();
  }
}
