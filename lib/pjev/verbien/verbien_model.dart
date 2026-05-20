import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'verbien_widget.dart' show VerbienWidget;
import 'package:flutter/material.dart';

class VerbienModel extends FlutterFlowModel<VerbienWidget> {
  ///  State fields for stateful widgets in this page.

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
  // State field(s) for Avaluo widget.
  FocusNode? avaluoFocusNode;
  TextEditingController? avaluoTextController;
  String? Function(BuildContext, String?)? avaluoTextControllerValidator;
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
  // State field(s) for Origenrecurso widget.
  final origenrecursoKey = GlobalKey();
  FocusNode? origenrecursoFocusNode;
  TextEditingController? origenrecursoTextController;
  String? origenrecursoSelectedOption;
  String? Function(BuildContext, String?)? origenrecursoTextControllerValidator;
  // State field(s) for VerificaVS widget.
  String? verificaVSValue;
  FormFieldController<String>? verificaVSValueController;
  // State field(s) for CotejoDoc widget.
  String? cotejoDocValue;
  FormFieldController<String>? cotejoDocValueController;
  // State field(s) for Ejercicio widget.
  FocusNode? ejercicioFocusNode;
  TextEditingController? ejercicioTextController;
  String? Function(BuildContext, String?)? ejercicioTextControllerValidator;
  // State field(s) for Ubicacion widget.
  final ubicacionKey = GlobalKey();
  FocusNode? ubicacionFocusNode;
  TextEditingController? ubicacionTextController;
  String? ubicacionSelectedOption;
  String? Function(BuildContext, String?)? ubicacionTextControllerValidator;
  // State field(s) for Ubicacionespecifica widget.
  FocusNode? ubicacionespecificaFocusNode;
  TextEditingController? ubicacionespecificaTextController;
  String? Function(BuildContext, String?)?
      ubicacionespecificaTextControllerValidator;
  // State field(s) for Proveedor widget.
  final proveedorKey = GlobalKey();
  FocusNode? proveedorFocusNode;
  TextEditingController? proveedorTextController;
  String? proveedorSelectedOption;
  String? Function(BuildContext, String?)? proveedorTextControllerValidator;
  // State field(s) for Nivel1 widget.
  FocusNode? nivel1FocusNode;
  TextEditingController? nivel1TextController;
  String? Function(BuildContext, String?)? nivel1TextControllerValidator;
  // State field(s) for Nivel2 widget.
  FocusNode? nivel2FocusNode;
  TextEditingController? nivel2TextController;
  String? Function(BuildContext, String?)? nivel2TextControllerValidator;
  // State field(s) for Nivel3 widget.
  FocusNode? nivel3FocusNode;
  TextEditingController? nivel3TextController;
  String? Function(BuildContext, String?)? nivel3TextControllerValidator;
  // State field(s) for Marca widget.
  final marcaKey = GlobalKey();
  FocusNode? marcaFocusNode;
  TextEditingController? marcaTextController;
  String? marcaSelectedOption;
  String? Function(BuildContext, String?)? marcaTextControllerValidator;
  // State field(s) for Facturas widget.
  final facturasKey = GlobalKey();
  FocusNode? facturasFocusNode;
  TextEditingController? facturasTextController;
  String? facturasSelectedOption;
  String? Function(BuildContext, String?)? facturasTextControllerValidator;
  // State field(s) for Clasedeactivo widget.
  FocusNode? clasedeactivoFocusNode;
  TextEditingController? clasedeactivoTextController;
  String? Function(BuildContext, String?)? clasedeactivoTextControllerValidator;
  // State field(s) for Estadodelbien widget.
  String? estadodelbienValue;
  FormFieldController<String>? estadodelbienValueController;
  // State field(s) for Color widget.
  final colorKey = GlobalKey();
  FocusNode? colorFocusNode;
  TextEditingController? colorTextController;
  String? colorSelectedOption;
  String? Function(BuildContext, String?)? colorTextControllerValidator;
  // State field(s) for Modelo widget.
  final modeloKey = GlobalKey();
  FocusNode? modeloFocusNode;
  TextEditingController? modeloTextController;
  String? modeloSelectedOption;
  String? Function(BuildContext, String?)? modeloTextControllerValidator;
  // State field(s) for Placa widget.
  FocusNode? placaFocusNode;
  TextEditingController? placaTextController;
  String? Function(BuildContext, String?)? placaTextControllerValidator;
  // State field(s) for Distrito widget.
  String? distritoValue;
  FormFieldController<String>? distritoValueController;
  // State field(s) for Licitacion widget.
  final licitacionKey = GlobalKey();
  FocusNode? licitacionFocusNode;
  TextEditingController? licitacionTextController;
  String? licitacionSelectedOption;
  String? Function(BuildContext, String?)? licitacionTextControllerValidator;
  // State field(s) for Categoria widget.
  final categoriaKey = GlobalKey();
  FocusNode? categoriaFocusNode;
  TextEditingController? categoriaTextController;
  String? categoriaSelectedOption;
  String? Function(BuildContext, String?)? categoriaTextControllerValidator;
  // State field(s) for Inmueble widget.
  final inmuebleKey = GlobalKey();
  FocusNode? inmuebleFocusNode;
  TextEditingController? inmuebleTextController;
  String? inmuebleSelectedOption;
  String? Function(BuildContext, String?)? inmuebleTextControllerValidator;
  // State field(s) for Zona widget.
  final zonaKey = GlobalKey();
  FocusNode? zonaFocusNode;
  TextEditingController? zonaTextController;
  String? zonaSelectedOption;
  String? Function(BuildContext, String?)? zonaTextControllerValidator;
  // State field(s) for Seriemonitor widget.
  FocusNode? seriemonitorFocusNode;
  TextEditingController? seriemonitorTextController;
  String? Function(BuildContext, String?)? seriemonitorTextControllerValidator;
  // State field(s) for Serieteclado widget.
  FocusNode? serietecladoFocusNode;
  TextEditingController? serietecladoTextController;
  String? Function(BuildContext, String?)? serietecladoTextControllerValidator;
  // State field(s) for Seriemouse widget.
  FocusNode? seriemouseFocusNode;
  TextEditingController? seriemouseTextController;
  String? Function(BuildContext, String?)? seriemouseTextControllerValidator;
  // State field(s) for Descripcionbien widget.
  FocusNode? descripcionbienFocusNode;
  TextEditingController? descripcionbienTextController;
  String? Function(BuildContext, String?)?
      descripcionbienTextControllerValidator;
  // State field(s) for Comentarios widget.
  FocusNode? comentariosFocusNode;
  TextEditingController? comentariosTextController;
  String? Function(BuildContext, String?)? comentariosTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    numeroinventarioidFocusNode?.dispose();
    numeroinventarioidTextController?.dispose();

