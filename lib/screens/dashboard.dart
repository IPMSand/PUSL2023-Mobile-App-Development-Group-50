import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFCAFFBF),
        title: const Text("Welcome"),
        actions: [
          Icon(Icons.settings),
          SizedBox(width: 10),
          Icon(Icons.person), // ✅ Profile Icon added
          SizedBox(width: 10),
        ],
        leading: Icon(Icons.menu),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hi, Seraphina",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Text("Here is your activity today."),
              const SizedBox(height: 16),

              // Feature Icons (Centered with 3 in first row, 2 in second)
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFeatureIcon("My Profile", "assets/home-profile.png"),
                        SizedBox(width: 12),
                        _buildFeatureIcon("To Do List", "assets/home-list.png"),
                        SizedBox(width: 12),
                        _buildFeatureIcon("Calendar", "assets/home-calendar.png"),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFeatureIcon("Plan Events", "assets/home-plan.png"),
                        SizedBox(width: 12),
                        _buildFeatureIcon("Timer", "assets/home-timer.png"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _buildChartRow(),
              const SizedBox(height: 16),

              const Text("Upcoming Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildEventCard("QUIZ", "04.30 PM - 05.30 PM"),
              _buildEventCard("Task", "08.30 PM - 10.00 PM"),
              _buildEventCard("Practical", "08.30 AM - 10.00 AM"),

              const SizedBox(height: 16),
              const Text("Tasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              // Task Icons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTaskIcon("HTML", "assets/home-html.png"),
                  _buildTaskIcon("CSS", "assets/home-css.png"),
                  _buildTaskIcon("PHP", "assets/home-php.png"),
                ],
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar (Fixed Background Color)
      bottomNavigationBar: Container(
        color: Color(0xFFCAFFBF), // Background color
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Transparent so Container color shows
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.shield), label: "Security"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
            BottomNavigationBarItem(icon: Icon(Icons.refresh), label: "Refresh"),
          ],
        ),
      ),
    );
  }

  // Feature Icon with Background Color & Rounded Corners
  Widget _buildFeatureIcon(String label, String imagePath) {
    return Container(
      width: 100,
      height: 90,
      decoration: BoxDecoration(
        color: Color(0xA3A8CD89), // ✅ #A8CD89A3
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 45,
            height: 45,
          ),
          SizedBox(height: 8),
          FittedBox(
            child: Text(
              label,
              style: TextStyle(fontSize: 11), // 🔹 Change 12 to 16 (or any size)
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Chart Row
  Widget _buildChartRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildChartCard("assets/home-graph.png"),
        _buildChartCard("assets/home-pie.png"),
      ],
    );
  }

  Widget _buildChartCard(String imagePath) {
    return Container(
      height: 120,
      width: 140,
      decoration: BoxDecoration(
        color: Color(0x80D9D9D9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // Updated Upcoming Event Cards with Color & Border Radius
  Widget _buildEventCard(String title, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0x66D9D9D9), // ✅ #D9D9D966
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Icon(Icons.shield, color: Colors.green),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(time),
            ],
          ),
        ],
      ),
    );
  }

  // Updated Task Icons with Rounded Corners
  Widget _buildTaskIcon(String label, String imagePath) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Color(0x66D9D9D9), // ✅ #D9D9D966
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Image.asset(imagePath, width: 90, height: 90),
          ),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
