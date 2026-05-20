import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'edit_comercio_widget.dart' show EditComercioWidget;
import 'package:flutter/material.dart';

class EditComercioModel extends FlutterFlowModel<EditComercioWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for CodigoQR widget.
  FocusNode? codigoQRFocusNode;
  TextEditingController? codigoQRTextController;
  String? Function(BuildContext, String?)? codigoQRTextControllerValidator;
  // State field(s) for NombrePropietario widget.
  FocusNode? nombrePropietarioFocusNode;
  TextEditingController? nombrePropietarioTextController;
  String? Function(BuildContext, String?)?
      nombrePropietarioTextControllerValidator;
  // State field(s) for DireccionParticular widget.
  FocusNode? direccionParticularFocusNode;
  TextEditingController? direccionParticularTextController;
  String? Function(BuildContext, String?)?
      direccionParticularTextControllerValidator;
  // State field(s) for TipoPersona widget.
  FocusNode? tipoPersonaFocusNode;
  TextEditingController? tipoPersonaTextController;
  String? Function(BuildContext, String?)? tipoPersonaTextControllerValidator;
  // State field(s) for RFC widget.
  FocusNode? rfcFocusNode;
  TextEditingController? rfcTextController;
  String? Function(BuildContext, String?)? rfcTextControllerValidator;
  // State field(s) for Nacionalidad widget.
  FocusNode? nacionalidadFocusNode;
  TextEditingController? nacionalidadTextController;
  String? Function(BuildContext, String?)? nacionalidadTextControllerValidator;
  // State field(s) for NombreEstablecimiento widget.
  FocusNode? nombreEstablecimientoFocusNode;
  TextEditingController? nombreEstablecimientoTextController;
  String? Function(BuildContext, String?)?
      nombreEstablecimientoTextControllerValidator;
  // State field(s) for DireccionNegcio widget.
  FocusNode? direccionNegcioFocusNode;
  TextEditingController? direccionNegcioTextController;
  String? Function(BuildContext, String?)?
      direccionNegcioTextControllerValidator;
  // State field(s) for Colonia widget.
  FocusNode? coloniaFocusNode;
  TextEditingController? coloniaTextController;
  String? Function(BuildContext, String?)? coloniaTextControllerValidator;
  // State field(s) for NumNegocio widget.
  FocusNode? numNegocioFocusNode;
  TextEditingController? numNegocioTextController;
  String? Function(BuildContext, String?)? numNegocioTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for Giro widget.
  String? giroValue;
  FormFieldController<String>? giroValueController;
  // State field(s) for TipoPago widget.
  String? tipoPagoValue;
  FormFieldController<String>? tipoPagoValueController;
  // State field(s) for Ruta widget.
  String? rutaValue;
  FormFieldController<String>? rutaValueController;
  // State field(s) for SuperficieM2 widget.
  FocusNode? superficieM2FocusNode;
  TextEditingController? superficieM2TextController;
  String? Function(BuildContext, String?)? superficieM2TextControllerValidator;
  // State field(s) for DescripcionActividad widget.
  FocusNode? descripcionActividadFocusNode;
  TextEditingController? descripcionActividadTextController;
  String? Function(BuildContext, String?)?
      descripcionActividadTextControllerValidator;
  // State field(s) for FechaInicioOperaciones widget.
  FocusNode? fechaInicioOperacionesFocusNode;
  TextEditingController? fechaInicioOperacionesTextController;
  String? Function(BuildContext, String?)?
      fechaInicioOperacionesTextControllerValidator;
  // State field(s) for WhatsApp widget.
  FocusNode? whatsAppFocusNode;
  TextEditingController? whatsAppTextController;
  String? Function(BuildContext, String?)? whatsAppTextControllerValidator;
  // State field(s) for Correo widget.
  FocusNode? correoFocusNode;
  TextEditingController? correoTextController;
  String? Function(BuildContext, String?)? correoTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    codigoQRFocusNode?.dispose();
    codigoQRTextController?.dispose();

    nombrePropietarioFocusNode?.dispose();
    nombrePropietarioTextController?.dispose();

    direccionParticularFocusNode?.dispose();
    direccionParticularTextController?.dispose();

    tipoPersonaFocusNode?.dispose();
    tipoPersonaTextController?.dispose();

    rfcFocusNode?.dispose();
    rfcTextController?.dispose();

    nacionalidadFocusNode?.dispose();
    nacionalidadTextController?.dispose();

    nombreEstablecimientoFocusNode?.dispose();
    nombreEstablecimientoTextController?.dispose();

    direccionNegcioFocusNode?.dispose();
    direccionNegcioTextController?.dispose();

    coloniaFocusNode?.dispose();
    coloniaTextController?.dispose();

    numNegocioFocusNode?.dispose();
    numNegocioTextController?.dispose();

    superficieM2FocusNode?.dispose();
    superficieM2TextController?.dispose();

    descripcionActividadFocusNode?.dispose();
    descripcionActividadTextController?.dispose();

    fechaInicioOperacionesFocusNode?.dispose();
    fechaInicioOperacionesTextController?.dispose();

    whatsAppFocusNode?.dispose();
    whatsAppTextController?.dispose();

    correoFocusNode?.dispose();
    correoTextController?.dispose();
  }
}
