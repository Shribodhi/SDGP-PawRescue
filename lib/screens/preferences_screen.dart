import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/user_preferences.dart';
import 'food_recommendation_screen.dart'; // Import the new screen

class PreferencesScreen extends StatefulWidget {
  final Function(UserPreferences) onSave;

  const PreferencesScreen({Key? key, required this.onSave}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
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

  // Loading state
  bool _isLoading = false;

  // Colors
  final Color primaryColor = Colors.blue;
  final Color secondaryColor = Colors.blue.shade100;
  final Color textColor = Colors.blue.shade900;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Food Recommendation'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Blue decorative header
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),

            // Main content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Pet Type Section
                  _buildSectionTitle('Pet Type'),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    value: _selectedPetType,
                    items: ['Dog', 'Cat', 'Bird', 'Rabbit', 'Hamster'],
                    onChanged: (value) =>
                        setState(() => _selectedPetType = value!),
                    icon: _getPetIcon(_selectedPetType),
                  ),

                  const SizedBox(height: 20),

                  // Health Condition Section
                  _buildSectionTitle('Health Condition'),
                  const SizedBox(height: 10),
                  _buildDropdown(
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

                  const SizedBox(height: 20),

                  // Pet Age Section
                  _buildSectionTitle('Pet Age'),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    value: _selectedPetAge,
                    items: ['Puppy/Kitten', 'Young', 'Adult', 'Senior'],
                    onChanged: (value) =>
                        setState(() => _selectedPetAge = value!),
                    icon: Icons.cake,
                  ),

                  const SizedBox(height: 20),

                  // Weight Range Section
                  _buildSectionTitle('Weight Range'),
                  const SizedBox(height: 10),
                  _buildDropdown(
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

                  const SizedBox(height: 20),

                  // Activity Level Section
                  _buildSectionTitle('Activity Level'),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    value: _selectedActivityLevel,
                    items: ['Low', 'Medium', 'High', 'Very Active'],
                    onChanged: (value) =>
                        setState(() => _selectedActivityLevel = value!),
                    icon: Icons.directions_run,
                  ),

                  const SizedBox(height: 24),

                  // Allergies Section
                  _buildSectionTitle('Allergies'),
                  const SizedBox(height: 10),
                  _buildChipSelector(
                    options: _availableAllergies,
                    selectedOptions: _selectedAllergies,
                  ),

                  const SizedBox(height: 24),

                  // Dietary Preferences Section
                  _buildSectionTitle('Dietary Preferences'),
                  const SizedBox(height: 10),
                  _buildChipSelector(
                    options: _dietaryOptions,
                    selectedOptions: _selectedDietaryPreferences,
                  ),

                  const SizedBox(height: 24),

                  // Toggle Options
                  _buildToggleOption(
                    label: 'Include Treats',
                    value: _includeTreats,
                    onChanged: (value) =>
                        setState(() => _includeTreats = value),
                    icon: Icons.icecream,
                  ),

                  const SizedBox(height: 12),

                  _buildToggleOption(
                    label: 'Budget-Friendly Options Only',
                    value: _budgetFriendly,
                    onChanged: (value) =>
                        setState(() => _budgetFriendly = value),
                    icon: Icons.attach_money,
                  ),

                  const SizedBox(height: 24),

                  // Portion Size Slider
                  _buildSectionTitle('Portion Size'),
                  const SizedBox(height: 10),
                  _buildSlider(),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _getRecommendation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Get Recommendation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                  onChanged: onChanged,
                  items: items
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                color: primaryColor,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipSelector({
    required List<String> options,
    required List<String> selectedOptions,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((option) {
          final isSelected = selectedOptions.contains(option);
          return FilterChip(
            label: Text(option),
            selected: isSelected,
            checkmarkColor: Colors.white,
            selectedColor: primaryColor,
            backgroundColor: Colors.grey.shade100,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : textColor,
            ),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  selectedOptions.add(option);
                } else {
                  selectedOptions.remove(option);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
            activeTrackColor: secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Small'),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_portionSize.toStringAsFixed(1)} cups',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              const Text('Large'),
            ],
          ),
          Slider(
            value: _portionSize,
            min: 0.5,
            max: 5.0,
            divisions: 9,
            activeColor: primaryColor,
            inactiveColor: secondaryColor,
            label: '${_portionSize.toStringAsFixed(1)} cups',
            onChanged: (value) {
              setState(() {
                _portionSize = value;
              });
            },
          ),
        ],
      ),
    );
  }

  IconData _getPetIcon(String petType) {
    switch (petType) {
      case 'Dog':
        return Icons.pets;
      case 'Cat':
        return Icons.catching_pokemon;
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

  void _getRecommendation() async {
    setState(() => _isLoading = true);

    try {
      // Create a map of preferences to pass to the FoodRecommendationScreen
      final Map<String, dynamic> preferencesMap = {
        'petType': _selectedPetType,
        'healthCondition': _selectedHealthCondition,
        'petAge': _selectedPetAge,
        'weightRange': _selectedWeightRange,
        'activityLevel': _selectedActivityLevel,
        'allergies': _selectedAllergies,
        'dietaryPreferences': _selectedDietaryPreferences,
        'includeTreats': _includeTreats,
        'budgetFriendly': _budgetFriendly,
        'portionSize': _portionSize,
      };

      // Save preferences using the callback
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

      // Navigate to the FoodRecommendationScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodRecommendationScreen(
            petPreferences: preferencesMap,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Remove the _showRecommendationDialog method as we're now navigating to a new screen

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: primaryColor),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
