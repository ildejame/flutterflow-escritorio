import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCqO_G2MmkGmAO51aZaAvAYMWaJeTlSbTY",
            authDomain: "inventarios-pjev.firebaseapp.com",
            projectId: "inventarios-pjev",
            storageBucket: "inventarios-pjev.firebasestorage.app",
            messagingSenderId: "585826507852",
            appId: "1:585826507852:web:5ea29df739ec900864e8e9",
            measurementId: "G-6HWEEKTE2N"));
  } else {
    await Firebase.initializeApp();
  }
}
