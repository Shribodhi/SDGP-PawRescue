import 'package:flutter/material.dart';
import '../models/user_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  final Function(UserPreferences) onSave;

  const PreferencesScreen({super.key, required this.onSave});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String _selectedPetType = 'Dog';
  String _selectedHealthCondition = 'Healthy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pet Preferences',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFE0B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your Pet Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: DropdownButton<String>(
                value: _selectedPetType,
                isExpanded: true,
                underline: Container(),
                onChanged: (value) {
                  setState(() {
                    _selectedPetType = value!;
                  });
                },
                items: ['Dog', 'Cat', 'Bird']
                    .map((pet) => DropdownMenuItem(
                          value: pet,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(pet),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Select Health Condition',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: DropdownButton<String>(
                value: _selectedHealthCondition,
                isExpanded: true,
                underline: Container(),
                onChanged: (value) {
                  setState(() {
                    _selectedHealthCondition = value!;
                  });
                },
                items: ['Healthy', 'Sick', 'Obese']
                    .map((condition) => DropdownMenuItem(
                          value: condition,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(condition),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                widget.onSave(UserPreferences(
                    petType: _selectedPetType,
                    healthCondition: _selectedHealthCondition,
                    petAge: 'Adult'));

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Center(
                child: Text(
                  'Save Preferences',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
