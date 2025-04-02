import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream to listen for auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String getUserInitials(User? user) {
    if (user == null || user.displayName == null || user.displayName!.isEmpty) {
      return 'U';
    }

    final nameParts = user.displayName!.split(' ');
    String initials = '';

    if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
      initials += nameParts[0][0];
      if (nameParts.length > 1 && nameParts[nameParts.length - 1].isNotEmpty) {
        initials += nameParts[nameParts.length - 1][0];
      }
    }

    return initials.toUpperCase();
  }
}
