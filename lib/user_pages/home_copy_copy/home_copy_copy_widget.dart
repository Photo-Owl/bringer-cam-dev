import 'package:flutter/services.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/fetching_photos_widget.dart';
import '/components/give_name/give_name_widget.dart';
import '/components/no_photos/no_photos_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

import 'home_copy_copy_model.dart';
export 'home_copy_copy_model.dart';

class HomeCopyCopyWidget extends StatefulWidget {
  const HomeCopyCopyWidget({super.key});

  @override
  State<HomeCopyCopyWidget> createState() => _HomeCopyCopyWidgetState();
}

class _HomeCopyCopyWidgetState extends State<HomeCopyCopyWidget>
    with TickerProviderStateMixin {
  late HomeCopyCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  var showPermsRequest = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeCopyCopyModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'HomeCopyCopy'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('HOME_COPY_COPY_HomeCopyCopy_ON_INIT_STAT');
      logFirebaseEvent('HomeCopyCopy_custom_action');
      _model.versionCheckResult = await actions.checkVersion();
      if (_model.versionCheckResult!) {
        logFirebaseEvent('HomeCopyCopy_wait__delay');
        await Future.delayed(const Duration(milliseconds: 0));
      } else {
        logFirebaseEvent('HomeCopyCopy_bottom_sheet');
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
                child: UpdateRequiredWidget(),
              ),
            );
          },
        ).then((value) => safeSetState(() {}));

        return;
      }

      if (currentUserDisplayName == null || currentUserDisplayName == '') {
        logFirebaseEvent('HomeCopyCopy_bottom_sheet');
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
                child: GiveNameWidget(),
              ),
            );
          },
        ).then((value) => safeSetState(() {}));
      } else {
        logFirebaseEvent('HomeCopyCopy_wait__delay');
        await Future.delayed(const Duration(milliseconds: 10));
      }

      logFirebaseEvent('HomeCopyCopy_google_analytics_event');
      logFirebaseEvent(
        'Home screen shown',
        parameters: {
          'Uid': currentUserUid,
          'Name': currentUserDisplayName,
        },
      );
      logFirebaseEvent('HomeCopyCopy_backend_call');

      await UserEventsRecord.collection.doc().set(createUserEventsRecordData(
            eventName: 'Home',
            uid: currentUserUid,
            timestamp: getCurrentTimestamp,
          ));
      logFirebaseEvent('HomeCopyCopy_custom_action');
      _model.timeline1 = await actions.getAllImages(
        currentUserUid,
      );
      logFirebaseEvent('HomeCopyCopy_update_page_state');
      setState(() {
        _model.loaded = true;
        _model.timeline = _model.timeline1!.toList().cast<TimelineItemStruct>();
      });

      await checkForPerms();
    });

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effects: [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 250.0.ms,
            begin: Offset(0.0, 15.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> checkForPerms() async {
    const platform = MethodChannel('com.smoose.photoowldev/autoUpload');
    showPermsRequest =
    ! (await platform.invokeMethod<bool>('checkForPermissions', null) ?? false);
    safeSetState(() {});
  }

  Future<void> onRefresh() async {
    logFirebaseEvent(
        'HOME_COPY_COPY_ListView_anbvrqxh_ON_PULL');
    logFirebaseEvent(
        'ListView_update_page_state');
    setState(() {
      _model.loaded = false;
    });
    logFirebaseEvent('ListView_custom_action');
    _model.timeline2 = await actions.getAllImages(
      currentUserUid,
    );
    logFirebaseEvent(
        'ListView_update_page_state');
    setState(() {
      _model.loaded = true;
      _model.timeline = _model.timeline2!
          .toList()
          .cast<TimelineItemStruct>();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<FFAppState>();

    if (appState.shouldReloadGallery) {
      onRefresh();
    }

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
                logFirebaseEvent('HOME_COPY_COPY_FloatingActionButton_dtrh');
                logFirebaseEvent('FloatingActionButton_navigate_to');

                context.goNamed('camera');
              },
              backgroundColor: Colors.transparent,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: FlutterFlowTheme.of(context).primaryText,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Container(
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
                child: SidebarWidget(
                  index: 0,
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              iconTheme: IconThemeData(color: Colors.black),
              automaticallyImplyLeading: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 2.0, 0.0),
                    child: AuthUserStreamWidget(
                      builder: (context) => Text(
                        'Hey ${currentUserDisplayName}',
                        textAlign: TextAlign.center,
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
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
              actions: [],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: Builder(
              builder: (context) {
                if (_model.loaded) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Color(0x00FFFFFF)],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional(0.0, -1.0),
                              end: AlignmentDirectional(0, 1.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 4.0, 0.0, 4.0),
                            child: Text(
                              'Gallery',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      if (showPermsRequest)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFF8D6), Color(0xFFFFF3B7)],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional(0.0, -1.0),
                              end: AlignmentDirectional(0, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        27.0, 27.0, 0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        width: 56.0,
                                        height: 56.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 35.0, 4.0, 0.0),
                                    child: Icon(
                                      Icons.add,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 27.0, 0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/cam.png',
                                        width: 56.0,
                                        height: 56.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 8.0, 8.0, 8.0),
                                child: Text(
                                  'Never worry about sharing photos again!',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: Color(0xFF534308),
                                        fontSize: 28.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 16.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    context.pushNamed('connectgallery');
                                    if (!context.mounted) return;
                                    await checkForPerms();
                                  },
                                  showLoadingIndicator: false,
                                  text: 'Connect Bringer to Your Camera',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 16.0, 24.0, 16.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 3.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!FFAppState().isUploading &&
                          (FFAppState().uploadCount > 0.0))
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 16.0, 10.0, 16.0),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width * 1.0,
                              maxHeight:
                                  MediaQuery.sizeOf(context).height * 0.09,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF5F5CFF),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  19.0, 15.0, 19.0, 15.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: FutureBuilder<
                                            List<ReadUploadedImagesRow>>(
                                          future: SQLiteManager.instance
                                              .readUploadedImages(
                                            ownerId: currentUserUid,
                                          ),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
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
                                            final showLocalImageReadUploadedImagesRowList =
                                                snapshot.data!;
                                            return Container(
                                              width: 48.0,
                                              height: 48.0,
                                              child:
                                                  custom_widgets.ShowLocalImage(
                                                width: 48.0,
                                                height: 48.0,
                                                path:
                                                    showLocalImageReadUploadedImagesRowList
                                                        .first.path,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      FFAppState().uploadCount > 1.0
                                          ? 'All${(double var1) {
                                              return ' ${var1.truncate()} ';
                                            }(FFAppState().uploadCount)}photos you took were shared! 🎉'
                                          : 'Photo that you took was shared! 🎉',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 4.0, 10.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              final album = _model.timeline.toList();
                              if (album.isEmpty) {
                                return Center(
                                  child: NoPhotosWidget(),
                                );
                              }
                              return RefreshIndicator(
                                key: Key('RefreshIndicator_1ydg9f2c'),
                                onRefresh: onRefresh,
                                child: ListView.separated(
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    0,
                                    8.0,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  itemCount: album.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 10.0),
                                  itemBuilder: (context, albumIndex) {
                                    final albumItem = album[albumIndex];
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Opacity(
                                            opacity: 0.6,
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        6.0, 0.0, 0.0, 6.0),
                                                child: Text(
                                                  albumItem.date,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (albumItem.owners.isNotEmpty)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF4F4FF),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Builder(
                                                      builder: (context) {
                                                        final owners = albumItem
                                                            .owners
                                                            .toList();
                                                        return Wrap(
                                                          spacing: 0.0,
                                                          runSpacing: 0.0,
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              WrapCrossAlignment
                                                                  .start,
                                                          direction:
                                                              Axis.horizontal,
                                                          runAlignment:
                                                              WrapAlignment
                                                                  .start,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .down,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          children:
                                                              List.generate(
                                                                  owners.length,
                                                                  (ownersIndex) {
                                                            final ownersItem =
                                                                owners[
                                                                    ownersIndex];
                                                            return Container(
                                                              width: 32.0,
                                                              height: 32.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  (String
                                                                      var1) {
                                                                    return var1[
                                                                        0];
                                                                  }(ownersItem),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Figtree',
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                        );
                                                      },
                                                    ),
                                                    Expanded(
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            'Photos from ${albumItem.owners.first}${(List<String> var1) {
                                                              return var1.length >
                                                                      2
                                                                  ? ', ${var1[1]} & ${var1.length - 2} more'
                                                                  : var1.length >
                                                                          1
                                                                      ? '& ${var1[1]}'
                                                                      : '';
                                                            }(albumItem.owners.toList())}!',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Figtree',
                                                                  color: Color(
                                                                      0xFF5D5AFF),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: Builder(
                                                    builder: (context) {
                                                      final imagesList =
                                                          albumItem.images
                                                              .toList();
                                                      return Wrap(
                                                        spacing: 4.0,
                                                        runSpacing: 4.0,
                                                        alignment:
                                                            WrapAlignment.start,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .start,
                                                        direction:
                                                            Axis.horizontal,
                                                        runAlignment:
                                                            WrapAlignment.start,
                                                        verticalDirection:
                                                            VerticalDirection
                                                                .down,
                                                        clipBehavior: Clip.none,
                                                        children: List.generate(
                                                            imagesList.length,
                                                            (imagesListIndex) {
                                                          final imagesListItem =
                                                              imagesList[
                                                                  imagesListIndex];
                                                          return Builder(
                                                            builder: (context) {
                                                              if (!imagesListItem
                                                                  .isLocal) {
                                                                return InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    logFirebaseEvent(
                                                                        'HOME_COPY_COPY_Image_203iliga_ON_TAP');
                                                                    await Future
                                                                        .wait([
                                                                      Future(
                                                                          () async {
                                                                        logFirebaseEvent(
                                                                            'Image_navigate_to');

                                                                        context
                                                                            .pushNamed(
                                                                          'ImageexpandedCopy',
                                                                          queryParameters:
                                                                              {
                                                                            'albumDoc':
                                                                                serializeParam(
                                                                              albumItem.images,
                                                                              ParamType.DataStruct,
                                                                              true,
                                                                            ),
                                                                            'index':
                                                                                serializeParam(
                                                                              imagesListIndex,
                                                                              ParamType.int,
                                                                            ),
                                                                          }.withoutNulls,
                                                                        );
                                                                      }),
                                                                      Future(
                                                                          () async {
                                                                        logFirebaseEvent(
                                                                            'Image_custom_action');
                                                                        await actions
                                                                            .addSeenby(
                                                                          currentUserUid,
                                                                          imagesListItem
                                                                              .id,
                                                                          currentUserDisplayName,
                                                                        );
                                                                      }),
                                                                    ]);
                                                                  },
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                    child:
                                                                        OctoImage(
                                                                      placeholderBuilder:
                                                                          (_) =>
                                                                              SizedBox.expand(
                                                                        child:
                                                                            Image(
                                                                          image:
                                                                              BlurHashImage('LAKBRFxu9FWB-;M{~qRj00xu00j['),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                      image:
                                                                          CachedNetworkImageProvider(
                                                                        functions
                                                                            .convertToImagePath(imagesListItem.imageUrl),
                                                                      ),
                                                                      width:
                                                                          (MediaQuery.sizeOf(context).width - 48) /
                                                                              3,
                                                                      height:
                                                                          (MediaQuery.sizeOf(context).width - 48) /
                                                                              3,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                );
                                                              } else {
                                                                return Container(
                                                                  width: (MediaQuery.sizeOf(context)
                                                                              .width -
                                                                          48) /
                                                                      3,
                                                                  height: (MediaQuery.sizeOf(context)
                                                                              .width -
                                                                          48) /
                                                                      3,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  child:
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
                                                                          'HOME_COPY_COPY_Stack_kr54o4qp_ON_TAP');
                                                                      await Future
                                                                          .wait([
                                                                        Future(
                                                                            () async {
                                                                          logFirebaseEvent(
                                                                              'Stack_navigate_to');

                                                                          context
                                                                              .pushNamed(
                                                                            'ImageexpandedCopy',
                                                                            queryParameters:
                                                                                {
                                                                              'albumDoc': serializeParam(
                                                                                albumItem.images,
                                                                                ParamType.DataStruct,
                                                                                true,
                                                                              ),
                                                                              'index': serializeParam(
                                                                                imagesListIndex,
                                                                                ParamType.int,
                                                                              ),
                                                                            }.withoutNulls,
                                                                          );
                                                                        }),
                                                                        Future(
                                                                            () async {
                                                                          logFirebaseEvent(
                                                                              'Stack_custom_action');
                                                                          await actions
                                                                              .addSeenby(
                                                                            currentUserUid,
                                                                            imagesListItem.id,
                                                                            currentUserDisplayName,
                                                                          );
                                                                        }),
                                                                      ]);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          80.0,
                                                                      height:
                                                                          100.0,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Container(
                                                                              width: double.infinity,
                                                                              height: double.infinity,
                                                                              child: custom_widgets.ShowLocalImage(
                                                                                width: double.infinity,
                                                                                height: double.infinity,
                                                                                path: imagesListItem.imageUrl,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                (MediaQuery.sizeOf(context).width - 48) / 3,
                                                                            height:
                                                                                (MediaQuery.sizeOf(context).width - 48) / 3,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              gradient: LinearGradient(
                                                                                colors: [
                                                                                  Color(0x99101213),
                                                                                  Colors.transparent
                                                                                ],
                                                                                stops: [
                                                                                  0.0,
                                                                                  0.4
                                                                                ],
                                                                                begin: AlignmentDirectional(1.0, 1.0),
                                                                                end: AlignmentDirectional(-1.0, -1.0),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(1.0, 1.0),
                                                                              child: Builder(
                                                                                builder: (context) {
                                                                                  if (imagesListItem.isUploading) {
                                                                                    return Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 5.0),
                                                                                      child: Icon(
                                                                                        Icons.cloud_upload_outlined,
                                                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                        size: 14.0,
                                                                                      ),
                                                                                    );
                                                                                  } else {
                                                                                    return Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 5.0),
                                                                                      child: FaIcon(
                                                                                        FontAwesomeIcons.clock,
                                                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          );
                                                        }),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ).animateOnPageLoad(animationsMap[
                                          'columnOnPageLoadAnimation']!),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: wrapWithModel(
                      model: _model.fetchingPhotosModel,
                      updateCallback: () => setState(() {}),
                      child: FetchingPhotosWidget(),
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }
}
