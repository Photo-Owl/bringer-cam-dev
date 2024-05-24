import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'read_qr_model.dart';
export 'read_qr_model.dart';

class ReadQrWidget extends StatefulWidget {
  const ReadQrWidget({
    super.key,
    required this.qrId,
  });

  final String? qrId;

  @override
  State<ReadQrWidget> createState() => _ReadQrWidgetState();
}

class _ReadQrWidgetState extends State<ReadQrWidget> {
  late ReadQrModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReadQrModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'ReadQr'});
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
        title: 'ReadQr',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              top: true,
              child: Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: FutureBuilder<List<QrCodesRecord>>(
                  future: queryQrCodesRecordOnce(
                    queryBuilder: (qrCodesRecord) => qrCodesRecord.where(
                      'id',
                      isEqualTo: widget.qrId,
                    ),
                    singleRecord: true,
                  ),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: SpinKitThreeBounce(
                            color: Color(0xFF8287F7),
                            size: 40.0,
                          ),
                        ),
                      );
                    }
                    List<QrCodesRecord> columnQrCodesRecordList =
                        snapshot.data!;
                    // Return an empty Container when the item does not exist.
                    if (snapshot.data!.isEmpty) {
                      return Container();
                    }
                    final columnQrCodesRecord =
                        columnQrCodesRecordList.isNotEmpty
                            ? columnQrCodesRecordList.first
                            : null;
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            fadeInDuration: const Duration(milliseconds: 0),
                            fadeOutDuration: const Duration(milliseconds: 0),
                            imageUrl: columnQrCodesRecord!.logoUrl,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 30.0, 0.0, 0.0),
                          child: Text(
                            'Follow to get your photos',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 25.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              logFirebaseEvent(
                                  'READ_QR_PAGE_FOLLOW_NOW_BTN_ON_TAP');
                              logFirebaseEvent('Button_launch_u_r_l');
                              await launchURL(columnQrCodesRecord.redirectUrl);
                            },
                            text: 'Follow Now',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: const Color(0xFFCBF7C2),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter',
                                    color: const Color(0xFF333333),
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 0.0,
                              borderSide: const BorderSide(
                                color: Color(0x6E000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
