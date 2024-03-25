import '/auth/firebase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/home_page_tab_bar/home_page_tab_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'uploads_page_model.dart';
export 'uploads_page_model.dart';

class UploadsPageWidget extends StatefulWidget {
  const UploadsPageWidget({
    super.key,
    double? uploadProgress,
  }) : uploadProgress = uploadProgress ?? 0.0;

  final double uploadProgress;

  @override
  State<UploadsPageWidget> createState() => _UploadsPageWidgetState();
}

class _UploadsPageWidgetState extends State<UploadsPageWidget> {
  late UploadsPageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadsPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: wrapWithModel(
            model: _model.homePageTabBarModel,
            updateCallback: () => setState(() {}),
            child: const HomePageTabBarWidget(
              selected: 'Gallery',
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RefreshIndicator(
              onRefresh: () async {
                logFirebaseEvent('UPLOADS_ListView_1ygeinss_ON_PULL_TO_REF');
                logFirebaseEvent('ListView_navigate_to');
                if (Navigator.of(context).canPop()) {
                  context.pop();
                }
                context.pushNamed(
                  'Uploads',
                  extra: <String, dynamic>{
                    kTransitionInfoKey: const TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.fade,
                      duration: Duration(milliseconds: 0),
                    ),
                  },
                );
              },
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: [
                  if (widget.uploadProgress > 0.0)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Photo Upload Progress',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Figtree',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          Text(
                            (double prog) {
                              return '${prog * 100}%';
                            }(widget.uploadProgress),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Figtree',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    'Not yet uploaded',
                    style: GoogleFonts.getFont(
                      'Figtree',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
                    child: FutureBuilder<List<ReadImagesToUploadRow>>(
                      future: SQLiteManager.instance.readImagesToUpload(
                        ownerId: currentUserUid,
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: Image.asset(
                              'assets/images/ezgif.com-gif-maker.gif',
                              width: 64.0,
                              height: 64.0,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        final gridViewReadImagesToUploadRowList =
                            snapshot.data!;
                        return GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (MediaQuery.sizeOf(context).width / 100)
                                    .floor(),
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                            childAspectRatio: 1.0,
                          ),
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: gridViewReadImagesToUploadRowList.length,
                          itemBuilder: (context, gridViewIndex) {
                            final gridViewReadImagesToUploadRow =
                                gridViewReadImagesToUploadRowList[
                                    gridViewIndex];
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  logFirebaseEvent(
                                      'UPLOADS_PAGE_COMP_Stack_o07fkcbe_ON_TAP');
                                  logFirebaseEvent('Stack_navigate_to');

                                  context.pushNamed(
                                    'LocalImage',
                                    queryParameters: {
                                      'path': serializeParam(
                                        gridViewReadImagesToUploadRow.path,
                                        ParamType.String,
                                      ),
                                      'isUploaded': serializeParam(
                                        false,
                                        ParamType.bool,
                                      ),
                                      'index': serializeParam(
                                        gridViewIndex,
                                        ParamType.int,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                      child: SizedBox(
                                        width: 100.0,
                                        height: 100.0,
                                        child: custom_widgets.ShowLocalImage(
                                          width: 100.0,
                                          height: 100.0,
                                          path: gridViewReadImagesToUploadRow
                                              .path,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0x99101213),
                                            Colors.transparent
                                          ],
                                          stops: [0.0, 0.4],
                                          begin: AlignmentDirectional(1.0, 1.0),
                                          end: AlignmentDirectional(-1.0, -1.0),
                                        ),
                                      ),
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(1.0, 1.0),
                                        child: Builder(
                                          builder: (context) {
                                            if (gridViewReadImagesToUploadRow
                                                    .isUploading ??
                                                false) {
                                              return Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 5.0, 5.0),
                                                child: Icon(
                                                  Icons.cloud_upload_outlined,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  size: 14.0,
                                                ),
                                              );
                                            } else {
                                              return Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 5.0, 5.0),
                                                child: FaIcon(
                                                  FontAwesomeIcons.clock,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  size: 14.0,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Text(
                    'Uploaded Images',
                    style: GoogleFonts.getFont(
                      'Figtree',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                  FutureBuilder<List<ReadUploadedImagesRow>>(
                    future: SQLiteManager.instance.readUploadedImages(
                      ownerId: currentUserUid,
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: Image.asset(
                            'assets/images/ezgif.com-gif-maker.gif',
                            width: 64.0,
                            height: 64.0,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      final gridViewReadUploadedImagesRowList = snapshot.data!;
                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (MediaQuery.sizeOf(context).width / 100).floor(),
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                          childAspectRatio: 1.0,
                        ),
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: gridViewReadUploadedImagesRowList.length,
                        itemBuilder: (context, gridViewIndex) {
                          final gridViewReadUploadedImagesRow =
                              gridViewReadUploadedImagesRowList[gridViewIndex];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'UPLOADS_PAGE_COMP_Stack_n7039dmy_ON_TAP');
                                logFirebaseEvent('Stack_navigate_to');

                                context.pushNamed(
                                  'LocalImage',
                                  queryParameters: {
                                    'path': serializeParam(
                                      gridViewReadUploadedImagesRow.path,
                                      ParamType.String,
                                    ),
                                    'isUploaded': serializeParam(
                                      true,
                                      ParamType.bool,
                                    ),
                                    'index': serializeParam(
                                      gridViewIndex,
                                      ParamType.int,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                    child: SizedBox(
                                      width: 100.0,
                                      height: 100.0,
                                      child: custom_widgets.ShowLocalImage(
                                        width: 100.0,
                                        height: 100.0,
                                        path:
                                            gridViewReadUploadedImagesRow.path,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0x99101213),
                                          Colors.transparent
                                        ],
                                        stops: [0.0, 0.4],
                                        begin: AlignmentDirectional(1.0, 1.0),
                                        end: AlignmentDirectional(-1.0, -1.0),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(1.0, 1.0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 5.0, 5.0),
                                        child: FaIcon(
                                          FontAwesomeIcons.check,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          size: 14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
