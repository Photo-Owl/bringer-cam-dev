import '/auth/firebase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'local_image_model.dart';
export 'local_image_model.dart';

class LocalImageWidget extends StatefulWidget {
  const LocalImageWidget({
    super.key,
    required this.path,
    required this.isUploaded,
    required this.index,
  });

  final String? path;
  final bool? isUploaded;
  final int? index;

  @override
  State<LocalImageWidget> createState() => _LocalImageWidgetState();
}

class _LocalImageWidgetState extends State<LocalImageWidget>
    with TickerProviderStateMixin {
  late LocalImageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'rowOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'rowOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LocalImageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'LocalImage'});

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
        title: 'LocalImage',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.black,
            body: SafeArea(
              top: true,
              child: Builder(
                builder: (context) {
                  if (widget.isUploaded ?? false) {
                    return FutureBuilder<List<ReadUploadedImagesRow>>(
                      future: SQLiteManager.instance.readUploadedImages(
                        ownerId: currentUserUid,
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
                                  Color(0xFF5282E5),
                                ),
                              ),
                            ),
                          );
                        }
                        final uploadedReadUploadedImagesRowList =
                            snapshot.data!;
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: CarouselSlider.builder(
                            itemCount: uploadedReadUploadedImagesRowList.length,
                            itemBuilder: (context, uploadedIndex, _) {
                              final uploadedReadUploadedImagesRow =
                                  uploadedReadUploadedImagesRowList[
                                      uploadedIndex];
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 20.0,
                                          borderWidth: 1.0,
                                          buttonSize: 44.0,
                                          fillColor: Colors.transparent,
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                            size: 24.0,
                                          ),
                                          onPressed: () async {
                                            logFirebaseEvent(
                                                'LOCAL_IMAGE_PAGE_arrow_back_ICN_ON_TAP');
                                            logFirebaseEvent(
                                                'IconButton_navigate_back');
                                            context.safePop();
                                          },
                                        ),
                                      ),
                                      if (!widget.isUploaded!)
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, 0.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 20.0,
                                            borderWidth: 1.0,
                                            buttonSize: 44.0,
                                            fillColor: Colors.transparent,
                                            icon: Icon(
                                              Icons.delete_rounded,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'LOCAL_IMAGE_delete_rounded_ICN_ON_TAP');
                                              logFirebaseEvent(
                                                  'IconButton_custom_action');
                                              await actions.deleteImage(
                                                uploadedReadUploadedImagesRow
                                                    .path,
                                              );
                                              logFirebaseEvent(
                                                  'IconButton_carousel');
                                              await _model.uploadedController
                                                  ?.previousPage(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ).animateOnPageLoad(animationsMap[
                                      'rowOnPageLoadAnimation1']!),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: custom_widgets.ShowLocalImage(
                                        width: double.infinity,
                                        height: double.infinity,
                                        path:
                                            uploadedReadUploadedImagesRow.path,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            carouselController: _model.uploadedController ??=
                                CarouselController(),
                            options: CarouselOptions(
                              initialPage: min(
                                  valueOrDefault<int>(
                                    widget.index,
                                    0,
                                  ),
                                  uploadedReadUploadedImagesRowList.length - 1),
                              viewportFraction: 1.0,
                              disableCenter: true,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.25,
                              enableInfiniteScroll: false,
                              scrollDirection: Axis.horizontal,
                              autoPlay: false,
                              onPageChanged: (index, _) =>
                                  _model.uploadedCurrentIndex = index,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return FutureBuilder<List<ReadImagesToUploadRow>>(
                      future: SQLiteManager.instance.readImagesToUpload(
                        ownerId: currentUserUid,
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
                                  Color(0xFF5282E5),
                                ),
                              ),
                            ),
                          );
                        }
                        final notuploadedReadImagesToUploadRowList =
                            snapshot.data!;
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: CarouselSlider.builder(
                            itemCount:
                                notuploadedReadImagesToUploadRowList.length,
                            itemBuilder: (context, notuploadedIndex, _) {
                              final notuploadedReadImagesToUploadRow =
                                  notuploadedReadImagesToUploadRowList[
                                      notuploadedIndex];
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 20.0,
                                          borderWidth: 1.0,
                                          buttonSize: 44.0,
                                          fillColor: Colors.transparent,
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                            size: 24.0,
                                          ),
                                          onPressed: () async {
                                            logFirebaseEvent(
                                                'LOCAL_IMAGE_PAGE_arrow_back_ICN_ON_TAP');
                                            logFirebaseEvent(
                                                'IconButton_navigate_back');
                                            context.safePop();
                                          },
                                        ),
                                      ),
                                      if (!widget.isUploaded!)
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, 0.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 20.0,
                                            borderWidth: 1.0,
                                            buttonSize: 44.0,
                                            fillColor: Colors.transparent,
                                            icon: Icon(
                                              Icons.delete_rounded,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'LOCAL_IMAGE_delete_rounded_ICN_ON_TAP');
                                              logFirebaseEvent(
                                                  'IconButton_custom_action');
                                              await actions.deleteImage(
                                                notuploadedReadImagesToUploadRow
                                                    .path,
                                              );
                                              logFirebaseEvent(
                                                  'IconButton_carousel');
                                              await _model.notuploadedController
                                                  ?.previousPage(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ).animateOnPageLoad(animationsMap[
                                      'rowOnPageLoadAnimation2']!),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: custom_widgets.ShowLocalImage(
                                        width: double.infinity,
                                        height: double.infinity,
                                        path: notuploadedReadImagesToUploadRow
                                            .path,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            carouselController: _model.notuploadedController ??=
                                CarouselController(),
                            options: CarouselOptions(
                              initialPage: min(
                                  valueOrDefault<int>(
                                    widget.index,
                                    0,
                                  ),
                                  notuploadedReadImagesToUploadRowList.length -
                                      1),
                              viewportFraction: 1.0,
                              disableCenter: true,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.25,
                              enableInfiniteScroll: false,
                              scrollDirection: Axis.horizontal,
                              autoPlay: false,
                              onPageChanged: (index, _) =>
                                  _model.notuploadedCurrentIndex = index,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
