import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Get posts stream
  Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  
  // Create a new post
  Future<void> createPost(String content, String type, File? mediaFile) async {
    // If auth isn't ready yet, use a temporary ID
    final userId = currentUserId ?? 'temp_user_${DateTime.now().millisecondsSinceEpoch}';
    
    // Upload media if provided
    String? mediaUrl;
    String? mediaType;
    
    if (mediaFile != null) {
      // Determine if it's an image or video based on extension
      final extension = path.extension(mediaFile.path).toLowerCase();
      mediaType = (extension == '.mp4' || extension == '.mov') ? 'video' : 'image';
      
      // Upload to Firebase Storage
      final storageRef = _storage.ref().child('post_media/${userId}_${DateTime.now().millisecondsSinceEpoch}$extension');
      await storageRef.putFile(mediaFile);
      mediaUrl = await storageRef.getDownloadURL();
    }
    
    // Create post document
    await _firestore.collection('posts').add({
      'content': content,
      'userId': userId,
      'username': 'User', // This will be updated when auth is ready
      'userImage': '',
      'mediaUrl': mediaUrl ?? '',
      'mediaType': mediaType ?? '',
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Toggle like on a post
  Future<void> toggleLike(String postId) async {
    // If auth isn't ready yet, use a temporary ID
    final userId = currentUserId ?? 'temp_user_${DateTime.now().millisecondsSinceEpoch}';
    
    final likeRef = _firestore.collection('posts').doc(postId).collection('likes').doc(userId);
    final likeDoc = await likeRef.get();
    
    if (likeDoc.exists) {
      // Unlike
      await likeRef.delete();
    } else {
      // Like
      await likeRef.set({
        'userId': userId,
        'username': 'User', // This will be updated when auth is ready
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
  
  // Check if user liked a post
  Future<bool> isPostLiked(String postId) async {
    final userId = currentUserId ?? 'temp_user';
    
    final likeDoc = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .get();
        
    return likeDoc.exists;
  }
  
  // Get likes count
  Future<int> getLikesCount(String postId) async {
    final likesSnapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get();
        
    return likesSnapshot.docs.length;
  }
  
  // Add comment to a post
  Future<void> addComment(String postId, String content) async {
    // If auth isn't ready yet, use a temporary ID
    final userId = currentUserId ?? 'temp_user_${DateTime.now().millisecondsSinceEpoch}';
    
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
          'content': content,
          'userId': userId,
          'username': 'User', // This will be updated when auth is ready
          'userImage': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
  }
  
  // Get comments for a post
  Stream<QuerySnapshot> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }
  
  // Delete a post
  Future<void> deletePost(String postId) async {
    final userId = currentUserId ?? 'temp_user';
    
    // Get the post to check if user is the author
    final postDoc = await _firestore.collection('posts').doc(postId).get();
    if (!postDoc.exists) return;
    
    final postData = postDoc.data() as Map<String, dynamic>;
    
    // Only allow deletion if it's the user's post or we're in development mode
    if (postData['userId'] == userId || userId.startsWith('temp_user')) {
      await _firestore.collection('posts').doc(postId).delete();
    }
  }
  
  // Format timestamp to readable time ago
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}


