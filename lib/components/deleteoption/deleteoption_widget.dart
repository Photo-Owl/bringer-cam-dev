import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'deleteoption_model.dart';
export 'deleteoption_model.dart';

class DeleteoptionWidget extends StatefulWidget {
  const DeleteoptionWidget({
    super.key,
    required this.imageitem,
    required this.imageKey,
    required this.deteletype,
  });

  final ImageModelStruct? imageitem;
  final String? imageKey;
  final Deletion? deteletype;

  @override
  State<DeleteoptionWidget> createState() => _DeleteoptionWidgetState();
}

class _DeleteoptionWidgetState extends State<DeleteoptionWidget> {
  late DeleteoptionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeleteoptionModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 300.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                  child: Text(
                    () {
                      if (widget.deteletype == Deletion.local) {
                        return 'Are you sure you would like to delete this photo?';
                      } else if (widget.deteletype == Deletion.foreveryone) {
                        return 'Are you sure you would like to remove access to this photo for everyone?';
                      } else if (widget.deteletype == Deletion.forme) {
                        return 'Are you sure you would like to remove access to this photo for Me?';
                      } else {
                        return 'Error';
                      }
                    }(),
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 3.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      logFirebaseEvent(
                          'DELETEOPTION_YES,_DELETE_FOR_ALL_BTN_ON_');
                      if (widget.deteletype == Deletion.local) {
                        logFirebaseEvent('Button_custom_action');
                        await actions.deleteImage(
                          widget.imageitem!.imageUrl,
                        );
                      } else {
                        if (widget.deteletype == Deletion.forme) {
                          logFirebaseEvent('Button_custom_action');
                          await actions.deleteForMe(
                            widget.imageKey!,
                            currentUserUid,
                          );
                        } else {
                          logFirebaseEvent('Button_backend_call');
                          await DeleteImageCall.call(
                            key: widget.imageKey,
                          );
                        }
                      }

                      logFirebaseEvent('Button_close_dialog,_drawer,_etc');
                      Navigator.pop(context);
                      logFirebaseEvent('Button_navigate_back');
                      context.safePop();
                    },
                    text: () {
                      if (widget.deteletype == Deletion.local) {
                        return 'Yes, Delete';
                      } else if (widget.deteletype == Deletion.foreveryone) {
                        return 'Yes, Delete for everyone';
                      } else if (widget.deteletype == Deletion.forme) {
                        return 'Yes, Delete for me';
                      } else {
                        return 'Error';
                      }
                    }(),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 40.0,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: const Color(0xFFFF8984),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                              ),
                      elevation: 0.0,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 12.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      logFirebaseEvent('DELETEOPTION_COMP_CANCEL_BTN_ON_TAP');
                      logFirebaseEvent('Button_navigate_back');
                      context.safePop();
                    },
                    text: 'Cancel',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 40.0,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).accent3,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                              ),
                      elevation: 0.0,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
