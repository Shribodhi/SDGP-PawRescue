import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sdgp_pawrescue/pet_social/post_detail_screen.dart';

class PostCard extends StatelessWidget {
  final QueryDocumentSnapshot post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final postData = post.data() as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(postData['userPhotoUrl'] ?? ''),
            ),
            title: Text(postData['userName'] ?? 'Unknown User'),
            subtitle: Text(postData['timestamp'].toDate().toString()),
          ),
          Image.network(
            postData['imageUrl'],
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(postData['caption']),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  postData['likes'].contains(user?.uid)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () => _toggleLike(post.id, user?.uid),
              ),
              Text('${postData['likes'].length} likes'),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(post: post),
                    ),
                  );
                },
              ),
              Text('${postData['comments'].length} comments'),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleLike(String postId, String? userId) {
    if (userId == null) return;

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      final postSnapshot = await transaction.get(postRef);
      
      if (!postSnapshot.exists) {
        throw Exception('Post does not exist!');
      }

      final likes = List<String>.from(postSnapshot.get('likes') as List<dynamic>);

      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }

      transaction.update(postRef, {'likes': likes});
    });
  }
}