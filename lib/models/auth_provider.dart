import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/firestore_service.dart';

/// Admin phone numbers — ONLY these phones can access the Admin Panel
const List<String> kAdminPhones = ['9878394950', '9878497680'];

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  String get displayName => _userData?['name'] ?? _user?.displayName ?? 'User';
  String get displayEmail => _userData?['email'] ?? _user?.email ?? '';
  String get displayPhone => _userData?['phone'] ?? '';
  bool get isAdmin => kAdminPhones.contains(displayPhone);

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _user = firebaseUser;
    if (_user != null) {
      FirebaseFirestore.instance.collection('users').doc(_user!.uid).snapshots().listen((doc) {
        if (doc.exists) {
          _userData = doc.data();
          notifyListeners();
        }
      });
    } else {
      _userData = null;
      notifyListeners();
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await _firestore.saveUser(
          uid: result.user!.uid,
          email: email,
          name: name,
          phone: phone,
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'This email is already registered. Please go to the Login page.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return 'Incorrect password. If you usually use Google, please click "Continue with Google".';
      }
      if (e.code == 'user-not-found') {
        return 'No account found with this email. Please Sign Up first.';
      }
      return e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return 'Google sign-in cancelled';

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      
      if (result.user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).get();
        if (!doc.exists) {
          await _firestore.saveUser(
            uid: result.user!.uid,
            email: result.user!.email ?? '',
            name: result.user!.displayName ?? 'Google User',
            phone: '', 
          );
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ IMPROVED RESET PASSWORD LOGIC
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      debugPrint('Attempting to send reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('Firebase accepted the request for: $email');
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found') {
        return 'This email is not registered. Please create an account first.';
      }
      return e.message;
    } catch (e) {
      debugPrint('General Error: $e');
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> updateProfile({String? name, String? phone, String? email}) async {
    if (_user == null) return;
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (phone != null) updates['phone'] = phone;
    if (email != null) updates['email'] = email;

    if (updates.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(_user!.uid).update(updates);
    }
  }
}
