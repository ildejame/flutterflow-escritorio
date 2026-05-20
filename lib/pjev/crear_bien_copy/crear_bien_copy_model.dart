import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'crear_bien_copy_widget.dart' show CrearBienCopyWidget;
import 'package:flutter/material.dart';

class CrearBienCopyModel extends FlutterFlowModel<CrearBienCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Numeroinventarioid widget.
  FocusNode? numeroinventarioidFocusNode;
  TextEditingController? numeroinventarioidTextController;
  String? Function(BuildContext, String?)?
      numeroinventarioidTextControllerValidator;
  // State field(s) for Serie widget.
  FocusNode? serieFocusNode;
  TextEditingController? serieTextController;
  String? Function(BuildContext, String?)? serieTextControllerValidator;
  // State field(s) for Numeroinventario widget.
  FocusNode? numeroinventarioFocusNode;
  TextEditingController? numeroinventarioTextController;
  String? Function(BuildContext, String?)?
      numeroinventarioTextControllerValidator;
  // State field(s) for Imposte widget.
  FocusNode? imposteFocusNode;
  TextEditingController? imposteTextController;
  String? Function(BuildContext, String?)? imposteTextControllerValidator;
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
  // State field(s) for Encargado widget.
  final encargadoKey = GlobalKey();
  FocusNode? encargadoFocusNode;
  TextEditingController? encargadoTextController;
  String? encargadoSelectedOption;
  String? Function(BuildContext, String?)? encargadoTextControllerValidator;
  // State field(s) for VerificaVS widget.
  String? verificaVSValue;
  FormFieldController<String>? verificaVSValueController;
  // State field(s) for Folioresguardo widget.
  FocusNode? folioresguardoFocusNode;
  TextEditingController? folioresguardoTextController;
  String? Function(BuildContext, String?)?
      folioresguardoTextControllerValidator;
  // State field(s) for CotejoDoc widget.
  String? cotejoDocValue;
  FormFieldController<String>? cotejoDocValueController;
  // State field(s) for Ejercicio widget.
  FocusNode? ejercicioFocusNode;
  TextEditingController? ejercicioTextController;
  String? Function(BuildContext, String?)? ejercicioTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for Ubicacion widget.
  final ubicacionKey = GlobalKey();
  FocusNode? ubicacionFocusNode;
  TextEditingController? ubicacionTextController;
  String? ubicacionSelectedOption;
  String? Function(BuildContext, String?)? ubicacionTextControllerValidator;
  // State field(s) for Facturas widget.
  final facturasKey = GlobalKey();
  FocusNode? facturasFocusNode;
  TextEditingController? facturasTextController;
  String? facturasSelectedOption;
  String? Function(BuildContext, String?)? facturasTextControllerValidator;
  // State field(s) for Proveedor widget.
  final proveedorKey = GlobalKey();
  FocusNode? proveedorFocusNode;
  TextEditingController? proveedorTextController;
  String? proveedorSelectedOption;
  String? Function(BuildContext, String?)? proveedorTextControllerValidator;
  // State field(s) for Recurso widget.
  final recursoKey = GlobalKey();
  FocusNode? recursoFocusNode;
  TextEditingController? recursoTextController;
  String? recursoSelectedOption;
  String? Function(BuildContext, String?)? recursoTextControllerValidator;
  // State field(s) for Articulo widget.
  final articuloKey = GlobalKey();
  FocusNode? articuloFocusNode;
  TextEditingController? articuloTextController;
  String? articuloSelectedOption;
  String? Function(BuildContext, String?)? articuloTextControllerValidator;
  // State field(s) for Marca widget.
  final marcaKey = GlobalKey();
  FocusNode? marcaFocusNode;
  TextEditingController? marcaTextController;
  String? marcaSelectedOption;
  String? Function(BuildContext, String?)? marcaTextControllerValidator;
  // State field(s) for Clasedeactivo widget.
  final clasedeactivoKey = GlobalKey();
  FocusNode? clasedeactivoFocusNode;
  TextEditingController? clasedeactivoTextController;
  String? clasedeactivoSelectedOption;
  String? Function(BuildContext, String?)? clasedeactivoTextControllerValidator;
  // State field(s) for Escontable widget.
  bool? escontableValue;
  // State field(s) for Estadodelbien widget.
  String? estadodelbienValue;
  FormFieldController<String>? estadodelbienValueController;
  // State field(s) for Color widget.
  final colorKey = GlobalKey();
  FocusNode? colorFocusNode;
  TextEditingController? colorTextController;
  String? colorSelectedOption;
  String? Function(BuildContext, String?)? colorTextControllerValidator;
  // State field(s) for Categoria widget.
  final categoriaKey = GlobalKey();
  FocusNode? categoriaFocusNode;
  TextEditingController? categoriaTextController;
  String? categoriaSelectedOption;
  String? Function(BuildContext, String?)? categoriaTextControllerValidator;
  // State field(s) for Origenrecurso widget.
  final origenrecursoKey = GlobalKey();
  FocusNode? origenrecursoFocusNode;
  TextEditingController? origenrecursoTextController;
  String? origenrecursoSelectedOption;
  String? Function(BuildContext, String?)? origenrecursoTextControllerValidator;
  // State field(s) for Licitacion widget.
  final licitacionKey = GlobalKey();
  FocusNode? licitacionFocusNode;
  TextEditingController? licitacionTextController;
  String? licitacionSelectedOption;
  String? Function(BuildContext, String?)? licitacionTextControllerValidator;
  // State field(s) for Inmueble widget.
  final inmuebleKey = GlobalKey();
  FocusNode? inmuebleFocusNode;
  TextEditingController? inmuebleTextController;
  String? inmuebleSelectedOption;
  String? Function(BuildContext, String?)? inmuebleTextControllerValidator;
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
  // State field(s) for Ubicacionespecifica widget.
  FocusNode? ubicacionespecificaFocusNode;
  TextEditingController? ubicacionespecificaTextController;
  String? Function(BuildContext, String?)?
      ubicacionespecificaTextControllerValidator;
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

    serieFocusNode?.dispose();
    serieTextController?.dispose();

    numeroinventarioFocusNode?.dispose();
    numeroinventarioTextController?.dispose();

    imposteFocusNode?.dispose();
    imposteTextController?.dispose();

    titularFocusNode?.dispose();

    depositarioFocusNode?.dispose();

    encargadoFocusNode?.dispose();

    folioresguardoFocusNode?.dispose();
    folioresguardoTextController?.dispose();

    ejercicioFocusNode?.dispose();
    ejercicioTextController?.dispose();

    ubicacionFocusNode?.dispose();

    facturasFocusNode?.dispose();

    proveedorFocusNode?.dispose();

    recursoFocusNode?.dispose();

    articuloFocusNode?.dispose();

    marcaFocusNode?.dispose();

    clasedeactivoFocusNode?.dispose();

    colorFocusNode?.dispose();

    categoriaFocusNode?.dispose();

    origenrecursoFocusNode?.dispose();

    licitacionFocusNode?.dispose();

    inmuebleFocusNode?.dispose();

    modeloFocusNode?.dispose();

    placaFocusNode?.dispose();
    placaTextController?.dispose();

    ubicacionespecificaFocusNode?.dispose();
    ubicacionespecificaTextController?.dispose();

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
