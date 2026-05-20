import '/flutter_flow/flutter_flow_util.dart';
import 'escanear_documento_widget.dart' show EscanearDocumentoWidget;
import 'package:flutter/material.dart';

class EscanearDocumentoModel extends FlutterFlowModel<EscanearDocumentoWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for NombreDocumento widget.
  FocusNode? nombreDocumentoFocusNode;
  TextEditingController? nombreDocumentoTextController;
  String? Function(BuildContext, String?)?
      nombreDocumentoTextControllerValidator;
  bool isDataUploading_uploadData8 = false;
  FFUploadedFile uploadedLocalFile_uploadData8 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadData8 = '';

  bool isDataUploading_uploadDataX9q = false;
  FFUploadedFile uploadedLocalFile_uploadDataX9q =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataX9q = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreDocumentoFocusNode?.dispose();
    nombreDocumentoTextController?.dispose();
  }
}
