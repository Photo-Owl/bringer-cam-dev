import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'selectmorephotos_model.dart';
export 'selectmorephotos_model.dart';

class SelectmorephotosWidget extends StatefulWidget {
  const SelectmorephotosWidget({
    super.key,
    required this.albumsdoc,
    required this.uploadsdoc,
  });

  final AlbumsRecord? albumsdoc;
  final UploadsRecord? uploadsdoc;

  @override
  State<SelectmorephotosWidget> createState() => _SelectmorephotosWidgetState();
}

class _SelectmorephotosWidgetState extends State<SelectmorephotosWidget> {
  late SelectmorephotosModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectmorephotosModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF2A2F32),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0),
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hold on !',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBtnText,
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          FlutterFlowIconButton(
                            borderColor: Color(0xFF2A2F32),
                            borderRadius: 20.0,
                            borderWidth: 1.0,
                            buttonSize: 40.0,
                            fillColor: Color(0xFF2A2F32),
                            icon: Icon(
                              Icons.close,
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              logFirebaseEvent(
                                  'SELECTMOREPHOTOS_COMP_close_ICN_ON_TAP');
                              logFirebaseEvent(
                                  'IconButton_close_dialog,_drawer,_etc');
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
              child: Text(
                'Found more Photos you\'d like to buy ?',
                style: FlutterFlowTheme.of(context).labelLarge.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Buy them all and avail AWESOME discounts',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                    )
                  ],
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 10.0, 20.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        logFirebaseEvent(
                            'SELECTMOREPHOTOS_COMP_BUY_NOW_BTN_ON_TAP');
                        var _shouldSetState = false;
                        if (widget.albumsdoc!.premiumImageDiscountedCost <
                            10.0) {
                          logFirebaseEvent('Button_close_dialog,_drawer,_etc');
                          Navigator.pop(context);
                          logFirebaseEvent('Button_show_snack_bar');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Minimum cart value of Rs.10 required',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
                            ),
                          );
                          if (_shouldSetState) setState(() {});
                          return;
                        }
                        logFirebaseEvent('Button_backend_call');
                        _model.apiResultm8a =
                            await InstamojoGroup.getAccessTokenCall.call();
                        _shouldSetState = true;
                        if ((_model.apiResultm8a?.succeeded ?? true)) {
                          logFirebaseEvent('Button_backend_call');
                          _model.apiResult545 = await InstamojoGroup
                              .createPaymentRequestCall
                              .call(
                            authToken:
                                InstamojoGroup.getAccessTokenCall.accessToken(
                              (_model.apiResultm8a?.jsonBody ?? ''),
                            ),
                            amount: widget.albumsdoc?.premiumImageDiscountedCost
                                ?.toString(),
                            purpose: 'PremiumPhoto ${widget.albumsdoc?.id}',
                            buyerName: currentUserDisplayName,
                            phoneNumber: currentPhoneNumber,
                          );
                          _shouldSetState = true;
                          if ((_model.apiResult545?.succeeded ?? true)) {
                            logFirebaseEvent('Button_backend_call');

                            await PremiumPhotoPurchasesRecord.collection
                                .doc()
                                .set(createPremiumPhotoPurchasesRecordData(
                                  uid: currentUserUid,
                                  key: widget.uploadsdoc?.key,
                                  createdAt: getCurrentTimestamp.toString(),
                                  paymentRequestId: InstamojoGroup
                                      .createPaymentRequestCall
                                      .id(
                                        (_model.apiResult545?.jsonBody ?? ''),
                                      )
                                      .toString(),
                                  status: 'Pending',
                                ));
                            logFirebaseEvent('Button_launch_u_r_l');
                            await launchURL(
                                InstamojoGroup.createPaymentRequestCall
                                    .longurl(
                                      (_model.apiResult545?.jsonBody ?? ''),
                                    )
                                    .toString());
                          }
                        } else {
                          logFirebaseEvent('Button_show_snack_bar');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to get auth token retry again',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
                            ),
                          );
                        }

                        if (_shouldSetState) setState(() {});
                      },
                      text: 'Buy Now',
                      options: FFButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            40.0, 0.0, 40.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              fontFamily: 'Inter',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              letterSpacing: 0.0,
                            ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 20.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        logFirebaseEvent(
                            'SELECTMOREPHOTOS_SELECT_MORE_BTN_ON_TAP');
                        logFirebaseEvent('Button_navigate_to');

                        context.pushNamed('SelectPhotos');
                      },
                      text: 'Select More',
                      options: FFButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).success,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                        elevation: 3.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
