import 'dart:async';

import 'package:bringer_cam_dev/social_gallery/common/encrypted_banner.dart';
import 'package:bringer_cam_dev/social_gallery/onboarding_flow/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class GetPermsWidget extends StatefulWidget {
  const GetPermsWidget({super.key});

  @override
  State<GetPermsWidget> createState() => _GetPermsWidgetState();
}

class _GetPermsWidgetState extends State<GetPermsWidget> {
  var _permStates = <bool>[false, false, false, false];
  var _focused = 0;
  bool get _isSetupDone => _permStates.every((state) => state);
  late final List<
      ({
        String permName,
        String permDesc,
        FutureOr<void> Function(int) permReq
      })> _perms;

  Future<void> requestStoragePermission(int i) async {
    const platform = MethodChannel('com.smoose.photoowldev/autoUpload');
    final permsGiven = await platform.invokeMethod<bool>(
            'requestExternalStoragePermission', null) ??
        false;
    if (!mounted) return;
    if (permsGiven) {
      setState(() {
        _focused++;
        _permStates[i] = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get storage access.'),
        ),
      );
    }
  }

  // TODO modify the perm request callbacks like the one above
  // TODO (the if permsGiven part)

  // TODO contacts permission is in a different branch
  // merge code from dev into this branch after merging the PR

  @override
  void initState() {
    super.initState();
    _perms = [
      (
        permName: 'Read files in storage',
        permDesc:
            'This allows you to easily share selected photos through Bringer.',
        permReq: requestStoragePermission,
      ),
      // TODO add rest of the permissions with their callbacks
      (
        permName: 'Read files in storage',
        permDesc:
            'This allows you to easily share selected photos through Bringer.',
        permReq: requestStoragePermission,
      ),
      (
        permName: 'Read files in storage',
        permDesc:
            'This allows you to easily share selected photos through Bringer.',
        permReq: requestStoragePermission,
      ),
      (
        permName: 'Read files in storage',
        permDesc:
            'This allows you to easily share selected photos through Bringer.',
        permReq: requestStoragePermission,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Get perms',
      color: AppColors.purple,
      child: Scaffold(
        backgroundColor: AppColors.purple,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 40),
                  child: Image.asset(
                    'assets/images/bunny_smile.png',
                    height: 85,
                  ),
                ),
                const Text(
                  'Allow these permissions to get started',
                  style: TextStyle(
                    fontFamily: 'Gotham Black',
                    fontSize: 36,
                    height: 1.05,
                    letterSpacing: -0.36,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsetsDirectional.symmetric(vertical: 16),
                    itemCount: _perms.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding:
                            const EdgeInsetsDirectional.symmetric(vertical: 8),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, anim) =>
                              FadeTransition(opacity: anim, child: child),
                          child: PermissionWidget(
                            key: ValueKey('$i $_focused'),
                            permName: _perms[i].permName,
                            permDesc: _perms[i].permDesc,
                            permReq: () => _perms[i].permReq(i),
                            focused: i == _focused,
                            allowed: _permStates[i],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: Feedback.wrapForTap(() {
                      if (!_isSetupDone) return;
                      // TODO finish setup screen
                    }, context),
                    child: Container(
                      color: _isSetupDone
                          ? Colors.white
                          : AppColors.disabledPurple,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Finish Setup',
                            style: GoogleFonts.getFont(
                              'Inter',
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 32),
                  child: Center(child: EncryptedBanner()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PermissionWidget extends StatelessWidget {
  final String permName;
  final String permDesc;
  final FutureOr<void> Function() permReq;
  final bool focused;
  final bool allowed;

  const PermissionWidget({
    super.key,
    required this.permName,
    required this.permDesc,
    required this.permReq,
    required this.focused,
    required this.allowed,
  });

  @override
  Widget build(BuildContext context) {
    assert(!(focused && allowed),
        'Why is this widget still focused if permission was obtained?');
    return Opacity(
      opacity: (!focused && !allowed) ? 0.4 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.hardEdge,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsetsDirectional.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                permName,
                style: GoogleFonts.getFont(
                  'Inter',
                  fontSize: 14,
                  height: 1.14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, bottom: 12),
                child: Text(
                  permDesc,
                  style: GoogleFonts.getFont(
                    'Inter',
                    fontSize: 14,
                    height: 1.14,
                    color: Colors.black,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: Feedback.wrapForTap(() {
                    if ((!focused) || allowed) return;
                    permReq();
                  }, context),
                  child: Container(
                    color: allowed
                        ? const Color(0xFF05A74F)
                        : const Color(0xFF037762),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    child: allowed
                        ? const Icon(
                            Icons.check,
                            size: 24,
                            color: Colors.white,
                            weight: 500,
                          )
                        : Text(
                            'Allow',
                            style: GoogleFonts.getFont(
                              'Inter',
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
