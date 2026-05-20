import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'catalogos_widget.dart' show CatalogosWidget;
import 'package:flutter/material.dart';

class CatalogosModel extends FlutterFlowModel<CatalogosWidget> {
  ///  Local state fields for this page.

  List<ListasPJEVRecord> listaCatalog = [];
  void addToListaCatalog(ListasPJEVRecord item) => listaCatalog.add(item);
  void removeFromListaCatalog(ListasPJEVRecord item) =>
      listaCatalog.remove(item);
  void removeAtIndexFromListaCatalog(int index) => listaCatalog.removeAt(index);
  void insertAtIndexInListaCatalog(int index, ListasPJEVRecord item) =>
      listaCatalog.insert(index, item);
  void updateListaCatalogAtIndex(
          int index, Function(ListasPJEVRecord) updateFn) =>
      listaCatalog[index] = updateFn(listaCatalog[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - obtenerListasPJEV] action in Catalogos widget.
  List<dynamic>? distritosresultado;
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
