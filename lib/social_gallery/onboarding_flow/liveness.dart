import 'dart:convert';

import 'package:bringer_cam_dev/auth/firebase_auth/auth_util.dart';
import 'package:bringer_cam_dev/backend/backend.dart';
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
          'https://us-central1-${kReleaseMode ? 'bringer-cam-dev' : 'social-gallery-dev'}.cloudfunctions.net'),
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
        webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.black)
          // TODO: Replace the link with hosted app
          ..loadRequest(Uri.parse('https://example.com?SessionId=$sessionId'));
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
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : WebViewWidget(controller: webViewController),
      ),
    );
  }
}
