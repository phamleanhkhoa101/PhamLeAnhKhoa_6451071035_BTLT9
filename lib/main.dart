import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// import 'cau1/app/cau1_app.dart';
import 'cau2/app/cau2_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const Cau1App());
  runApp(const Cau2App());
}
