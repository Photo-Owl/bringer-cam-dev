import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/give_name/give_name_widget.dart';
import '/components/no_photos/no_photos_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'gridViewOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 0.ms,
          begin: const Offset(0.0, 0.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    ),
    'imageOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 370.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 400.ms,
          begin: const Offset(0.0, 5.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Home'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('HOME_PAGE_Home_ON_INIT_STATE');
      logFirebaseEvent('Home_custom_action');
      _model.versionCheckResult = await actions.checkVersion();
      if (_model.versionCheckResult!) {
        logFirebaseEvent('Home_wait__delay');
        await Future.delayed(const Duration(milliseconds: 0));
      } else {
        logFirebaseEvent('Home_bottom_sheet');
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
        logFirebaseEvent('Home_bottom_sheet');
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

      logFirebaseEvent('Home_google_analytics_event');
      logFirebaseEvent(
        'Home screen shown',
        parameters: {
          'Uid': currentUserUid,
          'Name': currentUserDisplayName,
        },
      );
      logFirebaseEvent('Home_backend_call');

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

    return Title(
        title: 'Bringer  | Home',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            drawer: Drawer(
              elevation: 16.0,
              child: wrapWithModel(
                model: _model.sidebarModel,
                updateCallback: () => setState(() {}),
                child: const SidebarWidget(),
              ),
            ),
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
                      fillColor: Colors.white,
                      icon: Icon(
                        Icons.menu,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        logFirebaseEvent('HOME_PAGE_menu_ICN_ON_TAP');
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
              flexibleSpace: FlexibleSpaceBar(
                background: Opacity(
                  opacity: 0.9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/Frame_2608863.png',
                      fit: BoxFit.none,
                    ),
                  ),
                ),
              ),
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
                      buttonMargin:
                          const EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 10.0, 5.0),
                      tabs: const [
                        Tab(
                          text: 'My Photos',
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
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: StreamBuilder<UsersRecord>(
                                  stream: UsersRecord.getDocument(
                                      currentUserReference!),
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
                                    final containerUsersRecord = snapshot.data!;
                                    return Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.sizeOf(context).height *
                                                0.09,
                                      ),
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
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          if (containerUsersRecord
                                                  .progressLevel <
                                              100.0)
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                10.0, 0.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            blurRadius: 10.0,
                                                            color: Color(
                                                                0xFF2EB900),
                                                            offset: Offset(
                                                                -1.0, 0.0),
                                                          )
                                                        ],
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(
                                                            10.0),
                                                        child: Text(
                                                          '${formatNumber(
                                                            containerUsersRecord
                                                                .progressLevel,
                                                            formatType:
                                                                FormatType
                                                                    .custom,
                                                            format: '00',
                                                            locale: '',
                                                          )}%',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .success,
                                                                fontSize: 12.0,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Finding your photos',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (containerUsersRecord
                                                  .progressLevel >=
                                              100.0)
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      'Got your photos here ! ',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.75,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: StreamBuilder<List<MatchesRecord>>(
                                    stream: queryMatchesRecord(
                                      queryBuilder: (matchesRecord) =>
                                          matchesRecord
                                              .where(
                                                'uid',
                                                isEqualTo: currentUserUid,
                                              )
                                              .where(
                                                'is_matched',
                                                isEqualTo: true,
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
                                      List<MatchesRecord>
                                          gridViewMatchesRecordList =
                                          snapshot.data!;
                                      if (gridViewMatchesRecordList.isEmpty) {
                                        return const NoPhotosWidget();
                                      }
                                      return RefreshIndicator(
                                        onRefresh: () async {
                                          logFirebaseEvent(
                                              'HOME_StaggeredView_42r3omoo_ON_PULL_TO_R');
                                          logFirebaseEvent(
                                              'GridView_backend_call');
                                          _model.apiResultruf =
                                              await SearchFacesUsingTIFCall
                                                  .call(
                                            uid: currentUserUid,
                                            sourceKey: valueOrDefault(
                                                currentUserDocument
                                                    ?.refrencePhotoKey,
                                                ''),
                                            faceid: valueOrDefault(
                                                currentUserDocument?.faceId,
                                                ''),
                                          );
                                          if ((_model.apiResultruf?.succeeded ??
                                              true)) {
                                            logFirebaseEvent(
                                                'GridView_show_snack_bar');
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Refresh success',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                ),
                                                duration: const Duration(
                                                    milliseconds: 5850),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                              ),
                                            );
                                          } else {
                                            logFirebaseEvent(
                                                'GridView_show_snack_bar');
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Error',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                ),
                                                duration: const Duration(
                                                    milliseconds: 5850),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                              ),
                                            );
                                          }
                                        },
                                        child: GridView.builder(
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
                                              gridViewMatchesRecordList.length,
                                          itemBuilder:
                                              (context, gridViewIndex) {
                                            final gridViewMatchesRecord =
                                                gridViewMatchesRecordList[
                                                    gridViewIndex];
                                            return StreamBuilder<
                                                List<UploadsRecord>>(
                                              stream: queryUploadsRecord(
                                                queryBuilder: (uploadsRecord) =>
                                                    uploadsRecord.where(
                                                  'key',
                                                  isEqualTo:
                                                      gridViewMatchesRecord.key,
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
                                                List<UploadsRecord>
                                                    imageUploadsRecordList =
                                                    snapshot.data!;
                                                // Return an empty Container when the item does not exist.
                                                if (snapshot.data!.isEmpty) {
                                                  return Container();
                                                }
                                                final imageUploadsRecord =
                                                    imageUploadsRecordList
                                                            .isNotEmpty
                                                        ? imageUploadsRecordList
                                                            .first
                                                        : null;
                                                return InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    logFirebaseEvent(
                                                        'HOME_PAGE_Image_3y4i5s4v_ON_TAP');
                                                    logFirebaseEvent(
                                                        'Image_backend_call');

                                                    await UserEventsRecord
                                                        .collection
                                                        .doc()
                                                        .set(
                                                            createUserEventsRecordData(
                                                          eventName:
                                                              'Image Expanded',
                                                          uid: currentUserUid,
                                                          timestamp:
                                                              getCurrentTimestamp,
                                                          albumId:
                                                              imageUploadsRecord
                                                                  .albumId,
                                                          key:
                                                              imageUploadsRecord
                                                                  .key,
                                                        ));
                                                    logFirebaseEvent(
                                                        'Image_navigate_to');

                                                    context.pushNamed(
                                                      'Imageexpanded',
                                                      queryParameters: {
                                                        'uploadsDoc':
                                                            serializeParam(
                                                          imageUploadsRecord,
                                                          ParamType.Document,
                                                        ),
                                                      }.withoutNulls,
                                                      extra: <String, dynamic>{
                                                        'uploadsDoc':
                                                            imageUploadsRecord,
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
                                                  child: Hero(
                                                    tag: functions.convertToImagePath(
                                                        imageUploadsRecord
                                                                        ?.resizedImage250 !=
                                                                    null &&
                                                                imageUploadsRecord
                                                                        ?.resizedImage250 !=
                                                                    ''
                                                            ? imageUploadsRecord!
                                                                .resizedImage250
                                                            : imageUploadsRecord!
                                                                .imageUrl),
                                                    transitionOnUserGestures:
                                                        true,
                                                    child: OctoImage(
                                                      placeholderBuilder:
                                                          OctoPlaceholder
                                                              .blurHash(
                                                        'BEN]Rv-WPn}SQ[VF',
                                                      ),
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        functions.convertToImagePath(imageUploadsRecord
                                                                        .resizedImage250 !=
                                                                    ''
                                                            ? imageUploadsRecord.resizedImage250
                                                            : imageUploadsRecord.imageUrl),
                                                      ),
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          1.0,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          1.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ).animateOnPageLoad(animationsMap[
                                                    'imageOnPageLoadAnimation']!);
                                              },
                                            );
                                          },
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'gridViewOnPageLoadAnimation']!);
                                    },
                                  ),
                                ),
                              ),
                            ],
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
  }
}
