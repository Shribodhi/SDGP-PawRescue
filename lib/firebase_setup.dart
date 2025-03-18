import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseSetup {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Initialize user data collections when a user signs in
  Future<void> initializeUserData(User user) async {
    // Check if user document exists
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    
    if (!userDoc.exists) {
      // Create user document
      await _firestore.collection('users').doc(user.uid).set({
        'userId': user.uid,
        'username': user.displayName ?? 'User',
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } else {
      // Update last login time
      await _firestore.collection('users').doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }
  }
  
  // This method should be called when a user signs in
  Future<void> onUserSignIn(User user) async {
    await initializeUserData(user);
  }
  
  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return null;
    
    return userDoc.data();
  }
}

