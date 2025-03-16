import 'package:flutter/material.dart';
import 'screens/preferences_screen.dart';
import 'models/user_preferences.dart';
import 'screens/food_recommendation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: PreferencesScreen(
        onSave: (UserPreferences preferences) {
          // This will be handled in the PreferencesScreen itself
          print('Preferences saved: ${preferences.petType}');
        },
      ),
    );
  }
}
