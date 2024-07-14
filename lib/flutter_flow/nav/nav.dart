import 'dart:async';

import 'package:bringer_cam_dev/social_gallery/onboarding_flow/battery_permission_widget/battery_permission_widget.dart';
import 'package:bringer_cam_dev/social_gallery/onboarding_flow/get_perms_widget.dart';
import 'package:bringer_cam_dev/social_gallery/onboarding_flow/intro_share_widget.dart';
import 'package:bringer_cam_dev/user_pages/alldone/alldone_widget.dart';
import 'package:bringer_cam_dev/user_pages/battery_optimization/battery_optimization_widget.dart';
import 'package:bringer_cam_dev/user_pages/connect_gallery/connect_gallery_widget.dart';
import 'package:bringer_cam_dev/user_pages/contacts_perm/contacts_perm_widget.dart';
import 'package:bringer_cam_dev/user_pages/displayover/displayover_widget.dart';
import 'package:bringer_cam_dev/user_pages/share_photos/share_photos_widget.dart';
import 'package:bringer_cam_dev/user_pages/usageaccess/usageaccess_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';

import '/auth/base_auth_user_provider.dart';

import '/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.loggedIn
          ? const RedirectionCopyWidget()
          : const SignInCopyWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? const WaitForVerificationWidget()
              : const SignInCopyWidget(),
        ),
        FFRoute(
          name: 'OtpVerification',
          path: '/otpVerification',
          builder: (context, params) => OtpVerificationWidget(
            name: params.getParam(
              'name',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'SignIn',
          path: '/signIn',
          builder: (context, params) => SignInWidget(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
            name: params.getParam(
              'name',
              ParamType.String,
            ),
            qr: params.getParam(
              'qr',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'SkipSelfie',
          path: '/skipSelfie',
          builder: (context, params) => const SkipSelfieWidget(),
        ),
        FFRoute(
          name: 'Product',
          path: '/product',
          builder: (context, params) => const ProductWidget(),
        ),
        FFRoute(
          name: 'SelectPhotos',
          path: '/selectPhotos',
          builder: (context, params) => const SelectPhotosWidget(),
        ),
        FFRoute(
          name: 'Address',
          path: '/address',
          builder: (context, params) => AddressWidget(
            selectedPhotos: params.getParam<String>(
              'selectedPhotos',
              ParamType.String,
              true,
            ),
          ),
        ),
        FFRoute(
          name: 'ReviewOrder',
          path: '/reviewOrder',
          builder: (context, params) => ReviewOrderWidget(
            selectedphotos: params.getParam<String>(
              'selectedphotos',
              ParamType.String,
              true,
            ),
          ),
        ),
        FFRoute(
          name: 'PremiumPhotos',
          path: '/Premium',
          builder: (context, params) => const PremiumPhotosWidget(),
        ),
        FFRoute(
          name: 'CreateanEvent',
          path: '/createanEvent',
          builder: (context, params) => const CreateanEventWidget(),
        ),
        FFRoute(
          name: 'ReadQr',
          path: '/readQr',
          builder: (context, params) => ReadQrWidget(
            qrId: params.getParam(
              'qrId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'WaitForVerification',
          path: '/waitForVerification',
          builder: (context, params) => const WaitForVerificationWidget(),
        ),
        FFRoute(
          name: 'Cantfindphotos',
          path: '/cantfindphotos',
          builder: (context, params) => const CantfindphotosWidget(),
        ),
        FFRoute(
          name: 'SocialSignIn',
          path: '/socialSignIn',
          asyncParams: {
            'userDocument': getDoc(['users'], UsersRecord.fromSnapshot),
          },
          builder: (context, params) => SocialSignInWidget(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
            userDocument: params.getParam(
              'userDocument',
              ParamType.Document,
            ),
            email: params.getParam(
              'email',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'Album',
          path: '/album',
          requireAuth: true,
          builder: (context, params) => AlbumWidget(
            albumId: params.getParam(
              'albumId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'ImageexpandedCopy',
          path: '/imageexpandedCopy',
          requireAuth: true,
          builder: (context, params) => ImageexpandedCopyWidget(
            albumDoc: params.getParam<ImageModelStruct>(
              'albumDoc',
              ParamType.DataStruct,
              true,
              null,
              ImageModelStruct.fromSerializableMap,
            ),
            index: params.getParam(
              'index',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: 'SignInCopy',
          path: '/signInCopy',
          builder: (context, params) => SignInCopyWidget(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
            name: params.getParam(
              'name',
              ParamType.String,
            ),
            qr: params.getParam(
              'qr',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'SocialSignInCopy',
          path: '/socialSignInCopy',
          asyncParams: {
            'userDocument': getDoc(['users'], UsersRecord.fromSnapshot),
          },
          builder: (context, params) => SocialSignInCopyWidget(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
            userDocument: params.getParam(
              'userDocument',
              ParamType.Document,
            ),
            email: params.getParam(
              'email',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'RedirectionCopy',
          path: '/Bringer',
          requireAuth: true,
          builder: (context, params) => const RedirectionCopyWidget(),
        ),
        FFRoute(
          name: 'camera',
          path: '/camera',
          builder: (context, params) => const CameraWidget(),
        ),
        FFRoute(
          name: 'LocalImage',
          path: '/LocalImage',
          requireAuth: true,
          builder: (context, params) => LocalImageWidget(
            path: params.getParam(
              'path',
              ParamType.String,
            ),
            isUploaded: params.getParam(
              'isUploaded',
              ParamType.bool,
            ),
            index: params.getParam(
              'index',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: 'HomeCopyCopy',
          path: '/home',
          builder: (context, params) => const HomeCopyCopyWidget(),
        ),
        FFRoute(
          name: 'connectgallery',
          path: '/connectgallery',
          builder: (context, params) => const ConnectGalleryWidget(),
        ),
        FFRoute(
          name: 'displayover',
          path: '/displayover',
          builder: (context, params) => const DisplayoverWidget(),
        ),
        FFRoute(
          name: 'usageaccess',
          path: '/usageaccess',
          builder: (context, params) => const UsageaccessWidget(),
        ),
        FFRoute(
          name: 'batteryOptimization',
          path: '/batteryOptimization',
          builder: (context, params) => const BatteryOptimizationWidget(),
        ),
        FFRoute(
          name: 'alldone',
          path: '/alldone',
          builder: (context, params) => const AlldoneWidget(),
        ),
        FFRoute(
          name: 'introShare',
          path: '/socialGallery/onboarding/intro',
          builder: (context, params) => const IntroShareWidget(),
        ),
        FFRoute(
          name: 'batteryPermission',
          path: '/socialGallery/onboarding/batteryPermission',
          builder: (context, params) => const BatteryPermissionWidget(),
        ),
        FFRoute(
          name: 'getPermsNew',
          path: '/socialGallery/onboarding/getPerms',
          builder: (context, params) => const GetPermsWidget(),
        ),
        FFRoute(
          name: 'contactsPerm',
          path: '/contactsPerm',
          builder: (context, params) => const ContactsPermWidget(),
        ),
        FFRoute(
          name: 'sharePhotos',
          path: '/sharePhotos',
          builder: (context, params) {
            return SharePhotosWidget(
              photos: List.castFrom<dynamic, String>(
                  params.state.extra as List? ?? const []),
            );
          },
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.location);
            return '/signInCopy';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? const Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF5282E5),
                      ),
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() =>
      const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouter.of(context).location;
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}
