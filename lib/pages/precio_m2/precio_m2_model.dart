import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'precio_m2_widget.dart' show PrecioM2Widget;
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class PrecioM2Model extends FlutterFlowModel<PrecioM2Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Nombre widget.
  FocusNode? nombreFocusNode;
  TextEditingController? nombreTextController;
  String? Function(BuildContext, String?)? nombreTextControllerValidator;
  // State field(s) for Telefono widget.
  FocusNode? telefonoFocusNode;
  TextEditingController? telefonoTextController;
  String? Function(BuildContext, String?)? telefonoTextControllerValidator;
  // State field(s) for WhatsApp widget.
  FocusNode? whatsAppFocusNode;
  TextEditingController? whatsAppTextController;
  String? Function(BuildContext, String?)? whatsAppTextControllerValidator;
  // State field(s) for Correo widget.
  FocusNode? correoFocusNode;
  TextEditingController? correoTextController;
  String? Function(BuildContext, String?)? correoTextControllerValidator;
  // State field(s) for FirmaOficial widget.
  SignatureController? firmaOficialController;
  String uploadedSignatureUrl = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreFocusNode?.dispose();
    nombreTextController?.dispose();

    telefonoFocusNode?.dispose();
    telefonoTextController?.dispose();

    whatsAppFocusNode?.dispose();
    whatsAppTextController?.dispose();

    correoFocusNode?.dispose();
    correoTextController?.dispose();

    firmaOficialController?.dispose();
  }
}
