import '/components/busqueda_nombre/busqueda_nombre_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'busqueda_nombre_propietario_widget.dart'
    show BusquedaNombrePropietarioWidget;
import 'package:flutter/material.dart';

class BusquedaNombrePropietarioModel
    extends FlutterFlowModel<BusquedaNombrePropietarioWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BusquedaNombre component.
  late BusquedaNombreModel busquedaNombreModel;

  @override
  void initState(BuildContext context) {
    busquedaNombreModel = createModel(context, () => BusquedaNombreModel());
  }

  @override
  void dispose() {
    busquedaNombreModel.dispose();
  }
}
