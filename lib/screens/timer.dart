import 'package:flutter/material.dart';
// Timer Screen
class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Text("Timer Screen", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}