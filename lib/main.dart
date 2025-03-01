import 'package:flutter/material.dart';
import 'screens/preferences_screen.dart'; // Import your screen

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
        onSave: (prefs) {}, // Dummy function to avoid errors
      ), // Directly start from Preferences Screen
    );
  }
}
