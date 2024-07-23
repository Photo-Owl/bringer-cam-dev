import 'package:flutter/services.dart';

import '../../common/encrypted_banner.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'battery_permission_model.dart';
export 'battery_permission_model.dart';

class BatteryPermissionWidget extends StatefulWidget {
  const BatteryPermissionWidget({super.key});

  @override
  State<BatteryPermissionWidget> createState() =>
      _BatteryPermissionWidgetState();
}

class _BatteryPermissionWidgetState extends State<BatteryPermissionWidget> {
  late BatteryPermissionModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BatteryPermissionModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'batteryPermission'});
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
        title: 'batteryPermission',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              top: true,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 1,
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(flex: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/7.png',
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Final Step',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFA887D2),
                              letterSpacing: 0,
                            ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
                        child: Text('Allow us to work in the background',
                            style: TextStyle(
                              fontFamily: 'Gotham Black',
                              fontSize: 36,
                              height: 1.05,
                            )),
                      ),
                      Text(
                        'This helps us share and receive your photos without any interruption.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0,
                              fontSize: 14,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'You can turn it off in the settings anytime',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0,
                                    fontSize: 14,
                                  ),
                        ),
                      ),
                      const Spacer(),
                      FFButtonWidget(
                        onPressed: () async {
                          const platform = MethodChannel(
                              'com.smoose.photoowldev/autoUpload');
                          final permsGiven = await platform.invokeMethod<bool>(
                                  'requestIgnoreBatteryOptimization', null) ??
                              false;
                          if (!context.mounted) return;
                          if (permsGiven) {
                            context.pushNamed('alldone');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Battery optimizations not disabled.'),
                              ),
                            );
                          }
                        },
                        text: 'Allow access',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          padding:
                              EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: Color(0xFF5A00CD),
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                  ),
                          elevation: 3,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 32),
                        child: Center(
                            child: Wrap(
                          spacing: 8,
                          children: [
                            const Icon(
                              Icons.lock_outlined,
                              color: Color(0xFF030303),
                              size: 15,
                            ),
                            Text(
                              'All your photos are end to end encrypted',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0,
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
