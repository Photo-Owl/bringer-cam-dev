import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/payment_components/payment_failed/payment_failed_widget.dart';
import '/payment_components/payment_pending/payment_pending_widget.dart';
import '/payment_components/payment_successful/payment_successful_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'payment_confirmation_model.dart';
export 'payment_confirmation_model.dart';

class PaymentConfirmationWidget extends StatefulWidget {
  const PaymentConfirmationWidget({super.key});

  @override
  State<PaymentConfirmationWidget> createState() =>
      _PaymentConfirmationWidgetState();
}

class _PaymentConfirmationWidgetState extends State<PaymentConfirmationWidget> {
  late PaymentConfirmationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentConfirmationModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'PaymentConfirmation'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('PAYMENT_CONFIRMATION_PaymentConfirmation');
      logFirebaseEvent('PaymentConfirmation_custom_action');
      _model.paymentId = await actions.getPidFromURI();
      logFirebaseEvent('PaymentConfirmation_backend_call');
      _model.apiResult9yg = await InstamojoGroup.getAccessTokenCall.call();
      if ((_model.apiResult9yg?.succeeded ?? true)) {
        logFirebaseEvent('PaymentConfirmation_backend_call');
        _model.apiResultqp3 = await InstamojoGroup.verifyPaymentCall.call(
          authtoken: InstamojoGroup.getAccessTokenCall.accessToken(
            (_model.apiResult9yg?.jsonBody ?? ''),
          ),
          paymentRequestid: _model.paymentId,
        );
        if ((_model.apiResultqp3?.succeeded ?? true)) {
          logFirebaseEvent('PaymentConfirmation_update_page_state');
          setState(() {
            _model.paymentStatus =
                InstamojoGroup.verifyPaymentCall.paymentStatus(
              (_model.apiResultqp3?.jsonBody ?? ''),
            );
          });
        } else {
          logFirebaseEvent('PaymentConfirmation_show_snack_bar');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (_model.apiResultqp3?.jsonBody ?? '').toString(),
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              duration: const Duration(milliseconds: 4000),
              backgroundColor: FlutterFlowTheme.of(context).alternate,
            ),
          );
          return;
        }
      } else {
        logFirebaseEvent('PaymentConfirmation_show_snack_bar');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              (_model.apiResult9yg?.jsonBody ?? '').toString(),
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).alternate,
          ),
        );
        return;
      }
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
        title: 'PaymentConfirmation',
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
              child: Stack(
                alignment: const AlignmentDirectional(0.0, 0.0),
                children: [
                  if ((_model.paymentStatus == null) ||
                      (_model.paymentId == null || _model.paymentId == ''))
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: wrapWithModel(
                        model: _model.paymentPendingModel,
                        updateCallback: () => setState(() {}),
                        child: PaymentPendingWidget(
                          paymentReqId: _model.paymentId,
                        ),
                      ),
                    ),
                  if (_model.paymentStatus ?? true)
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: StreamBuilder<List<PremiumPhotoPurchasesRecord>>(
                        stream: queryPremiumPhotoPurchasesRecord(
                          queryBuilder: (premiumPhotoPurchasesRecord) =>
                              premiumPhotoPurchasesRecord.where(
                            'payment_request_id',
                            isEqualTo: _model.paymentId,
                          ),
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
                          List<PremiumPhotoPurchasesRecord>
                              paymentSuccessfulPremiumPhotoPurchasesRecordList =
                              snapshot.data!;
                          return wrapWithModel(
                            model: _model.paymentSuccessfulModel,
                            updateCallback: () => setState(() {}),
                            child: PaymentSuccessfulWidget(
                              imagekey:
                                  paymentSuccessfulPremiumPhotoPurchasesRecordList
                                      .first.key,
                              premiumphotoDoc:
                                  paymentSuccessfulPremiumPhotoPurchasesRecordList
                                      .first,
                              hasMultipleDocs:
                                  paymentSuccessfulPremiumPhotoPurchasesRecordList
                                          .length >
                                      1,
                            ),
                          );
                        },
                      ),
                    ),
                  if (!_model.paymentStatus!)
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: wrapWithModel(
                        model: _model.paymentFailedModel,
                        updateCallback: () => setState(() {}),
                        child: const PaymentFailedWidget(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}
