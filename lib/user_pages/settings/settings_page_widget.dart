import 'package:bringer_cam_dev/flutter_flow/flutter_flow_util.dart';
import 'package:bringer_cam_dev/flutter_flow/flutter_flow_widgets.dart';
import 'package:bringer_cam_dev/user_pages/settings/settings_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/sidebar/sidebar_widget.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({super.key});

  @override
  State<SettingsPageWidget> createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late SettingsPageModel _model;
  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => SettingsPageModel());
  }

  Future<void> hideStaticNotification() async {
    const platform = MethodChannel('com.smoose.photoowldev/autoUpload');
    await platform.invokeMethod<String>('hideStaticNotification', null);
    safeSetState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Title(
        title: 'Social Gallery | Home',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 2.0, 0.0),
                    child: Text(
                      'Social Gallery',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              ),
              actions: [],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 32.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            'Turn off Sharing mode notification?',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  fontSize: 24.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            'Turning off Sharing mode notification does not turn off instant share feature. You will be redirected to your settings to turn off the notification',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: FFButtonWidget(
                              text: 'Go to settings',
                              onPressed: () {
                                hideStaticNotification();
                              },
                              options: FFButtonOptions(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                color: Color(0xFF5F5CFF),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                        fontFamily: 'Inter',
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFFFFFFFF)),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
