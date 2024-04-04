import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 100.0,
          height: 191.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Lottie.network(
            'https://assets10.lottiefiles.com/packages/lf20_AwuJJyHD4u.json',
            width: 150.0,
            height: 125.0,
            fit: BoxFit.contain,
            animate: true,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
          child: Text(
            'The website version is out of date,\n Simply refresh your browser for the latest version',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                ),
          ),
        ),
      ],
    );
  }
}
