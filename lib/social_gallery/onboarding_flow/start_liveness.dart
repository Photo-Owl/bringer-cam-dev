import 'package:bringer_cam_dev/auth/firebase_auth/auth_util.dart';
import 'package:bringer_cam_dev/flutter_flow/flutter_flow_util.dart';
import 'package:bringer_cam_dev/social_gallery/onboarding_flow/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class LivenessStartWidget extends StatefulWidget {
  const LivenessStartWidget({super.key});

  @override
  State<LivenessStartWidget> createState() => _LivenessStartWidgetState();
}

class _LivenessStartWidgetState extends State<LivenessStartWidget> {
  late VideoPlayerController _controller;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> userDoc;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/Instashare.mp4', // Replace with your asset path
    )..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });

    userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .snapshots();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Liveness check',
      color: AppColors.purplishWhite,
      child: Scaffold(
        backgroundColor: Color(0xFF4400CA),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFF4400CA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: userDoc,
                  builder: (context, snapshot) {
                    final isLive = snapshot.hasData
                        ? (snapshot.requireData.data()?['isLive'] ?? false)
                        : false;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      child: InkWell(
                        onTap: Feedback.wrapForTap(
                            () => isLive ? context.pushNamed('homeCopyCopy') : context.pushNamed('checkLiveness'), context),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 12, horizontal: 32),
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  fontSize: 16,
                                  height: 1.5,
                                  letterSpacing: -0.3,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
