import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/components/sharetoatendees/sharetoatendees_widget.dart';
import '/events/confirm_event_name/confirm_event_name_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'upload_model.dart';
export 'upload_model.dart';

class UploadWidget extends StatefulWidget {
  const UploadWidget({
    super.key,
    this.eventName,
  });

  final String? eventName;

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget>
    with TickerProviderStateMixin {
  late UploadModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      loop: true,
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        RotateEffect(
          curve: Curves.easeIn,
          delay: 0.ms,
          duration: 2000.ms,
          begin: -1.25,
          end: 3.0,
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Upload'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('UPLOAD_PAGE_Upload_ON_INIT_STATE');
      logFirebaseEvent('Upload_upload_media_to_firebase');
      final selectedMedia = await selectMedia(
        mediaSource: MediaSource.photoGallery,
        multiImage: true,
      );
      if (selectedMedia != null &&
          selectedMedia
              .every((m) => validateFileFormat(m.storagePath, context))) {
        setState(() => _model.isDataUploading = true);
        var selectedUploadedFiles = <FFUploadedFile>[];

        var downloadUrls = <String>[];
        try {
          showUploadMessage(
            context,
            'Uploading file...',
            showLoading: true,
          );
          selectedUploadedFiles = selectedMedia
              .map((m) => FFUploadedFile(
                    name: m.storagePath.split('/').last,
                    bytes: m.bytes,
                    height: m.dimensions?.height,
                    width: m.dimensions?.width,
                    blurHash: m.blurHash,
                  ))
              .toList();

          downloadUrls = (await Future.wait(
            selectedMedia.map(
              (m) async => await uploadData(m.storagePath, m.bytes),
            ),
          ))
              .where((u) => u != null)
              .map((u) => u!)
              .toList();
        } finally {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          _model.isDataUploading = false;
        }
        if (selectedUploadedFiles.length == selectedMedia.length &&
            downloadUrls.length == selectedMedia.length) {
          setState(() {
            _model.uploadedLocalFiles = selectedUploadedFiles;
            _model.uploadedFileUrls = downloadUrls;
          });
          showUploadMessage(context, 'Success!');
        } else {
          setState(() {});
          showUploadMessage(context, 'Failed to upload data');
          return;
        }
      }

      logFirebaseEvent('Upload_custom_action');
      _model.albumId = await actions.addurl(
        _model.uploadedFileUrls.toList(),
        currentUserUid,
      );
      logFirebaseEvent('Upload_bottom_sheet');
      await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () => _model.unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                : FocusScope.of(context).unfocus(),
            child: Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: SizedBox(
                height: 250.0,
                child: ConfirmEventNameWidget(
                  albumid: _model.albumId!,
                  eventName: widget.eventName,
                ),
              ),
            ),
          );
        },
      ).then((value) => safeSetState(() {}));

      logFirebaseEvent('Upload_alert_dialog');
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
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: const SharetoatendeesWidget(),
            ),
          );
        },
      ).then((value) => setState(() {}));

      logFirebaseEvent('Upload_backend_call');
      _model.apiResultfv5 = await SearchOnUploadCall.call(
        albumId: _model.albumId,
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

    return Builder(
      builder: (context) => Title(
          title: 'Upload',
          color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
          child: GestureDetector(
            onTap: () => _model.unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                : FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    logFirebaseEvent('UPLOAD_arrow_back_rounded_ICN_ON_TAP');
                    logFirebaseEvent('IconButton_navigate_back');
                    context.pop();
                  },
                ),
                title: Text(
                  'Upload images',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                ),
                actions: const [],
                centerTitle: true,
                elevation: 2.0,
              ),
              body: SafeArea(
                top: true,
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: StreamBuilder<UsersRecord>(
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
                      final columnUsersRecord = snapshot.data!;
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              if ((columnUsersRecord.uploadProgress < 100.0) &&
                                  (columnUsersRecord.uploadProgress > 0.0))
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 12.0,
                                        color: Color(0xFF00E66B),
                                        offset: Offset(0.0, 5.0),
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'containerOnPageLoadAnimation']!),
                              if ((columnUsersRecord.uploadProgress < 100.0) &&
                                  (columnUsersRecord.uploadProgress > 0.0))
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AuthUserStreamWidget(
                                        builder: (context) => Text(
                                          '${formatNumber(
                                            valueOrDefault(
                                                currentUserDocument
                                                    ?.uploadProgress,
                                                0.0),
                                            formatType: FormatType.custom,
                                            format: '00',
                                            locale: '',
                                          )}%',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          if ((columnUsersRecord.uploadProgress < 100.0) &&
                              (columnUsersRecord.uploadProgress > 0.0))
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: Text(
                                'Uploading',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: const BoxDecoration(),
                            child: Visibility(
                              visible:
                                  (columnUsersRecord.uploadProgress == 100.0) &&
                                      (_model.uploadedFileUrls.isNotEmpty),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Lottie.asset(
                                  'assets/lottie_animations/91068-message-sent-successfully-plane.json',
                                  height: 150.0,
                                  fit: BoxFit.cover,
                                  animate: true,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: const BoxDecoration(),
                            child: Visibility(
                              visible: _model.isDataUploading,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Lottie.network(
                                  'https://assets4.lottiefiles.com/packages/lf20_z7DhMX.json',
                                  height: 150.0,
                                  fit: BoxFit.cover,
                                  animate: true,
                                ),
                              ),
                            ),
                          ),
                          if ((columnUsersRecord.uploadProgress == 100.0) &&
                              (_model.uploadedFileUrls.isNotEmpty))
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent(
                                      'UPLOAD_PAGE_BACK_TO_HOME_BTN_ON_TAP');
                                  logFirebaseEvent('Button_navigate_to');

                                  context.pushNamed('Home');
                                },
                                text: 'Back to Home',
                                options: FFButtonOptions(
                                  width: 130.0,
                                  height: 40.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                      ),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          if ((_model.uploadedFileUrls.isEmpty) &&
                              !_model.isDataUploading)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent(
                                      'UPLOAD_PAGE_SELECT_PHOTOS_BTN_ON_TAP');
                                  logFirebaseEvent('Button_navigate_to');

                                  context.goNamed(
                                    'Upload',
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: const TransitionInfo(
                                        hasTransition: true,
                                        transitionType: PageTransitionType.fade,
                                        duration: Duration(milliseconds: 0),
                                      ),
                                    },
                                  );
                                },
                                text: 'Select Photos',
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
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
                            ),
                          if ((_model.uploadedFileUrls.isEmpty) &&
                              !_model.isDataUploading)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 15.0, 0.0, 0.0),
                              child: Text(
                                'We currently support JPG format only.',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
