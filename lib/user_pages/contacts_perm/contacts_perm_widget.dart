import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'contacts_perm_model.dart';

class ContactsPermWidget extends StatefulWidget {
  const ContactsPermWidget({super.key});

  @override
  State<ContactsPermWidget> createState() => _ContactsPermWidgetState();
}

class _ContactsPermWidgetState extends State<ContactsPermWidget> {
  late ContactsPermModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() async {
    super.initState();
    _model = createModel(context, () => ContactsPermModel());
    const platform = MethodChannel('com.smoose.photoowldev/autoUpload');
    final permsGiven =
        await platform.invokeMethod<bool>('requestContactsPermission', null) ??
            false;
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'alldone'});
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
        title: 'Contacts Permission',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 30.0, 20.0, 30.0),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF8D6), Color(0xFFFFF3B7)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(0.0, -1.0),
                      end: AlignmentDirectional(0, 1.0),
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 20.0, 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(1.0, -1.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            onPressed: () => context.goNamed('HomeCopyCopy'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 20.0),
                          child: LinearPercentIndicator(
                            percent: 0.6,
                            lineHeight: 12.0,
                            animation: false,
                            animateFromLastPercent: false,
                            progressColor: Color(0xFF342C00),
                            backgroundColor: Color(0xFFCEC48D),
                            barRadius: Radius.circular(10.0),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        Spacer(flex: 3),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            badges.Badge(
                              badgeContent: Text(
                                '✓',
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              showBadge: true,
                              shape: badges.BadgeShape.circle,
                              badgeColor: Color(0xFFBBBBBB),
                              elevation: 4.0,
                              padding: EdgeInsets.all(4.0),
                              position: badges.BadgePosition.topEnd(),
                              animationType: badges.BadgeAnimationType.scale,
                              toAnimate: true,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 56.0,
                                  height: 56.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  4.0, 15.0, 4.0, 0.0),
                              child: Icon(
                                Icons.add,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ),
                            badges.Badge(
                              badgeContent: Text(
                                '✓',
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              showBadge: true,
                              shape: badges.BadgeShape.circle,
                              badgeColor: Color(0xFFBBBBBB),
                              elevation: 4.0,
                              padding: EdgeInsets.all(4.0),
                              position: badges.BadgePosition.topEnd(),
                              animationType: badges.BadgeAnimationType.scale,
                              toAnimate: true,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/cam.png',
                                  width: 56.0,
                                  height: 56.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Text(
                              'Step 4',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFFB4A245),
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 16.0),
                            child: Text(
                              'Allow access to contacts list.',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF534308),
                                    fontSize: 28.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 16.0),
                            child: Text(
                              'Helps us filter out spam images and block unknown senders.',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF534308),
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                        Center(
                          child: FFButtonWidget(
                            onPressed: () async {
                              const platform = MethodChannel(
                                  'com.smoose.photoowldev/autoUpload');
                              final permsGiven =
                                  await platform.invokeMethod<bool>(
                                          'requestContactsPermission', null) ??
                                      false;
                              if (!context.mounted) return;
                              if (permsGiven) {
                                context.pushNamed('batteryOptimization');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Failed to get contacts access.'),
                                  ),
                                );
                              }
                            },
                            text: 'Provide contacts access',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 16.0, 24.0, 16.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primaryText,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsetsDirectional.fromSTEB(
                        //       0.0, 16.0, 0.0, 16.0),
                        //   child: FFButtonWidget(
                        //     onPressed: () async {
                        //       const platform = MethodChannel('com.smoose.photoowldev/autoUpload');
                        //       await platform.invokeMethod('openCamera', null);
                        //       if (!context.mounted) return;
                        //       context.goNamed('HomeCopyCopy');
                        //     },
                        //     text: 'Go to camera',
                        //     options: FFButtonOptions(
                        //       width: double.infinity,
                        //       height: 50.0,
                        //       padding: EdgeInsetsDirectional.fromSTEB(
                        //           24.0, 16.0, 24.0, 16.0),
                        //       iconPadding: EdgeInsetsDirectional.fromSTEB(
                        //           0.0, 0.0, 0.0, 0.0),
                        //       color: FlutterFlowTheme.of(context).primaryText,
                        //       textStyle: FlutterFlowTheme.of(context)
                        //           .titleSmall
                        //           .override(
                        //         fontFamily: 'Inter',
                        //         color: Colors.white,
                        //         letterSpacing: 0.0,
                        //       ),
                        //       elevation: 3.0,
                        //       borderSide: BorderSide(
                        //         color: Colors.transparent,
                        //         width: 1.0,
                        //       ),
                        //       borderRadius: BorderRadius.circular(14.0),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
