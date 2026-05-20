import '/flutter_flow/flutter_flow_util.dart';
import 'buscar_bien2b_copy_widget.dart' show BuscarBien2bCopyWidget;
import 'package:flutter/material.dart';

class BuscarBien2bCopyModel extends FlutterFlowModel<BuscarBien2bCopyWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Articulo widget.
  final articuloKey = GlobalKey();
  FocusNode? articuloFocusNode;
  TextEditingController? articuloTextController;
  String? articuloSelectedOption;
  String? Function(BuildContext, String?)? articuloTextControllerValidator;
  // State field(s) for Numeroinventarioid widget.
  FocusNode? numeroinventarioidFocusNode;
  TextEditingController? numeroinventarioidTextController;
  String? Function(BuildContext, String?)?
      numeroinventarioidTextControllerValidator;
  // State field(s) for IDanterior widget.
  FocusNode? iDanteriorFocusNode;
  TextEditingController? iDanteriorTextController;
  String? Function(BuildContext, String?)? iDanteriorTextControllerValidator;
  // State field(s) for Importe widget.
  FocusNode? importeFocusNode;
  TextEditingController? importeTextController;
  String? Function(BuildContext, String?)? importeTextControllerValidator;
  // State field(s) for Titular widget.
  final titularKey = GlobalKey();
  FocusNode? titularFocusNode;
  TextEditingController? titularTextController;
  String? titularSelectedOption;
  String? Function(BuildContext, String?)? titularTextControllerValidator;
  // State field(s) for Depositario widget.
  FocusNode? depositarioFocusNode;
  TextEditingController? depositarioTextController;
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    articuloFocusNode?.dispose();

    numeroinventarioidFocusNode?.dispose();
    numeroinventarioidTextController?.dispose();

    iDanteriorFocusNode?.dispose();
    iDanteriorTextController?.dispose();

    importeFocusNode?.dispose();
    importeTextController?.dispose();

    titularFocusNode?.dispose();

    depositarioFocusNode?.dispose();
    depositarioTextController?.dispose();

    nivel1FocusNode?.dispose();

    nivel2FocusNode?.dispose();

    nivel3FocusNode?.dispose();
  }
}
