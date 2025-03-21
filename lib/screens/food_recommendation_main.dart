import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../utils/theme_constants.dart';
import 'preferences_screen.dart';

class FoodRecommendationMain extends StatelessWidget {
  const FoodRecommendationMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Food Recommendations'),
        // Theme is now handled by the global theme
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryLightColor.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pet icon with animation effect
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLightColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.pets,
                    size: 70,
                    color: AppTheme.primaryDarkColor,
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                Text(
                  'Find the Perfect Food for Your Pet',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                    shadows: [
                      Shadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Description
                Text(
                  'Our AI-powered recommendation system will help you choose the best food based on your pet\'s needs.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textLightColor,
                    height: 1.5,
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
                              print(
                                  'Preferences saved: ${preferences.petType}');
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Start Recommendation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Features list with improved styling
                ...[
                  'Personalized Recommendations',
                  'Based on Pet\'s Needs',
                  'Health-Focused Options'
                ]
                    .map((feature) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: AppTheme.successColor),
                                const SizedBox(width: 12),
                                Text(
                                  feature,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