    iDanteriorFocusNode?.dispose();
    iDanteriorTextController?.dispose();

    importeFocusNode?.dispose();
    importeTextController?.dispose();

    avaluoFocusNode?.dispose();
    avaluoTextController?.dispose();

    articuloFocusNode?.dispose();

    titularFocusNode?.dispose();
    titularTextController?.dispose();

    depositarioFocusNode?.dispose();
    depositarioTextController?.dispose();

    origenrecursoFocusNode?.dispose();

    ejercicioFocusNode?.dispose();
    ejercicioTextController?.dispose();

    ubicacionFocusNode?.dispose();

    ubicacionespecificaFocusNode?.dispose();
    ubicacionespecificaTextController?.dispose();

    proveedorFocusNode?.dispose();

    nivel1FocusNode?.dispose();
    nivel1TextController?.dispose();

    nivel2FocusNode?.dispose();
    nivel2TextController?.dispose();

    nivel3FocusNode?.dispose();
    nivel3TextController?.dispose();

    marcaFocusNode?.dispose();

    facturasFocusNode?.dispose();

    clasedeactivoFocusNode?.dispose();
    clasedeactivoTextController?.dispose();

    colorFocusNode?.dispose();

    modeloFocusNode?.dispose();

    placaFocusNode?.dispose();
    placaTextController?.dispose();

    licitacionFocusNode?.dispose();

    categoriaFocusNode?.dispose();

    inmuebleFocusNode?.dispose();

    zonaFocusNode?.dispose();

    seriemonitorFocusNode?.dispose();
    seriemonitorTextController?.dispose();

    serietecladoFocusNode?.dispose();
    serietecladoTextController?.dispose();

    seriemouseFocusNode?.dispose();
    seriemouseTextController?.dispose();

    descripcionbienFocusNode?.dispose();
    descripcionbienTextController?.dispose();

    comentariosFocusNode?.dispose();
    comentariosTextController?.dispose();
  }
}
