import 'package:flutter/material.dart';
import 'tracker_selection_page.dart';

class PetTrackerPage extends StatelessWidget {
  final String userId;

  const PetTrackerPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Return a Scaffold with AppBar that includes a back button
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Tracker'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: TrackerSelectionPage(userId: userId),
    );
  }
}