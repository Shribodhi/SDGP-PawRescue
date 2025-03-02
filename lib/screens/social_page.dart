import 'package:flutter/material.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  String _currentFilter = 'All';
  final List<Map<String, dynamic>> _posts = [
    {
      'id': 1,
      'username': 'Emma Johnson',
      'userImage': 'assets/images/user1.png',
      'timeAgo': '2 hours ago',
      'content': 'Just adopted this beautiful puppy! Meet Max, my new family member. He\'s a 3-month-old Golden Retriever and already loves playing fetch!',
      'image': 'assets/images/post_dog1.png',
      'video': null,
      'likes': 42,
      'comments': 8,
      'reactions': {
        'love': 20,
        'wow': 15,
        'laugh': 5,
        'sad': 0,
        'angry': 0,
      },
      'isLiked': false,
    },
    {
      'id': 2,
      'username': 'Michael Smith',
      'userImage': 'assets/images/user2.png',
      'timeAgo': '5 hours ago',
      'content': 'Luna enjoying her new cat tree! Best purchase ever. She hasn\'t stopped climbing since we set it up this morning.',
      'image': 'assets/images/post_cat1.png',
      'video': null,
      'likes': 28,
      'comments': 5,
      'reactions': {
        'love': 15,
        'wow': 8,
        'laugh': 3,
        'sad': 0,
        'angry': 0,
      },
      'isLiked': false,
    },
    {
      'id': 3,
      'username': 'Sophia Williams',
      'userImage': 'assets/images/user3.png',
      'timeAgo': '1 day ago',
      'content': 'First visit to the vet went well! Rocky is healthy and happy. The vet said he\'s growing perfectly and his vaccinations are up to date.',
      'image': 'assets/images/post_dog2.png',
      'video': null,
      'likes': 56,
      'comments': 12,
      'reactions': {
        'love': 30,
        'wow': 18,
        'laugh': 5,
        'sad': 0,
        'angry': 0,
      },
      'isLiked': false,
    },
    {
      'id': 4,
      'username': 'James Brown',
      'userImage': 'assets/images/user4.png',
      'timeAgo': '2 days ago',
      'content': 'Mittens and her new toy! She\'s been playing with it non-stop. Any recommendations for other toys that cats love?',
      'image': 'assets/images/post_cat2.png',
      'video': null,
      'likes': 35,
      'comments': 15,
      'reactions': {
        'love': 18,
        'wow': 10,
        'laugh': 5,
        'sad': 0,
        'angry': 0,
      },
      'isLiked': false,
    },
    {
      'id': 5,
      'username': 'Alex Thompson',
      'userImage': 'assets/images/user5.png',
      'timeAgo': '3 days ago',
      'content': 'Check out this cute video of my cat playing with a new toy!',
      'image': null,
      'video': 'assets/videos/cat_playing.mp4',
      'likes': 62,
      'comments': 18,
      'reactions': {
        'love': 25,
        'wow': 12,
        'laugh': 20,
        'sad': 0,
        'angry': 0,
      },
      'isLiked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildFilterButtons(),
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF219EBC),
              onRefresh: () async {
                // Simulate refresh
                await Future.delayed(const Duration(seconds: 1));
                setState(() {});
              },
              child: ListView.builder(
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
    );
  }

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
          // Post header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.white),
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
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    _showPostOptions(context, post);
                  },
                ),
              ],
            ),
          ),

          // Post content
          if (post['content'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                post['content'],
                style: const TextStyle(fontSize: 14),
              ),
            ),

          // Post media (image or video)
          if (post['image'] != null)
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 80,
                  color: Colors.white,
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

          // Reactions
          _buildReactionsBar(post),

          const Divider(),

          // Post actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  icon: post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  label: '${post['likes']}',
                  color: post['isLiked'] ? Colors.red : null,
                  onTap: () {
                    setState(() {
                      post['isLiked'] = !post['isLiked'];
                      post['likes'] += post['isLiked'] ? 1 : -1;
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

  void _showPostOptions(BuildContext context, Map<String, dynamic> post) {
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
              if (post['username'] == 'Emma Johnson') // Assuming this is the current user
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Delete Post', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _posts.removeWhere((p) => p['id'] == post['id']);
                    });
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

  void _showComments(BuildContext context, Map<String, dynamic> post) {
    final commentController = TextEditingController();

    // Sample comments
    final List<Map<String, dynamic>> comments = [
      {
        'username': 'Sarah Parker',
        'comment': 'So adorable! What breed is he?',
        'timeAgo': '1 hour ago',
      },
      {
        'username': 'John Davis',
        'comment': 'Congratulations on your new family member!',
        'timeAgo': '45 minutes ago',
      },
      {
        'username': 'Lisa Wilson',
        'comment': 'He looks so happy! 😍',
        'timeAgo': '30 minutes ago',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              // Header
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
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(Icons.person, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment['username'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      comment['timeAgo'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment['comment'],
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
                ),
              ),

              // Comment input
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
                      onPressed: () {
                        if (commentController.text.isNotEmpty) {
                          // Add comment logic
                          setState(() {
                            post['comments']++;
                          });
                          Navigator.pop(context);
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
  }

  void _showCreatePostModal(BuildContext context) {
    final contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              // Header
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

              // User info
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emma Johnson',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
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
              ),

              // Post content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: contentController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind?',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // Image placeholder
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add Photo',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
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
                    onPressed: () {
                      if (contentController.text.isNotEmpty) {
                        setState(() {
                          _posts.insert(0, {
                            'id': _posts.length + 1,
                            'username': 'Emma Johnson',
                            'userImage': 'assets/images/user1.png',
                            'timeAgo': 'Just now',
                            'content': contentController.text,
                            'image': '',
                            'video': null,
                            'likes': 0,
                            'comments': 0,
                            'reactions': {
                              'love': 0,
                              'wow': 0,
                              'laugh': 0,
                              'sad': 0,
                              'angry': 0,
                            },
                            'isLiked': false,
                          });
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Post created successfully'),
                            backgroundColor: Color(0xFF219EBC),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please add some content to your post'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Post',
                      style: TextStyle(
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
  }

  Widget _buildReactionsBar(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildReactionButton(post, 'love', '❤️'),
          _buildReactionButton(post, 'wow', '😮'),
          _buildReactionButton(post, 'laugh', '😂'),
          _buildReactionButton(post, 'sad', '😢'),
          _buildReactionButton(post, 'angry', '😠'),
        ],
      ),
    );
  }

  Widget _buildReactionButton(Map<String, dynamic> post, String reaction, String emoji) {
    return InkWell(
      onTap: () {
        setState(() {
          post['reactions'][reaction]++;
        });
      },
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            '${post['reactions'][reaction]}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

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






