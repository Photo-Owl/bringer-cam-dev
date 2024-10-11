import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'otp_verification_model.dart';
export 'otp_verification_model.dart';

class OtpVerificationWidget extends StatefulWidget {
  const OtpVerificationWidget({
    super.key,
    required this.name,
    required this.phoneNumber,
  });

  final String? name;
  final String? phoneNumber;

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget>
    with TickerProviderStateMixin {
  late OtpVerificationModel _model;

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
    _model = createModel(context, () => OtpVerificationModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'OtpVerification'});

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
        title: 'OtpVerification',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).accent3,
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 0.15,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Image.png',
                        width: 300.0,
                        height: 200.0,
                        fit: BoxFit.none,
                        alignment: const Alignment(0.0, -1.0),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.85,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15.0, 24.0, 15.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'Confirm your Code',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'Inter',
                                        fontSize: 32.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 10.0, 15.0, 0.0),
                                child: Text(
                                  'This code helps keep your account safe and secure.',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Inter',
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 20.0, 0.0, 0.0),
                                child: PinCodeTextField(
                                  autoDisposeControllers: false,
                                  appContext: context,
                                  length: 6,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter',
                                        color: Colors.black,
                                        letterSpacing: 0.0,
                                      ),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  enableActiveFill: false,
                                  autoFocus: true,
                                  enablePinAutofill: true,
                                  errorTextSpace: 0.0,
                                  showCursor: true,
                                  cursorColor: Colors.black,
                                  obscureText: false,
                                  hintCharacter: '-',
                                  keyboardType: TextInputType.number,
                                  pinTheme: PinTheme(
                                    fieldHeight: 45.0,
                                    fieldWidth: 45.0,
                                    borderWidth: 2.0,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                    ),
                                    shape: PinCodeFieldShape.box,
                                    activeColor:
                                        FlutterFlowTheme.of(context).primary,
                                    inactiveColor:
                                        FlutterFlowTheme.of(context).accent2,
                                    selectedColor: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    activeFillColor:
                                        FlutterFlowTheme.of(context).primary,
                                    inactiveFillColor:
                                        FlutterFlowTheme.of(context).accent2,
                                    selectedFillColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryText,
                                  ),
                                  controller: _model.pinCodeController,
                                  onChanged: (_) {},
                                  onCompleted: (_) async {
                                    logFirebaseEvent('OTP_VERIFICATION',
                                        parameters: {
                                          'uid': currentUserUid,
                                        });
                                    Function() navigate = () {};
                                    GoRouter.of(context).prepareAuthEvent();
                                    final smsCodeVal =
                                        _model.pinCodeController!.text;
                                    if (smsCodeVal.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Enter SMS verification code.'),
                                        ),
                                      );
                                      return;
                                    }
                                    final phoneVerifiedUser =
                                        await authManager.linkWithExistingAccount(
                                      context: context,
                                      smsCode: smsCodeVal,
                                    );
                                    if (phoneVerifiedUser == null) {
                                      return;
                                    }

                                    await currentUserReference!
                                        .update(createUsersRecordData(
                                      phoneNumber: widget.phoneNumber,
                                      phoneNumberVerified: true,
                                    ));

                                    // navigate = () => context.goNamedAuth(
                                    //     'RedirectionCopy', context.mounted);
                                    navigate = () => context.goNamedAuth(
                                        'WaitForVerification', context.mounted);
                                    logFirebaseEvent('Otp filled');
                                    if (widget.name != null &&
                                        widget.name != '') {
                                      await currentUserReference!
                                          .update(createUsersRecordData(
                                        displayName: widget.name,
                                      ));
                                    }

                                    navigate();
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: _model.pinCodeControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 20.0, 16.0, 100.0),
                          child: FFButtonWidget(
                            onPressed: () {},
                            text: 'Confirm & Continue',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 56.0,
                              padding: const EdgeInsets.all(0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: const Color(0xFF007EFC),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 2.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ).animateOnPageLoad(
                        animationsMap['columnOnPageLoadAnimation']!),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
