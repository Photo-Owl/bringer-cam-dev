import 'package:bringer_cam_dev/flutter_flow/flutter_flow_model.dart';
import 'package:bringer_cam_dev/index.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../components/sidebar/sidebar_model.dart';

class SettingsPageModel extends FlutterFlowModel<SettingsPageWidget> {
  late SidebarModel sidebarModel;
  @override
  void dispose() {
    sidebarModel.dispose();
  }

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }
}
