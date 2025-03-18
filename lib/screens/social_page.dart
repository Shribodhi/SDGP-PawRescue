import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import 'post_service.dart';

class SocialPage extends StatefulWidget {
  final String? userId;
  
  const SocialPage({super.key, this.userId});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  String _currentFilter = 'All';
  final PostService _postService = PostService();
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;
  File? _selectedMedia;
  String? _mediaType;
  
  @override
  void initState() {
    super.initState();
    _loadPosts();
  }
  
  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
    });
    
    // Listen to posts stream from Firebase
    _postService.getPosts().listen((snapshot) {
      setState(() {
        _posts = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'username': data['username'] ?? 'Unknown User',
            'userImage': data['userImage'] ?? '',
            'timeAgo': _postService.getTimeAgo(
              data['createdAt'] != null 
                ? (data['createdAt'] as Timestamp).toDate() 
                : DateTime.now()
            ),
            'content': data['content'] ?? '',
            'image': data['mediaType'] == 'image' ? data['mediaUrl'] : null,
            'video': data['mediaType'] == 'video' ? data['mediaUrl'] : null,
            'likes': 0, // Will be updated with getLikesCount
            'comments': 0, // Will be updated with getCommentsCount
            'isLiked': false, // Will be updated with isPostLiked
            'type': data['type'] ?? 'normal',
            'userId': data['userId'] ?? '',
          };
        }).toList();
        
        // Update likes and comments count for each post
        _updatePostsMetadata();
        _isLoading = false;
      });
    });
  }
  
  Future<void> _updatePostsMetadata() async {
    for (var post in _posts) {
      final postId = post['id'];
      
      // Get likes count
      _postService.getLikesCount(postId).then((count) {
        if (mounted) {
          setState(() {
            post['likes'] = count;
          });
        }
      });
      
      // Check if current user liked the post
      _postService.isPostLiked(postId).then((isLiked) {
        if (mounted) {
          setState(() {
            post['isLiked'] = isLiked;
          });
        }
      });
      
      // Get comments count
      _postService.getCommentsCount(postId).then((count) {
        if (mounted) {
          setState(() {
            post['comments'] = count;
          });
        }
      });
    }
  }
  
  Future<void> _pickMedia(ImageSource source, String type) async {
    final ImagePicker picker = ImagePicker();
    
    try {
      if (type == 'image') {
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _selectedMedia = File(image.path);
            _mediaType = 'image';
          });
        }
      } else if (type == 'video') {
        final XFile? video = await picker.pickVideo(source: source);
        if (video != null) {
          setState(() {
            _selectedMedia = File(video.path);
            _mediaType = 'video';
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking media: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
        backgroundColor: const Color(0xFF219EBC),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterButtons(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    color: const Color(0xFF219EBC),
                    onRefresh: () async {
                      await _loadPosts();
                    },
                    child: _posts.isEmpty
                        ? const Center(child: Text('No posts yet. Be the first to post!'))
                        : ListView.builder(
                            itemCount: _posts.length,
                            itemBuilder: (context, index) {
                              final post = _posts[index];
                              if (_currentFilter == 'All' ||
                                  (_currentFilter == 'Photos' && post['image'] != null) ||
                                  (_currentFilter == 'Videos' && post['video'] != null)) {
                                return _buildPostCard(post);
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostModal(context);
        },
        backgroundColor: const Color(0xFF219EBC),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index != 0) {
            Navigator.pop(context);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF023047),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'My Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Build a post card widget
  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header with user info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: post['userImage'] != null && post['userImage'].isNotEmpty
                      ? NetworkImage(post['userImage'])
                      : null,
                  child: post['userImage'] == null || post['userImage'].isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        post['timeAgo'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Lost & Found badge
                if (post['type'] == 'lost_found')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Lost & Found',
                      style: TextStyle(
                        color: Colors.red[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    _showPostOptions(context, post);
                  },
                ),
              ],
            ),
          ),

          // Post content text
          if (post['content'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                post['content'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: post['type'] == 'lost_found' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),

          // Post media (image or video)
          if (post['image'] != null)
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: post['image'].toString().startsWith('http')
                  ? Image.network(
                      post['image'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(
                        Icons.image,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                    ),
            )
          else if (post['video'] != null)
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.play_circle_filled,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),

          const Divider(),

          // Post actions (like, comment, share)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  icon: post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  label: '${post['likes']}',
                  color: post['isLiked'] ? Colors.red : null,
                  onTap: () async {
                    await _postService.toggleLike(post['id']);
                    // Update UI after toggling like
                    final isLiked = await _postService.isPostLiked(post['id']);
                    final likesCount = await _postService.getLikesCount(post['id']);
                    
                    setState(() {
                      post['isLiked'] = isLiked;
                      post['likes'] = likesCount;
                    });
                  },
                ),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: '${post['comments']}',
                  onTap: () {
                    _showComments(context, post);
                  },
                ),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sharing post...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(),
        ],
      ),
    );
  }

  // Helper to build action buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color ?? Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show post options menu
  void _showPostOptions(BuildContext context, Map<String, dynamic> post) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isCurrentUserPost = currentUser != null && post['userId'] == currentUser.uid;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share Post'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              if (isCurrentUserPost)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Delete Post', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _postService.deletePost(post['id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post deleted'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // Show comments modal
  void _showComments(BuildContext context, Map<String, dynamic> post) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  // Comments header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Comments list
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _postService.getComments(post['id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No comments yet. Be the first to comment!'));
                        }
                        
                        return ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final commentDoc = snapshot.data!.docs[index];
                            final commentData = commentDoc.data() as Map<String, dynamic>;
                            
                            final timestamp = commentData['createdAt'] as Timestamp?;
                            final createdAt = timestamp?.toDate() ?? DateTime.now();
                            final timeAgo = _postService.getTimeAgo(createdAt);
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: commentData['userImage'] != null && 
                                                    commentData['userImage'].toString().isNotEmpty
                                        ? NetworkImage(commentData['userImage'])
                                        : null,
                                    child: commentData['userImage'] == null || 
                                           commentData['userImage'].toString().isEmpty
                                        ? const Icon(Icons.person, color: Colors.white, size: 20)
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              commentData['username'] ?? 'Unknown User',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              timeAgo,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          commentData['content'] ?? '',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: const Text(
                                                'Like',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            InkWell(
                                              onTap: () {},
                                              child: const Text(
                                                'Reply',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Comment input field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.send, color: Color(0xFF219EBC)),
                          onPressed: () async {
                            if (commentController.text.isNotEmpty) {
                              await _postService.addComment(post['id'], commentController.text);
                              commentController.clear();
                              
                              // Update comments count
                              final commentsCount = await _postService.getCommentsCount(post['id']);
                              setState(() {
                                post['comments'] = commentsCount;
                              });
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Comment added'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Show create post modal
  void _showCreatePostModal(BuildContext context) {
    final contentController = TextEditingController();
    String postType = 'normal';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  // Modal header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Create Post',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  // User info and post type selection
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[300],
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Text(
                                  'Public',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        // Post type toggle buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    postType = 'normal';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: postType == 'normal' ? const Color(0xFF219EBC) : Colors.grey[300],
                                  foregroundColor: postType == 'normal' ? Colors.white : Colors.black,
                                ),
                                child: const Text('Normal Post'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    postType = 'lost_found';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: postType == 'lost_found' ? Colors.red : Colors.grey[300],
                                  foregroundColor: postType == 'lost_found' ? Colors.white : Colors.black,
                                ),
                                child: const Text('Lost & Found'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Post content input
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: contentController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: postType == 'normal'
                              ? 'What\'s on your mind?'
                              : 'Describe the lost/found pet...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  // Media picker area
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.photo_camera),
                                title: const Text('Take a Photo'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickMedia(ImageSource.camera, 'image');
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Choose from Gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickMedia(ImageSource.gallery, 'image');
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.videocam),
                                title: const Text('Record a Video'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickMedia(ImageSource.camera, 'video');
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.video_library),
                                title: const Text('Choose Video from Gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickMedia(ImageSource.gallery, 'video');
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _selectedMedia != null
                          ? _mediaType == 'image'
                              ? Image.file(_selectedMedia!, fit: BoxFit.cover)
                              : const Center(
                                  child: Icon(
                                    Icons.play_circle_filled,
                                    size: 50,
                                    color: Color(0xFF219EBC),
                                  ),
                                )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Add Photo or Video',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  // Post button
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF219EBC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (contentController.text.isNotEmpty) {
                            try {
                              await _postService.createPost(
                                contentController.text,
                                postType,
                                _selectedMedia,
                              );
                              
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(postType == 'normal' 
                                      ? 'Post created successfully' 
                                      : 'Lost & Found post created'),
                                  backgroundColor: const Color(0xFF219EBC),
                                ),
                              );
                              
                              // Reset selected media
                              setState(() {
                                _selectedMedia = null;
                                _mediaType = null;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error creating post: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please add some content to your post'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text(
                          postType == 'normal' ? 'Post' : 'Post Lost & Found',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Filter buttons for content type
  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterButton('All'),
          _buildFilterButton('Photos'),
          _buildFilterButton('Videos'),
        ],
      ),
    );
  }

  // Individual filter button
  Widget _buildFilterButton(String filter) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentFilter == filter ? const Color(0xFF219EBC) : Colors.grey[300],
        foregroundColor: _currentFilter == filter ? Colors.white : Colors.black,
      ),
      child: Text(filter),
    );
  }
}






















