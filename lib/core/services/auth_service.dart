import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/core/services/firebase_service.dart';
import 'package:myapp/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = FirebaseService();

  // Stream for auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Helper method to handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email or try logging in.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email. Please check your email or register for a new account.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      default:
        return e.message ??
            'An authentication error occurred. Please try again.';
    }
  }

  // Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validate password strength
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Validate inputs
      if (!_isValidEmail(email)) {
        throw Exception('Please enter a valid email address');
      }
      if (!_isValidPassword(password)) {
        throw Exception('Password must be at least 6 characters');
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Check if user profile exists in Firestore
      try {
        final userModel = await _firebaseService.getUserProfile(
          userCredential.user!.uid,
        );
        if (userModel == null) {
          // If profile doesn't exist, create a default one
          final newUserModel = UserModel(
            id: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? email.split('@')[0],
            email: userCredential.user!.email ?? email,
            phone: userCredential.user!.phoneNumber ?? '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _firebaseService.saveUserProfile(newUserModel);
        }
      } catch (firestoreError) {
        // Handle Firestore permission errors gracefully
        if (firestoreError.toString().contains('permission-denied')) {
          print(
            'Warning: Could not access user profile due to permission restrictions. User is signed in but profile data may not be available.',
          );
        } else {
          // Re-throw other Firestore errors
          rethrow;
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      throw Exception(_handleAuthException(e));
    } catch (e) {
      print('Sign In Error: $e');
      throw Exception('An error occurred during sign in: $e');
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      // Validate inputs
      if (name.isEmpty) {
        throw Exception('Please enter your name');
      }
      if (!_isValidEmail(email)) {
        throw Exception('Please enter a valid email address');
      }
      if (!_isValidPassword(password)) {
        throw Exception('Password must be at least 6 characters');
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update the user's display name in Firebase Auth
      await userCredential.user?.updateDisplayName(name);

      // Create user profile in Firestore
      final userModel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email.trim(),
        phone: phone,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firebaseService.saveUserProfile(userModel);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      throw Exception(_handleAuthException(e));
    } catch (e) {
      print('Registration Error: $e');
      throw Exception('An error occurred during registration: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      if (!_isValidEmail(email)) {
        throw Exception('Please enter a valid email address');
      }

      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      throw Exception(_handleAuthException(e));
    } catch (e) {
      print('Reset Password Error: $e');
      throw Exception('An error occurred while resetting password: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
      throw Exception('An error occurred while signing out: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      // Validate inputs
      if (name.isEmpty) {
        throw Exception('Please enter your name');
      }

      // Update display name in Firebase Auth
      await user.updateDisplayName(name);

      // Get existing user model
      final userModel = await _firebaseService.getUserProfile(user.uid);
      if (userModel == null) {
        throw Exception('User profile not found');
      }

      // Update user model
      final updatedUserModel = userModel.copyWith(
        name: name,
        phone: phone,
        updatedAt: DateTime.now(),
      );

      // Save updated user model
      await _firebaseService.saveUserProfile(updatedUserModel);
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      throw Exception(_handleAuthException(e));
    } catch (e) {
      print('Update Profile Error: $e');
      throw Exception('An error occurred while updating profile: $e');
    }
  }
}
