import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'depositarios_widget.dart' show DepositariosWidget;
import 'package:flutter/material.dart';

class DepositariosModel extends FlutterFlowModel<DepositariosWidget> {
  ///  Local state fields for this page.

  List<EmpleadospjevRecord> empleadosPJEV = [];
  void addToEmpleadosPJEV(EmpleadospjevRecord item) => empleadosPJEV.add(item);
  void removeFromEmpleadosPJEV(EmpleadospjevRecord item) =>
      empleadosPJEV.remove(item);
  void removeAtIndexFromEmpleadosPJEV(int index) =>
      empleadosPJEV.removeAt(index);
  void insertAtIndexInEmpleadosPJEV(int index, EmpleadospjevRecord item) =>
      empleadosPJEV.insert(index, item);
  void updateEmpleadosPJEVAtIndex(
          int index, Function(EmpleadospjevRecord) updateFn) =>
      empleadosPJEV[index] = updateFn(empleadosPJEV[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - obtenerDepositarios] action in Depositarios widget.
  List<dynamic>? depositarios;
  // Stores action output result for [Custom Action - actualizarempleado] action in Button widget.
  bool? resultadobien;
  // Stores action output result for [Custom Action - obtenerDepositarios] action in Button widget.
  List<dynamic>? resultadodepositarios;
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<dynamic>();
  // Stores action output result for [Custom Action - actualizadepositario] action in Icon widget.
  bool? depositarioresultado;
  // Stores action output result for [Custom Action - obtenerDepositarios] action in Icon widget.
  List<dynamic>? depositatioeditado;
  // Stores action output result for [Custom Action - confirmarBorradoEmpleado] action in Icon widget.
  bool? borradoExitoso;
  // Stores action output result for [Custom Action - obtenerDepositarios] action in Icon widget.
  List<dynamic>? depositarios02;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
