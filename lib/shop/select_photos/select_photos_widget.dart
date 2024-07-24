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
                  context.pop();
                },
              ),
              actions: const [],
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
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1.0, 0.0),
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
                            alignment: const AlignmentDirectional(-1.0, 0.0),
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
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
                                        padding: const EdgeInsetsDirectional.fromSTEB(
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
                          alignment: const AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
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
                                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                            if (_model.selectedPhotos.contains(
                                                    purchasableimageschildItem
                                                        .toString()) ==
                                                true) {
                                              setState(() {
                                                _model.removeFromSelectedPhotos(
                                                    purchasableimageschildItem
                                                        .toString());
                                              });
                                            } else {
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
                                                padding: const EdgeInsets.all(10.0),
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
                                                        if (_model
                                                                .selectedPhotos
                                                                .contains(
                                                                    purchasableimageschildItem
                                                                        .toString()) ==
                                                            true) {
                                                          setState(() {
                                                            _model.removeFromSelectedPhotos(
                                                                purchasableimageschildItem
                                                                    .toString());
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _model.addToSelectedPhotos(
                                                                purchasableimageschildItem
                                                                    .toString());
                                                          });
                                                        }
                                                      },
                                                      onLongPress: () async {
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
                                                                    imageUploadsRecord
                                                                        .resizedImage250),
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              allowRotation:
                                                                  false,
                                                              tag: functions
                                                                  .convertToImagePath(
                                                                      imageUploadsRecord
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
                                                                imageUploadsRecord
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
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        1.0,
                                                    decoration: const BoxDecoration(
                                                      color: Color(0x5D000000),
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              -1.0, -1.0),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(
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
                  if (_model.selectedPhotos.isNotEmpty)
                    FFButtonWidget(
                      onPressed: () async {
                        _model.apiResults = await GetReviwOrderDetailsCall.call(
                          keysList: _model.selectedPhotos,
                        );

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
                        padding: const EdgeInsets.all(0.0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
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
        ));
  }
}
