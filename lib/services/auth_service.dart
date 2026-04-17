import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirestoreService();

  // =========================
  // ✅ EMAIL SIGNUP (FIXED)
  // =========================
  Future<User?> signUp(
      String email,
      String password,
      String name,
      String phone,
      ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        await firestore.saveUser(
          uid: user.uid,
          email: user.email ?? '',
          name: name,
          phone: phone,
        );
      }

      return user;
    } catch (e) {
      throw Exception("Signup Failed: $e");
    }
  }

  // =========================
  // ✅ EMAIL LOGIN
  // =========================
  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (e) {
      throw Exception("Login Failed: $e");
    }
  }

  // =========================
  // ✅ GOOGLE LOGIN (UPDATED)
  // =========================
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result =
      await _auth.signInWithCredential(credential);

      final user = result.user;

      if (user != null) {
        await firestore.saveUser(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          phone: user.phoneNumber ?? '',
        );
      }

      return user;
    } catch (e) {
      throw Exception("Google Login Failed: $e");
    }
  }

  // =========================
  // ✅ LOGOUT
  // =========================
  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}