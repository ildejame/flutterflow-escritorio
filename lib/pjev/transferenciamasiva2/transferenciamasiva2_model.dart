import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'transferenciamasiva2_widget.dart' show Transferenciamasiva2Widget;
import 'package:flutter/material.dart';

class Transferenciamasiva2Model
    extends FlutterFlowModel<Transferenciamasiva2Widget> {
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
