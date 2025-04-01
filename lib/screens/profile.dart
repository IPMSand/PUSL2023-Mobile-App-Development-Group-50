// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/profile_edit.dart'; // Import the new EditProfileScreen file

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var userData = snapshot.data?.data() as Map<String, dynamic>?;
        String name = userData?['name'] ?? user?.displayName ?? "User";
        String email = user?.email ?? "No Email";

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
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.edit, color: const Color.fromARGB(255, 2, 94, 59)),
                  title: Text("Edit Profile"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Back to the Home Screen", style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context); // adjust here
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}