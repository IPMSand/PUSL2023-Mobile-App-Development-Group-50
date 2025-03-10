import 'package:flutter/material.dart';
import 'add_event_screen.dart'; // Import the AddEventScreen file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddEventScreen(),
    );
  }
}
