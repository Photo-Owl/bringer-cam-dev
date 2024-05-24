import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page_tab_bar_model.dart';
export 'home_page_tab_bar_model.dart';

class HomePageTabBarWidget extends StatefulWidget {
  const HomePageTabBarWidget({
    super.key,
    required this.selected,
  });

  final String? selected;

  @override
  State<HomePageTabBarWidget> createState() => _HomePageTabBarWidgetState();
}

class _HomePageTabBarWidgetState extends State<HomePageTabBarWidget> {
  late HomePageTabBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageTabBarModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                logFirebaseEvent('HOME_TAB_BAR_Container_s7mjz3js_ON_TAP');
                logFirebaseEvent('Container_navigate_to');

                context.goNamed('HomeCopyCopy');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: widget.selected == 'Shared'
                      ? const Color(0xFFE0EFFF)
                      : const Color(0xFFE9E9E9),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Shared with You',
                    style: GoogleFonts.getFont(
                      'Figtree',
                      color: widget.selected == 'Shared'
                          ? const Color(0xFF006AD4)
                          : const Color(0xFF44474F),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                logFirebaseEvent('HOME_TAB_BAR_Container_85m191xu_ON_TAP');
                logFirebaseEvent('Container_navigate_to');

                context.goNamed('HomeCopyCopy');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: widget.selected == 'Gallery'
                      ? const Color(0xFFE0EFFF)
                      : const Color(0xFFE9E9E9),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(16.0),
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Your Photos',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Figtree',
                          color: widget.selected == 'Gallery'
                              ? const Color(0xFF006AD4)
                              : const Color(0xFF44474F),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
