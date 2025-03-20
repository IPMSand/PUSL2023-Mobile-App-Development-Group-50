import 'package:flutter/material.dart';
import '../screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'start01.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(OpenDemo());
}

class OpenDemo extends StatelessWidget {
  const OpenDemo({super.key});

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: FutureBuilder<bool>(
        future: _isFirstTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Or a splash screen
          } else if (snapshot.hasData && snapshot.data!) {
            return StudyZenScreen(); // Show onboarding for first-time users
          } else {
            return HomeScreen(); // Show main app for returning users
          }
        },
      ),
    );
  }
  Future<bool> _isFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('first_time') ?? true; // Default to true if not set
}

Future<void> _setFirstTime(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('first_time', value);
}
}

// ... (Rest of your onboarding and main app code)