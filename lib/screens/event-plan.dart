import 'package:flutter/material.dart';

// Event Planning Screen
class EventPlanningScreen extends StatelessWidget {
  const EventPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Planning"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Text("Plan Your Events", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}