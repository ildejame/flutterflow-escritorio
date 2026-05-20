import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'homeenero2026_widget.dart' show Homeenero2026Widget;
import 'package:flutter/material.dart';

class Homeenero2026Model extends FlutterFlowModel<Homeenero2026Widget> {
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

  // Stores action output result for [Custom Action - obtenerNombresEmpleados] action in Homeenero2026 widget.
  List<String>? resultadoNombres;
  // Stores action output result for [Custom Action - obtenerDepositarios] action in Homeenero2026 widget.
  List<dynamic>? depositarios;
  // Stores action output result for [Custom Action - actualizarNivelDesdeExcel] action in Button widget.
  String? actualizacionnivel;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
