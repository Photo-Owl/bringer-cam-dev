import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'enlargedimage_model.dart';
export 'enlargedimage_model.dart';

class EnlargedimageWidget extends StatefulWidget {
  const EnlargedimageWidget({
    super.key,
    required this.imageurl,
  });

  final String? imageurl;

  @override
  State<EnlargedimageWidget> createState() => _EnlargedimageWidgetState();
}

class _EnlargedimageWidgetState extends State<EnlargedimageWidget> {
  late EnlargedimageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EnlargedimageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
        ),
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: OctoImage(
                  placeholderBuilder: (_) => SizedBox.expand(
                    child: Image(
                      image: BlurHashImage('BEN]Rv-WPn}SQ[VF'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  image: CachedNetworkImageProvider(
                    functions.convertToImagePath(widget.imageurl!),
                  ),
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 0.65,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(1.0, 0.0),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent('ENLARGEDIMAGE_COMP_Icon_a27928lr_ON_TAP');
                    logFirebaseEvent('Icon_close_dialog,_drawer,_etc');
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
