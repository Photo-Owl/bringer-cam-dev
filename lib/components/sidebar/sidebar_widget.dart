import '../../auth/firebase_auth/auth_util.dart';
import '/components/contact_usbottomsheet/contact_usbottomsheet_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'sidebar_model.dart';
export 'sidebar_model.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({
    super.key,
    int? index,
  }) : index = index ?? 0;

  final int index;

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  late SidebarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SidebarModel());

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
      width: 450.0,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  logFirebaseEvent('SIDEBAR_COMP_Container_fhich1a8_ON_TAP');
                  logFirebaseEvent('Container_navigate_to');

                  context.pushNamed('HomeCopyCopy');
                },
                child: Container(
                  width: 300.0,
                  height: 146.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        28.0, 28.0, 108.0, 40.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Group_669569.png',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 10.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                logFirebaseEvent('SIDEBAR_COMP_Hom_ON_TAP');
                logFirebaseEvent('Hom_navigate_to');

                context.pushNamed('HomeCopyCopy');
              },
              child: Container(
                width: double.infinity,
                height: 56.0,
                decoration: BoxDecoration(
                  color: widget.index == 0
                      ? const Color(0xFFDBE2F9)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 0.0, 5.0),
                    child: Text(
                      'Home',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Builder(
            builder: (context) => Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 10.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  logFirebaseEvent('SIDEBAR_COMP_Hom_ON_TAP');
                  logFirebaseEvent('Hom_alert_dialog');
                  await showDialog(
                    barrierColor: const Color(0x23000000),
                    context: context,
                    builder: (dialogContext) {
                      return Dialog(
                        elevation: 0,
                        insetPadding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        alignment: const AlignmentDirectional(0.0, 1.0)
                            .resolve(Directionality.of(context)),
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.4,
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          child: const ContactUsbottomsheetWidget(),
                        ),
                      );
                    },
                  ).then((value) => setState(() {}));
                },
                child: Container(
                  width: double.infinity,
                  height: 56.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 0.0, 5.0),
                      child: Text(
                        'Contact us',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 20.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                logFirebaseEvent('SIDEBAR_COMP_Hom_ON_TAP');
                logFirebaseEvent('Hom_launch_u_r_l');
                await launchURL('https://bringerapp.com/privacy-policy');
              },
              child: Container(
                width: double.infinity,
                height: 56.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 0.0, 5.0),
                    child: Text(
                      'Policies',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 20.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                logFirebaseEvent('SIDEBAR_COMP_Hom_ON_TAP');
                logFirebaseEvent('Hom_launch_u_r_l');
                await launchURL('https://bringerapp.com/');
              },
              child: Container(
                width: double.infinity,
                height: 56.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 0.0, 5.0),
                    child: Text(
                      'About us',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 20),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                logFirebaseEvent('SIDEBAR_COMP_Hom_ON_TAP');
                logFirebaseEvent('Hom_auth');
                GoRouter.of(context).prepareAuthEvent();
                await authManager.signOut();
                GoRouter.of(context).clearRedirectLocation();
                context.goNamedAuth('SignInCopy', context.mounted);
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 5),
                    child: Text(
                      'Sign Out',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
