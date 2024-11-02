import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDnj1O8ReRzpE4hOyCTIEVFkilYb07QwIM",
            authDomain: "accesibilidad-flutterflow.firebaseapp.com",
            projectId: "accesibilidad-flutterflow",
            storageBucket: "accesibilidad-flutterflow.firebasestorage.app",
            messagingSenderId: "760726058558",
            appId: "1:760726058558:web:ec2ce3840a1e799754436f",
            measurementId: "G-DEWYZRHX8Z"));
  } else {
    await Firebase.initializeApp();
  }
}
