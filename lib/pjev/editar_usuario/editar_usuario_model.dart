import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'editar_usuario_widget.dart' show EditarUsuarioWidget;
import 'package:flutter/material.dart';

class EditarUsuarioModel extends FlutterFlowModel<EditarUsuarioWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for NombreResponsable widget.
  FocusNode? nombreResponsableFocusNode;
  TextEditingController? nombreResponsableTextController;
  String? Function(BuildContext, String?)?
      nombreResponsableTextControllerValidator;
  // State field(s) for celular widget.
  FocusNode? celularFocusNode;
  TextEditingController? celularTextController;
  String? Function(BuildContext, String?)? celularTextControllerValidator;
  // State field(s) for Permiso widget.
  String? permisoValue;
  FormFieldController<String>? permisoValueController;
  // State field(s) for Responsable widget.
  String? responsableValue;
  FormFieldController<String>? responsableValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreResponsableFocusNode?.dispose();
    nombreResponsableTextController?.dispose();

    celularFocusNode?.dispose();
    celularTextController?.dispose();
  }
}
