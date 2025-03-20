import 'package:flutter/material.dart';
import '../screens/start02.dart'; // Import the start02 page
import 'package:google_fonts/google_fonts.dart';


class StudyZenScreen extends StatefulWidget {
  const StudyZenScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StudyZenScreenState createState() => _StudyZenScreenState();
}

class _StudyZenScreenState extends State<StudyZenScreen> {
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
      pageBuilder: (context, animation, secondaryAnimation) => const Start02Screen(),
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
      backgroundColor: const Color(0xFFCAFFBF), // Light green background
      body: Column(
        children: [
          const Spacer(), // Pushes everything below to the bottom
          Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logos/studyzen_logo.png', 
                    height: 220,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          const Spacer(), 
           Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: Text(
              'STUDYZEN',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
