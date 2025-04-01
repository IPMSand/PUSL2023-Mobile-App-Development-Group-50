import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../widgets/colored_bottom_nav.dart';
import 'profile.dart';
import 'view_todo.dart';
import 'calander.dart';
import 'event_plan.dart';
import 'timer.dart';
import '../models/todo_taks_class.dart';
import '../database/todo_database.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _MyDashboardScreen();
}

class _MyDashboardScreen extends State<DashboardScreen> {
  String _username = 'User';
  List<Map<String, dynamic>> _upcomingEvents = [];
  List<Task> _upcomingTasks = [];
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _fetchUsername(user);
        await _fetchUpcomingEvents(user);
        await _fetchUpcomingTasks(user);
      } else {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          _username = prefs.getString('username') ?? 'User';
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUsername(User user) async {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
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

 Future<void> _fetchUpcomingEvents(User user) async {
  try {
    Timestamp nowTimestamp = Timestamp.fromDate(DateTime.now());
    QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('userId', isEqualTo: user.uid)
        .where('date', isGreaterThanOrEqualTo: nowTimestamp)
        .orderBy('date')
        .get();

    setState(() {
      _upcomingEvents = eventSnapshot.docs.map((doc) {
        print('Firestore Document: ${doc.data()}'); // Add this line
        Timestamp timestamp = doc['date'];
        DateTime date = timestamp.toDate();
        String formattedTime = DateFormat('hh:mm a').format(date);
        return {
          'title': doc['title'],
          'startTime': formattedTime,
        };
      }).toList();
    });
  } catch (e) {
    print('Error fetching events: $e');
  }
}

  Future<void> _fetchUpcomingTasks(User user) async {
    try {
      Database db = Database();
      db.fetchAllTasks(user.uid, (List<Task> tasks) {
        List<Task> upcoming = tasks
            .where((task) =>
                DateFormat('yyyy-MM-dd').parse(task.date!).isAfter(DateTime.now()) ||
                DateFormat('yyyy-MM-dd').parse(task.date!).isAtSameMomentAs(DateTime.now()))
            .toList()
          ..sort((a, b) => DateFormat('yyyy-MM-dd').parse(a.date!).compareTo(DateFormat('yyyy-MM-dd').parse(b.date!)));

        setState(() {
          _upcomingTasks = upcoming.take(3).toList();
        });
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text("StudyZen"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi, $_username", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const Text("Here is your activity today."),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildFeatureIcon("My Profile", "assets/images/home-profile.png", ProfileScreen()),
                              SizedBox(width: 12),
                              _buildFeatureIcon("To Do List", "assets/images/home-list.png", TaskListScreen()),
                              SizedBox(width: 12),
                              _buildFeatureIcon("Calendar", "assets/images/home-calendar.png", CalendarScreen()),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildFeatureIcon("Plan Events", "assets/images/home-plan.png", AddEventScreen()),
                              SizedBox(width: 12),
                              _buildFeatureIcon("Timer", "assets/images/home-timer.png", TimerPage()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Upcoming Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _upcomingEvents.isNotEmpty
                        ? Column(
                            children: _upcomingEvents
                                .map((event) => _buildEventCard(event['title']!, event['time']!))
                                .toList(),
                          )
                        : const Text("No upcoming events", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    const Text("Upcoming Tasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                   
                    SizedBox(height: 16),
                    _upcomingTasks.isNotEmpty
                        ? Column(
                            children: _upcomingTasks.map((task) {
                              return ListTile(
                                title: Text(task.taskName),
                                subtitle: Text(task.date!),
                              );
                            }).toList(),
                          )
                        : const Text("No upcoming tasks", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: ColoredBottomBar(),
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
    return Container(
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
            FittedBox(child: Text(label, style: TextStyle(fontSize: 11), textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}

// ... (rest of your classes: ToDoScreen, PlanEventsScreen, TimerScreen, EventDetailScreen)
//... rest of the classes are same...
