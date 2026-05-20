import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login_p_j_e_v_widget.dart' show LoginPJEVWidget;
import 'package:flutter/material.dart';

class LoginPJEVModel extends FlutterFlowModel<LoginPJEVWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddressweb widget.
  FocusNode? emailAddresswebFocusNode1;
  TextEditingController? emailAddresswebTextController1;
  String? Function(BuildContext, String?)?
      emailAddresswebTextController1Validator;
  // State field(s) for passwordLoginweb widget.
  FocusNode? passwordLoginwebFocusNode1;
  TextEditingController? passwordLoginwebTextController1;
  late bool passwordLoginwebVisibility1;
  String? Function(BuildContext, String?)?
      passwordLoginwebTextController1Validator;
  // State field(s) for emailAddressweb widget.
  FocusNode? emailAddresswebFocusNode2;
  TextEditingController? emailAddresswebTextController2;
  String? Function(BuildContext, String?)?
      emailAddresswebTextController2Validator;
  // State field(s) for passwordLoginweb widget.
  FocusNode? passwordLoginwebFocusNode2;
  TextEditingController? passwordLoginwebTextController2;
  late bool passwordLoginwebVisibility2;
  String? Function(BuildContext, String?)?
      passwordLoginwebTextController2Validator;

  @override
  void initState(BuildContext context) {
    passwordLoginwebVisibility1 = false;
    passwordLoginwebVisibility2 = false;
  }

  @override
  void dispose() {
    emailAddresswebFocusNode1?.dispose();
    emailAddresswebTextController1?.dispose();

    passwordLoginwebFocusNode1?.dispose();
    passwordLoginwebTextController1?.dispose();

    emailAddresswebFocusNode2?.dispose();
    emailAddresswebTextController2?.dispose();

    passwordLoginwebFocusNode2?.dispose();
    passwordLoginwebTextController2?.dispose();
  }
}
