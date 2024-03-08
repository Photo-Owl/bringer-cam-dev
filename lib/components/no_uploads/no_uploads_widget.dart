import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'no_uploads_model.dart';
export 'no_uploads_model.dart';

class NoUploadsWidget extends StatefulWidget {
  const NoUploadsWidget({super.key});

  @override
  State<NoUploadsWidget> createState() => _NoUploadsWidgetState();
}

class _NoUploadsWidgetState extends State<NoUploadsWidget> {
  late NoUploadsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoUploadsModel());

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
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Seems like you don’t have any Events',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).titleMedium,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
          child: FFButtonWidget(
            onPressed: () async {
              logFirebaseEvent('NO_UPLOADS_COMP_CREATE_EVENT_BTN_ON_TAP');
              logFirebaseEvent('Button_navigate_to');

              context.pushNamed('CreateanEvent');
            },
            text: 'Create Event',
            options: FFButtonOptions(
              width: 170.0,
              height: 50.0,
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Lexend Deca',
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
              elevation: 2.0,
              borderSide: const BorderSide(
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
