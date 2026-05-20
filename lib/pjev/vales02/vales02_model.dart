import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'vales02_widget.dart' show Vales02Widget;
import 'package:flutter/material.dart';

class Vales02Model extends FlutterFlowModel<Vales02Widget> {
  ///  Local state fields for this page.

  List<DepreciacionRecord> depreci = [];
  void addToDepreci(DepreciacionRecord item) => depreci.add(item);
  void removeFromDepreci(DepreciacionRecord item) => depreci.remove(item);
  void removeAtIndexFromDepreci(int index) => depreci.removeAt(index);
  void insertAtIndexInDepreci(int index, DepreciacionRecord item) =>
      depreci.insert(index, item);
  void updateDepreciAtIndex(int index, Function(DepreciacionRecord) updateFn) =>
      depreci[index] = updateFn(depreci[index]);

  List<OficinasPJEVRecord> ubicaciones = [];
  void addToUbicaciones(OficinasPJEVRecord item) => ubicaciones.add(item);
  void removeFromUbicaciones(OficinasPJEVRecord item) =>
      ubicaciones.remove(item);
  void removeAtIndexFromUbicaciones(int index) => ubicaciones.removeAt(index);
  void insertAtIndexInUbicaciones(int index, OficinasPJEVRecord item) =>
      ubicaciones.insert(index, item);
  void updateUbicacionesAtIndex(
          int index, Function(OficinasPJEVRecord) updateFn) =>
      ubicaciones[index] = updateFn(ubicaciones[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<dynamic>();
  // Stores action output result for [Custom Action - obtenerValesPocketBase] action in Icon widget.
  List<dynamic>? valespb02;
  // Stores action output result for [Custom Action - buscarBienesYMovimientosPorFolio] action in Icon widget.
  dynamic valebien;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
