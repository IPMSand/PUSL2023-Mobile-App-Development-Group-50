
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

    String handleAuthErrors(dynamic e) {
    String errorMessage = 'Login failed.';
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for the email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled.';
          break;
        default:
          errorMessage = 'Error please try agian: ${e.message}';
      }
    } else {
      errorMessage = 'Error please try agian: $e';
    }
    return errorMessage;
  }
}