import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyC1OmQvD5i94MRT3jueigjooGZt83M3Yi0",
            authDomain: "your-photos-dev.firebaseapp.com",
            projectId: "your-photos-dev",
            storageBucket: "your-photos-dev.appspot.com",
            messagingSenderId: "451341218107",
            appId: "1:451341218107:web:85d2ba3a6e73d01798c71e"));
  } else {
    await Firebase.initializeApp();
  }
}
