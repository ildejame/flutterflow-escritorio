import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ver_escaneo_model.dart';
export 'ver_escaneo_model.dart';

class VerEscaneoWidget extends StatefulWidget {
  const VerEscaneoWidget({
    super.key,
    this.comercioParam,
  });

  final DocumentReference? comercioParam;

  static String routeName = 'VerEscaneo';
  static String routePath = 'verEscaneo';

  @override
  State<VerEscaneoWidget> createState() => _VerEscaneoWidgetState();
}

class _VerEscaneoWidgetState extends State<VerEscaneoWidget>
    with TickerProviderStateMixin {
  late VerEscaneoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerEscaneoModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
        appBar: AppBar(
          backgroundColor: Color(0xFF285C4D),
          automaticallyImplyLeading: true,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.keyboard_backspace_sharp,
              color: FlutterFlowTheme.of(context).primaryBtnText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              '9olxgt6j' /* Ver documento escaneado */,
            ),
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.poppins(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 24.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                  child: StreamBuilder<List<DocumentosScannerRecord>>(
                    stream: queryDocumentosScannerRecord(
                      parent: widget.comercioParam,
                      queryBuilder: (documentosScannerRecord) =>
                          documentosScannerRecord.orderBy('fecha',
                              descending: true),
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).accent3,
                              ),
                            ),
                          ),
                        );
                      }
                      List<DocumentosScannerRecord>
                          listViewDocumentosScannerRecordList = snapshot.data!;
                      if (listViewDocumentosScannerRecordList.isEmpty) {
                        return Center(
                          child: Image.asset(
                            'assets/images/hojablanca.png',
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listViewDocumentosScannerRecordList.length,
                        itemBuilder: (context, listViewIndex) {
                          final listViewDocumentosScannerRecord =
                              listViewDocumentosScannerRecordList[
                                  listViewIndex];
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                100.0, 0.0, 100.0, 8.0),
                            child: Container(
                              width: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x33000000),
                                    offset: Offset(
                                      2.0,
                                      8.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).accent2,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 10.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            await launchURL(
                                                valueOrDefault<String>(
                                              functions.getURLImage(
                                                  listViewDocumentosScannerRecord
                                                      .imagen),
                                              'data:image/png;base64,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',
                                            ));
                                          },
                                          child: Hero(
                                            tag: listViewDocumentosScannerRecord
                                                .imagen,
                                            transitionOnUserGestures: true,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                listViewDocumentosScannerRecord
                                                    .imagen,
                                                width: 80.0,
                                                height: 80.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        FFLocalizations.of(context).getText(
                                          '0yaufl6b' /* Fecha de captura:  */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              fontStyle: FontStyle.italic,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                      ),
                                      Text(
                                        dateTimeFormat(
                                          "d/M/y",
                                          listViewDocumentosScannerRecord
                                              .fecha!,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent1,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              fontStyle: FontStyle.italic,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'k6axcf6l' /* Quién captura:  */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.italic,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                        ),
                                        Text(
                                          valueOrDefault<String>(
                                            listViewDocumentosScannerRecord
                                                .quienComenta,
                                            'Sin especificar',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.italic,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: AutoSizeText(
                                            listViewDocumentosScannerRecord
                                                .comentario,
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await launchURL(functions.getURLIpdf(
                                                  listViewDocumentosScannerRecord
                                                      .pdfEscaneado)!);
                                            },
                                            child: AutoSizeText(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'eaef6i4v' /* Ver PDF */,
                                              ),
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation']!),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
