import 'package:flutter/material.dart';
import '../screens/timer.dart';
import '../widgets/colored_bottom_nav.dart';
import '../screens/profile.dart';
import 'view_todo.dart';
import '../screens/event_plan.dart';
import '../screens/calander.dart';
import '../screens/dashboard.dart';
import '../screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String userName = "User";
  String userEmail = "email@example.com";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          userName = snapshot.get('name') ?? "User";
          userEmail = user.email ?? "email@example.com";
        });
      } else {
        setState(() {
          userName = user.displayName ?? "User";
          userEmail = user.email ?? "email@example.com";
        });
      }
    }
  }

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
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.green),
              title: Text("Home"),
              onTap: () => _navigateToScreen(DashboardScreen()),
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
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("Welcome", style: TextStyle(color: Colors.black)),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _navigateToScreen(ProfileScreen()),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.green.shade800),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(child: Text("Main Content Here")),
      bottomNavigationBar: ColoredBottomBar(),
    );
  }
}
