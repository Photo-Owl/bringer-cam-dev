import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/give_name/give_name_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/components/uploads_page_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'uploads_model.dart';
export 'uploads_model.dart';

class UploadsWidget extends StatefulWidget {
  const UploadsWidget({super.key});

  @override
  State<UploadsWidget> createState() => _UploadsWidgetState();
}

class _UploadsWidgetState extends State<UploadsWidget> {
  late UploadsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadsModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Uploads'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('UPLOADS_PAGE_Uploads_ON_INIT_STATE');
      logFirebaseEvent('Uploads_custom_action');
      _model.versionCheckResult = await actions.checkVersion();
      if (_model.versionCheckResult!) {
        logFirebaseEvent('Uploads_wait__delay');
        await Future.delayed(const Duration(milliseconds: 0));
      } else {
        logFirebaseEvent('Uploads_bottom_sheet');
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
        logFirebaseEvent('Uploads_bottom_sheet');
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
        logFirebaseEvent('Uploads_wait__delay');
        await Future.delayed(const Duration(milliseconds: 10));
      }

      logFirebaseEvent('Uploads_google_analytics_event');
      logFirebaseEvent(
        'Home screen shown',
        parameters: {
          'Uid': currentUserUid,
          'Name': currentUserDisplayName,
        },
      );
      logFirebaseEvent('Uploads_backend_call');

      await UserEventsRecord.collection.doc().set(createUserEventsRecordData(
            eventName: 'Uploads',
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
                logFirebaseEvent('UPLOADS_FloatingActionButton_namcul5b_ON');
                logFirebaseEvent('FloatingActionButton_navigate_to');

                context.pushNamed('camera');
              },
              backgroundColor: Colors.black,
              elevation: 8.0,
              child: const SizedBox(
                width: 36.0,
                height: 36.0,
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: FaIcon(
                        FontAwesomeIcons.camera,
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
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 2.0, 0.0),
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
                    ),
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 20.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    fillColor: Colors.transparent,
                    icon: const Icon(
                      Icons.upload_rounded,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    showLoadingIndicator: true,
                    onPressed: () async {
                      logFirebaseEvent(
                          'UPLOADS_PAGE_upload_rounded_ICN_ON_TAP');
                      logFirebaseEvent('IconButton_custom_action');
                      await actions.uploadImagesFromSqlite(
                        currentUserUid,
                        () async {
                          logFirebaseEvent('_backend_call');
                          await SQLiteManager.instance.fetchImagesToUpload(
                            ownerId: currentUserUid,
                          );
                        },
                        () async {
                          logFirebaseEvent('_show_snack_bar');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Upload in progress...',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.black,
                                    ),
                              ),
                              duration: const Duration(milliseconds: 4000),
                              backgroundColor: const Color(0xFFE5FFCD),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              actions: const [],
              flexibleSpace: FlexibleSpaceBar(
                background: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/Image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: wrapWithModel(
              model: _model.uploadsPageModel,
              updateCallback: () => setState(() {}),
              child: const UploadsPageWidget(),
            ),
          ),
        ));
  }
}
