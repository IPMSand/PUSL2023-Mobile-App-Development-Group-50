/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // Import for delay
import 'start03.dart'; // Import the next screen

void main() {
  runApp(const StudyZenApp());
}

class StudyZenApp extends StatelessWidget {
  const StudyZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Start02Screen(),
    );
  }
}

class Start02Screen extends StatefulWidget {
  const Start02Screen({super.key});

  @override
  _Start02ScreenState createState() => _Start02ScreenState();
}

class _Start02ScreenState extends State<Start02Screen> {
  @override
  void initState() {
    super.initState();
    // Delayed navigation with a fade transition
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(_createRoute());
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800), // Smooth transition duration
      pageBuilder: (context, animation, secondaryAnimation) => const Start03Screen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCAFFBF), 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/start2.png', 
              height: 250,
            ),
            const SizedBox(height: 15),
            Text(
              "Hello and\nWelcome here!",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Get an overview of how you are \nperforming and motivate yourself to achieve even more.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color.fromARGB(230, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// TODO: Look at the problems in below */