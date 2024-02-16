import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/payment_components/payment_processing/payment_processing_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'paymentpage_model.dart';
export 'paymentpage_model.dart';

class PaymentpageWidget extends StatefulWidget {
  const PaymentpageWidget({
    super.key,
    this.paymentRequestId,
    this.imagekey,
  });

  final String? paymentRequestId;
  final String? imagekey;

  @override
  State<PaymentpageWidget> createState() => _PaymentpageWidgetState();
}

class _PaymentpageWidgetState extends State<PaymentpageWidget> {
  late PaymentpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentpageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Paymentpage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('PAYMENTPaymentpage_ON_INIT_STATE');
      logFirebaseEvent('Paymentpage_custom_action');
      _model.paymentRequestId = await actions.getidFromURI();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    context.watch<FFAppState>();

    return Title(
        title: 'Paymentpage',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              actions: const [],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: StreamBuilder<List<TransactionsRecord>>(
                stream: queryTransactionsRecord(
                  queryBuilder: (transactionsRecord) =>
                      transactionsRecord.where(
                    'id',
                    isEqualTo: widget.paymentRequestId != null &&
                            widget.paymentRequestId != ''
                        ? widget.paymentRequestId
                        : _model.paymentRequestId,
                  ),
                  singleRecord: true,
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return const Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF5282E5),
                          ),
                        ),
                      ),
                    );
                  }
                  List<TransactionsRecord> columnTransactionsRecordList =
                      snapshot.data!;
                  // Return an empty Container when the item does not exist.
                  if (snapshot.data!.isEmpty) {
                    return Container();
                  }
                  final columnTransactionsRecord =
                      columnTransactionsRecordList.isNotEmpty
                          ? columnTransactionsRecordList.first
                          : null;
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          if (columnTransactionsRecord?.status == 'Pending')
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: wrapWithModel(
                                model: _model.paymentProcessingModel,
                                updateCallback: () => setState(() {}),
                                updateOnChange: true,
                                child: PaymentProcessingWidget(
                                  longUrl: columnTransactionsRecord!.longurl,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        widget.paymentRequestId != null &&
                                widget.paymentRequestId != ''
                            ? widget.paymentRequestId!
                            : _model.paymentRequestId!,
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: Text(
                          columnTransactionsRecord!.status,
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            logFirebaseEvent(
                                'PAYMENTPAGE_PAGE_Text_6lh3qub4_ON_TAP');
                            logFirebaseEvent('Text_navigate_to');

                            context.goNamed('Home');
                          },
                          child: Text(
                            'You can close this tab',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ));
  }
}
