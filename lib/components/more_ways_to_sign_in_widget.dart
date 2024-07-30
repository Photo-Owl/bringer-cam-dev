import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'more_ways_to_sign_in_model.dart';
export 'more_ways_to_sign_in_model.dart';

class MoreWaysToSignInWidget extends StatefulWidget {
  const MoreWaysToSignInWidget({
    super.key,
    required this.phoneNumber,
    this.userDocument,
  });

  final String? phoneNumber;
  final UsersRecord? userDocument;

  @override
  State<MoreWaysToSignInWidget> createState() => _MoreWaysToSignInWidgetState();
}

class _MoreWaysToSignInWidgetState extends State<MoreWaysToSignInWidget> {
  late MoreWaysToSignInModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MoreWaysToSignInModel());

    authManager.handlePhoneAuthStateChanges(context);
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
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: 300.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
              child: Text(
                'Other ways to sign in',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: Colors.black,
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (responsiveVisibility(
              context: context,
              phone: false,
              tablet: false,
              tabletLandscape: false,
              desktop: false,
            ))
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: Stack(
                  children: [
                    if (responsiveVisibility(
                      context: context,
                      phone: false,
                      tablet: false,
                      tabletLandscape: false,
                      desktop: false,
                    ))
                      FFButtonWidget(
                        onPressed: () async {
                          logFirebaseEvent(
                              'MORE_WAYS_TO_SIGN_IN_SIGN_IN_WITH_GOOGLE');
                          Function() navigate = () {};
                          _model.userDocumentaction =
                              await queryUsersRecordOnce(
                            queryBuilder: (usersRecord) => usersRecord.where(
                              'phone_number',
                              isEqualTo: widget.phoneNumber,
                            ),
                          );
                          GoRouter.of(context).prepareAuthEvent();
                          final user =
                              await authManager.signInWithGoogle(context);
                          if (user == null) {
                            return;
                          }
                          navigate = () => context.goNamedAuth(
                              'RedirectionCopy', context.mounted);
                          if (currentPhoneNumber == '') {
                            if (valueOrDefault<bool>(
                                currentUserDocument?.isBusinessAccount,
                                false)) {
                              GoRouter.of(context).prepareAuthEvent();
                              await authManager.signOut();
                              GoRouter.of(context).clearRedirectLocation();

                              navigate = () => context.goNamedAuth(
                                  'SignInCopy', context.mounted);
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
                                            Navigator.pop(alertDialogContext),
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              if (_model.userDocumentaction!.isNotEmpty) {
                                await currentUserReference!.delete();
                                GoRouter.of(context).prepareAuthEvent();
                                await authManager.signOut();
                                GoRouter.of(context).clearRedirectLocation();

                                navigate = () => context.goNamedAuth(
                                    'SignInCopy', context.mounted);
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
                                              Navigator.pop(alertDialogContext),
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                await currentUserReference!.update({
                                  ...createUsersRecordData(
                                    phoneNumber: widget.phoneNumber,
                                    isGoogleLogin: true,
                                  ),
                                  ...mapToFirestore(
                                    {
                                      'photo_url': FieldValue.delete(),
                                    },
                                  ),
                                });
                              }
                            }
                          } else if (_model
                                      .userDocumentaction?.first.phoneNumber !=
                                  null &&
                              _model.userDocumentaction?.first.phoneNumber !=
                                  '') {
                            if (currentPhoneNumber !=
                                _model.userDocumentaction?.first.phoneNumber) {
                              GoRouter.of(context).prepareAuthEvent();
                              await authManager.signOut();
                              GoRouter.of(context).clearRedirectLocation();

                              navigate = () => context.goNamedAuth(
                                  'SignInCopy', context.mounted);
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
                                            Navigator.pop(alertDialogContext),
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            GoRouter.of(context).prepareAuthEvent();
                            await authManager.signOut();
                            GoRouter.of(context).clearRedirectLocation();

                            navigate = () => context.goNamedAuth(
                                'SignInCopy', context.mounted);
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
                                          Navigator.pop(alertDialogContext),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          navigate();

                          setState(() {});
                        },
                        text: 'Sign in with Google',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 40.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 10.0, 0.0),
                          color: Colors.white,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: Colors.black,
                                    letterSpacing: 0.0,
                                  ),
                          elevation: 2.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    Align(
                      alignment: const AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            15.0, 10.0, 0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/Company_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  final phoneNumberVal = widget.phoneNumber;
                  if (phoneNumberVal == null ||
                      phoneNumberVal.isEmpty ||
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
                },
                text: 'Sign In with OTP',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 56.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: const Color(0xFF1589FC),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).primaryBtnText,
                        letterSpacing: 0.0,
                      ),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
