import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../database/auth_service_register.dart'; 
import '../widgets/person_painter.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Instance of AuthService

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (name.isEmpty) {
      _showSnackBar('Please enter your name.');
      return;
    }

    if (email.isEmpty || !EmailValidator.validate(email)) {
      _showSnackBar('Please enter a valid email address.');
      return;
    }

    if (password.isEmpty || password.length < 8 || password.length > 20) {
      _showSnackBar('Password must be between 8 and 20 characters.');
      return;
    }

    try {
      await _authService.registerUser(name, email, password); // Use AuthService method
      _showSnackBar('Registration successful!');
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar(_authService.handleAuthErrors(e)); // Use AuthService error handling
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                    'Register',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please fill your details below",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: _buildRegisterIllustration(),
                  ),
                  const SizedBox(height: 10),
                  _buildFormField(
                    label: 'Your Name',
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                  ),
                  _buildFormField(
                    label: 'Email Address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildFormField(
                    label: 'Password',
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _registerUser, // Call the register function
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D4059),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Register', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an Account?", style: TextStyle(fontSize: 14)),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Login', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: '', contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), suffixIcon: suffix),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildRegisterIllustration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 6, width: 70, margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(3))),
                    Container(height: 6, width: 60, margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(3))),
                    Container(height: 6, width: 70, decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(3))),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.blue, size: 20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        CustomPaint(size: const Size(40, 120), painter: PersonPainter(color: Colors.blue[900]!)),
      ],
    );
  }
}

// TODO: 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss.
    // helen@g.com
    // HHelon@123
