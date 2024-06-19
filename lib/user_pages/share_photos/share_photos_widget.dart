import 'package:content_resolver/content_resolver.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'share_photos_model.dart';
export 'share_photos_model.dart';

class SharePhotosWidget extends StatefulWidget {
  const SharePhotosWidget({
    super.key,
    required this.photos,
  });

  final List<String> photos;

  @override
  State<SharePhotosWidget> createState() => _SharePhotosWidgetState();
}

class _SharePhotosWidgetState extends State<SharePhotosWidget> {
  late SharePhotosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SharePhotosModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'SharePhotos'});

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
      title: 'SharePhotos',
      color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
      child: GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: SafeArea(
            top: true,
            child: Column(
              children: [
                Center(child: Text('bringer share photos'),),
                // Expanded(
                //   child: FutureBuilder(
                //     future: ContentResolver.resolveContent(widget.photos.first),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                //         return Image.memory(snapshot.requireData.data, fit: BoxFit.cover);
                //       }
                //       return const CircularProgressIndicator();
                //     },
                //   ),
                // ),
                const Text('Tap the share button below to share the pics to your friends!'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
