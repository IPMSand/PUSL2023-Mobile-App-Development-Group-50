import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// screens
import 'screens/login.dart';
import 'screens/start01.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstTime = true; // Default to true, will be updated

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final firstTime = prefs.getBool('first_time') ?? true; // Get the value, or default to true

    setState(() {
      _isFirstTime = firstTime;
    });

    if (_isFirstTime) {
      prefs.setBool('first_time', false); // Set to false for subsequent launches
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(41, 153, 115, 1), ),
      home: _isFirstTime ? StudyZenScreen () : LoginScreen(), // Conditional screen
      debugShowCheckedModeBanner: false,
    );
  }
}
