import 'package:flutter/material.dart';
import '../models/user_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  final Function(UserPreferences) onSave;

  const PreferencesScreen({super.key, required this.onSave});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String selectedAnimalType = 'Dog';
  String selectedDietType = 'Vegetarian';
  String selectedHealthCondition = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Food Preferences'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: selectedAnimalType,
              items: ['Dog', 'Cat', 'Bird']
                  .map((animal) => DropdownMenuItem(
                        value: animal,
                        child: Text(animal),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedAnimalType = value!;
                });
              },
              decoration:
                  const InputDecoration(labelText: 'Select Animal Type'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              value: selectedDietType,
              items: ['Vegetarian', 'Non-Vegetarian', 'Mixed']
                  .map((diet) => DropdownMenuItem(
                        value: diet,
                        child: Text(diet),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDietType = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Select Diet Type'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              value: selectedHealthCondition,
              items: ['None', 'Diabetes', 'Obesity']
                  .map((condition) => DropdownMenuItem(
                        value: condition,
                        child: Text(condition),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedHealthCondition = value!;
                });
              },
              decoration:
                  const InputDecoration(labelText: 'Select Health Condition'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                widget.onSave(UserPreferences(
                  animalType: selectedAnimalType,
                  dietType: selectedDietType,
                  healthCondition: selectedHealthCondition,
                ));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
