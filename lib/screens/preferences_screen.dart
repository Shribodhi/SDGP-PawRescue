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
  String _selectedPetAge = 'Young';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Preferences'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedPetType,
              onChanged: (value) {
                setState(() {
                  _selectedPetType = value!;
                });
              },
              items: ['Dog', 'Cat', 'Bird']
                  .map((pet) => DropdownMenuItem(
                        value: pet,
                        child: Text(pet),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedHealthCondition,
              onChanged: (value) {
                setState(() {
                  _selectedHealthCondition = value!;
                });
              },
              items: ['Healthy', 'Sick', 'Obese']
                  .map((condition) => DropdownMenuItem(
                        value: condition,
                        child: Text(condition),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedPetAge,
              onChanged: (value) {
                setState(() {
                  _selectedPetAge = value!;
                });
              },
              items: ['Young', 'Adult', 'Senior']
                  .map((age) => DropdownMenuItem(
                        value: age,
                        child: Text(age),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                widget.onSave(UserPreferences(
                    petType: _selectedPetType,
                    petAge: _selectedPetAge,
                    healthCondition: _selectedHealthCondition));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
