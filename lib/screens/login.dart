// backend ok
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import '../screens/home.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || !EmailValidator.validate(email)) {
      _showSnackBar(context, 'Please enter a valid email address.');
      return;
    }

    if (password.isEmpty) {
      _showSnackBar(context, 'Please enter a password.');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed.';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled.';
          break;
        default:
          errorMessage = 'An unexpected error occurred: ${e.message}';
      }
      _showSnackBar(context, errorMessage);
    } catch (e) {
      _showSnackBar(context, 'An unexpected error occurred: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          duration: duration ?? const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Hello, Let's get started",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Login illustration
                  SizedBox(
                    height: 180,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          child: Container(
                            width: 200,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        // Blue login form
                        Positioned(
                          right: MediaQuery.of(context).size.width * 0.25,
                          top: 20,
                          child: Container(
                            width: 80,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 10,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 10,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Person illustrations
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.1,
                          bottom: 20,
                          child: Container(
                            width: 50,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: CustomPaint(
                              painter: PersonPainter(
                                  color: Colors.blue[700]!), // Pass the color
                            ),
                          ),
                        ),
                        Positioned(
                          right: MediaQuery.of(context).size.width * 0.1,
                          bottom: 20,
                          child: Container(
                            width: 50,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: CustomPaint(
                              painter: PersonPainter(
                                  color: Colors.red[400]!), // Pass the color.
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: '',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: '',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            shape: const CircleBorder(),
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ??
                                    false; //handle null value, though it will not happen.
                              });
                            },
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _loginUser(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D4059),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Doesn't have an account yet?",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Sign up navigation would go here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen(), // Use the correct class name
                                ),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter class for drawing the person icon
class PersonPainter extends CustomPainter {
  final Color color;

  PersonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 4), size.width / 3, paint);

    // Body
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2 + 10),
        width: size.width / 2,
        height: size.height / 2,
      ),
      paint,
    );

    // Legs
    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 4,
        size.height,
        size.width / 6,
        size.height / 3,
      ),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 2 + size.width / 6,
        size.height,
        size.width / 6,
        size.height / 3,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
