import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/custom_code/actions/index.dart' as actions;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import '/backend/sqlite/sqlite_manager.dart';
import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await initFirebase();

  // Start initial custom actions code
  await actions.initializeNotifs();
  // End initial custom actions code

  await SQLiteManager.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  // Start final custom actions code
  await actions.startAutoUpload();
  // End final custom actions code

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = bringerCamDevFirebaseUserStream()
      ..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );

    _handleSharedPhotos();
  }

  @override
  void dispose() {
    authUserSub.cancel();

    super.dispose();
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  void _handleSharedPhotos() {
    const photosChannel = MethodChannel('com.smoose.photoowldev/sharePhotos');
    photosChannel.setMethodCallHandler((methodCall) async {
      debugPrint('bringer/sharePhotos: received method call');
      if (methodCall.method == "sharePhotos") {
        final photosList = List.castFrom<dynamic, String>(methodCall.arguments as List);
        final timestamp = DateTime.timestamp().millisecondsSinceEpoch;
        for (final pic in photosList) {
          await SQLiteManager.instance.insertImage(
            path: pic,
            ownerId: FirebaseAuth.instance.currentUser?.uid,
            unixTimestamp: timestamp,
          );
        }
        Fluttertoast.showToast(msg: "Uploading the pics to Social Gallery...");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Social Gallery',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
