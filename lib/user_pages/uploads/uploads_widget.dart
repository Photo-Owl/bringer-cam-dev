import '../../custom_code/widgets/nav_button.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/give_name/give_name_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'uploads_model.dart';
export 'uploads_model.dart';

class UploadsWidget extends StatefulWidget {
  const UploadsWidget({super.key});

  @override
  State<UploadsWidget> createState() => _UploadsWidgetState();
}

class _UploadsWidgetState extends State<UploadsWidget> {
  late UploadsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadsModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Uploads'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('UPLOADS_PAGE_Uploads_ON_INIT_STATE');
      logFirebaseEvent('Uploads_custom_action');
      _model.versionCheckResult = await actions.checkVersion();
      if (_model.versionCheckResult!) {
        logFirebaseEvent('Uploads_wait__delay');
        await Future.delayed(const Duration(milliseconds: 0));
      } else {
        logFirebaseEvent('Uploads_bottom_sheet');
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          isDismissible: false,
          enableDrag: false,
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: const UpdateRequiredWidget(),
              ),
            );
          },
        ).then((value) => safeSetState(() {}));

        return;
      }

      if (currentUserDisplayName == '') {
        logFirebaseEvent('Uploads_bottom_sheet');
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          isDismissible: false,
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: const GiveNameWidget(),
              ),
            );
          },
        ).then((value) => safeSetState(() {}));
      } else {
        logFirebaseEvent('Uploads_wait__delay');
        await Future.delayed(const Duration(milliseconds: 10));
      }

      logFirebaseEvent('Uploads_google_analytics_event');
      logFirebaseEvent(
        'Home screen shown',
        parameters: {
          'Uid': currentUserUid,
          'Name': currentUserDisplayName,
        },
      );
      logFirebaseEvent('Uploads_backend_call');

      await UserEventsRecord.collection.doc().set(createUserEventsRecordData(
            eventName: 'Home',
            uid: currentUserUid,
            timestamp: getCurrentTimestamp,
          ));
      logFirebaseEvent('Uploads_custom_action');
      _model.uploadedImages = await actions.readAllImagesSqlite(
        currentUserUid,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    context.watch<FFAppState>();

    return Title(
        title: 'Bringer  | Home',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                logFirebaseEvent('HOME_COPY_FloatingActionButton_nasjbr31_');
                logFirebaseEvent('FloatingActionButton_navigate_to');

                final selectedMedia = await selectMedia(
                  imageQuality: 100,
                  multiImage: false,
                );
                if (selectedMedia != null &&
                    selectedMedia.every(
                        (m) => validateFileFormat(m.storagePath, context))) {
                  await actions.saveFileToGallery(selectedMedia.first.filePath!);
                  final images = await actions.readAllImagesSqlite(currentUserUid);
                  setState(() {
                    _model.uploadedImages = images;
                  });
                }
              },
              backgroundColor: const Color(0xFF1589FC),
              elevation: 8.0,
              child: FaIcon(
                FontAwesomeIcons.camera,
                color: FlutterFlowTheme.of(context).secondaryBackground,
                size: 24.0,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endContained,
            bottomNavigationBar: Material(
              elevation: 8,
              color: Colors.white,
              child: BottomAppBar(
                color: Colors.transparent,
                elevation: 0,
                child: Wrap(
                  spacing: 10,
                  children: [
                    NavButton(
                      isSelected: false,
                      icon: Icons.portrait_rounded,
                      label: 'Your Photos',
                      onPressed: () => context.pushReplacementNamed('homeCopy'),
                    ),
                    NavButton(
                      isSelected: true,
                      icon: Icons.photo_library_rounded,
                      label: 'All Photos',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            drawer: Drawer(
              elevation: 16.0,
              child: wrapWithModel(
                model: _model.sidebarModel,
                updateCallback: () => setState(() {}),
                child: const SidebarWidget(
                  index: 0,
                ),
              ),
            ),
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) => [
                SliverAppBar(
                  pinned: false,
                  floating: false,
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 10.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: 20.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          icon: Icon(
                            Icons.menu,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            logFirebaseEvent('UPLOADS_PAGE_menu_ICN_ON_TAP');
                            logFirebaseEvent('IconButton_drawer');
                            scaffoldKey.currentState!.openDrawer();
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 24.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 2.0, 0.0),
                                  child: AuthUserStreamWidget(
                                    builder: (context) => Text(
                                      'Hey $currentUserDisplayName',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0x00FFFFFF),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/Waving_hand.png',
                                      width: 300.0,
                                      height: 200.0,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: const [],
                  flexibleSpace: FlexibleSpaceBar(
                    background: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Image.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  centerTitle: false,
                  elevation: 0.0,
                )
              ],
              body: Builder(
                builder: (context) {
                  return SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 3.0,
                                  color: Color(0x33000000),
                                  offset: Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: BorderRadius.circular(5.0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Upload Offline Files',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'UPLOADS_PAGE_START_UPLOAD_BTN_ON_TAP');
                                      logFirebaseEvent('Button_custom_action');
                                      await actions.uploadImagesFromSqlite(
                                          currentUserUid, () async {
                                        final uploadedImages =
                                            await actions.readAllImagesSqlite(
                                                currentUserUid);
                                        setState(() {
                                          _model.uploadedImages =
                                              uploadedImages;
                                        });
                                      });
                                    },
                                    text: 'Start Upload',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: const Color(0xFF3987EF),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Colors.white,
                                          ),
                                      elevation: 3.0,
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final uploadedImage =
                                  (_model.uploadedImages?.toList()) ?? [];
                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 125),
                                itemCount: uploadedImage.length,
                                itemBuilder: (context, index) {
                                  final uploadedImageItem =
                                      uploadedImage[index];
                                  return Stack(
                                    children: [
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            -1.0, -1.0),
                                        child: SizedBox(
                                          width: 100.0,
                                          height: 100.0,
                                          child: custom_widgets.ShowLocalImage(
                                            width: 100.0,
                                            height: 100.0,
                                            path: getJsonField(
                                              uploadedImageItem,
                                              r'''$["path"]''',
                                            ).toString(),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0x99101213),
                                              Colors.transparent
                                            ],
                                            stops: [0.0, 0.4],
                                            begin:
                                                AlignmentDirectional(1.0, 1.0),
                                            end: AlignmentDirectional(
                                                -1.0, -1.0),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: const AlignmentDirectional(
                                              1.0, 1.0),
                                          child: Builder(
                                            builder: (context) {
                                              if (getJsonField(
                                                    uploadedImageItem,
                                                    r'''$["is_uploaded"]''',
                                                  ) !=
                                                  0) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 5.0, 5.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons.check,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    size: 14.0,
                                                  ),
                                                );
                                              } else if (getJsonField(
                                                    uploadedImageItem,
                                                    r'''$["is_uploading"]''',
                                                  ) !=
                                                  0) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
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
                                                  padding:
                                                      const EdgeInsetsDirectional
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
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
