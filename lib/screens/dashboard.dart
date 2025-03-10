import 'package:flutter/material.dart';
// Dashboard Screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Text(" Dashboard!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );

  }
}