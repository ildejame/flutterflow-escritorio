import '/components/raiting/raiting_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'calif_componente_copy_copy_widget.dart'
    show CalifComponenteCopyCopyWidget;
import 'package:flutter/material.dart';

class CalifComponenteCopyCopyModel
    extends FlutterFlowModel<CalifComponenteCopyCopyWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for raiting component.
  late RaitingModel raitingModel;

  @override
  void initState(BuildContext context) {
    raitingModel = createModel(context, () => RaitingModel());
  }

  @override
  void dispose() {
    raitingModel.dispose();
  }
}
