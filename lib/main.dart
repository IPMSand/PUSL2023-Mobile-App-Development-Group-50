import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/open_screen.dart';


// keep this page as it. Don't put ur code here. just change which screen to open here
// home: const HomeScreen(), // first page to open in the system
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Linker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
<<<<<<< HEAD
      home: const HomeScreen(), // first page to open in the system
=======
      home: const OpenDemo(),
>>>>>>> parent of 7414d9d (Merge branch 'main' into startup-pages)
    );
  }
}
// ToDO: for the first login user display start 1-5 pages......
