import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterTrackerPage extends StatefulWidget {
  final String? initialTrackerModel;
  final String userId;

  

  const RegisterTrackerPage({
    super.key,
    this.initialTrackerModel,
    required this.userId
  });

  @override
  State<RegisterTrackerPage> createState() => _RegisterTrackerPageState();
}

class _RegisterTrackerPageState extends State<RegisterTrackerPage> {
  final _formKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  final _simNumberController = TextEditingController();
  String _selectedPetType = 'Dog';
  late String _selectedTrackerModel;

  @override
  void initState() {
    super.initState();
    _selectedTrackerModel = widget.initialTrackerModel ?? 'A9G';
  }

  Future<void> _registerTracker() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Generate a demo user ID since we're bypassing login
        final String demoUserId = widget.userId;

        final trackerData = {
          'petName': _petNameController.text,
          'simNumber': _simNumberController.text,
          'petType': _selectedPetType,
          'trackerModel': _selectedTrackerModel,
          'ownerId': demoUserId, // Using a demo user ID
          'createdAt': FieldValue.serverTimestamp(),
          'lastKnownLocation': {
            'latitude': 6.9271, // Default location (Colombo)
            'longitude': 79.8612,
            'timestamp': FieldValue.serverTimestamp(),
          },
        };

        // Add activity data if it's a smart tracker
        if (_selectedTrackerModel == 'A9G') {
          trackerData['activityData'] = {
            'heart_rate': 80, // Default heart rate
            'steps': 0,
            'timestamp': FieldValue.serverTimestamp(),
          };
        }

        await FirebaseFirestore.instance
            .collection('trackers')
            .doc(_simNumberController.text)
            .set(trackerData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tracker registered successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error registering tracker: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Pet Tracker'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Demo mode banner
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Demo Mode: No login required. Data will be saved to Firebase.',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              
              TextFormField(
                controller: _petNameController,
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pet name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _simNumberController,
                decoration: const InputDecoration(
                  labelText: 'Tracker SIM Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter SIM number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPetType,
                decoration: const InputDecoration(
                  labelText: 'Pet Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Dog', 'Cat', 'Other']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPetType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTrackerModel,
                decoration: const InputDecoration(
                  labelText: 'Tracker Model',
                  border: OutlineInputBorder(),
                ),
                items: ['A9G', 'Third Party']
                    .map((model) => DropdownMenuItem(
                          value: model,
                          child: Text(model == 'A9G' ? 'PR Smart Tracker (A9G)' : 'Third Party Tracker'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTrackerModel = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _registerTracker,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Register Tracker',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _petNameController.dispose();
    _simNumberController.dispose();
    super.dispose();
  }
}