import 'dart:convert';

import 'package:bringer_cam_dev/auth/firebase_auth/auth_util.dart';
import 'package:bringer_cam_dev/backend/backend.dart';
import 'package:bringer_cam_dev/flutter_flow/flutter_flow_util.dart';
import 'package:bringer_cam_dev/flutter_flow/flutter_flow_widgets.dart';
import 'package:bringer_cam_dev/social_gallery/onboarding_flow/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LivenessWidget extends StatefulWidget {
  const LivenessWidget({super.key});

  @override
  State<LivenessWidget> createState() => _LivenessWidgetState();
}

class _LivenessWidgetState extends State<LivenessWidget> {
  late final WebViewController webViewController;
  var loading = true;

  Future<String> setSessionId() async {
    final resp = await post(
      Uri.parse(
          'https://us-central1-${kReleaseMode ? 'bringer-cam-dev' : 'social-gallery-dev'}.cloudfunctions.net/createFaceLivenessSession'),
    );

    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .update({
        "isLive": false,
        "sessionId": decoded['SessionId'],
      });
      return decoded['SessionId'];
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    setSessionId().then((sessionId) {
      if (mounted) {
        webViewController = WebViewController(
          onPermissionRequest: (request) => request.grant(),
        )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.black)
          ..loadRequest(Uri.parse(
              'https://${kReleaseMode ? 'main' : 'qa'}.d3613fn7sidf3k.amplifyapp.com/?SessionId=$sessionId'));
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Liveness check',
      color: AppColors.purplishWhite,
      child: Scaffold(
        backgroundColor: const Color(0xFF4400CA),
        appBar: AppBar(
          title: Text(
            "Liveness check",
            style: GoogleFonts.getFont(
              'Inter',
              height: 1.5,
              letterSpacing: -0.3,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserUid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var userDoc = snapshot.data!;
            var userDocData = userDoc.data() as Map<String, dynamic>? ?? {};
            var isLive = userDocData['isLive'] as bool?;

            if (isLive == true) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Liveness check passed",
                        style: GoogleFonts.getFont(
                          'Inter',
                          height: 1.5,
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      FFButtonWidget(
                        text: 'Continue',
                        onPressed: () {
                          context.pushReplacementNamed('waitForVerification');
                        },
                        options: FFButtonOptions(
                          width: 200,
                          height: 50,
                          color: Colors.white,
                          textStyle: GoogleFonts.getFont(
                            'Inter',
                            height: 1.5,
                            letterSpacing: -0.3,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return loading
                ? const Center(child: CircularProgressIndicator())
                : WebViewWidget(controller: webViewController);
          },
        ),
      ),
    );
  }
}
