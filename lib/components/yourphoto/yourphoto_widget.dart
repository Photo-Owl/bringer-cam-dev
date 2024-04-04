import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'yourphoto_model.dart';
export 'yourphoto_model.dart';

class YourphotoWidget extends StatefulWidget {
  const YourphotoWidget({super.key});

  @override
  State<YourphotoWidget> createState() => _YourphotoWidgetState();
}

class _YourphotoWidgetState extends State<YourphotoWidget> {
  late YourphotoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => YourphotoModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
