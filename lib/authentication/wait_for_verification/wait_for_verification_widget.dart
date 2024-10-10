import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'wait_for_verification_model.dart';
export 'wait_for_verification_model.dart';

class WaitForVerificationWidget extends StatefulWidget {
  const WaitForVerificationWidget({
    super.key,
  });

  @override
  State<WaitForVerificationWidget> createState() =>
      _WaitForVerificationWidgetState();
}

class _WaitForVerificationWidgetState extends State<WaitForVerificationWidget> {
  late WaitForVerificationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WaitForVerificationModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'WaitForVerification'});
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    if (currentPhoneNumber.length > 3) {
      _model.textController.text = currentPhoneNumber.substring(3);
    }
    _getContactsPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void _getContactsPermission() async {
    const platform = MethodChannel('com.smoose.photoowldev/autoUpload');
    final permsGiven =
        await platform.invokeMethod<bool>('requestContactsPermission', null) ??
            false;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
        title: 'WaitForVerification',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/phoneauthback.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                        ),
                        AuthUserStreamWidget(
                          builder: (context) {
                            if ((currentUserPhoto != null &&
                                    currentUserPhoto != '') &&
                                (valueOrDefault(
                                            currentUserDocument?.faceId, '') ==
                                        null ||
                                    valueOrDefault(
                                            currentUserDocument?.faceId, '') ==
                                        '')) {
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24, 45, 24, 0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF036E5B),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 0, 16),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 0, 0, 0),
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0x535FF6D3),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 0, 0, 0),
                                          child: Text(
                                            'We are setting up your profile\nThis may take a while',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  fontSize: 15,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if ((currentUserPhoto == null ||
                                    currentUserPhoto == '') &&
                                (valueOrDefault(
                                            currentUserDocument?.faceId, '') ==
                                        null ||
                                    valueOrDefault(
                                            currentUserDocument?.faceId, '') ==
                                        '')) {
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24, 45, 24, 0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFAA5656),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 0, 16),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 0, 0, 0),
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF0D2D2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Color(0xFFA23737),
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 0, 8, 0),
                                          child: Text(
                                            'Looks like we had a problem with\nyour selfie',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  fontSize: 15,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24, 45, 24, 0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF036E5B),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 0, 16),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 0, 0, 0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/phone_number_done.png',
                                              height: 40,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 0, 0, 0),
                                          child: Text(
                                            'Your selfie setup is completed!',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  fontSize: 15,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    AuthUserStreamWidget(builder: (context) {
                      if (currentPhoneNumber == null ||
                          currentPhoneNumber == '' ||
                          !currentUserPhoneNumberVerified) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
                              child: Text(
                                'Verify your phone number to continue.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 32,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF9F4F4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Text(
                                        '+91',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              color: Color(0xFF44474F),
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 0, 8, 0),
                                      child: TextFormField(
                                        controller: _model.textController,
                                        focusNode: _model.textFieldFocusNode,
                                        autofocus: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Phone number',
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    color: Color(0xFF44474F),
                                                    letterSpacing: 0,
                                                  ),
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    letterSpacing: 0,
                                                  ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFF9F4F4),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFF1F1F1),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF9F4F4),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              color: Color(0xFF1B1B1F),
                                              letterSpacing: 0,
                                            ),
                                        keyboardType: TextInputType.phone,
                                        validator: _model
                                            .textControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24, 16, 24, 16),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  // await currentUserReference!
                                  //     .update(createUsersRecordData(
                                  //   phoneNumber:
                                  //       '+91${_model.textController.text}',
                                  // ));
                                  if (_model.textController.text.length < 10) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please enter a valid mobile number.')));
                                    return;
                                  }

                                  final codeSent =
                                      await authManager.beginPhoneAuth(
                                          context: context,
                                          phoneNumber:
                                              '+91${_model.textController.text}',
                                          onCodeSent: (context) {});

                                  if (codeSent) {
                                    context.pushNamed('OtpVerification',
                                        queryParameters: {
                                          'phoneNumber':
                                              '+91${_model.textController.text}',
                                        });
                                  }
                                  final error = authManager
                                      .phoneAuthManager.phoneAuthError;
                                  if (error != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(error.toString())));
                                  }
                                },
                                text: 'Continue',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 24, 24, 24),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFF5A00CD),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        fontSize: 16,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (currentPhoneNumber != null &&
                          currentPhoneNumber != '' &&
                          currentUserPhoneNumberVerified) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/phone_number_done.png',
                                  width: 80,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
                              child: Text(
                                'You are all set',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 32,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                            if ((currentUserPhoto != '') &&
                                (valueOrDefault(
                                        currentUserDocument?.faceId, '') ==
                                    ''))
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 0),
                                  child: Text(
                                    'Wait for a moment',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF775C7B),
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            if ((currentPhoneNumber != '') &&
                                (valueOrDefault(
                                        currentUserDocument?.faceId, '') !=
                                    ''))
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 20, 24, 16),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    context
                                        .pushReplacementNamed('HomeCopyCopy');
                                    print('Button pressed ...');
                                  },
                                  text: 'Continue',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 24, 24, 24),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    color: Color(0xFF5A00CD),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            if ((currentPhoneNumber != '') &&
                                (currentUserPhoto == '') &&
                                (valueOrDefault(
                                        currentUserDocument?.faceId, '') ==
                                    ''))
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 20, 24, 16),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    context.goNamed('RedirectionCopy');
                                  },
                                  text: 'Retry Selfie',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 24, 24, 24),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    color: Color(0xFF5A00CD),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                      return const SizedBox();
                    }),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: FaIcon(
                              FontAwesomeIcons.lock,
                              color: Color(0xFF303030),
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
                                    color: Color(0xFF303030),
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
                ),
              ),
            ),
          ),
        ));
  }
}
