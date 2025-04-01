import 'package:flutter/material.dart';
import '../screens/timer.dart';
import '../widgets/bottom_navbar.dart';
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
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.green.shade800, size: 40),
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
          Icon(Icons.settings, color: Colors.black),
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
      bottomNavigationBar: MyBottomNavigationBarWidget(
        initialIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// profilescreen.dart page
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
                  backgroundColor: Colors.greenAccent,
                  child: Icon(Icons.person, color: Colors.white, size: 80),
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
                  leading: Icon(Icons.edit, color: Colors.green),
                  title: Text("Edit Profile"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.green),
                  title: Text("Phone Number"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Log Out", style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
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



class EditProfileScreen extends StatefulWidget {
  final User? user;
  const EditProfileScreen({super.key, required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late Future<DocumentSnapshot> _userDataFuture;
  final _formKey = GlobalKey<FormState>();
  String _originalName = '';
  String _originalEmail = '';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _userDataFuture = FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).get();
      _userDataFuture.then((snapshot) {
        if (snapshot.exists) {
          _originalName = snapshot.get('name') ?? '';
          _originalEmail = widget.user!.email ?? '';
        }
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _confirmAndUpdateName() async {
    if (_formKey.currentState!.validate()) {
      if (nameController.text == _originalName) {
        _showErrorSnackBar("Please enter a new name.");
        return;
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Name Update"),
          content: const Text("Are you sure you want to update your name?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Confirm", style: TextStyle(color: Colors.green)),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).update({
                    'name': nameController.text,
                  });
                  Navigator.pop(context);
                  _showSuccessSnackBar("Name updated successfully");
                  _originalName = nameController.text;
                } on FirebaseAuthException catch (e) {
                  _showErrorSnackBar("Failed to update: ${e.message}");
                } catch (e) {
                  _showErrorSnackBar("An unexpected error occurred.");
                }
              },
            ),
          ],
        ),
      );
    }
  }

  void _confirmAndUpdateEmail() async {
    if (_formKey.currentState!.validate()) {
      if (emailController.text == _originalEmail) {
        _showErrorSnackBar("Please enter a new email.");
        return;
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Email Update"),
          content: const Text("Are you sure you want to update your email?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Confirm", style: TextStyle(color: Colors.green)),
              onPressed: () async {
                try {
                  await widget.user!.updateEmail(emailController.text);
                  Navigator.pop(context);
                  _showSuccessSnackBar("Email updated successfully");
                  _originalEmail = emailController.text;
                } on FirebaseAuthException catch (e) {
                  _showErrorSnackBar("Failed to update: ${e.message}");
                } catch (e) {
                  _showErrorSnackBar("An unexpected error occurred.");
                }
              },
            ),
          ],
        ),
      );
    }
  }

  void _confirmAndUpdatePassword() async {
    if (passwordController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Password Change"),
          content: const Text("Are you sure you want to change your password?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Confirm", style: TextStyle(color: Colors.green)),
              onPressed: () async {
                try {
                  await widget.user!.updatePassword(passwordController.text);
                  Navigator.pop(context);
                  _showSuccessSnackBar("Password Updated Successfully");
                  passwordController.clear();
                } on FirebaseAuthException catch (e) {
                  _showErrorSnackBar("Failed to update password: ${e.message}");
                } catch (e) {
                  _showErrorSnackBar("An unexpected error occurred.");
                }
              },
            ),
          ],
        ),
      );
    } else {
      _showErrorSnackBar("Please enter a new password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.user == null
            ? const Center(child: Text("User not found"))
            : FutureBuilder<DocumentSnapshot>(
                future: _userDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData && snapshot.data!.exists) {
                    var userData = snapshot.data!.data() as Map<String, dynamic>?;
                    nameController.text = userData?['name'] ?? "";
                    emailController.text = widget.user!.email ?? "";
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: nameController,
                                  decoration: const InputDecoration(labelText: "Name"),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your name";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _confirmAndUpdateName,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text("Update", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: const InputDecoration(labelText: "Email"),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your email";
                                    }
                                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _confirmAndUpdateEmail,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text("Update", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: passwordController,
                                  decoration: const InputDecoration(labelText: "New Password"),
                                  obscureText: true,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _confirmAndUpdatePassword,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text("Update", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text("User data not found"));
                  }
                },
              ),
      ),
    );
  }
}