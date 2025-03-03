import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterTrackerPage extends StatefulWidget {
  const RegisterTrackerPage({super.key});

  @override
  State<RegisterTrackerPage> createState() => _RegisterTrackerPageState();
}

class _RegisterTrackerPageState extends State<RegisterTrackerPage> {
  final _formKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  final _simNumberController = TextEditingController();
  String _selectedPetType = 'Dog';
  String _selectedTrackerModel = 'A9G';

  Future<void> _registerTracker() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login to register a tracker')),
          );
          return;
        }

        await FirebaseFirestore.instance
            .collection('trackers')
            .doc(_simNumberController.text)
            .set({
          'petName': _petNameController.text,
          'simNumber': _simNumberController.text,
          'petType': _selectedPetType,
          'trackerModel': _selectedTrackerModel,
          'ownerId': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'lastKnownLocation': {
            'latitude': 0.0,
            'longitude': 0.0,
            'timestamp': FieldValue.serverTimestamp(),
          },
        });

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
                          child: Text(model),
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