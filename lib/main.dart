import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/start01.dart';



Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp(MaterialApp(
home: StudyZenScreen(),
debugShowCheckedModeBanner: false,
));
}

// ToDO: for the first login user display start 1-5 pages......

