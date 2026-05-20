import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_diciembre2025_widget.dart' show HomeDiciembre2025Widget;
import 'package:flutter/material.dart';

class HomeDiciembre2025Model extends FlutterFlowModel<HomeDiciembre2025Widget> {
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

  // Stores action output result for [Custom Action - cardexsinimagen] action in Button widget.
  int? numerosumar2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
