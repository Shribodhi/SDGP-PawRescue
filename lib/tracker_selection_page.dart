import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pet_location_page.dart';
import 'register_tracker.dart';

class TrackerSelectionPage extends StatefulWidget {
  const TrackerSelectionPage({super.key});

  @override
  State<TrackerSelectionPage> createState() => _TrackerSelectionPageState();
}

class _TrackerSelectionPageState extends State<TrackerSelectionPage> {
  bool _isLoading = true;
  List<QueryDocumentSnapshot> _a9gTrackers = [];
  List<QueryDocumentSnapshot> _thirdPartyTrackers = [];

  @override
  void initState() {
    super.initState();
    _loadTrackers();
  }

  Future<void> _loadTrackers() async {
    setState(() {
      _isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('trackers')
          .where('ownerId', isEqualTo: user.uid)
          .get();

      setState(() {
        _a9gTrackers = snapshot.docs
            .where((doc) => (doc.data())['trackerModel'] == 'A9G')
            .toList();
        _thirdPartyTrackers = snapshot.docs
            .where((doc) => (doc.data())['trackerModel'] == 'Third Party')
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading trackers: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Tracker'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Tracker Type',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTrackerTypeCard(
                    title: 'PR Smart Tracker (A9G)',
                    description: 'Advanced tracking with activity monitoring',
                    icon: Icons.pets,
                    color: Colors.orange,
                    trackers: _a9gTrackers,
                    isSmartTracker: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTrackerTypeCard(
                    title: 'Third Party Tracker',
                    description: 'Basic location tracking',
                    icon: Icons.location_on,
                    color: Colors.blue,
                    trackers: _thirdPartyTrackers,
                    isSmartTracker: false,
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterTrackerPage()),
          ).then((_) => _loadTrackers());
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTrackerTypeCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<QueryDocumentSnapshot> trackers,
    required bool isSmartTracker,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 24,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (trackers.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No ${isSmartTracker ? 'PR Smart' : 'Third Party'} trackers registered',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: trackers.length,
                itemBuilder: (context, index) {
                  final tracker = trackers[index];
                  final data = tracker.data() as Map<String, dynamic>;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Text(
                        data['petName'].toString()[0].toUpperCase(),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(data['petName'] as String),
                    subtitle: Text('${data['petType']} • ${data['simNumber']}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetLocationPage(
                            trackerId: tracker.id,
                            isSmartTracker: isSmartTracker,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterTrackerPage(
                        initialTrackerModel: isSmartTracker ? 'A9G' : 'Third Party',
                      ),
                    ),
                  ).then((_) => _loadTrackers());
                },
                icon: const Icon(Icons.add),
                label: Text('Add ${isSmartTracker ? 'PR Smart' : 'Third Party'} Tracker'),
                style: TextButton.styleFrom(
                  foregroundColor: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}