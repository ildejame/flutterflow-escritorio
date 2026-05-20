import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'formato_comercio_widget.dart' show FormatoComercioWidget;
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class FormatoComercioModel extends FlutterFlowModel<FormatoComercioWidget> {
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
  String? tipoPersonaValue;
  FormFieldController<String>? tipoPersonaValueController;
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
  // State field(s) for Giro widget.
  String? giroValue;
  FormFieldController<String>? giroValueController;
  // State field(s) for PagoAdicional widget.
  String? pagoAdicionalValue;
  FormFieldController<String>? pagoAdicionalValueController;
  // State field(s) for TipoPago widget.
  String? tipoPagoValue;
  FormFieldController<String>? tipoPagoValueController;
  DateTime? datePicked;
  // State field(s) for Ruta widget.
  String? rutaValue;
  FormFieldController<String>? rutaValueController;
  // State field(s) for Movimiento widget.
  String? movimientoValue;
  FormFieldController<String>? movimientoValueController;
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
  bool isDataUploading_uploadMediaLmb = false;
  FFUploadedFile uploadedLocalFile_uploadMediaLmb =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadMediaLmb = '';

  bool isDataUploading_uploadMediaYwj = false;
  List<FFUploadedFile> uploadedLocalFiles_uploadMediaYwj = [];
  List<String> uploadedFileUrls_uploadMediaYwj = [];

  // State field(s) for FirmaInfractor widget.
  SignatureController? firmaInfractorController;
  String uploadedSignatureUrl = '';

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

    firmaInfractorController?.dispose();
  }
}
