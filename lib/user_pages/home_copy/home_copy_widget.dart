import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/fetching_photos_widget.dart';
import '/components/give_name/give_name_widget.dart';
import '/components/no_photos/no_photos_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'home_copy_model.dart';
export 'home_copy_model.dart';

class HomeCopyWidget extends StatefulWidget {
  const HomeCopyWidget({super.key});

  @override
  State<HomeCopyWidget> createState() => _HomeCopyWidgetState();
}

class _HomeCopyWidgetState extends State<HomeCopyWidget>
    with TickerProviderStateMixin {
  late HomeCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'columnOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 250.ms,
          begin: const Offset(0.0, 15.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    ),
    'columnOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 60.ms,
          duration: 400.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 110.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'stackOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 110.ms,
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
    _model = createModel(context, () => HomeCopyModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'HomeCopy'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('HOME_COPY_PAGE_HomeCopy_ON_INIT_STATE');
      logFirebaseEvent('HomeCopy_custom_action');
      _model.versionCheckResult = await actions.checkVersion();
      if (_model.versionCheckResult!) {
        logFirebaseEvent('HomeCopy_wait__delay');
        await Future.delayed(const Duration(milliseconds: 0));
      } else {
        logFirebaseEvent('HomeCopy_bottom_sheet');
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
        logFirebaseEvent('HomeCopy_bottom_sheet');
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
        logFirebaseEvent('HomeCopy_wait__delay');
        await Future.delayed(const Duration(milliseconds: 10));
      }

      logFirebaseEvent('HomeCopy_google_analytics_event');
      logFirebaseEvent(
        'Home screen shown',
        parameters: {
          'Uid': currentUserUid,
          'Name': currentUserDisplayName,
        },
      );
      logFirebaseEvent('HomeCopy_backend_call');

      await UserEventsRecord.collection.doc().set(createUserEventsRecordData(
            eventName: 'Home',
            uid: currentUserUid,
            timestamp: getCurrentTimestamp,
          ));
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
                logFirebaseEvent('HOME_COPY_FloatingActionButton_ihr6yqmh_');
                logFirebaseEvent('FloatingActionButton_navigate_to');

                context.pushNamed('camera');
              },
              backgroundColor: Colors.transparent,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: FlutterFlowTheme.of(context).primaryText,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: 36.0,
                    height: 36.0,
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Icon(
                            Icons.photo_camera_outlined,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(1.0, -1.0),
                          child: Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
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
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              iconTheme: const IconThemeData(color: Colors.black),
              automaticallyImplyLeading: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 2.0, 0.0),
                    child: AuthUserStreamWidget(
                      builder: (context) => Text(
                        'Hey $currentUserDisplayName',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).titleMedium,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/Waving_hand.png',
                      width: 25.0,
                      height: 25.0,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ],
              ),
              actions: const [],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                StreamBuilder<UsersRecord>(
                  stream: UsersRecord.getDocument(currentUserReference!),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return const Center(
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
                    final conditionalBuilderUsersRecord = snapshot.data!;
                    return Builder(
                      builder: (context) {
                        if (conditionalBuilderUsersRecord.progressLevel <
                            100.0) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 10.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 10.0,
                                          color: Color(0xFF2EB900),
                                          offset: Offset(-1.0, 0.0),
                                        )
                                      ],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        (double prog) {
                                          return '${prog.truncate()}%';
                                        }(conditionalBuilderUsersRecord
                                            .progressLevel),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .success,
                                              fontSize: 12.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Finding your photos',
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .success,
                                      ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            width: 0.0,
                            height: 0.0,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                Align(
                  alignment: const AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 8.0),
                    child: Text(
                      'Your photos',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                if (FFAppState().uploadProgress > 0.0)
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Photo Upload Progress',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Figtree',
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                        Text(
                          (double prog) {
                            return '${prog * 100}%';
                          }(FFAppState().uploadProgress),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Figtree',
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ],
                    ),
                  ),
                Align(
                  alignment: const AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 8.0),
                    child: Text(
                      'Not yet uploaded',
                      style: GoogleFonts.getFont(
                        'Figtree',
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
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
                      final gridViewReadImagesToUploadRowList = snapshot.data!;
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
                        itemCount: gridViewReadImagesToUploadRowList.length,
                        itemBuilder: (context, gridViewIndex) {
                          final gridViewReadImagesToUploadRow =
                              gridViewReadImagesToUploadRowList[gridViewIndex];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'HOME_COPY_PAGE_Stack_g6i9dzv5_ON_TAP');
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
                                        path:
                                            gridViewReadImagesToUploadRow.path,
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
                                      child: Builder(
                                        builder: (context) {
                                          if (gridViewReadImagesToUploadRow
                                                  .isUploading ??
                                              false) {
                                            return Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 5.0, 5.0),
                                              child: Icon(
                                                Icons.cloud_upload_outlined,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                size: 14.0,
                                              ),
                                            );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 5.0, 5.0),
                                              child: FaIcon(
                                                FontAwesomeIcons.clock,
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                    child: FutureBuilder<ApiCallResponse>(
                      future: GetMatchesCall.call(
                        uid: currentUserUid,
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return const FetchingPhotosWidget();
                        }
                        final listViewGetMatchesResponse = snapshot.data!;
                        return Builder(
                          builder: (context) {
                            final album = GetMatchesCall.matchAlbums(
                                  listViewGetMatchesResponse.jsonBody,
                                )?.toList() ??
                                [];
                            if (album.isEmpty) {
                              return const Center(
                                child: NoPhotosWidget(),
                              );
                            }
                            return RefreshIndicator(
                              onRefresh: () async {
                                logFirebaseEvent(
                                    'HOME_COPY_ListView_cwr0rn96_ON_PULL_TO_R');
                                if (valueOrDefault(
                                        currentUserDocument?.progressLevel,
                                        0.0) <
                                    99.0) {
                                  return;
                                }

                                logFirebaseEvent('ListView_backend_call');
                                unawaited(
                                  () async {
                                    await SearchFacesUsingTIFCall.call(
                                      uid: currentUserUid,
                                      sourceKey: valueOrDefault(
                                          currentUserDocument?.refrencePhotoKey,
                                          ''),
                                      faceid: valueOrDefault(
                                          currentUserDocument?.faceId, ''),
                                    );
                                  }(),
                                );
                              },
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  0,
                                  0,
                                  8.0,
                                ),
                                scrollDirection: Axis.vertical,
                                itemCount: album.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10.0),
                                itemBuilder: (context, albumIndex) {
                                  final albumItem = album[albumIndex];
                                  return StreamBuilder<List<AlbumsRecord>>(
                                    stream: queryAlbumsRecord(
                                      queryBuilder: (albumsRecord) =>
                                          albumsRecord.where(
                                        'id',
                                        isEqualTo: albumItem.toString(),
                                      ),
                                      singleRecord: true,
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
                                      List<AlbumsRecord>
                                          containerAlbumsRecordList =
                                          snapshot.data!;
                                      // Return an empty Container when the item does not exist.
                                      if (snapshot.data!.isEmpty) {
                                        return Container();
                                      }
                                      final containerAlbumsRecord =
                                          containerAlbumsRecordList.isNotEmpty
                                              ? containerAlbumsRecordList.first
                                              : null;
                                      return Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Opacity(
                                              opacity: 0.6,
                                              child: Align(
                                                alignment: const AlignmentDirectional(
                                                    -1.0, 0.0),
                                                child: Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          6.0, 0.0, 0.0, 6.0),
                                                  child: Text(
                                                    dateTimeFormat(
                                                        'relative',
                                                        containerAlbumsRecord!
                                                            .createdAt!),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            StreamBuilder<List<UsersRecord>>(
                                              stream: queryUsersRecord(
                                                queryBuilder: (usersRecord) =>
                                                    usersRecord.where(
                                                  'uid',
                                                  isEqualTo:
                                                      containerAlbumsRecord
                                                          .ownerId,
                                                ),
                                                singleRecord: true,
                                              ),
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          Color(0xFF5282E5),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                List<UsersRecord>
                                                    conditionalBuilderUsersRecordList =
                                                    snapshot.data!;
                                                // Return an empty Container when the item does not exist.
                                                if (snapshot.data!.isEmpty) {
                                                  return Container();
                                                }
                                                final conditionalBuilderUsersRecord =
                                                    conditionalBuilderUsersRecordList
                                                            .isNotEmpty
                                                        ? conditionalBuilderUsersRecordList
                                                            .first
                                                        : null;
                                                return Builder(
                                                  builder: (context) {
                                                    if (containerAlbumsRecord
                                                            .ownerId !=
                                                        currentUserUid) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.all(5.0),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 0.0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0x215D5AFF),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              border:
                                                                  Border.all(
                                                                color: const Color(
                                                                    0x005D5AFF),
                                                                width: 0.0,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap:
                                                                        () async {
                                                                      logFirebaseEvent(
                                                                          'HOME_COPY_PAGE_Row_tc74dqlx_ON_TAP');
                                                                      logFirebaseEvent(
                                                                          'Row_navigate_to');

                                                                      context
                                                                          .pushNamed(
                                                                        'Album',
                                                                        queryParameters:
                                                                            {
                                                                          'albumId':
                                                                              serializeParam(
                                                                            albumItem.toString(),
                                                                            ParamType.String,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );
                                                                    },
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              32.0,
                                                                          height:
                                                                              32.0,
                                                                          clipBehavior:
                                                                              Clip.antiAlias,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              Image.network(
                                                                            conditionalBuilderUsersRecord!.photoUrl,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                                                              10.0,
                                                                              0.0,
                                                                              0.0,
                                                                              10.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 2.0),
                                                                                    child: Text(
                                                                                      'Shared By user',
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Inter',
                                                                                            color: const Color(0xFF5D5AFF),
                                                                                            fontSize: 15.0,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                  const Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                    child: Icon(
                                                                                      Icons.verified_sharp,
                                                                                      color: Color(0xFF0E50CC),
                                                                                      size: 16.0,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                                                                    child: Text(
                                                                                      valueOrDefault<String>(
                                                                                        conditionalBuilderUsersRecord.displayName,
                                                                                        'username',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Inter',
                                                                                            fontSize: 12.0,
                                                                                            fontWeight: FontWeight.w300,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    width: 6.0,
                                                                                    height: 6.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      shape: BoxShape.circle,
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      dateTimeFormat('relative', containerAlbumsRecord.createdAt!),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Inter',
                                                                                            fontSize: 12.0,
                                                                                            fontWeight: FontWeight.w300,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation2']!),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            -1.0,
                                                                            0.0),
                                                                    child: StreamBuilder<
                                                                        List<
                                                                            UploadsRecord>>(
                                                                      stream:
                                                                          queryUploadsRecord(
                                                                        queryBuilder: (uploadsRecord) => uploadsRecord
                                                                            .where(
                                                                              'album_id',
                                                                              isEqualTo: albumItem.toString(),
                                                                            )
                                                                            .where(
                                                                              'faces',
                                                                              arrayContains: 'users/$currentUserUid',
                                                                            )
                                                                            .orderBy('uploaded_at', descending: true),
                                                                      ),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        // Customize what your widget looks like when it's loading.
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return const Center(
                                                                            child:
                                                                                SizedBox(
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
                                                                        List<UploadsRecord>
                                                                            wrapUploadsRecordList =
                                                                            snapshot.data!;
                                                                        return Wrap(
                                                                          spacing:
                                                                              0.0,
                                                                          runSpacing:
                                                                              0.0,
                                                                          alignment:
                                                                              WrapAlignment.start,
                                                                          crossAxisAlignment:
                                                                              WrapCrossAlignment.start,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          runAlignment:
                                                                              WrapAlignment.start,
                                                                          verticalDirection:
                                                                              VerticalDirection.down,
                                                                          clipBehavior:
                                                                              Clip.none,
                                                                          children: List.generate(
                                                                              wrapUploadsRecordList.length,
                                                                              (wrapIndex) {
                                                                            final wrapUploadsRecord =
                                                                                wrapUploadsRecordList[wrapIndex];
                                                                            return Container(
                                                                              width: MediaQuery.sizeOf(context).width * 0.26,
                                                                              height: 92.0,
                                                                              constraints: const BoxConstraints(
                                                                                maxWidth: 107.0,
                                                                              ),
                                                                              decoration: const BoxDecoration(),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                child: InkWell(
                                                                                  splashColor: Colors.transparent,
                                                                                  focusColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  highlightColor: Colors.transparent,
                                                                                  onTap: () async {
                                                                                    logFirebaseEvent('HOME_COPY_PAGE_Image_svfb0k14_ON_TAP');
                                                                                    logFirebaseEvent('Image_backend_call');

                                                                                    await UserEventsRecord.collection.doc().set(createUserEventsRecordData(
                                                                                          eventName: 'Image Expanded',
                                                                                          uid: currentUserUid,
                                                                                          timestamp: getCurrentTimestamp,
                                                                                          albumId: albumItem.toString(),
                                                                                          key: wrapUploadsRecord.key,
                                                                                        ));
                                                                                    logFirebaseEvent('Image_navigate_to');

                                                                                    context.pushNamed(
                                                                                      'ImageexpandedCopy',
                                                                                      queryParameters: {
                                                                                        'albumDoc': serializeParam(
                                                                                          containerAlbumsRecord,
                                                                                          ParamType.Document,
                                                                                        ),
                                                                                        'index': serializeParam(
                                                                                          wrapIndex,
                                                                                          ParamType.int,
                                                                                        ),
                                                                                      }.withoutNulls,
                                                                                      extra: <String, dynamic>{
                                                                                        'albumDoc': containerAlbumsRecord,
                                                                                        kTransitionInfoKey: const TransitionInfo(
                                                                                          hasTransition: true,
                                                                                          transitionType: PageTransitionType.scale,
                                                                                          alignment: Alignment.bottomCenter,
                                                                                        ),
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                    child: OctoImage(
                                                                                      placeholderBuilder: (_) => const SizedBox.expand(
                                                                                        child: Image(
                                                                                          image: BlurHashImage('LAKBRFxu9FWB-;M{~qRj00xu00j['),
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                      image: CachedNetworkImageProvider(
                                                                                        functions.convertToImagePath(wrapUploadsRecord.resizedImage250),
                                                                                      ),
                                                                                      width: MediaQuery.sizeOf(context).width * 0.3,
                                                                                      height: 100.0,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
                                                                          }),
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
                                                    } else {
                                                      return Padding(
                                                        padding: const EdgeInsets.all(
                                                            10.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      -1.0,
                                                                      0.0),
                                                              child: StreamBuilder<
                                                                  List<
                                                                      UploadsRecord>>(
                                                                stream:
                                                                    queryUploadsRecord(
                                                                  queryBuilder: (uploadsRecord) =>
                                                                      uploadsRecord
                                                                          .where(
                                                                            'album_id',
                                                                            isEqualTo:
                                                                                albumItem.toString(),
                                                                          )
                                                                          .orderBy(
                                                                              'uploaded_at',
                                                                              descending: true),
                                                                ),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  // Customize what your widget looks like when it's loading.
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return const Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(
                                                                            Color(0xFF5282E5),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  List<UploadsRecord>
                                                                      wrapUploadsRecordList =
                                                                      snapshot
                                                                          .data!;
                                                                  return Wrap(
                                                                    spacing:
                                                                        0.0,
                                                                    runSpacing:
                                                                        0.0,
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runAlignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    verticalDirection:
                                                                        VerticalDirection
                                                                            .down,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: List.generate(
                                                                        wrapUploadsRecordList
                                                                            .length,
                                                                        (wrapIndex) {
                                                                      final wrapUploadsRecord =
                                                                          wrapUploadsRecordList[
                                                                              wrapIndex];
                                                                      return Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(3.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            logFirebaseEvent('HOME_COPY_PAGE_Stack_nhnxy9wa_ON_TAP');
                                                                            logFirebaseEvent('Stack_navigate_to');

                                                                            context.pushNamed(
                                                                              'ImageexpandedCopy',
                                                                              queryParameters: {
                                                                                'albumDoc': serializeParam(
                                                                                  containerAlbumsRecord,
                                                                                  ParamType.Document,
                                                                                ),
                                                                                'index': serializeParam(
                                                                                  wrapIndex,
                                                                                  ParamType.int,
                                                                                ),
                                                                              }.withoutNulls,
                                                                              extra: <String, dynamic>{
                                                                                'albumDoc': containerAlbumsRecord,
                                                                                kTransitionInfoKey: const TransitionInfo(
                                                                                  hasTransition: true,
                                                                                  transitionType: PageTransitionType.scale,
                                                                                  alignment: Alignment.bottomCenter,
                                                                                ),
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.sizeOf(context).width * 0.26,
                                                                                height: 92.0,
                                                                                constraints: const BoxConstraints(
                                                                                  maxWidth: 107.0,
                                                                                ),
                                                                                decoration: const BoxDecoration(),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                  child: OctoImage(
                                                                                    placeholderBuilder: (_) => const SizedBox.expand(
                                                                                      child: Image(
                                                                                        image: BlurHashImage('LAKBRFxu9FWB-;M{~qRj00xu00j['),
                                                                                        fit: BoxFit.cover,
                                                                                      ),
                                                                                    ),
                                                                                    image: CachedNetworkImageProvider(
                                                                                      functions.convertToImagePath(wrapUploadsRecord.resizedImage250),
                                                                                    ),
                                                                                    width: MediaQuery.sizeOf(context).width * 0.3,
                                                                                    height: 100.0,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              if (wrapIndex == 5)
                                                                                InkWell(
                                                                                  splashColor: Colors.transparent,
                                                                                  focusColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  highlightColor: Colors.transparent,
                                                                                  onTap: () async {
                                                                                    logFirebaseEvent('HOME_COPY_PAGE_Container_qin92tkv_ON_TAP');
                                                                                    logFirebaseEvent('Container_navigate_to');

                                                                                    context.pushNamed(
                                                                                      'Album',
                                                                                      queryParameters: {
                                                                                        'albumId': serializeParam(
                                                                                          albumItem.toString(),
                                                                                          ParamType.String,
                                                                                        ),
                                                                                      }.withoutNulls,
                                                                                    );
                                                                                  },
                                                                                  child: Container(
                                                                                    width: MediaQuery.sizeOf(context).width * 0.26,
                                                                                    height: 92.0,
                                                                                    constraints: const BoxConstraints(
                                                                                      maxWidth: 107.0,
                                                                                    ),
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.transparent,
                                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                                    ),
                                                                                    child: Align(
                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                      child: FutureBuilder<int>(
                                                                                        future: queryUploadsRecordCount(
                                                                                          queryBuilder: (uploadsRecord) => uploadsRecord
                                                                                              .where(
                                                                                                'album_id',
                                                                                                isEqualTo: albumItem.toString(),
                                                                                              )
                                                                                              .where(
                                                                                                'faces',
                                                                                                arrayContains: (String userId) {
                                                                                                  return 'users/$userId';
                                                                                                }(currentUserUid),
                                                                                              ),
                                                                                        ),
                                                                                        builder: (context, snapshot) {
                                                                                          // Customize what your widget looks like when it's loading.
                                                                                          if (!snapshot.hasData) {
                                                                                            return const Center(
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
                                                                                          int textCount = snapshot.data!;
                                                                                          return Text(
                                                                                            (int count) {
                                                                                              return '+$count';
                                                                                            }(textCount),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Inter',
                                                                                                  color: Colors.white,
                                                                                                  fontSize: 20.0,
                                                                                                ),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ).animateOnPageLoad(animationsMap['stackOnPageLoadAnimation']!),
                                                                      );
                                                                    }),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ).animateOnPageLoad(animationsMap[
                                            'columnOnPageLoadAnimation1']!),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
