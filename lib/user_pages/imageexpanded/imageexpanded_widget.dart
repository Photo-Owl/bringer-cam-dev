import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/downloadbottomsheet/downloadbottomsheet_widget.dart';
import '/components/expanded_image_options/expanded_image_options_widget.dart';
import '/components/invitelink/invitelink_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'imageexpanded_model.dart';
export 'imageexpanded_model.dart';

class ImageexpandedWidget extends StatefulWidget {
  const ImageexpandedWidget({
    super.key,
    required this.uploadsDoc,
  });

  final UploadsRecord? uploadsDoc;

  @override
  State<ImageexpandedWidget> createState() => _ImageexpandedWidgetState();
}

class _ImageexpandedWidgetState extends State<ImageexpandedWidget>
    with TickerProviderStateMixin {
  late ImageexpandedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'imageOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 100.ms,
          begin: const Offset(0.3, 0.3),
          end: const Offset(1.0, 1.0),
        ),
      ],
    ),
    'textOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 100.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ImageexpandedModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'Imageexpanded'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('IMAGEEXPANDED_Imageexpanded_ON_INIT_STAT');
      logFirebaseEvent('Imageexpanded_google_analytics_event');
      logFirebaseEvent(
        'Expanded Image',
        parameters: {
          'Uid': currentUserUid,
          'Name': currentUserDisplayName,
        },
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

    return FutureBuilder<List<AlbumsRecord>>(
      future: queryAlbumsRecordOnce(
        queryBuilder: (albumsRecord) => albumsRecord.where(
          'id',
          isEqualTo: widget.uploadsDoc?.albumId != ''
              ? widget.uploadsDoc?.albumId
              : null,
        ),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
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
        List<AlbumsRecord> imageexpandedAlbumsRecordList = snapshot.data!;
        final imageexpandedAlbumsRecord =
            imageexpandedAlbumsRecordList.isNotEmpty
                ? imageexpandedAlbumsRecordList.first
                : null;
        return Title(
            title: 'Imageexpanded',
            color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
            child: GestureDetector(
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: const Color(0xFF060606),
                  automaticallyImplyLeading: false,
                  leading: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlutterFlowIconButton(
                        borderRadius: 30.0,
                        borderWidth: 1.0,
                        buttonSize: 50.0,
                        icon: const Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () async {
                          logFirebaseEvent(
                              'IMAGEEXPANDED_arrow_back_sharp_ICN_ON_TA');
                          logFirebaseEvent('IconButton_navigate_back');
                          context.pop();
                        },
                      ),
                    ],
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(),
                        child: Visibility(
                          visible: imageexpandedAlbumsRecord != null,
                          child: Align(
                            alignment: const AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 5.0, 0.0, 2.0),
                              child: Text(
                                valueOrDefault<String>(
                                  imageexpandedAlbumsRecord?.albumName,
                                  '-',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                              ).animateOnPageLoad(
                                  animationsMap['textOnPageLoadAnimation']!),
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<List<UsersRecord>>(
                        stream: queryUsersRecord(
                          queryBuilder: (usersRecord) => usersRecord.where(
                            'uid',
                            isEqualTo: widget.uploadsDoc?.ownerId,
                          ),
                          singleRecord: true,
                        ),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 1.0,
                                height: 1.0,
                                child: SpinKitRotatingPlain(
                                  color: FlutterFlowTheme.of(context).accent2,
                                  size: 1.0,
                                ),
                              ),
                            );
                          }
                          List<UsersRecord> rowUsersRecordList = snapshot.data!;
                          // Return an empty Container when the item does not exist.
                          if (snapshot.data!.isEmpty) {
                            return Container();
                          }
                          final rowUsersRecord = rowUsersRecordList.isNotEmpty
                              ? rowUsersRecordList.first
                              : null;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 1.0, 0.0, 0.0),
                                  child: Text(
                                    'Shared By ${rowUsersRecord?.displayName}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          fontSize: 10.0,
                                        ),
                                  ),
                                ),
                                if (rowUsersRecord?.isBusinessAccount ?? true)
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 0.0, 0.0, 0.0),
                                    child: Icon(
                                      Icons.verified,
                                      color: Color(0xFF0073FF),
                                      size: 10.0,
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3.0, 1.0, 0.0, 0.0),
                                  child: Text(
                                    'on ${dateTimeFormat('yMMMd', widget.uploadsDoc?.uploadedAt)}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: const Color(0xFFECECEC),
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Builder(
                          builder: (context) => FlutterFlowIconButton(
                            borderRadius: 20.0,
                            borderWidth: 1.0,
                            buttonSize: 40.0,
                            icon: const Icon(
                              Icons.share_outlined,
                              color: Colors.white,
                              size: 23.0,
                            ),
                            onPressed: () async {
                              logFirebaseEvent(
                                  'IMAGEEXPANDED_share_outlined_ICN_ON_TAP');
                              logFirebaseEvent('IconButton_alert_dialog');
                              await showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: const AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: GestureDetector(
                                      onTap: () => _model
                                              .unfocusNode.canRequestFocus
                                          ? FocusScope.of(context)
                                              .requestFocus(_model.unfocusNode)
                                          : FocusScope.of(context).unfocus(),
                                      child: const InvitelinkWidget(),
                                    ),
                                  );
                                },
                              ).then((value) => setState(() {}));
                            },
                          ),
                        ),
                        FutureBuilder<List<PremiumPhotoPurchasesRecord>>(
                          future: queryPremiumPhotoPurchasesRecordOnce(
                            queryBuilder: (premiumPhotoPurchasesRecord) =>
                                premiumPhotoPurchasesRecord
                                    .where(
                                      'uid',
                                      isEqualTo: currentUserUid,
                                    )
                                    .where(
                                      'key',
                                      isEqualTo: widget.uploadsDoc?.key,
                                    )
                                    .where(
                                      'status',
                                      isEqualTo: 'Purchased',
                                    ),
                            singleRecord: true,
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 1.0,
                                  height: 1.0,
                                  child: SpinKitChasingDots(
                                    color: FlutterFlowTheme.of(context).accent2,
                                    size: 1.0,
                                  ),
                                ),
                              );
                            }
                            List<PremiumPhotoPurchasesRecord>
                                containerPremiumPhotoPurchasesRecordList =
                                snapshot.data!;
                            final containerPremiumPhotoPurchasesRecord =
                                containerPremiumPhotoPurchasesRecordList
                                        .isNotEmpty
                                    ? containerPremiumPhotoPurchasesRecordList
                                        .first
                                    : null;
                            return Container(
                              decoration: const BoxDecoration(),
                              child: Visibility(
                                visible:
                                    (containerPremiumPhotoPurchasesRecord !=
                                            null) ==
                                        false,
                                child: FlutterFlowIconButton(
                                  borderRadius: 20.0,
                                  borderWidth: 1.0,
                                  buttonSize: 40.0,
                                  icon: const Icon(
                                    Icons.file_download,
                                    color: Colors.white,
                                    size: 23.0,
                                  ),
                                  onPressed: () async {
                                    logFirebaseEvent(
                                        'IMAGEEXPANDED_file_download_ICN_ON_TAP');
                                    logFirebaseEvent('IconButton_backend_call');

                                    await UserEventsRecord.collection
                                        .doc()
                                        .set(createUserEventsRecordData(
                                          eventName: 'Download Image',
                                          uid: currentUserUid,
                                          timestamp: getCurrentTimestamp,
                                          albumId: widget.uploadsDoc?.albumId,
                                          key: widget.uploadsDoc?.key,
                                        ));
                                    logFirebaseEvent('IconButton_backend_call');

                                    await currentUserReference!
                                        .update(createUsersRecordData(
                                      lastDownloadedAt: getCurrentTimestamp,
                                    ));
                                    if (imageexpandedAlbumsRecord != null) {
                                      if (imageexpandedAlbumsRecord.isPremium) {
                                        logFirebaseEvent(
                                            'IconButton_bottom_sheet');
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: const Color(0x32000000),
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () => _model.unfocusNode
                                                      .canRequestFocus
                                                  ? FocusScope.of(context)
                                                      .requestFocus(
                                                          _model.unfocusNode)
                                                  : FocusScope.of(context)
                                                      .unfocus(),
                                              child: Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child: SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.9,
                                                  child:
                                                      DownloadbottomsheetWidget(
                                                    imageDocument:
                                                        widget.uploadsDoc!,
                                                    albumDocument:
                                                        imageexpandedAlbumsRecord,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));
                                      } else {
                                        logFirebaseEvent(
                                            'IconButton_custom_action');
                                        await actions.getDownloadUrl(
                                          widget.uploadsDoc!.ownerId,
                                          widget.uploadsDoc!.key,
                                        );
                                      }
                                    } else {
                                      logFirebaseEvent(
                                          'IconButton_custom_action');
                                      await actions.getDownloadUrl(
                                        widget.uploadsDoc!.ownerId,
                                        widget.uploadsDoc!.key,
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        if (widget.uploadsDoc?.ownerId == currentUserUid)
                          FlutterFlowIconButton(
                            borderWidth: 1.0,
                            buttonSize: 40.0,
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            onPressed: () async {
                              logFirebaseEvent(
                                  'IMAGEEXPANDED_PAGE_delete_ICN_ON_TAP');
                              var shouldSetState = false;
                              logFirebaseEvent('IconButton_alert_dialog');
                              var confirmDialogResponse =
                                  await showDialog<bool>(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            content: const Text(
                                                'Do you want to delete this image'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext, true),
                                                child: const Text('Confirm'),
                                              ),
                                            ],
                                          );
                                        },
                                      ) ??
                                      false;
                              if (!confirmDialogResponse) {
                                if (shouldSetState) setState(() {});
                                return;
                              }
                              logFirebaseEvent('IconButton_backend_call');
                              _model.apiResultpe6 = await DeleteImageCall.call(
                                key: widget.uploadsDoc?.key,
                              );
                              shouldSetState = true;
                              if ((_model.apiResultpe6?.succeeded ?? true)) {
                                logFirebaseEvent('IconButton_navigate_back');
                                context.safePop();
                                logFirebaseEvent('IconButton_show_snack_bar');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Photo deleted successfully',
                                      style: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 14.0,
                                          ),
                                    ),
                                    duration: const Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                  ),
                                );
                              } else {
                                logFirebaseEvent('IconButton_show_snack_bar');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error: ${(_model.apiResultpe6?.bodyText ?? '')}',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                    ),
                                    duration: const Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                );
                                if (shouldSetState) setState(() {});
                                return;
                              }

                              if (shouldSetState) setState(() {});
                            },
                          ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 10.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.black,
                            borderRadius: 20.0,
                            borderWidth: 1.0,
                            buttonSize: 40.0,
                            icon: const Icon(
                              Icons.keyboard_control,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            onPressed: () async {
                              logFirebaseEvent(
                                  'IMAGEEXPANDED_keyboard_control_ICN_ON_TA');
                              logFirebaseEvent('IconButton_bottom_sheet');
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () => _model
                                            .unfocusNode.canRequestFocus
                                        ? FocusScope.of(context)
                                            .requestFocus(_model.unfocusNode)
                                        : FocusScope.of(context).unfocus(),
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.5,
                                        child: ExpandedImageOptionsWidget(
                                          imageKey: widget.uploadsDoc!.key,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  centerTitle: false,
                  elevation: 2.0,
                ),
                body: SafeArea(
                  top: true,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.sizeOf(context).height * 0.7,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        5.0, 10.0, 5.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        logFirebaseEvent(
                                            'IMAGEEXPANDED_PAGE_Image_c067fztu_ON_TAP');
                                        logFirebaseEvent(
                                            'Image_show_snack_bar');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Download Image for full resolution',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color: Colors.white,
                                                      ),
                                            ),
                                            duration:
                                                const Duration(milliseconds: 4000),
                                            backgroundColor: Colors.black,
                                          ),
                                        );
                                        logFirebaseEvent('Image_expand_image');
                                        await Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: FlutterFlowExpandedImageView(
                                              image: OctoImage(
                                                placeholderBuilder:
                                                    OctoPlaceholder.blurHash(
                                                  'BEN]Rv-WPn}SQ[VF',
                                                ),
                                                image:
                                                    CachedNetworkImageProvider(
                                                  (imageexpandedAlbumsRecord
                                                                  ?.isPremium ==
                                                              true) &&
                                                          (widget.uploadsDoc
                                                                  ?.hasWatermarkedImage500() ==
                                                              true)
                                                      ? functions
                                                          .convertToImagePath(widget
                                                              .uploadsDoc!
                                                              .watermarkedImage500)
                                                      : functions
                                                          .convertToImagePath(widget
                                                              .uploadsDoc!
                                                              .resizedImage600),
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                              allowRotation: true,
                                              tag: (imageexpandedAlbumsRecord
                                                              ?.isPremium ==
                                                          true) &&
                                                      (widget.uploadsDoc
                                                              ?.hasWatermarkedImage500() ==
                                                          true)
                                                  ? functions
                                                      .convertToImagePath(widget
                                                          .uploadsDoc!
                                                          .watermarkedImage500)
                                                  : functions
                                                      .convertToImagePath(widget
                                                          .uploadsDoc!
                                                          .resizedImage600),
                                              useHeroAnimation: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: (imageexpandedAlbumsRecord
                                                        ?.isPremium ==
                                                    true) &&
                                                (widget.uploadsDoc
                                                        ?.hasWatermarkedImage500() ==
                                                    true)
                                            ? functions.convertToImagePath(
                                                widget.uploadsDoc!
                                                    .watermarkedImage500)
                                            : functions.convertToImagePath(
                                                widget.uploadsDoc!
                                                    .resizedImage600),
                                        transitionOnUserGestures: true,
                                        child: OctoImage(
                                          placeholderBuilder:
                                              OctoPlaceholder.blurHash(
                                            'BEN]Rv-WPn}SQ[VF',
                                          ),
                                          image: CachedNetworkImageProvider(
                                            (imageexpandedAlbumsRecord
                                                            ?.isPremium ==
                                                        true) &&
                                                    (widget.uploadsDoc
                                                            ?.hasWatermarkedImage500() ==
                                                        true)
                                                ? functions.convertToImagePath(
                                                    widget.uploadsDoc!
                                                        .watermarkedImage500)
                                                : functions.convertToImagePath(
                                                    widget.uploadsDoc!
                                                        .resizedImage600),
                                          ),
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.98,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.65,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'imageOnPageLoadAnimation']!),
                                  ),
                                ),
                                if (imageexpandedAlbumsRecord!.isPremium &&
                                    imageexpandedAlbumsRecord.hasIsPremium())
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        10.0, 50.0, 0.0, 0.0),
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .accent4,
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/crown.png',
                                          width: 2.0,
                                          height: 2.0,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (currentUserPhoto == '')
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15.0, 10.0, 15.0, 10.0),
                              child: AuthUserStreamWidget(
                                builder: (context) => Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  constraints: const BoxConstraints(
                                    maxWidth: 750.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Want to see all your photos?',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w300,
                                              ),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () async {
                                            logFirebaseEvent(
                                                'IMAGEEXPANDED_TAKE_SELFIE_BTN_ON_TAP');
                                            logFirebaseEvent(
                                                'Button_navigate_to');

                                            context.pushNamed('Redirection');
                                          },
                                          text: 'Take Selfie',
                                          options: FFButtonOptions(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                            elevation: 2.0,
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          FutureBuilder<List<PremiumPhotoPurchasesRecord>>(
                            future: queryPremiumPhotoPurchasesRecordOnce(
                              queryBuilder: (premiumPhotoPurchasesRecord) =>
                                  premiumPhotoPurchasesRecord
                                      .where(
                                        'uid',
                                        isEqualTo: currentUserUid,
                                      )
                                      .where(
                                        'key',
                                        isEqualTo: widget.uploadsDoc?.key,
                                      )
                                      .where(
                                        'status',
                                        isEqualTo: 'Purchased',
                                      ),
                              singleRecord: true,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: SizedBox(
                                    width: 10.0,
                                    height: 10.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.transparent,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<PremiumPhotoPurchasesRecord>
                                  photopurchasedPremiumPhotoPurchasesRecordList =
                                  snapshot.data!;
                              // Return an empty Container when the item does not exist.
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }
                              final photopurchasedPremiumPhotoPurchasesRecord =
                                  photopurchasedPremiumPhotoPurchasesRecordList
                                          .isNotEmpty
                                      ? photopurchasedPremiumPhotoPurchasesRecordList
                                          .first
                                      : null;
                              return Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 750.0,
                                ),
                                decoration: const BoxDecoration(),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      15.0, 10.0, 15.0, 10.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      logFirebaseEvent(
                                          'IMAGEEXPANDED_Container_dekmrgv7_ON_TAP');
                                      logFirebaseEvent(
                                          'Container_custom_action');
                                      await actions.getDownloadUrl(
                                        widget.uploadsDoc!.ownerId,
                                        widget.uploadsDoc!.key,
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF0F009C),
                                            Color(0xFF129A8C)
                                          ],
                                          stops: [0.0, 1.0],
                                          begin:
                                              AlignmentDirectional(0.94, -1.0),
                                          end: AlignmentDirectional(-0.94, 1.0),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.5,
                                              decoration: const BoxDecoration(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'You Purchased this photo',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: Colors.white,
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 5.0,
                                                                20.0, 0.0),
                                                    child: Text(
                                                      'You can download the photo anytime here',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            FFButtonWidget(
                                              onPressed: () async {
                                                logFirebaseEvent(
                                                    'IMAGEEXPANDED_DOWNLOAD_NOW_BTN_ON_TAP');
                                                logFirebaseEvent(
                                                    'Button_custom_action');
                                                await actions.getDownloadUrl(
                                                  widget.uploadsDoc!.ownerId,
                                                  widget.uploadsDoc!.key,
                                                );
                                              },
                                              text: 'Download Now',
                                              options: FFButtonOptions(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                iconPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color: Colors.black,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                elevation: 2.0,
                                                borderSide: const BorderSide(
                                                  width: 0.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          FutureBuilder<ApiCallResponse>(
                            future: GetBannerDetailsCall.call(
                              uid: currentUserUid,
                              key: widget.uploadsDoc?.key,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      width: 10.0,
                                      height: 10.0,
                                      child: SpinKitThreeBounce(
                                        color: Colors.transparent,
                                        size: 10.0,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final bannerGetBannerDetailsResponse =
                                  snapshot.data!;
                              return Container(
                                decoration: const BoxDecoration(),
                                child: Visibility(
                                  visible: valueOrDefault<bool>(
                                    bannerGetBannerDetailsResponse.succeeded,
                                    false,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: StreamBuilder<List<BannersRecord>>(
                                      stream: queryBannersRecord(
                                        queryBuilder: (bannersRecord) =>
                                            bannersRecord.where(
                                          'banner_id',
                                          isEqualTo:
                                              GetBannerDetailsCall.bannerId(
                                            bannerGetBannerDetailsResponse
                                                .jsonBody,
                                          ).toString(),
                                        ),
                                        singleRecord: true,
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: SizedBox(
                                                width: 15.0,
                                                height: 15.0,
                                                child: SpinKitWanderingCubes(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 15.0,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<BannersRecord>
                                            containerBannersRecordList =
                                            snapshot.data!;
                                        // Return an empty Container when the item does not exist.
                                        if (snapshot.data!.isEmpty) {
                                          return Container();
                                        }
                                        final containerBannersRecord =
                                            containerBannersRecordList
                                                    .isNotEmpty
                                                ? containerBannersRecordList
                                                    .first
                                                : null;
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            logFirebaseEvent(
                                                'IMAGEEXPANDED_Container_eehna9gv_ON_TAP');
                                            logFirebaseEvent(
                                                'Container_backend_call');

                                            await UserEventsRecord.collection
                                                .doc()
                                                .set(createUserEventsRecordData(
                                                  eventName: 'Banner Click',
                                                  uid: currentUserUid,
                                                  timestamp:
                                                      getCurrentTimestamp,
                                                  albumId: widget
                                                      .uploadsDoc?.albumId,
                                                  key: widget.uploadsDoc?.key,
                                                  bannerId:
                                                      containerBannersRecord
                                                          .bannerId,
                                                ));
                                            logFirebaseEvent(
                                                'Container_backend_call');

                                            await containerBannersRecord.reference
                                                .update({
                                              ...mapToFirestore(
                                                {
                                                  'click_count':
                                                      FieldValue.increment(1),
                                                },
                                              ),
                                            });
                                            logFirebaseEvent(
                                                'Container_launch_u_r_l');
                                            await launchURL(GetBannerDetailsCall
                                                .redirectUrl(
                                              bannerGetBannerDetailsResponse
                                                  .jsonBody,
                                            ).toString());
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: colorFromCssString(
                                                GetBannerDetailsCall
                                                    .bannerColor(
                                                  bannerGetBannerDetailsResponse
                                                      .jsonBody,
                                                )!,
                                                defaultColor: Colors.black,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(12.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.6,
                                                          decoration:
                                                              const BoxDecoration(),
                                                          child: Visibility(
                                                            visible: containerBannersRecord
                                                                        ?.bannerText !=
                                                                    null &&
                                                                containerBannersRecord
                                                                        ?.bannerText !=
                                                                    '',
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          5.0),
                                                              child: Text(
                                                                containerBannersRecord!
                                                                    .bannerText,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Open Sans',
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image.network(
                                                            valueOrDefault<
                                                                String>(
                                                              GetBannerDetailsCall
                                                                  .imageUrl(
                                                                bannerGetBannerDetailsResponse
                                                                    .jsonBody,
                                                              ),
                                                              '123',
                                                            ),
                                                            height: 35.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                5.0, 0.0),
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        logFirebaseEvent(
                                                            'IMAGEEXPANDED_PAGE_>_BTN_ON_TAP');
                                                        logFirebaseEvent(
                                                            'Button_backend_call');

                                                        await UserEventsRecord
                                                            .collection
                                                            .doc()
                                                            .set(
                                                                createUserEventsRecordData(
                                                              eventName:
                                                                  'Banner Click',
                                                              uid:
                                                                  currentUserUid,
                                                              timestamp:
                                                                  getCurrentTimestamp,
                                                              albumId: widget
                                                                  .uploadsDoc
                                                                  ?.albumId,
                                                              key: widget
                                                                  .uploadsDoc
                                                                  ?.key,
                                                              bannerId:
                                                                  containerBannersRecord
                                                                      .bannerId,
                                                            ));
                                                        logFirebaseEvent(
                                                            'Button_backend_call');

                                                        await containerBannersRecord.reference
                                                            .update({
                                                          ...mapToFirestore(
                                                            {
                                                              'click_count':
                                                                  FieldValue
                                                                      .increment(
                                                                          1),
                                                            },
                                                          ),
                                                        });
                                                        logFirebaseEvent(
                                                            'Button_launch_u_r_l');
                                                        await launchURL(
                                                            GetBannerDetailsCall
                                                                .redirectUrl(
                                                          bannerGetBannerDetailsResponse
                                                              .jsonBody,
                                                        ).toString());
                                                      },
                                                      text: '>',
                                                      options: FFButtonOptions(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8.0,
                                                                    5.0,
                                                                    8.0,
                                                                    5.0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        color:
                                                            colorFromCssString(
                                                          GetBannerDetailsCall
                                                              .buttonColor(
                                                            bannerGetBannerDetailsResponse
                                                                .jsonBody,
                                                          )!,
                                                          defaultColor:
                                                              Colors.black,
                                                        ),
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      20.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                        elevation: 0.0,
                                                        borderSide: const BorderSide(
                                                          width: 0.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          if (imageexpandedAlbumsRecord.hasExpiry() ?? true)
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 0.0, 0.0),
                                        child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'This photo expires on  ',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBtnText,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                              ),
                                              TextSpan(
                                                text: dateTimeFormat(
                                                    'yMMMd',
                                                    imageexpandedAlbumsRecord.expiry!),
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            ],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
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
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
