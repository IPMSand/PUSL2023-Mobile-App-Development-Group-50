import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      _userDataFuture =
          FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).get();
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
      SnackBar(content: Text(message), backgroundColor: const Color.fromARGB(255, 95, 18, 13)),
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
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.user!.uid)
                      .update({'name': nameController.text});
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
              child: const Text("Confirm", style: TextStyle(color: Color.fromARGB(255, 2, 87, 48))),
              onPressed: () async {
                try {
                  await widget.user!.verifyBeforeUpdateEmail(emailController.text);
                  Navigator.pop(context);
                  _showSuccessSnackBar("Email verification sent. Please check your email.");
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
        backgroundColor: const Color.fromRGBO(105, 240, 174, 1),
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
                            backgroundImage: AssetImage('assets/images/profile.jpg'),

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
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 15, 110, 44)),
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
                                    if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _confirmAndUpdateEmail,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 15, 110, 44)),
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
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 15, 110, 44)),
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