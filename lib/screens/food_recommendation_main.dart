import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import 'preferences_screen.dart';

class FoodRecommendationMain extends StatelessWidget {
  const FoodRecommendationMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Food Recommendations'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pet icon
              Icon(
                Icons.pets,
                size: 80,
                color: Colors.blue.shade300,
              ),
              const SizedBox(height: 30),
              
              // Title
              Text(
                'Find the Perfect Food for Your Pet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              // Description
              Text(
                'Our AI-powered recommendation system will help you choose the best food based on your pet\'s needs.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Start button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreferencesScreen(
                          onSave: (UserPreferences preferences) {
                            // This callback will be called when preferences are saved
                            print('Preferences saved: ${preferences.petType}');
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Start Recommendation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Features list
              ...['Personalized Recommendations', 'Based on Pet\'s Needs', 'Health-Focused Options']
                  .map((feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 10),
                            Text(
                              feature,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}