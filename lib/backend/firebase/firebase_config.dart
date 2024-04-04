import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBlzTW6aaY4kp7l47Pzz1MXtiqFKJF34vU",
            authDomain: "bringer-cam-dev.firebaseapp.com",
            projectId: "bringer-cam-dev",
            storageBucket: "bringer-cam-dev.appspot.com",
            messagingSenderId: "374889583246",
            appId: "1:374889583246:web:0c8e3e9d2093a8a71aefdf",
            measurementId: "G-DP9FF2YCE5"));
  } else {
    await Firebase.initializeApp();
  }
}
