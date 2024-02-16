import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/more_ways_to_sign_in_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'social_sign_in_copy_model.dart';
export 'social_sign_in_copy_model.dart';

class SocialSignInCopyWidget extends StatefulWidget {
  const SocialSignInCopyWidget({
    super.key,
    this.phoneNumber,
    this.userDocument,
    this.email,
  });

  final String? phoneNumber;
  final UsersRecord? userDocument;
  final String? email;

  @override
  State<SocialSignInCopyWidget> createState() => _SocialSignInCopyWidgetState();
}

class _SocialSignInCopyWidgetState extends State<SocialSignInCopyWidget>
    with TickerProviderStateMixin {
  late SocialSignInCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'columnOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 490.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0.0, 13.999999999999986),
          end: const Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SocialSignInCopyModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'SocialSignInCopy'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('SOCIAL_SIGN_IN_COPY_SocialSignInCopy_ON_');
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    context.watch<FFAppState>();

    return Title(
        title: 'SocialSignInCopy',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).accent3,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 0.1,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/Image.png',
                      fit: BoxFit.fitHeight,
                      alignment: const Alignment(0.0, -1.0),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.9,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (currentUserReference == null)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'Sign In to get started',
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            if (widget.email != null && widget.email != '')
                              Align(
                                alignment: const AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      15.0, 10.0, 15.0, 0.0),
                                  child: Text(
                                    'This account is already associated with ${widget.email}',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Inter',
                                          fontSize: 14.0,
                                        ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15.0, 30.0, 15.0, 30.0),
                              child: Stack(
                                children: [
                                  FFButtonWidget(
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'SOCIAL_SIGN_IN_COPY_SIGN_IN_WITH_GOOGLE_');
                                      if (!((String var1) {
                                        return var1.contains('+');
                                      }(widget.phoneNumber!))) {
                                        logFirebaseEvent('Button_navigate_to');

                                        context.goNamedAuth(
                                            'SignInCopy', context.mounted);

                                        return;
                                      }
                                      logFirebaseEvent('Button_auth');
                                      GoRouter.of(context).prepareAuthEvent();
                                      final user = await authManager
                                          .signInWithGoogle(context);
                                      if (user == null) {
                                        return;
                                      }
                                      if (currentPhoneNumber == '') {
                                        if (valueOrDefault<bool>(
                                            currentUserDocument
                                                ?.isBusinessAccount,
                                            false)) {
                                          logFirebaseEvent('Button_auth');
                                          GoRouter.of(context)
                                              .prepareAuthEvent();
                                          await authManager.signOut();
                                          GoRouter.of(context)
                                              .clearRedirectLocation();

                                          logFirebaseEvent(
                                              'Button_alert_dialog');
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: const Text('Error'),
                                                content: const Text(
                                                    'This email is used for a business account. Try using a different email'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: const Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          if (widget.userDocument != null) {
                                            logFirebaseEvent(
                                                'Button_backend_call');
                                            await currentUserReference!
                                                .delete();
                                            logFirebaseEvent('Button_auth');
                                            GoRouter.of(context)
                                                .prepareAuthEvent();
                                            await authManager.signOut();
                                            GoRouter.of(context)
                                                .clearRedirectLocation();

                                            logFirebaseEvent(
                                                'Button_alert_dialog');
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: const Text('Error'),
                                                  content: const Text(
                                                      'This phone number is already associated with another email id'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: const Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            logFirebaseEvent(
                                                'Button_backend_call');

                                            await currentUserReference!.update({
                                              ...createUsersRecordData(
                                                phoneNumber: widget.phoneNumber,
                                                isGoogleLogin: true,
                                              ),
                                              ...mapToFirestore(
                                                {
                                                  'photo_url':
                                                      FieldValue.delete(),
                                                },
                                              ),
                                            });
                                          }
                                        }
                                      } else if (widget.phoneNumber != null &&
                                          widget.phoneNumber != '') {
                                        if (currentPhoneNumber ==
                                            widget.phoneNumber) {
                                          logFirebaseEvent(
                                              'Button_navigate_to');

                                          context.pushNamedAuth(
                                              'RedirectionCopy',
                                              context.mounted);
                                        } else {
                                          logFirebaseEvent('Button_auth');
                                          GoRouter.of(context)
                                              .prepareAuthEvent();
                                          await authManager.signOut();
                                          GoRouter.of(context)
                                              .clearRedirectLocation();

                                          logFirebaseEvent(
                                              'Button_alert_dialog');
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: const Text('Error'),
                                                content: const Text(
                                                    'This email id is already registered with another phone number'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: const Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        logFirebaseEvent('Button_auth');
                                        GoRouter.of(context).prepareAuthEvent();
                                        await authManager.signOut();
                                        GoRouter.of(context)
                                            .clearRedirectLocation();

                                        logFirebaseEvent('Button_alert_dialog');
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: const Text(
                                                  'This email id is already registered with another phone number'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext),
                                                  child: const Text('Ok'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    text: 'Sign in with Google',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 56.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 10.0, 0.0),
                                      color: const Color(0xFF1589FC),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBtnText,
                                          ),
                                      elevation: 2.0,
                                      borderSide: const BorderSide(
                                        color: Color(0xFF5282E5),
                                        width: 0.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          8.0, 10.0, 0.0, 0.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/Google_logo.png',
                                          width: 36.0,
                                          fit: BoxFit.fitHeight,
                                          alignment: const Alignment(0.0, 0.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.email == null || widget.email == '')
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    logFirebaseEvent(
                                        'SOCIAL_SIGN_IN_COPY_Text_cmlg6qqs_ON_TAP');
                                    logFirebaseEvent('Text_bottom_sheet');
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: MoreWaysToSignInWidget(
                                            phoneNumber: widget.phoneNumber!,
                                            userDocument: widget.userDocument,
                                          ),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  },
                                  child: Text(
                                    'Find other ways to sign in',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: const Color(0xFF1589FC),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20.0, 55.0, 20.0, 10.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  logFirebaseEvent(
                                      'SOCIAL_SIGN_IN_COPY_Text_0wjxtv5j_ON_TAP');
                                  logFirebaseEvent('Text_launch_u_r_l');
                                  await launchURL(
                                      'https://bringerapp.com/privacy-policy');
                                },
                                child: Text(
                                  'By signing in you agree to our Data Privacy Policy',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ).animateOnPageLoad(
                            animationsMap['columnOnPageLoadAnimation']!),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 30.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (currentUserReference != null)
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 30.0, 0.0, 15.0),
                                  child: Text(
                                    'Login Successful',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (currentUserReference != null)
                        FFButtonWidget(
                          onPressed: () async {
                            logFirebaseEvent(
                                'SOCIAL_SIGN_IN_COPY_CONTINUE_BTN_ON_TAP');
                            logFirebaseEvent('Button_navigate_to');

                            context.goNamed('Redirection');
                          },
                          text: 'Continue',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: const Color(0xFF1589FC),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                ),
                            elevation: 3.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
