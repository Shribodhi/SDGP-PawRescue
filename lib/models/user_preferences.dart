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
}
