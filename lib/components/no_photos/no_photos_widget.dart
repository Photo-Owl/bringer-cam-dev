import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'no_photos_model.dart';
export 'no_photos_model.dart';

class NoPhotosWidget extends StatefulWidget {
  const NoPhotosWidget({super.key});

  @override
  State<NoPhotosWidget> createState() => _NoPhotosWidgetState();
}

class _NoPhotosWidgetState extends State<NoPhotosWidget> {
  late NoPhotosModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoPhotosModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Lying%20Face.png',
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Seems like you don’t have any photos',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
          child: FFButtonWidget(
            onPressed: () async {
              logFirebaseEvent('NO_PHOTOS_COMP_REFRESH_BTN_ON_TAP');
              logFirebaseEvent('Button_google_analytics_event');
              logFirebaseEvent('Refresh button pressed');
              logFirebaseEvent('Button_backend_call');
              _model.apiResult = await SearchFacesUsingTIFCall.call(
                uid: currentUserUid,
                sourceKey:
                    valueOrDefault(currentUserDocument?.refrencePhotoKey, ''),
                faceid: valueOrDefault(currentUserDocument?.faceId, ''),
              );
              if ((_model.apiResult?.succeeded ?? true)) {
                logFirebaseEvent('Button_show_snack_bar');
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Refresh success',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    duration: Duration(milliseconds: 5850),
                    backgroundColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                  ),
                );
              } else {
                logFirebaseEvent('Button_show_snack_bar');
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    duration: Duration(milliseconds: 5850),
                    backgroundColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                  ),
                );
              }

              setState(() {});
            },
            text: 'Refresh',
            options: FFButtonOptions(
              width: 170.0,
              height: 56.0,
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: Color(0xFF1589FC),
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Lexend Deca',
                    color: Colors.white,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
              elevation: 2.0,
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
