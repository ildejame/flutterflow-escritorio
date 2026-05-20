import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'depreciacion_widget.dart' show DepreciacionWidget;
import 'package:flutter/material.dart';

class DepreciacionModel extends FlutterFlowModel<DepreciacionWidget> {
  ///  Local state fields for this page.

  List<DepreciacionRecord> depreci = [];
  void addToDepreci(DepreciacionRecord item) => depreci.add(item);
  void removeFromDepreci(DepreciacionRecord item) => depreci.remove(item);
  void removeAtIndexFromDepreci(int index) => depreci.removeAt(index);
  void insertAtIndexInDepreci(int index, DepreciacionRecord item) =>
      depreci.insert(index, item);
  void updateDepreciAtIndex(int index, Function(DepreciacionRecord) updateFn) =>
      depreci[index] = updateFn(depreci[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - obtenerDepreciacionesPB] action in Depreciacion widget.
  List<dynamic>? registros;
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<dynamic>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
