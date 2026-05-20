import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  Local state fields for this page.

  List<BienesmueblesRecord> listabienesPage = [];
  void addToListabienesPage(BienesmueblesRecord item) =>
      listabienesPage.add(item);
  void removeFromListabienesPage(BienesmueblesRecord item) =>
      listabienesPage.remove(item);
  void removeAtIndexFromListabienesPage(int index) =>
      listabienesPage.removeAt(index);
  void insertAtIndexInListabienesPage(int index, BienesmueblesRecord item) =>
      listabienesPage.insert(index, item);
  void updateListabienesPageAtIndex(
          int index, Function(BienesmueblesRecord) updateFn) =>
      listabienesPage[index] = updateFn(listabienesPage[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - obtenerNombresDepreciacion] action in Home widget.
  List<String>? nombresdepreciacion;
  // Stores action output result for [Custom Action - obtenerNombresEmpleados] action in Home widget.
  List<String>? resultadoNombres;
  // Stores action output result for [Custom Action - obtenerOficinas] action in Home widget.
  dynamic resultadoAPI;
  // Stores action output result for [Custom Action - variacion] action in CircleImage widget.
  bool? variacion;
  // Stores action output result for [Custom Action - obtenerNombresDepreciacion] action in Button widget.
  List<String>? depre2d;
  // Stores action output result for [Custom Action - obtenerOficinas] action in Button widget.
  dynamic nivel5d;
  // Stores action output result for [Custom Action - obtenerNombresDepreciacion] action in Button widget.
  List<String>? depre2;
  // Stores action output result for [Custom Action - obtenerOficinas] action in Button widget.
  dynamic nivel5;
  // Stores action output result for [Custom Action - obtenerOficinas] action in Button widget.
  dynamic nivel4;
  // Stores action output result for [Custom Action - obtenerOficinas] action in Button widget.
  dynamic nivel3;
  // Stores action output result for [Custom Action - obtenerOficinas] action in Button widget.
  dynamic nivel2;
  // Stores action output result for [Custom Action - obtenerNombresDepreciacion] action in Button widget.
  List<String>? depre1;
  // Stores action output result for [Custom Action - obtenerOficinas] action in Button widget.
  dynamic nivel1;
  // Stores action output result for [Custom Action - obtenerOficinas] action in Button widget.
  dynamic fila1;
  // Stores action output result for [Custom Action - obtenerNombresDepreciacion] action in Button widget.
  List<String>? depre1C;
  // Stores action output result for [Custom Action - obtenerOficinas] action in Button widget.
  dynamic nivel1C;
  // Stores action output result for [Custom Action - actualizarbien] action in Button widget.
  bool? editado;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
