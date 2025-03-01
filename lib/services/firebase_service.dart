import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    await _db.collection("preferences").add(preferences);
  }

  Stream<QuerySnapshot> getFoodRecommendations() {
    return _db.collection("recommendations").snapshots();
  }
}
