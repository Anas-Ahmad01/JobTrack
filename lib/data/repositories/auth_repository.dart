import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_profile.dart';

class AuthRepository {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepository(this._authService, this._firestoreService);

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  String? get currentUserId => _authService.currentUserId;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.register(email, password);
      final uid = credential.user!.uid;

      final profile = UserProfile(
        uid: uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      await _firestoreService.createUserProfile(profile);
    } on FirebaseAuthException catch (e) {
      throw Exception(_authService.getErrorMessage(e));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _authService.login(email, password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_authService.getErrorMessage(e));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_authService.getErrorMessage(e));
    }
  }
}