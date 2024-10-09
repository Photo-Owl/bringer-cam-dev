import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

import '../../pref_manager.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/fetching_photos_widget.dart';
import '/components/give_name/give_name_widget.dart';
import '/components/no_photos/no_photos_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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
      _model.versionCheckResult = await actions.checkVersion();
      if (_model.versionCheckResult!) {
        await Future.delayed(const Duration(milliseconds: 0));
      } else {
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
        await Future.delayed(const Duration(milliseconds: 10));
      }

      _model.timeline1 = await actions.getAllImages(
        currentUserUid,
      );
      var prefs = await PrefManager().prefs;
      bool removedNotifications = await prefs.remove('sent_notifications');

      print(prefs.containsKey('sent_notifications'));
      setState(() {
        _model.loaded = true;
        _model.timeline = _model.timeline1!.toList().cast<TimelineItemStruct>();
      });
      logFirebaseEvent(
        'Home_screen_shown',
        parameters: {
          'Uid': currentUserUid,
          'Name': currentUserDisplayName,
        },
      );
      await UserEventsRecord.collection.doc().set(createUserEventsRecordData(
            eventName: 'Home',
            uid: currentUserUid,
            timestamp: getCurrentTimestamp,
          ));
      //Resetting sent notifications

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

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          showSnackbar();
          showMobileLink();
        }));
  }

  Future<void> showMobileLink() async {
    final userRecord = await UsersRecord.collection
        .where('uid', isEqualTo: currentUserUid)
        .get();
    final userDoc = userRecord.docs[0];
    final userMap = userDoc.data() as Map<String, dynamic>;
    if (userMap['phone_number_verified'] == null) {
      context.pushNamed('WaitForVerification');
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> checkForPerms() async {
    const platform = MethodChannel('com.smoose.photoowldev/autoUpload');
    showPermsRequest =
        !(await platform.invokeMethod<bool>('checkForPermissions', null) ??
            false);
    safeSetState(() {});
  }

  Future<void> onRefresh() async {
    logFirebaseEvent('refresh_home', parameters: {
      'uid': currentUserUid,
    });
    setState(() {
      _model.loaded = false;
    });
    _model.timeline2 = await actions.getAllImages(
      currentUserUid,
    );
    setState(() {
      _model.loaded = true;
      _model.timeline = _model.timeline2!.toList().cast<TimelineItemStruct>();
    });
  }

  showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
          "You can turn off sharing mode Notification from the app settings"),
      action: SnackBarAction(
        label: 'Go to notification settings',
        onPressed: () {
          context.pushNamed('settingsPage');
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<FFAppState>();

    if (appState.shouldReloadGallery) {
      onRefresh();
      appState.update(() {
        appState.shouldReloadGallery = false;
      });
    }

    return Title(
        title: 'Social Gallery | Home',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
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
                  return Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.white, Color(0x00FFFFFF)],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(0.0, -1.0),
                                  end: AlignmentDirectional(0, 1.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
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
                          if (!FFAppState().isUploading &&
                              (FFAppState().uploadCount > 0.0))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 16.0, 10.0, 16.0),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * 1.0,
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                                  .readUploadedImages(),
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
                                                final showLocalImageReadUploadedImagesRowList =
                                                    snapshot.data!;
                                                return Container(
                                                  width: 48.0,
                                                  height: 48.0,
                                                  child: custom_widgets
                                                      .ShowLocalImage(
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
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10.0, 4.0, 10.0, 0.0),
                              child: Builder(
                                builder: (context) {
                                  final album = _model.timeline.toList();
                                  if (album.isEmpty) {
                                    return const Center(
                                      child: NoPhotosWidget(),
                                    );
                                  }
                                  return RefreshIndicator(
                                    key: Key('RefreshIndicator_1ydg9f2c'),
                                    onRefresh: onRefresh,
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
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(6.0, 0.0,
                                                                0.0, 6.0),
                                                    child: Text(
                                                      albumItem.date,
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(12.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Builder(
                                                          builder: (context) {
                                                            final owners =
                                                                albumItem.owners
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
                                                              direction: Axis
                                                                  .horizontal,
                                                              runAlignment:
                                                                  WrapAlignment
                                                                      .start,
                                                              verticalDirection:
                                                                  VerticalDirection
                                                                      .down,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              children: List.generate(
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
                                                                            color:
                                                                                Colors.white,
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
                                                                style: FlutterFlowTheme.of(
                                                                        context)
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                                Clip.none,
                                                            children: List.generate(
                                                                imagesList
                                                                    .length,
                                                                (imagesListIndex) {
                                                              final imagesListItem =
                                                                  imagesList[
                                                                      imagesListIndex];
                                                              return Builder(
                                                                builder:
                                                                    (context) {
                                                                  if (!imagesListItem
                                                                      .isLocal) {
                                                                    return InkWell(
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
                                                                        await Future
                                                                            .wait([
                                                                          Future(
                                                                              () async {
                                                                            context.pushNamed(
                                                                              'ImageexpandedCopy',
                                                                              queryParameters: {
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
                                                                            await actions.addSeenby(
                                                                              currentUserUid,
                                                                              imagesListItem.id,
                                                                              currentUserDisplayName,
                                                                            );
                                                                          }),
                                                                        ]);
                                                                      },
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                        child:
                                                                            OctoImage(
                                                                          placeholderBuilder: (_) =>
                                                                              SizedBox.expand(
                                                                            child:
                                                                                Image(
                                                                              image: BlurHashImage('LAKBRFxu9FWB-;M{~qRj00xu00j['),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          image:
                                                                              CachedNetworkImageProvider(
                                                                            functions.convertToImagePath(imagesListItem.imageUrl),
                                                                          ),
                                                                          width:
                                                                              (MediaQuery.sizeOf(context).width - 48) / 3,
                                                                          height:
                                                                              (MediaQuery.sizeOf(context).width - 48) / 3,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Container(
                                                                      width:
                                                                          (MediaQuery.sizeOf(context).width - 48) /
                                                                              3,
                                                                      height:
                                                                          (MediaQuery.sizeOf(context).width - 48) /
                                                                              3,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
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
                                                                          await Future
                                                                              .wait([
                                                                            Future(() async {
                                                                              logFirebaseEvent('view_image', parameters: {
                                                                                'uid': currentUserUid,
                                                                              });
                                                                              context.pushNamed(
                                                                                'ImageexpandedCopy',
                                                                                queryParameters: {
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
                                                                            Future(() async {
                                                                              await actions.addSeenby(
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
                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                child: Container(
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
                                                                                width: (MediaQuery.sizeOf(context).width - 48) / 3,
                                                                                height: (MediaQuery.sizeOf(context).width - 48) / 3,
                                                                                decoration: BoxDecoration(
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
                                                                                child: Align(
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
                      ),
                      if (showPermsRequest)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0x32FFFFFF), Colors.white],
                              stops: [0, 0.5],
                              begin: AlignmentDirectional(0, -1),
                              end: AlignmentDirectional(0, 1),
                            ),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Spacer(
                                flex: 3,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 8, 8, 24),
                                child: Text(
                                  'One final step',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: Color(0xFF72707E),
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1, -1),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      32, 0, 32, 8),
                                  child: Text(
                                    'Ready for lightning-fast⚡ photo sharing?',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 26,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1, -1),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      32, 8, 32, 0),
                                  child: Text(
                                    'This will help you safely share and receive photos from your friends and events',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF534308),
                                          fontSize: 14,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 24, 16, 24),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    if (!context.mounted) return;
                                    context.pushNamed('introShare');
                                    await checkForPerms();
                                  },
                                  text: 'Yes, Im ready',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 16, 24, 16),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    color: Color(0xFF5A00CD),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    elevation: 3,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 24, 16, 24),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xDFCEE1FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10, 0, 10, 0),
                                          child: Icon(
                                            Icons.security_sharp,
                                            color: Color(0xFF0066FF),
                                            size: 24,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 4, 0, 4),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Secure photo sharing',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 4, 0, 0),
                                                child: Text(
                                                  'All your photos are end to end encrypted',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            Color(0xFF696969),
                                                        fontSize: 12,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                              ),
                            ],
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
