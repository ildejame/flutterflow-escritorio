import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'ubicaciones_widget.dart' show UbicacionesWidget;
import 'package:flutter/material.dart';

class UbicacionesModel extends FlutterFlowModel<UbicacionesWidget> {
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

  // Stores action output result for [Custom Action - oficinas] action in Ubicaciones widget.
  List<dynamic>? listaoficinas;
  // Stores action output result for [Custom Action - creanivel] action in Button widget.
  bool? nivel;
  // Stores action output result for [Custom Action - borraniveles] action in Button widget.
  bool? salidaborrar;
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<dynamic>();
  // Stores action output result for [Custom Action - oficinas] action in Icon widget.
  List<dynamic>? listaresult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
