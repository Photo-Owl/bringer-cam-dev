import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'report_options_model.dart';
export 'report_options_model.dart';

class ReportOptionsWidget extends StatefulWidget {
  const ReportOptionsWidget({
    super.key,
    required this.imageKey,
  });

  final String? imageKey;

  @override
  State<ReportOptionsWidget> createState() => _ReportOptionsWidgetState();
}

class _ReportOptionsWidgetState extends State<ReportOptionsWidget> {
  late ReportOptionsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportOptionsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: MediaQuery.sizeOf(context).height * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Image',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).error,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              'Tell us what went wrong',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  logFirebaseEvent('REPORT_OPTIONS_Container_evwrcs78_ON_TAP');
                  logFirebaseEvent('Container_backend_call');

                  await ImageReportsRecord.collection
                      .doc()
                      .set(createImageReportsRecordData(
                        key: widget.imageKey,
                        uid: currentUserUid,
                        reason: 'I\'m not in this image',
                      ));
                  logFirebaseEvent('Container_alert_dialog');
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: const Text('Information'),
                        content: const Text(
                            'The image has been reported, Our team will verify and take down the image soon.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(alertDialogContext),
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                  logFirebaseEvent('Container_navigate_to');

                  context.pushNamed('HomeCopyCopy');
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 16.0),
                    child: Text(
                      'I\'m not in this image',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  logFirebaseEvent('REPORT_OPTIONS_Container_awa9qbgi_ON_TAP');
                  logFirebaseEvent('Container_backend_call');

                  await ImageReportsRecord.collection
                      .doc()
                      .set(createImageReportsRecordData(
                        key: widget.imageKey,
                        uid: currentUserUid,
                        reason: 'This Image is spam',
                      ));
                  logFirebaseEvent('Container_alert_dialog');
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: const Text('Information'),
                        content: const Text(
                            'The image has been reported, Our team will verify and take down the image soon.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(alertDialogContext),
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                  logFirebaseEvent('Container_navigate_to');

                  context.goNamed('HomeCopyCopy');
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 16.0),
                    child: Text(
                      'This Image is spam',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  logFirebaseEvent('REPORT_OPTIONS_Container_cunkfvgj_ON_TAP');
                  logFirebaseEvent('Container_backend_call');

                  await ImageReportsRecord.collection
                      .doc()
                      .set(createImageReportsRecordData(
                        key: widget.imageKey,
                        uid: currentUserUid,
                        reason: 'Image is uploaded by unknown user',
                      ));
                  logFirebaseEvent('Container_alert_dialog');
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: const Text('Information'),
                        content: const Text(
                            'The image has been reported, Our team will verify and take down the image soon.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(alertDialogContext),
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                  logFirebaseEvent('Container_navigate_to');

                  context.goNamed('HomeCopyCopy');
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 16.0),
                    child: Text(
                      'Image is uploaded by unknown user',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
