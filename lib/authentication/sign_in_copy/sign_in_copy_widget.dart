import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/update_required/update_required_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'sign_in_copy_model.dart';
export 'sign_in_copy_model.dart';

class SignInCopyWidget extends StatefulWidget {
  const SignInCopyWidget({
    super.key,
    this.phoneNumber,
    this.name,
    this.qr,
  });

  final String? phoneNumber;
  final String? name;
  final String? qr;

  @override
  State<SignInCopyWidget> createState() => _SignInCopyWidgetState();
}

class _SignInCopyWidgetState extends State<SignInCopyWidget>
    with TickerProviderStateMixin {
  late SignInCopyModel _model;

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
    _model = createModel(context, () => SignInCopyModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'SignInCopy'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('SIGN_IN_COPY_SignInCopy_ON_INIT_STATE');
      logFirebaseEvent('SignInCopy_custom_action');
      _model.checkVersionResult = await actions.checkVersion();
      if (_model.checkVersionResult!) {
        logFirebaseEvent('SignInCopy_wait__delay');
        await Future.delayed(const Duration(milliseconds: 0));
      } else {
        logFirebaseEvent('SignInCopy_bottom_sheet');
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          isDismissible: false,
          enableDrag: false,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: const UpdateRequiredWidget(),
            );
          },
        ).then((value) => safeSetState(() {}));

        return;
      }

      if ((widget.phoneNumber != null && widget.phoneNumber != '') &&
          (widget.name != null && widget.name != '')) {
        logFirebaseEvent('SignInCopy_auth');
        final phoneNumberVal = widget.phoneNumber;
        if (phoneNumberVal == null ||
            phoneNumberVal.isEmpty ||
            !phoneNumberVal.startsWith('+')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Phone Number is required and has to start with +.'),
            ),
          );
          return;
        }
        await authManager.beginPhoneAuth(
          context: context,
          phoneNumber: phoneNumberVal,
          onCodeSent: (context) async {
            context.goNamedAuth(
              'OtpVerification',
              context.mounted,
              queryParameters: {
                'name': serializeParam(
                  widget.name,
                  ParamType.String,
                ),
              }.withoutNulls,
              ignoreRedirect: true,
            );
          },
        );
      } else {
        return;
      }
    });

    authManager.handlePhoneAuthStateChanges(context);
    _model.textController1 ??= TextEditingController(text: '+');
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(text: '91');
    _model.textFieldFocusNode2 ??= FocusNode();

    authManager.handlePhoneAuthStateChanges(context);

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
        title: 'SignInCopy',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).accent3,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5A00CD),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(),
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Text(
                            'Social\nGallery',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  color: const Color(0xFFAA67FF),
                                  fontSize: 28,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w900,
                                  lineHeight: 0.9,
                                ),
                          ),
                        ),
                        const Spacer(flex: 2),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Image.asset(
                                'assets/images/16.png',
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(30, 20, 50, 0),
                          child: Text(
                            'Dear Friend,',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  color: Color(0xFFF094FF),
                                  fontSize: 30,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 0, 50, 0),
                          child: Text(
                            'Are you still begging for your photos from others?',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  color: Color(0xFFFDFDFD),
                                  fontSize: 29,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                        const Spacer(flex: 3),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20.0, 20.0, 20.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEEEA),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 0.0, 0.0),
                                      child: TextFormField(
                                        controller: _model.textController1,
                                        focusNode: _model.textFieldFocusNode1,
                                        autofocus: true,
                                        readOnly: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent2,
                                                letterSpacing: 0.0,
                                              ),
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    letterSpacing: 0.0,
                                                  ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedErrorBorder: InputBorder.none,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                            ),
                                        textAlign: TextAlign.center,
                                        validator: _model
                                            .textController1Validator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Form(
                                      key: _model.formKey,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 8.0, 0.0),
                                        child: TextFormField(
                                          controller: _model.textController2,
                                          focusNode: _model.textFieldFocusNode2,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                        fontSize: 16),
                                            hintText: 'Mobile Number',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .override(
                                                        fontFamily: 'Inter',
                                                        color: const Color(
                                                            0xbacd8c9fad),
                                                        letterSpacing: 0.0,
                                                        fontSize: 16),
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 15.0,
                                                letterSpacing: 0.0,
                                              ),
                                          keyboardType: TextInputType.number,
                                          validator: _model
                                              .textController2Validator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (!((widget.phoneNumber != null &&
                                widget.phoneNumber != '') &&
                            (widget.name != null && widget.name != '')))
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 20.0, 20.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                logFirebaseEvent(
                                    'SIGN_IN_COPY_PAGE_Button-Login_ON_TAP');
                                var shouldSetState = false;
                                logFirebaseEvent(
                                    'Button-Login_google_analytics_event');
                                logFirebaseEvent('Sign in button pressed');
                                logFirebaseEvent('Button-Login_validate_form');
                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  return;
                                }
                                logFirebaseEvent(
                                    'Button-Login_firestore_query');
                                _model.userDocument =
                                    await queryUsersRecordOnce(
                                  queryBuilder: (usersRecord) =>
                                      usersRecord.where(
                                    'phone_number',
                                    isEqualTo:
                                        '${_model.textController1.text}${_model.textController2.text}',
                                  ),
                                );
                                shouldSetState = true;
                                if (_model.userDocument!.isEmpty) {
                                  logFirebaseEvent('Button-Login_navigate_to');

                                  context.pushNamed(
                                    'SocialSignInCopy',
                                    queryParameters: {
                                      'phoneNumber': serializeParam(
                                        '${_model.textController1.text}${_model.textController2.text}',
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: const TransitionInfo(
                                        hasTransition: true,
                                        transitionType: PageTransitionType.fade,
                                      ),
                                    },
                                  );

                                  if (shouldSetState) setState(() {});
                                  return;
                                } else if (_model.userDocument!.first
                                    .hasIsGoogleLogin()) {
                                  if (_model
                                          .userDocument?.first.isGoogleLogin ==
                                      true) {
                                    logFirebaseEvent(
                                        'Button-Login_navigate_to');

                                    context.pushNamed(
                                      'SocialSignInCopy',
                                      queryParameters: {
                                        'phoneNumber': serializeParam(
                                          '${_model.textController1.text}${_model.textController2.text}',
                                          ParamType.String,
                                        ),
                                        'userDocument': serializeParam(
                                          _model.userDocument?.first,
                                          ParamType.Document,
                                        ),
                                        'email': serializeParam(
                                          _model.userDocument?.first.email,
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        'userDocument':
                                            _model.userDocument?.first,
                                        kTransitionInfoKey:
                                            const TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.fade,
                                        ),
                                      },
                                    );

                                    if (shouldSetState) setState(() {});
                                    return;
                                  }
                                }

                                logFirebaseEvent('Button-Login_auth');
                                final phoneNumberVal =
                                    '${_model.textController1.text}${_model.textController2.text}';
                                if (phoneNumberVal.isEmpty ||
                                    !phoneNumberVal.startsWith('+')) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Phone Number is required and has to start with +.'),
                                    ),
                                  );
                                  return;
                                }
                                await authManager.beginPhoneAuth(
                                  context: context,
                                  phoneNumber: phoneNumberVal,
                                  onCodeSent: (context) async {
                                    context.goNamedAuth(
                                      'OtpVerification',
                                      context.mounted,
                                      queryParameters: {
                                        'name': serializeParam(
                                          '',
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                      ignoreRedirect: true,
                                    );
                                  },
                                );

                                if (shouldSetState) setState(() {});
                              },
                              text: 'Yes, I do',
                              options: FFButtonOptions(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                iconPadding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Color(0xFF353535),
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                elevation: 3,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        if ((widget.phoneNumber != null &&
                                widget.phoneNumber != '') &&
                            (widget.name != null && widget.name != ''))
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: Text(
                              'Signing you in',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 32, 0, 32),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4),
                                child: FaIcon(
                                  FontAwesomeIcons.lock,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  size: 14,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Text(
                                  'All your photos are end to end encrypted',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        fontSize: 12,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).animateOnPageLoad(
                        animationsMap['columnOnPageLoadAnimation']!)),
              ],
            ),
          ),
        ));
  }
}
