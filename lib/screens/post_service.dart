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
    // Get current user
    final user = _auth.currentUser;
    
    // If auth isn't ready yet, use a temporary ID
    final userId = user?.uid ?? 'temp_user_${DateTime.now().millisecondsSinceEpoch}';
    final username = user?.displayName ?? 'User';
    final userImage = user?.photoURL ?? '';
    
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
      'username': username,
      'userImage': userImage,
      'mediaUrl': mediaUrl ?? '',
      'mediaType': mediaType ?? '',
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Toggle like on a post
  Future<void> toggleLike(String postId) async {
    try {
      // Get current user
      final user = _auth.currentUser;
      
      // If auth isn't ready yet, use a temporary ID
      final userId = user?.uid ?? 'temp_user_${DateTime.now().millisecondsSinceEpoch}';
      final username = user?.displayName ?? 'User';
      
      final likeRef = _firestore.collection('posts').doc(postId).collection('likes').doc(userId);
      final likeDoc = await likeRef.get();
      
      if (likeDoc.exists) {
        // Unlike
        await likeRef.delete();
      } else {
        // Like
        await likeRef.set({
          'userId': userId,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error toggling like: $e');
      // Silently fail - don't throw the error to the UI
    }
  }
  
  // Check if user liked a post
  Future<bool> isPostLiked(String postId) async {
    try {
      final userId = currentUserId ?? 'temp_user';
      
      final likeDoc = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId)
          .get();
          
      return likeDoc.exists;
    } catch (e) {
      print('Error checking if post is liked: $e');
      return false; // Default to not liked if there's an error
    }
  }
  
  // Get likes count
  Future<int> getLikesCount(String postId) async {
    try {
      final likesSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .get();
          
      return likesSnapshot.docs.length;
    } catch (e) {
      print('Error getting likes count: $e');
      return 0; // Return 0 likes if there's an error
    }
  }
  
  // Add comment to a post
  Future<void> addComment(String postId, String content) async {
    try {
      // Get current user
      final user = _auth.currentUser;
      
      // If auth isn't ready yet, use a temporary ID
      final userId = user?.uid ?? 'temp_user_${DateTime.now().millisecondsSinceEpoch}';
      final username = user?.displayName ?? 'User';
      final userImage = user?.photoURL ?? '';
      
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
            'content': content,
            'userId': userId,
            'username': username,
            'userImage': userImage,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error adding comment: $e');
      throw e; // Re-throw to let the UI know there was an error
    }
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
  
  // Get comments count
  Future<int> getCommentsCount(String postId) async {
    try {
      final commentsSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();
          
      return commentsSnapshot.docs.length;
    } catch (e) {
      print('Error getting comments count: $e');
      return 0; // Return 0 comments if there's an error
    }
  }
  
  // Delete a post - improved version
  Future<bool> deletePost(String postId) async {
    try {
      // Get the post document
      final postDoc = await _firestore.collection('posts').doc(postId).get();
      
      if (!postDoc.exists) {
        print('Post does not exist');
        return false;
      }
      
      // Get post data
      final postData = postDoc.data() as Map<String, dynamic>;
      
      // Delete the post document first
      await _firestore.collection('posts').doc(postId).delete();
      print('Post document deleted successfully');
      
      // Try to delete media if it exists
      if (postData['mediaUrl'] != null && postData['mediaUrl'].toString().isNotEmpty) {
        try {
          final storageRef = FirebaseStorage.instance.refFromURL(postData['mediaUrl']);
          await storageRef.delete();
          print('Post media deleted successfully');
        } catch (e) {
          print('Warning: Could not delete media: $e');
          // Continue even if media deletion fails
        }
      }
      
      return true;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
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
  
  // Create user document if it doesn't exist
  Future<void> createUserIfNotExists() async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    
    if (!userDoc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'userId': user.uid,
        'username': user.displayName ?? 'User',
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}






