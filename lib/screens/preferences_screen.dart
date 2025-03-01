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
      appBar: AppBar(
        title: const Text(
          'Pet Preferences',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, secondaryColor.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSectionHeader('Basic Information', Icons.pets),
              const SizedBox(height: 16),

              // Pet Type Dropdown
              _buildDropdown(
                label: 'Pet Type',
                value: _selectedPetType,
                items: ['Dog', 'Cat', 'Bird', 'Rabbit', 'Hamster'],
                onChanged: (value) => setState(() => _selectedPetType = value!),
                icon: Icons.pets,
              ),

              const SizedBox(height: 16),

              // Pet Age Dropdown
              _buildDropdown(
                label: 'Pet Age',
                value: _selectedPetAge,
                items: ['Puppy/Kitten', 'Young', 'Adult', 'Senior'],
                onChanged: (value) => setState(() => _selectedPetAge = value!),
                icon: Icons.cake,
              ),

              const SizedBox(height: 16),

              // Health Condition Dropdown
              _buildDropdown(
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
                icon: Icons.favorite,
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('Physical Attributes', Icons.fitness_center),
              const SizedBox(height: 16),

              // Weight Range Dropdown
              _buildDropdown(
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
              _buildDropdown(
                label: 'Activity Level',
                value: _selectedActivityLevel,
                items: ['Low', 'Medium', 'High', 'Very Active'],
                onChanged: (value) =>
                    setState(() => _selectedActivityLevel = value!),
                icon: Icons.directions_run,
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('Dietary Preferences', Icons.restaurant_menu),
              const SizedBox(height: 16),

              // Allergies Multi-Select
              _buildChipSelector(
                label: 'Select Allergies',
                options: _availableAllergies,
                selectedOptions: _selectedAllergies,
                icon: Icons.health_and_safety,
              ),

              const SizedBox(height: 20),

              // Dietary Preferences Multi-Select
              _buildChipSelector(
                label: 'Dietary Preferences',
                options: _dietaryOptions,
                selectedOptions: _selectedDietaryPreferences,
                icon: Icons.set_meal,
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('Additional Options', Icons.tune),
              const SizedBox(height: 16),

              // Toggle Buttons
              _buildToggleOption(
                label: 'Include Treats',
                value: _includeTreats,
                onChanged: (value) => setState(() => _includeTreats = value),
                icon: Icons.icecream,
              ),

              const SizedBox(height: 12),

              _buildToggleOption(
                label: 'Budget-Friendly Options Only',
                value: _budgetFriendly,
                onChanged: (value) => setState(() => _budgetFriendly = value),
                icon: Icons.attach_money,
              ),

              const SizedBox(height: 20),

              // Portion Size Slider
              _buildSlider(
                label: 'Portion Size',
                value: _portionSize,
                min: 0.5,
                max: 5.0,
                divisions: 9,
                onChanged: (value) => setState(() => _portionSize = value),
                icon: Icons.dinner_dining,
              ),

              const SizedBox(height: 32),

              // Save Button
              _buildSaveButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(color: primaryColor.withOpacity(0.5), thickness: 1),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor),
              ),
            ),
            icon: Icon(Icons.arrow_drop_down, color: primaryColor),
            dropdownColor: Colors.white,
            onChanged: onChanged,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChipSelector({
    required String label,
    required List<String> options,
    required List<String> selectedOptions,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200),
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
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
        ),
      ],
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
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

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Small'),
                  Text(
                    '${value.toStringAsFixed(1)} cups',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Text('Large'),
                ],
              ),
              Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                activeColor: primaryColor,
                inactiveColor: secondaryColor,
                label: '${value.toStringAsFixed(1)} cups',
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
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
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.save),
          const SizedBox(width: 8),
          Text(
            'Save Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
