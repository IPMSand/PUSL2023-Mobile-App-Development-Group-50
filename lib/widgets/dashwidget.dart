import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../screens/calander.dart';
import '../screens/event_plan.dart';
import '../screens/profile.dart';
import '../screens/timer.dart';
import '../screens/view_todo.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  String _username = 'User';
  List<Map<String, dynamic>> _upcomingEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchUpcomingEvents();
  }

  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.displayName != null) {
      setState(() {
        _username = user.displayName!;
      });
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _username = prefs.getString('username') ?? 'User';
      });
    }
  }

  Future<void> _fetchUpcomingEvents() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('userID', isEqualTo: user.uid)
        .orderBy('time')
        .limit(3)
        .get();

    setState(() {
      _upcomingEvents = eventSnapshot.docs.map((doc) {
        Timestamp timestamp = doc['time'];
        String formattedTime = DateFormat('hh:mm a').format(timestamp.toDate());
        return {
          'title': doc['title'],
          'time': formattedTime,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi, $_username",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Here is your activity today."),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureIcon("My Profile",
                          "assets/images/home-profile.png", ProfileScreen()),
                      SizedBox(width: 12),
                      _buildFeatureIcon("To Do List",
                          "assets/images/home-list.png", TaskListScreen()),
                      SizedBox(width: 12),
                      _buildFeatureIcon("Calendar",
                          "assets/images/home-calendar.png", CalendarScreen()),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureIcon("Plan Events",
                          "assets/images/home-plan.png", AddEventScreen()),
                      SizedBox(width: 12),
                      _buildFeatureIcon("Timer",
                          "assets/images/home-timer.png", TimerPage()),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text("Upcoming Events",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _upcomingEvents.isNotEmpty
                ? Column(
                    children: _upcomingEvents
                        .map((event) =>
                            _buildEventCard(event['title']!, event['time']!))
                        .toList(),
                  )
                : const Text("No upcoming events",
                    style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            const Text("Tasks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTaskIcon("HTML", "assets/images/home-html.png"),
                _buildTaskIcon("CSS", "assets/images/home-css.png"),
                _buildTaskIcon("PHP", "assets/images/home-php.png"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskIcon(String label, String imagePath) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Color(0x66D9D9D9),
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

  Widget _buildEventCard(String title, String time) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventDetailScreen(title: title, time: time)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0x66D9D9D9),
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
      ),
    );
  }

  Widget _buildFeatureIcon(String label, String imagePath, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Container(
        width: 100,
        height: 90,
        decoration: BoxDecoration(
          color: Color(0xA3A8CD89),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 45, height: 45),
            SizedBox(height: 8),
            FittedBox(
                child: Text(label,
                    style: TextStyle(fontSize: 11), textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final String title;
  final String time;

  const EventDetailScreen({Key? key, required this.title, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Event Title: $title",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Event Time: $time",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}