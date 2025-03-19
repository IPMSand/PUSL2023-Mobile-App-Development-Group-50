import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'start05.dart'; 

class Start04Screen extends StatelessWidget {
  const Start04Screen({super.key});

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
              'assets/start4.png',
              height: 250,
            ),
            const SizedBox(height: 25),
            
            Text(
              "Timer",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            Text(
              " Stay focused and boost productivity\n with our study timer! Set custom study\n sessions, take breaks, and manage\n your time effectively.",
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
                  width: index == 1 ? 12 : 8, // Second dot is bigger
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == 1 ? Colors.black : Colors.black26,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
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
                // Add action for Skip 
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

            // Next Button with slide transition
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const Start05Screen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Slide from right to left
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                  ),
                );
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
}
// TODO: Look at the problems in below 