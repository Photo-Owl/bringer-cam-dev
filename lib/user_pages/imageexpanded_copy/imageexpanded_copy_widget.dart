import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/expanded_image_options/expanded_image_options_widget.dart';
import '/components/invitelink/invitelink_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'imageexpanded_copy_model.dart';
export 'imageexpanded_copy_model.dart';

class ImageexpandedCopyWidget extends StatefulWidget {
  const ImageexpandedCopyWidget({
    super.key,
    required this.albumDoc,
    required this.index,
  });

  final List<ImageModelStruct>? albumDoc;
  final int? index;

  @override
  State<ImageexpandedCopyWidget> createState() =>
      _ImageexpandedCopyWidgetState();
}

class _ImageexpandedCopyWidgetState extends State<ImageexpandedCopyWidget> {
  late ImageexpandedCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ImageexpandedCopyModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'ImageexpandedCopy'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('IMAGEEXPANDED_COPY_ImageexpandedCopy_ON_');
      logFirebaseEvent('ImageexpandedCopy_google_analytics_event');
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
    return Title(
        title: 'ImageexpandedCopy',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Color(0x004B39EF),
              iconTheme: IconThemeData(
                  color: FlutterFlowTheme.of(context).secondaryBackground),
              automaticallyImplyLeading: true,
              title: Text(
                ' ',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Builder(
                builder: (context) {
                  final images = widget.albumDoc!.toList();
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    child: CarouselSlider.builder(
                      itemCount: images.length,
                      itemBuilder: (context, imagesIndex, _) {
                        final imagesItem = images[imagesIndex];
                        return StreamBuilder<List<UploadsRecord>>(
                          stream: queryUploadsRecord(
                            queryBuilder: (uploadsRecord) =>
                                uploadsRecord.where(
                              'key',
                              isEqualTo: imagesItem.id,
                            ),
                            singleRecord: true,
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
                            List<UploadsRecord> containerUploadsRecordList =
                                snapshot.data!;
                            final containerUploadsRecord =
                                containerUploadsRecordList.isNotEmpty
                                    ? containerUploadsRecordList.first
                                    : null;
                            return Container(
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (imagesItem.isLocal == false)
                                          FutureBuilder<List<UsersRecord>>(
                                            future: queryUsersRecordOnce(
                                              queryBuilder: (usersRecord) =>
                                                  usersRecord.where(
                                                'uid',
                                                isEqualTo:
                                                    containerUploadsRecord
                                                        ?.ownerId,
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
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent2,
                                                      size: 1.0,
                                                    ),
                                                  ),
                                                );
                                              }
                                              List<UsersRecord>
                                                  rowUsersRecordList =
                                                  snapshot.data!;
                                              // Return an empty Container when the item does not exist.
                                              if (snapshot.data!.isEmpty) {
                                                return Container();
                                              }
                                              final rowUsersRecord =
                                                  rowUsersRecordList.isNotEmpty
                                                      ? rowUsersRecordList.first
                                                      : null;
                                              return SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  1.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Shared By ${rowUsersRecord?.displayName}',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Inter',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                    ),
                                                    if (rowUsersRecord
                                                            ?.isBusinessAccount ??
                                                        true)
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    6.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Icon(
                                                          Icons.verified,
                                                          color:
                                                              Color(0xFF0073FF),
                                                          size: 14.0,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 6.0, 0.0, 0.0),
                                          child: Text(
                                            imagesItem.timestamp!.toString(),
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          if (!imagesItem.isLocal) {
                                            return Container(
                                              decoration: BoxDecoration(),
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child:
                                                    custom_widgets.FadeInImage(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  imageUrl: functions
                                                      .convertToImagePath(
                                                          containerUploadsRecord!
                                                              .uploadUrl),
                                                  placeholderImage: functions
                                                      .convertToImagePath(
                                                          imagesItem.imageUrl),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 10.0, 0.0, 0.0),
                                              child: Container(
                                                decoration: BoxDecoration(),
                                                child: custom_widgets
                                                    .ShowLocalImage(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  path: imagesItem.imageUrl,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 1.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          StreamBuilder<
                                              List<
                                                  PremiumPhotoPurchasesRecord>>(
                                            stream:
                                                queryPremiumPhotoPurchasesRecord(
                                              queryBuilder:
                                                  (premiumPhotoPurchasesRecord) =>
                                                      premiumPhotoPurchasesRecord
                                                          .where(
                                                            'uid',
                                                            isEqualTo:
                                                                currentUserUid,
                                                          )
                                                          .where(
                                                            'key',
                                                            isEqualTo:
                                                                imagesItem.id,
                                                          )
                                                          .where(
                                                            'status',
                                                            isEqualTo:
                                                                'Purchased',
                                                          ),
                                              singleRecord: true,
                                            ),
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 10.0,
                                                    height: 10.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
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
                                                constraints: BoxConstraints(
                                                  maxWidth: 750.0,
                                                ),
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(15.0, 10.0,
                                                          15.0, 10.0),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF0F009C),
                                                          Color(0xFF129A8C)
                                                        ],
                                                        stops: [0.0, 1.0],
                                                        begin:
                                                            AlignmentDirectional(
                                                                0.94, -1.0),
                                                        end:
                                                            AlignmentDirectional(
                                                                -0.94, 1.0),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'You Purchased this photo',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Inter',
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              13.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            5.0,
                                                                            20.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      'You can download the photo anytime here',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              logFirebaseEvent(
                                                                  'IMAGEEXPANDED_COPY_DOWNLOAD_NOW_BTN_ON_T');
                                                              logFirebaseEvent(
                                                                  'Button_custom_action');
                                                              _model.downloadURL =
                                                                  await actions
                                                                      .getDownloadUrl(
                                                                imagesItem.id,
                                                              );
                                                              logFirebaseEvent(
                                                                  'Button_custom_action');
                                                              await actions
                                                                  .downloadImage(
                                                                _model
                                                                    .downloadURL!,
                                                                imagesItem.id,
                                                              );

                                                              setState(() {});
                                                            },
                                                            text:
                                                                'Download Now',
                                                            options:
                                                                FFButtonOptions(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          12.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color:
                                                                  Colors.black,
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
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                              elevation: 2.0,
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 0.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            decoration: BoxDecoration(),
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Expanded(
                                                    child: Builder(
                                                      builder: (context) =>
                                                          InkWell(
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
                                                              'IMAGEEXPANDED_COPY_Container_u0sydobl_ON');
                                                          logFirebaseEvent(
                                                              'Container_alert_dialog');
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (dialogContext) {
                                                              return Dialog(
                                                                elevation: 0,
                                                                insetPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                alignment: AlignmentDirectional(
                                                                        0.0,
                                                                        0.0)
                                                                    .resolve(
                                                                        Directionality.of(
                                                                            context)),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () => _model
                                                                          .unfocusNode
                                                                          .canRequestFocus
                                                                      ? FocusScope.of(
                                                                              context)
                                                                          .requestFocus(_model
                                                                              .unfocusNode)
                                                                      : FocusScope.of(
                                                                              context)
                                                                          .unfocus(),
                                                                  child:
                                                                      InvitelinkWidget(),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              setState(() {}));
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            5.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .share_outlined,
                                                                  color: Color(
                                                                      0xFFFCFCFC),
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            5.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Share',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Inter',
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: InkWell(
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
                                                              'IMAGEEXPANDED_COPY_Container_qjjomigi_ON');
                                                          logFirebaseEvent(
                                                              'Container_backend_call');

                                                          await UserEventsRecord
                                                              .collection
                                                              .doc()
                                                              .set(
                                                                  createUserEventsRecordData(
                                                                eventName:
                                                                    'Download Image',
                                                                uid:
                                                                    currentUserUid,
                                                                timestamp:
                                                                    getCurrentTimestamp,
                                                                albumId: (widget
                                                                            .albumDoc?[
                                                                        widget
                                                                            .index!])
                                                                    ?.id,
                                                                key: imagesItem
                                                                    .id,
                                                              ));
                                                          logFirebaseEvent(
                                                              'Container_backend_call');

                                                          await currentUserReference!
                                                              .update(
                                                                  createUsersRecordData(
                                                            lastDownloadedAt:
                                                                getCurrentTimestamp,
                                                          ));
                                                          logFirebaseEvent(
                                                              'Container_custom_action');
                                                          _model.downloadUrl =
                                                              await actions
                                                                  .getDownloadUrl(
                                                            imagesItem.id,
                                                          );
                                                          logFirebaseEvent(
                                                              'Container_custom_action');
                                                          await actions
                                                              .downloadImage(
                                                            _model.downloadUrl!,
                                                            imagesItem.id,
                                                          );

                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            5.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .file_download_outlined,
                                                                  color: Color(
                                                                      0xFFFCFCFC),
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            5.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Download',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Inter',
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
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
                                                            'IMAGEEXPANDED_COPY_Container_ws7fg8ij_ON');
                                                        logFirebaseEvent(
                                                            'Container_bottom_sheet');
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          enableDrag: false,
                                                          useSafeArea: true,
                                                          context: context,
                                                          builder: (context) {
                                                            return GestureDetector(
                                                              onTap: () => _model
                                                                      .unfocusNode
                                                                      .canRequestFocus
                                                                  ? FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          _model
                                                                              .unfocusNode)
                                                                  : FocusScope.of(
                                                                          context)
                                                                      .unfocus(),
                                                              child: Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    Container(
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.2,
                                                                  child:
                                                                      ExpandedImageOptionsWidget(
                                                                    imageKey:
                                                                        imagesItem
                                                                            .id,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          5.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .keyboard_control_outlined,
                                                                color: Color(
                                                                    0xFFFCFCFC),
                                                                size: 24.0,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          5.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'More',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Inter',
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12.0,
                                                                      letterSpacing:
                                                                          0.0,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      carouselController: _model.carouselController ??=
                          CarouselController(),
                      options: CarouselOptions(
                        initialPage: min(
                            valueOrDefault<int>(
                              widget.index,
                              0,
                            ),
                            images.length - 1),
                        viewportFraction: 0.95,
                        disableCenter: true,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.2,
                        enableInfiniteScroll: false,
                        scrollDirection: Axis.horizontal,
                        autoPlay: false,
                        onPageChanged: (index, _) =>
                            _model.carouselCurrentIndex = index,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
