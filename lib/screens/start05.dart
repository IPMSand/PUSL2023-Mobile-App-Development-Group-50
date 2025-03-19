import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad_project/screens/home.dart';
import 'package:mad_project/screens/loginPage.dart';

class Start05Screen extends StatelessWidget {
  const Start05Screen({super.key});

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
              'assets/start5.png',
              height: 250,
            ),
            const SizedBox(height: 25),
            
            Text(
              "Event Planing",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            Text(
              "Plan and organize your study events\n effortlessly! Schedule exams, group\n studies, and deadlines to stay ahead of\n your academic goals.",
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
                  width: index == 2 ? 12 : 8, // Change active dot to last one
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == 2 ? Colors.black : Colors.black26,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),

      // Bottom Navigation (Done Button)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the Done button
          children: [
            // Done Button
            ElevatedButton(

               onPressed: () {
                 Navigator.pushAndRemoveUntil(
                     context,
                     MaterialPageRoute(builder: (context) => LoginScreen()), // Replace NewPage() with your target page widget
                     (Route<dynamic> route) => false,
                 );
            },

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                backgroundColor: Colors.lightBlueAccent, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                "Done",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// TODO: Look at the problems in below 