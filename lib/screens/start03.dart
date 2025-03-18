import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'start04.dart'; // Import the next screen

class Start03Screen extends StatelessWidget {
  const Start03Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/start3.png',
              height: 250,
            ),
            const SizedBox(height: 15),
            
            Text(
              "To Do List",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            Text(
              "Keep track of your study tasks efficiently! Organize assignments, set deadlines, and stay on top of your learning with our easy-to-use To-Do List.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 17,
                color: const Color.fromARGB(230, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 20),

            // Dots Indicator 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: index == 0 ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.black : Colors.black26,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // Bottom Navigation (Skip & Next)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                // Skip action 
              },
              child: Text(
                "Skip",
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute()); // Slide transition
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(18),
                backgroundColor: Colors.lightBlueAccent,
              ),
              child: const Icon(
                Icons.arrow_forward, 
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Slide Transition with Swipe Back Enabled
  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => const Start04Screen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right to left
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
// TODO: Look at the problems in below 