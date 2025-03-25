import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'screens/home.dart';
// import 'screens/open_screen.dart';


// keep this page as it. Don't put ur code here. just change which screen to open here
// home: const HomeScreen(), // first page to open in the system

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp(MaterialApp(
home: LoginScreen(),
debugShowCheckedModeBanner: false,
));
}

/*
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
      home: const LoginScreen(),
    );
  }
}*/
// ToDO: for the first login user display start 1-5 pages......
