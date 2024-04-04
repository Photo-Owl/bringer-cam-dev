import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/review_orderpop/review_orderpop_widget.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'select_photos_model.dart';
export 'select_photos_model.dart';

class SelectPhotosWidget extends StatefulWidget {
  const SelectPhotosWidget({super.key});

  @override
  State<SelectPhotosWidget> createState() => _SelectPhotosWidgetState();
}

class _SelectPhotosWidgetState extends State<SelectPhotosWidget> {
  late SelectPhotosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectPhotosModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'SelectPhotos'});
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
        title: 'SelectPhotos',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  logFirebaseEvent('SELECT_PHOTOS_arrow_back_rounded_ICN_ON_');
                  logFirebaseEvent('IconButton_navigate_back');
                  context.pop();
                },
              ),
              actions: [],
              centerTitle: true,
              elevation: 2.0,
            ),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 160.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Text(
                              'Selected Photos',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Text(
                              '${_model.selectedPhotos.length.toString()} Selected',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 5.0, 0.0, 0.0),
                            child: Builder(
                              builder: (context) {
                                final selectedPhotoschild =
                                    _model.selectedPhotos.toList();
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: List.generate(
                                        selectedPhotoschild.length,
                                        (selectedPhotoschildIndex) {
                                      final selectedPhotoschildItem =
                                          selectedPhotoschild[
                                              selectedPhotoschildIndex];
                                      return Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 12.0, 0.0),
                                        child:
                                            StreamBuilder<List<UploadsRecord>>(
                                          stream: queryUploadsRecord(
                                            queryBuilder: (uploadsRecord) =>
                                                uploadsRecord.where(
                                              'key',
                                              isEqualTo:
                                                  selectedPhotoschildItem,
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
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                functions.convertToImagePath(
                                                    imageUploadsRecord!
                                                        .resizedImage250),
                                                width: 75.0,
                                                height: 75.0,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 9.0, 0.0, 0.0),
                            child: Text(
                              'Your Photo Owl Gallery',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 0.0, 10.0),
                          child: Text(
                            'Long press a photo to enlarge it.',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: FutureBuilder<ApiCallResponse>(
                              future: GetPurchasableImagesCall.call(
                                uid: currentUserUid,
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
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
                                final gridViewGetPurchasableImagesResponse =
                                    snapshot.data!;
                                return Builder(
                                  builder: (context) {
                                    final purchasableimageschild =
                                        gridViewGetPurchasableImagesResponse
                                            .jsonBody
                                            .toList();
                                    return GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 5.0,
                                        mainAxisSpacing: 5.0,
                                        childAspectRatio: 1.0,
                                      ),
                                      scrollDirection: Axis.vertical,
                                      itemCount: purchasableimageschild.length,
                                      itemBuilder: (context,
                                          purchasableimageschildIndex) {
                                        final purchasableimageschildItem =
                                            purchasableimageschild[
                                                purchasableimageschildIndex];
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            logFirebaseEvent(
                                                'SELECT_PHOTOS_PAGE_Stack_9nxhhqb8_ON_TAP');
                                            if (_model.selectedPhotos.contains(
                                                    purchasableimageschildItem
                                                        .toString()) ==
                                                true) {
                                              logFirebaseEvent(
                                                  'Stack_update_page_state');
                                              setState(() {
                                                _model.removeFromSelectedPhotos(
                                                    purchasableimageschildItem
                                                        .toString());
                                              });
                                            } else {
                                              logFirebaseEvent(
                                                  'Stack_update_page_state');
                                              setState(() {
                                                _model.addToSelectedPhotos(
                                                    purchasableimageschildItem
                                                        .toString());
                                              });
                                            }
                                          },
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: FutureBuilder<
                                                    List<UploadsRecord>>(
                                                  future:
                                                      queryUploadsRecordOnce(
                                                    queryBuilder:
                                                        (uploadsRecord) =>
                                                            uploadsRecord.where(
                                                      'key',
                                                      isEqualTo:
                                                          purchasableimageschildItem
                                                              .toString(),
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
                                                    if (snapshot
                                                        .data!.isEmpty) {
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
                                                            'SELECT_PHOTOS_PAGE_Image_rqpksrnj_ON_TAP');
                                                        if (_model
                                                                .selectedPhotos
                                                                .contains(
                                                                    purchasableimageschildItem
                                                                        .toString()) ==
                                                            true) {
                                                          logFirebaseEvent(
                                                              'Image_update_page_state');
                                                          setState(() {
                                                            _model.removeFromSelectedPhotos(
                                                                purchasableimageschildItem
                                                                    .toString());
                                                          });
                                                        } else {
                                                          logFirebaseEvent(
                                                              'Image_update_page_state');
                                                          setState(() {
                                                            _model.addToSelectedPhotos(
                                                                purchasableimageschildItem
                                                                    .toString());
                                                          });
                                                        }
                                                      },
                                                      onLongPress: () async {
                                                        logFirebaseEvent(
                                                            'SELECT_PHOTOS_Image_rqpksrnj_ON_LONG_PRE');
                                                        logFirebaseEvent(
                                                            'Image_expand_image');
                                                        await Navigator.push(
                                                          context,
                                                          PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:
                                                                FlutterFlowExpandedImageView(
                                                              image:
                                                                  Image.network(
                                                                functions.convertToImagePath(
                                                                    imageUploadsRecord!
                                                                        .resizedImage250),
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              allowRotation:
                                                                  false,
                                                              tag: functions
                                                                  .convertToImagePath(
                                                                      imageUploadsRecord!
                                                                          .resizedImage250),
                                                              useHeroAnimation:
                                                                  true,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Hero(
                                                        tag: functions
                                                            .convertToImagePath(
                                                                imageUploadsRecord!
                                                                    .resizedImage250),
                                                        transitionOnUserGestures:
                                                            true,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image.network(
                                                            functions.convertToImagePath(
                                                                imageUploadsRecord!
                                                                    .resizedImage250),
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                1.0,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                1.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              if (_model.selectedPhotos
                                                  .contains(
                                                      purchasableimageschildItem
                                                          .toString()))
                                                Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0x5D000000),
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1.0, -1.0),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Icon(
                                                          Icons
                                                              .check_circle_rounded,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
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
                  if (_model.selectedPhotos.length > 0)
                    FFButtonWidget(
                      onPressed: () async {
                        logFirebaseEvent(
                            'SELECT_PHOTOS_PAGE_CONTINUE_BTN_ON_TAP');
                        logFirebaseEvent('Button_backend_call');
                        _model.apiResults = await GetReviwOrderDetailsCall.call(
                          keysList: _model.selectedPhotos,
                        );
                        logFirebaseEvent('Button_bottom_sheet');
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () => _model.unfocusNode.canRequestFocus
                                  ? FocusScope.of(context)
                                      .requestFocus(_model.unfocusNode)
                                  : FocusScope.of(context).unfocus(),
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: ReviewOrderpopWidget(
                                  cartTotal: GetReviwOrderDetailsCall.totalCost(
                                    (_model.apiResults?.jsonBody ?? ''),
                                  ),
                                  discount: GetReviwOrderDetailsCall.discount(
                                    (_model.apiResults?.jsonBody ?? ''),
                                  ),
                                  total: GetReviwOrderDetailsCall.finalTotal(
                                    (_model.apiResults?.jsonBody ?? ''),
                                  ),
                                  imagekeys: _model.selectedPhotos,
                                ),
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));

                        setState(() {});
                      },
                      text: 'Continue',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 40.0,
                        padding: EdgeInsets.all(0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                        elevation: 3.0,
                        borderSide: BorderSide(
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
        ));
  }
}
