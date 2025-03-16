class UserPreferences {
  final String petType;
  final String healthCondition;
  final String petAge;
  final String weightRange;
  final String activityLevel;
  final List<String> allergies;
  final List<String> dietaryPreferences;
  final bool includeTreats;
  final bool budgetFriendly;
  final double portionSize;

  UserPreferences({
    required this.petType,
    required this.healthCondition,
    required this.petAge,
    required this.weightRange,
    required this.activityLevel,
    required this.allergies,
    required this.dietaryPreferences,
    required this.includeTreats,
    required this.budgetFriendly,
    required this.portionSize,
  });

  // Convert to a map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'petType': petType,
      'healthCondition': healthCondition,
      'petAge': petAge,
      'weightRange': weightRange,
      'activityLevel': activityLevel,
      'allergies': allergies,
      'dietaryPreferences': dietaryPreferences,
      'includeTreats': includeTreats,
      'budgetFriendly': budgetFriendly,
      'portionSize': portionSize,
    };
  }

  // Create from a map (for Firebase retrieval)
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      petType: map['petType'] ?? 'Dog',
      healthCondition: map['healthCondition'] ?? 'Healthy',
      petAge: map['petAge'] ?? 'Adult',
      weightRange: map['weightRange'] ?? 'Medium (10-25kg)',
      activityLevel: map['activityLevel'] ?? 'Medium',
      allergies: List<String>.from(map['allergies'] ?? []),
      dietaryPreferences: List<String>.from(map['dietaryPreferences'] ?? []),
      includeTreats: map['includeTreats'] ?? true,
      budgetFriendly: map['budgetFriendly'] ?? false,
      portionSize: (map['portionSize'] ?? 2.0).toDouble(),
    );
  }
}
