import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'update_required_model.dart';
export 'update_required_model.dart';

class UpdateRequiredWidget extends StatefulWidget {
  const UpdateRequiredWidget({super.key});

  @override
  State<UpdateRequiredWidget> createState() => _UpdateRequiredWidgetState();
}

class _UpdateRequiredWidgetState extends State<UpdateRequiredWidget> {
  late UpdateRequiredModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpdateRequiredModel());

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
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 1,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Align(
        alignment: const AlignmentDirectional(0, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Lottie.network(
                  'https://assets10.lottiefiles.com/packages/lf20_AwuJJyHD4u.json',
                  height: 50,
                  fit: BoxFit.contain,
                  animate: true,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                child: Text(
                  'Your version of the app is outdated, Update the app now',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        letterSpacing: 0,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                child: FFButtonWidget(
                  onPressed: () async {
                    logFirebaseEvent('UPDATE_REQUIRED_UPDATE_NOW_BTN_ON_TAP');
                    logFirebaseEvent('Button_launch_u_r_l');
                    await launchURL(
                        'https://play.google.com/store/apps/details?id=com.smoose.photoowldev');
                  },
                  text: 'Update now',
                  options: FFButtonOptions(
                    height: 40,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Color(0xFFFCD784),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
