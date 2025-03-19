
import 'package:flutter/material.dart';
/*
import '../screens/calander.dart';
import '../screens/event_plan.dart';
import '../screens/home.dart';
import '../screens/timer.dart';
import '../screens/todo_view_screen.dart';
import 'bottom_navbar.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onDrawerIconPressed;
  final VoidCallback onSettingsIconPressed;
  final VoidCallback onProfileIconPressed;

  MyAppBar({
    required this.onDrawerIconPressed,
    required this.onSettingsIconPressed,
    required this.onProfileIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.greenAccent,
      title: Text("Welcome", style: TextStyle(color: Colors.black)),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.black),
        onPressed: onDrawerIconPressed,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings, color: Colors.black),
          onPressed: onSettingsIconPressed,
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onProfileIconPressed,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.green.shade800),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Example usage within HomeScreen or other pages:
class HomeScreenr extends StatefulWidget {
  const HomeScreenr({super.key});

  @override
  State<HomeScreenr> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenr> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void _onSettingsPressed() {
    // Implement settings functionality here
    print("Settings pressed");
  }

  void _onProfilePressed() {
    // Navigate to profile screen
    _navigateToScreen(ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.greenAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.green.shade800, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Seraphina",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    "seraphina@example.com",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.green),
              title: Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.shield_moon_rounded, color: Colors.green),
              title: Text("To Do List"),
              onTap: () => _navigateToScreen(TaskListScreen()),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.green),
              title: Text("Calender"),
              onTap: () => _navigateToScreen(CalendarScreen()),
            ),
            ListTile(
              leading: Icon(Icons.timer, color: Colors.green),
              title: Text("Timer"),
              onTap: () => _navigateToScreen(TimerPage()),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart_outlined, color: Colors.green),
              title: Text("Event Planing"),
              onTap: () => _navigateToScreen(AddEventScreen()),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Log Out", style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        onDrawerIconPressed: () => _openDrawer(context),
        onSettingsIconPressed: _onSettingsPressed,
        onProfileIconPressed: _onProfilePressed,
      ),
      body: Center(child: Text("Main Content Here")),
      bottomNavigationBar: MyBottomNavigationBarWidget(
        initialIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
*/