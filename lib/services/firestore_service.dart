import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ Save user data
  Future<void> saveUser({
    required String uid,
    required String email,
    required String name,
    required String phone,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'phone': phone,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}