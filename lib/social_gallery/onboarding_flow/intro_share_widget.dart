import 'package:bringer_cam_dev/flutter_flow/flutter_flow_util.dart';
import 'package:bringer_cam_dev/social_gallery/onboarding_flow/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroShareWidget extends StatelessWidget {
  const IntroShareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Get perms',
      color: AppColors.purplishWhite,
      child: Scaffold(
        backgroundColor: AppColors.purplishWhite,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.only(top: 64, bottom: 8),
                  child: Text(
                    'Introducing share for your camera',
                    style: TextStyle(
                      fontFamily: 'Gotham Black',
                      fontSize: 36,
                      height: 1.05,
                      letterSpacing: -0.36,
                      color: Colors.black,
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: Text(
                    'Click pictures that you want to share with your friends with sharing mode on and they will be shared instantly.',
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontSize: 16,
                      height: 1.25,
                      letterSpacing: -0.3,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: Feedback.wrapForTap(
                          () => context.pushNamed('getPermsNew'), context),
                      child: Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                            vertical: 12, horizontal: 32),
                        color: AppColors.purple,
                        child: Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: GoogleFonts.getFont(
                                'Inter',
                                fontSize: 16,
                                height: 1.5,
                                letterSpacing: -0.3,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Image.asset('assets/images/Right Arrow.png', height: 24,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset('assets/images/share_intro.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
