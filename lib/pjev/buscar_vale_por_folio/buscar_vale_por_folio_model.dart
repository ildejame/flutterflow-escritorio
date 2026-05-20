import '/flutter_flow/flutter_flow_util.dart';
import 'buscar_vale_por_folio_widget.dart' show BuscarValePorFolioWidget;
import 'package:flutter/material.dart';

class BuscarValePorFolioModel
    extends FlutterFlowModel<BuscarValePorFolioWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for NumeroFolio widget.
  FocusNode? numeroFolioFocusNode;
  TextEditingController? numeroFolioTextController;
  String? Function(BuildContext, String?)? numeroFolioTextControllerValidator;
  // Stores action output result for [Custom Action - buscarValePorFolio] action in Button widget.
  dynamic valeresp;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    numeroFolioFocusNode?.dispose();
    numeroFolioTextController?.dispose();
  }
}
