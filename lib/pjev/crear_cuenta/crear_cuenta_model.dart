import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'crear_cuenta_widget.dart' show CrearCuentaWidget;
import 'package:flutter/material.dart';

class CrearCuentaModel extends FlutterFlowModel<CrearCuentaWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // State field(s) for confirmPassword widget.
  FocusNode? confirmPasswordFocusNode;
  TextEditingController? confirmPasswordTextController;
  late bool confirmPasswordVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswordTextControllerValidator;
  // State field(s) for DirCorreo widget.
  FocusNode? dirCorreoFocusNode;
  TextEditingController? dirCorreoTextController;
  String? Function(BuildContext, String?)? dirCorreoTextControllerValidator;
  // State field(s) for MiPassword widget.
  FocusNode? miPasswordFocusNode;
  TextEditingController? miPasswordTextController;
  late bool miPasswordVisibility;
  String? Function(BuildContext, String?)? miPasswordTextControllerValidator;
  // State field(s) for MiPasswordConfirmacion widget.
  FocusNode? miPasswordConfirmacionFocusNode;
  TextEditingController? miPasswordConfirmacionTextController;
  late bool miPasswordConfirmacionVisibility;
  String? Function(BuildContext, String?)?
      miPasswordConfirmacionTextControllerValidator;
  // State field(s) for NombredeUsuario widget.
  FocusNode? nombredeUsuarioFocusNode;
  TextEditingController? nombredeUsuarioTextController;
  String? Function(BuildContext, String?)?
      nombredeUsuarioTextControllerValidator;
  // State field(s) for Celular widget.
  FocusNode? celularFocusNode;
  TextEditingController? celularTextController;
  String? Function(BuildContext, String?)? celularTextControllerValidator;
  // State field(s) for Responsable widget.
  String? responsableValue;
  FormFieldController<String>? responsableValueController;
  // State field(s) for Permiso widget.
  String? permisoValue;
  FormFieldController<String>? permisoValueController;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
    confirmPasswordVisibility = false;
    miPasswordVisibility = false;
    miPasswordConfirmacionVisibility = false;
  }

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();

    confirmPasswordFocusNode?.dispose();
    confirmPasswordTextController?.dispose();

    dirCorreoFocusNode?.dispose();
    dirCorreoTextController?.dispose();

    miPasswordFocusNode?.dispose();
    miPasswordTextController?.dispose();

    miPasswordConfirmacionFocusNode?.dispose();
    miPasswordConfirmacionTextController?.dispose();

    nombredeUsuarioFocusNode?.dispose();
    nombredeUsuarioTextController?.dispose();

    celularFocusNode?.dispose();
    celularTextController?.dispose();
  }
}
