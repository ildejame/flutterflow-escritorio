import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'bitacora_widget.dart' show BitacoraWidget;
import 'package:flutter/material.dart';

class BitacoraModel extends FlutterFlowModel<BitacoraWidget> {
  ///  Local state fields for this page.

  List<BitacoraRecord> bitacoraLista = [];
  void addToBitacoraLista(BitacoraRecord item) => bitacoraLista.add(item);
  void removeFromBitacoraLista(BitacoraRecord item) =>
      bitacoraLista.remove(item);
  void removeAtIndexFromBitacoraLista(int index) =>
      bitacoraLista.removeAt(index);
  void insertAtIndexInBitacoraLista(int index, BitacoraRecord item) =>
      bitacoraLista.insert(index, item);
  void updateBitacoraListaAtIndex(
          int index, Function(BitacoraRecord) updateFn) =>
      bitacoraLista[index] = updateFn(bitacoraLista[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in Bitacora widget.
  List<BitacoraRecord>? bitacoraQuery;
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<BitacoraRecord>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
