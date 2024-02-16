import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/give_name/give_name_widget.dart';
import '/components/no_uploads/no_uploads_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'my_uploads_model.dart';
export 'my_uploads_model.dart';

class MyUploadsWidget extends StatefulWidget {
  const MyUploadsWidget({super.key});

  @override
  State<MyUploadsWidget> createState() => _MyUploadsWidgetState();
}

class _MyUploadsWidgetState extends State<MyUploadsWidget>
    with TickerProviderStateMixin {
  late MyUploadsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyUploadsModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'MyUploads'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('MY_UPLOADS_PAGE_MyUploads_ON_INIT_STATE');
      logFirebaseEvent('MyUploads_custom_action');
      _model.versionCheckResult = await actions.checkVersion();
      if (_model.versionCheckResult!) {
        logFirebaseEvent('MyUploads_wait__delay');
        await Future.delayed(const Duration(milliseconds: 0));
      } else {
        logFirebaseEvent('MyUploads_bottom_sheet');
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
        logFirebaseEvent('MyUploads_bottom_sheet');
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
        return;
      }

      logFirebaseEvent('MyUploads_google_analytics_event');
      logFirebaseEvent(
        'Home screen shown',
        parameters: {
          'Uid': currentUserUid,
          'Name': currentUserDisplayName,
        },
      );
      logFirebaseEvent('MyUploads_backend_call');

      await UserEventsRecord.collection.doc().set(createUserEventsRecordData(
            eventName: 'Home',
            uid: currentUserUid,
            timestamp: getCurrentTimestamp,
          ));
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 1,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
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

    return StreamBuilder<List<ConstantsRecord>>(
      stream: queryConstantsRecord(
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: const Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF5282E5),
                  ),
                ),
              ),
            ),
          );
        }
        List<ConstantsRecord> myUploadsConstantsRecordList = snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final myUploadsConstantsRecord = myUploadsConstantsRecordList.isNotEmpty
            ? myUploadsConstantsRecordList.first
            : null;
        return Title(
            title: 'Bringer | Home',
            color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
            child: GestureDetector(
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () async {
                    logFirebaseEvent(
                        'MY_UPLOADS_FloatingActionButton_8dl10ait');
                    logFirebaseEvent(
                        'FloatingActionButton_google_analytics_ev');
                    logFirebaseEvent(
                      'Upload Button from Home',
                      parameters: {
                        'Uid': currentUserUid,
                        'Name': currentUserDisplayName,
                      },
                    );
                    logFirebaseEvent('FloatingActionButton_backend_call');

                    await UserEventsRecord.collection
                        .doc()
                        .set(createUserEventsRecordData(
                          eventName: 'Share photos',
                          uid: currentUserUid,
                          timestamp: getCurrentTimestamp,
                        ));
                    logFirebaseEvent('FloatingActionButton_navigate_to');

                    context.pushNamed('Upload');
                  },
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  elevation: 8.0,
                  label: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.cloudUploadAlt,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Share Photos',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                drawer: Drawer(
                  elevation: 16.0,
                  child: wrapWithModel(
                    model: _model.sidebarModel,
                    updateCallback: () => setState(() {}),
                    child: const SidebarWidget(),
                  ),
                ),
                appBar: AppBar(
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
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
                            logFirebaseEvent('MY_UPLOADS_PAGE_menu_ICN_ON_TAP');
                            logFirebaseEvent('IconButton_drawer');
                            scaffoldKey.currentState!.openDrawer();
                          },
                        ),
                      ),
                      AuthUserStreamWidget(
                        builder: (context) => Text(
                          'Hey $currentUserDisplayName',
                          style: FlutterFlowTheme.of(context).titleMedium,
                        ),
                      ),
                    ],
                  ),
                  actions: const [],
                  centerTitle: false,
                  elevation: 0.0,
                ),
                body: SafeArea(
                  top: true,
                  child: Column(
                    children: [
                      Align(
                        alignment: const Alignment(0.0, 0),
                        child: FlutterFlowButtonTabBar(
                          useToggleButtonStyle: false,
                          labelStyle: FlutterFlowTheme.of(context).bodyMedium,
                          unselectedLabelStyle: const TextStyle(),
                          labelColor: FlutterFlowTheme.of(context).primaryText,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          unselectedBackgroundColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          borderWidth: 0.0,
                          borderRadius: 5.0,
                          elevation: 0.0,
                          buttonMargin: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 10.0, 10.0, 5.0),
                          tabs: const [
                            Tab(
                              text: 'My Uploads',
                            ),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [() async {}][i]();
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            KeepAliveWidgetWrapper(
                              builder: (context) => Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: StreamBuilder<List<UploadsRecord>>(
                                    stream: queryUploadsRecord(
                                      queryBuilder: (uploadsRecord) =>
                                          uploadsRecord
                                              .where(
                                                'owner_id',
                                                isEqualTo: currentUserUid,
                                              )
                                              .orderBy('uploaded_at',
                                                  descending: true),
                                    ),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Color(0xFF5282E5),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      List<UploadsRecord>
                                          gridViewUploadsRecordList =
                                          snapshot.data!;
                                      if (gridViewUploadsRecordList.isEmpty) {
                                        return const NoUploadsWidget();
                                      }
                                      return GridView.builder(
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10.0,
                                          mainAxisSpacing: 10.0,
                                          childAspectRatio: 1.0,
                                        ),
                                        scrollDirection: Axis.vertical,
                                        itemCount:
                                            gridViewUploadsRecordList.length,
                                        itemBuilder: (context, gridViewIndex) {
                                          final gridViewUploadsRecord =
                                              gridViewUploadsRecordList[
                                                  gridViewIndex];
                                          return Stack(
                                            children: [
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  logFirebaseEvent(
                                                      'MY_UPLOADS_PAGE_Image_y1fcyvlj_ON_TAP');
                                                  logFirebaseEvent(
                                                      'Image_navigate_to');

                                                  context.pushNamed(
                                                    'Imageexpanded',
                                                    queryParameters: {
                                                      'uploadsDoc':
                                                          serializeParam(
                                                        gridViewUploadsRecord,
                                                        ParamType.Document,
                                                      ),
                                                    }.withoutNulls,
                                                    extra: <String, dynamic>{
                                                      'uploadsDoc':
                                                          gridViewUploadsRecord,
                                                      kTransitionInfoKey:
                                                          const TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType:
                                                            PageTransitionType
                                                                .scale,
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                      ),
                                                    },
                                                  );
                                                },
                                                child: OctoImage(
                                                  placeholderBuilder:
                                                      OctoPlaceholder.blurHash(
                                                    'BEN]Rv-WPn}SQ[VF',
                                                  ),
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    functions.convertToImagePath(
                                                        gridViewUploadsRecord
                                                                        .resizedImage250 !=
                                                                    ''
                                                            ? gridViewUploadsRecord
                                                                .resizedImage250
                                                            : gridViewUploadsRecord
                                                                .uploadUrl),
                                                  ),
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          1.0,
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          1.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              if (valueOrDefault<bool>(
                                                    gridViewUploadsRecord
                                                                .imageUrl ==
                                                            '',
                                                    true,
                                                  ) &&
                                                  valueOrDefault<bool>(
                                                    gridViewUploadsRecord
                                                                .error ==
                                                            '',
                                                    true,
                                                  ))
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0x7FFFFFFF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(10.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        5.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .upload_sharp,
                                                              color:
                                                                  Colors.black,
                                                              size: 24.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Uploading',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (gridViewUploadsRecord.error !=
                                                      '')
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0x7FFFFFFF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(10.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        5.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons.error,
                                                              color:
                                                                  Colors.black,
                                                              size: 24.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Error ',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
