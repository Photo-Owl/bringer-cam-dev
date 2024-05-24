import 'dart:convert';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Instamojo Group Code

class InstamojoGroup {
  static String baseUrl =
      'https://us-central1-bringer-cam-dev.cloudfunctions.net';
  static Map<String, String> headers = {};
  static GetAccessTokenCall getAccessTokenCall = GetAccessTokenCall();
  static CreatePaymentRequestCall createPaymentRequestCall =
      CreatePaymentRequestCall();
  static VerifyPaymentCall verifyPaymentCall = VerifyPaymentCall();
}

class GetAccessTokenCall {
  Future<ApiCallResponse> call() async {
    const ffApiRequestBody = '''
{
  "client_id": "O37u9BWWpUj5iACsZkuTwar6hlcPVsGM2DQ9HYlZ",
  "client_secret": "lZSSVwl07yXh2gdLzVczqiFabd62MbZNbdr6afk2DN0tZpxpD88YlO3wtdp1smRRVX6SthLZwgPL7av9l1vDDmgEJ656wkscSho3wOgCjsFfpkRVjgLPOM5eZ5FDmsl0"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Access Token',
      apiUrl: '${InstamojoGroup.baseUrl}/GenerateAccessTokenIM',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  String? accessToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.access_token''',
      ));
  int? expiresIn(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.expires_in''',
      ));
  String? scope(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.scope''',
      ));
  String? tokenType(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.token_type''',
      ));
}

class CreatePaymentRequestCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    String? amount = '',
    String? purpose = '',
    String? buyerName = '',
    String? phoneNumber = '',
  }) async {
    final ffApiRequestBody = '''
{
  "auth_token": "$authToken",
  "amount": "$amount",
  "purpose": "$purpose",
  "buyer_name": "$buyerName",
  "phone_number": "$phoneNumber"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Create Payment Request',
      apiUrl: '${InstamojoGroup.baseUrl}/CreatePaymentRequestIM',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  dynamic id(dynamic response) => getJsonField(
        response,
        r'''$.id''',
      );
  dynamic status(dynamic response) => getJsonField(
        response,
        r'''$.status''',
      );
  dynamic longurl(dynamic response) => getJsonField(
        response,
        r'''$.longurl''',
      );
  dynamic createdAt(dynamic response) => getJsonField(
        response,
        r'''$.created_at''',
      );
  dynamic modifiedAt(dynamic response) => getJsonField(
        response,
        r'''$.modified_at''',
      );
  dynamic resourceUrl(dynamic response) => getJsonField(
        response,
        r'''$.resource_uri''',
      );
}

class VerifyPaymentCall {
  Future<ApiCallResponse> call({
    String? authtoken = '',
    String? paymentRequestid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "payment_request_id": "$paymentRequestid",
  "auth_token": "$authtoken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Verify payment',
      apiUrl: '${InstamojoGroup.baseUrl}/verifyPayment',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  dynamic paymentStatus(dynamic response) => getJsonField(
        response,
        r'''$.status''',
      );
}

/// End Instamojo Group Code

class UserOnboardingCall {
  static Future<ApiCallResponse> call({
    String? storageUrl = '',
    String? uid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "imageUrl": "$storageUrl",
  "uid": "$uid"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'userOnboarding',
      apiUrl:
          'https://us-central1-bringer-cam-dev.cloudfunctions.net/userOnboardingTIF',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class SearchFacesUsingTIFCall {
  static Future<ApiCallResponse> call({
    String? uid = '',
    String? sourceKey = '',
    String? faceid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "faceId": "$faceid",
  "uId": "$uid",
  "sourceKey": "$sourceKey"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'searchFacesUsingTIF',
      apiUrl:
          'https://us-central1-bringer-cam-dev.cloudfunctions.net/searchFacesUsingTIF',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteImageCall {
  static Future<ApiCallResponse> call({
    String? key = '',
  }) async {
    final ffApiRequestBody = '''
{
  "Key": "$key"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'DeleteImage',
      apiUrl:
          'https://us-central1-bringer-cam-dev.cloudfunctions.net/deleteImage',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class CompressedImageForAllCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'compressedImageForAll',
      apiUrl:
          'https://us-central1-bringer-cam-dev.cloudfunctions.net/generatecompressedImageUrlForAllDocuments',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      bodyType: BodyType.NONE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetBannerDetailsCall {
  static Future<ApiCallResponse> call({
    String? uid = '',
    String? key = '',
  }) async {
    final ffApiRequestBody = '''
{
  "uid": "$uid",
  "key": "$key"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetBannerDetails',
      apiUrl:
          'https://us-central1-bringer-cam-dev.cloudfunctions.net/getBanner',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  static String? imageUrl(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.imageUrl''',
      ));
  static String? buttonText(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.button.text''',
      ));
  static String? buttonColor(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.button.color''',
      ));
  static String? bannerColor(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.banner.color''',
      ));
  static dynamic redirectUrl(dynamic response) => getJsonField(
        response,
        r'''$.redirectUrl''',
      );
  static dynamic bannerId(dynamic response) => getJsonField(
        response,
        r'''$.bannerId''',
      );
}

class SearchOnUploadCall {
  static Future<ApiCallResponse> call({
    String? albumId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "albumId": "$albumId"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SearchOnUpload',
      apiUrl:
          'https://us-central1-bringer-cam-dev.cloudfunctions.net/searchFacesOnUploadTIF',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPurchasableImagesCall {
  static Future<ApiCallResponse> call({
    String? uid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "uid": "$uid"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getPurchasableImages',
      apiUrl:
          'https://us-central1-bringer-cam-dev.cloudfunctions.net/getImagesForPurchases',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetReviwOrderDetailsCall {
  static Future<ApiCallResponse> call({
    List<String>? keysList,
  }) async {
    final keys = _serializeList(keysList);

    final ffApiRequestBody = '''
{
  "keys": $keys
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetReviwOrderDetails',
      apiUrl:
          'https://us-central1-bringer-cam-dev.cloudfunctions.net/getReviewOrderDetails',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic totalCost(dynamic response) => getJsonField(
        response,
        r'''$.totalCost''',
      );
  static dynamic discount(dynamic response) => getJsonField(
        response,
        r'''$.discount''',
      );
  static dynamic finalTotal(dynamic response) => getJsonField(
        response,
        r'''$.finalTotal''',
      );
}

class GetMatchesCall {
  static Future<ApiCallResponse> call({
    String? uid = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getMatches',
      apiUrl:
          'https://us-central1-bringer-cam-dev.cloudfunctions.net/getAllMatches',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'userId': uid,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  static List? matchAlbums(dynamic response) => getJsonField(
        response,
        r'''$''',
        true,
      ) as List?;
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
