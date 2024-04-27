import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'compare_images_model.dart';
export 'compare_images_model.dart';

class CompareImagesWidget extends StatefulWidget {
  const CompareImagesWidget({
    super.key,
    required this.uploadDoc,
  });

  final UploadsRecord? uploadDoc;

  @override
  State<CompareImagesWidget> createState() => _CompareImagesWidgetState();
}

class _CompareImagesWidgetState extends State<CompareImagesWidget> {
  late CompareImagesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CompareImagesModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'compareImages'});
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
        title: 'compareImages',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryText,
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      logFirebaseEvent(
                          'COMPARE_IMAGES_Container_5666cb1h_ON_TAP');
                      logFirebaseEvent('Container_update_page_state');
                      setState(() {
                        _model.showOrginal = !_model.showOrginal;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: Stack(
                          children: [
                            if (_model.showOrginal)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: CachedNetworkImage(
                                  fadeInDuration: const Duration(milliseconds: 500),
                                  fadeOutDuration: const Duration(milliseconds: 500),
                                  imageUrl: functions.convertToImagePath(
                                      widget.uploadDoc!.uploadUrl),
                                  width: MediaQuery.sizeOf(context).width * 0.9,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            if (!_model.showOrginal)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  widget.uploadDoc!.reminiImage,
                                  width: MediaQuery.sizeOf(context).width * 0.9,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      'Tap to compare',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
