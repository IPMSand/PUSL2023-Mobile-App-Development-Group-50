import 'package:flutter/material.dart';
// Profile Screen --- this is included in homepage too...
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.greenAccent,
              child: Icon(Icons.person, color: Colors.white, size: 80),
            ),
            const SizedBox(height: 20),
            Text(
              "Seraphina",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "seraphina@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.green),
              title: Text("Edit Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.green),
              title: Text("Phone Number"),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Log Out", style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
