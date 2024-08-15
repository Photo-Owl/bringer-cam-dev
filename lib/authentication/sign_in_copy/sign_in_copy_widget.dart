import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/components/update_required/update_required_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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
      const platform = MethodChannel('com.smoose.photoowldev/autoUpload');
      await platform.invokeMethod<bool>(
          'requestExternalStoragePermission', null);
      _model.checkVersionResult = await actions.checkVersion();
      if (_model.checkVersionResult!) {
        await Future.delayed(const Duration(milliseconds: 0));
      } else {
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
                            'Are you still begging photos from your friends?',
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
                          child: FFButtonWidget(
                            onPressed: () async {
                              /*logFirebaseEvent('yes_i_do');
                              context.pushNamed(
                                'SocialSignInCopy',
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: const TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                  ),
                                },
                              );
*/
                              try {
                                const platform = MethodChannel(
                                    'com.smoose.photoowldev/autoUpload');

                                final String result = (await platform
                                        .invokeMethod<String>('getlog', null))
                                    as String;
                                print(result);
                              } on PlatformException catch (e) {
                                print("Failed to get message: '${e.message}'.");
                              }

                              /*Directory directory = await getTemporaryDirectory();
                              final File file = File('${directory.path}/samp.txt');
                              await file.writeAsString('Sample message');

                              print((await file.readAsString()));

                              final MailOptions mailOptions = MailOptions(
                                body: 'report a issue',
                                subject: 'Report problem',
                                recipients: ['claudin@smoose.com'],
                                isHTML: false,
                                attachments: [file.path],
                              );

                              try {
                                await FlutterMailer.send(mailOptions);
                              } catch (error) {
                                print('Could not send email: $error');
                              }
                              await file.delete();*/
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
