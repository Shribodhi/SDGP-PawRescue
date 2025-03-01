import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/user_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  final Function(UserPreferences) onSave;

  const PreferencesScreen({super.key, required this.onSave});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  // Basic preferences
  String _selectedPetType = 'Dog';
  String _selectedHealthCondition = 'Healthy';
  String _selectedPetAge = 'Adult';
  String _selectedWeightRange = 'Medium (10-25kg)';
  String _selectedActivityLevel = 'Medium';

  // Multi-select options
  final List<String> _availableAllergies = [
    'Chicken',
    'Beef',
    'Grain',
    'Dairy',
    'Fish'
  ];
  final List<String> _selectedAllergies = [];

  final List<String> _dietaryOptions = [
    'Grain-Free',
    'Organic',
    'Vegan',
    'Raw',
    'High-Protein'
  ];
  final List<String> _selectedDietaryPreferences = [];

  // Toggle options
  bool _includeTreats = true;
  bool _budgetFriendly = false;

  // Slider value
  double _portionSize = 2.0;

  // Colors
  final Color primaryColor = Colors.orange;
  final Color secondaryColor = const Color(0xFFFFE0B2);
  final Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Select Pet Type',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade800,
              Colors.orange.shade500,
              Colors.orange.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: ListView(
              children: [
                const SizedBox(height: 10),

                // Pet Type Selection
                _buildGlassyDropdown(
                  label: 'Select Pet',
                  value: _selectedPetType,
                  items: ['Dog', 'Cat', 'Bird', 'Rabbit', 'Hamster'],
                  onChanged: (value) =>
                      setState(() => _selectedPetType = value!),
                  icon: _getPetIcon(_selectedPetType),
                ),

                const SizedBox(height: 16),

                // Health Condition Dropdown
                _buildGlassyDropdown(
                  label: 'Health Condition',
                  value: _selectedHealthCondition,
                  items: [
                    'Healthy',
                    'Overweight',
                    'Underweight',
                    'Sensitive Stomach',
                    'Joint Issues'
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedHealthCondition = value!),
                  icon: _getHealthIcon(_selectedHealthCondition),
                ),

                const SizedBox(height: 16),

                // Pet Age Dropdown
                _buildGlassyDropdown(
                  label: 'Pet Age',
                  value: _selectedPetAge,
                  items: ['Puppy/Kitten', 'Young', 'Adult', 'Senior'],
                  onChanged: (value) =>
                      setState(() => _selectedPetAge = value!),
                  icon: Icons.cake,
                ),

                const SizedBox(height: 16),

                // Weight Range Dropdown
                _buildGlassyDropdown(
                  label: 'Weight Range',
                  value: _selectedWeightRange,
                  items: [
                    'Small (<10kg)',
                    'Medium (10-25kg)',
                    'Large (25-40kg)',
                    'Extra Large (>40kg)'
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedWeightRange = value!),
                  icon: Icons.monitor_weight_outlined,
                ),

                const SizedBox(height: 16),

                // Activity Level Dropdown
                _buildGlassyDropdown(
                  label: 'Activity Level',
                  value: _selectedActivityLevel,
                  items: ['Low', 'Medium', 'High', 'Very Active'],
                  onChanged: (value) =>
                      setState(() => _selectedActivityLevel = value!),
                  icon: Icons.directions_run,
                ),

                const SizedBox(height: 20),

                // Allergies Multi-Select
                _buildGlassyChipSelector(
                  label: 'Allergies',
                  options: _availableAllergies,
                  selectedOptions: _selectedAllergies,
                ),

                const SizedBox(height: 20),

                // Dietary Preferences Multi-Select
                _buildGlassyChipSelector(
                  label: 'Dietary Preferences',
                  options: _dietaryOptions,
                  selectedOptions: _selectedDietaryPreferences,
                ),

                const SizedBox(height: 20),

                // Toggle Buttons
                _buildGlassyToggle(
                  label: 'Include Treats',
                  value: _includeTreats,
                  onChanged: (value) => setState(() => _includeTreats = value),
                ),

                const SizedBox(height: 12),

                _buildGlassyToggle(
                  label: 'Budget-Friendly Only',
                  value: _budgetFriendly,
                  onChanged: (value) => setState(() => _budgetFriendly = value),
                ),

                const SizedBox(height: 20),

                // Portion Size Slider
                _buildGlassySlider(
                  label: 'Portion Size',
                  value: _portionSize,
                  min: 0.5,
                  max: 5.0,
                  divisions: 9,
                  onChanged: (value) => setState(() => _portionSize = value),
                ),

                const SizedBox(height: 30),

                // Get Recommendation Button
                _buildGlowingButton(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassyDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      dropdownColor: Colors.orange.shade300.withOpacity(0.9),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: onChanged,
                      items: items
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      hint: Text(
                        label,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassyChipSelector({
    required String label,
    required List<String> options,
    required List<String> selectedOptions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((option) {
                  final isSelected = selectedOptions.contains(option);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedOptions.remove(option);
                        } else {
                          selectedOptions.add(option);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.orange.shade600.withOpacity(0.8)
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassyToggle({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.orange.shade600,
                activeTrackColor: Colors.white.withOpacity(0.5),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.white.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassySlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Small',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade600.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${value.toStringAsFixed(1)} cups',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        'Large',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white.withOpacity(0.3),
                      thumbColor: Colors.orange.shade600,
                      overlayColor: Colors.orange.withOpacity(0.2),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 20),
                    ),
                    child: Slider(
                      value: value,
                      min: min,
                      max: max,
                      divisions: divisions,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlowingButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade700.withOpacity(0.6),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          widget.onSave(UserPreferences(
            petType: _selectedPetType,
            healthCondition: _selectedHealthCondition,
            petAge: _selectedPetAge,
            weightRange: _selectedWeightRange,
            activityLevel: _selectedActivityLevel,
            allergies: _selectedAllergies,
            dietaryPreferences: _selectedDietaryPreferences,
            includeTreats: _includeTreats,
            budgetFriendly: _budgetFriendly,
            portionSize: _portionSize,
          ));
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 24),
            SizedBox(width: 8),
            Text(
              'Get Recommendation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPetIcon(String petType) {
    switch (petType) {
      case 'Dog':
        return Icons.pets;
      case 'Cat':
        return Icons.pets;
      case 'Bird':
        return Icons.flutter_dash;
      case 'Rabbit':
        return Icons.pets;
      case 'Hamster':
        return Icons.pets;
      default:
        return Icons.pets;
    }
  }

  IconData _getHealthIcon(String condition) {
    switch (condition) {
      case 'Healthy':
        return Icons.favorite;
      case 'Overweight':
        return Icons.monitor_weight;
      case 'Underweight':
        return Icons.fitness_center;
      case 'Sensitive Stomach':
        return Icons.sick;
      case 'Joint Issues':
        return Icons.accessibility;
      default:
        return Icons.favorite;
    }
  }
}
