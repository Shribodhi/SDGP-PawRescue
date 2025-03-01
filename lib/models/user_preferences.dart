class UserPreferences {
  final String petType;
  final String petAge;
  final String healthCondition; // Added this line 🔥

  UserPreferences({
    required this.petType,
    required this.petAge,
    required this.healthCondition, // Added this line 🔥
  });

  Map<String, dynamic> toJson() {
    return {
      'petType': petType,
      'petAge': petAge,
      'healthCondition': healthCondition, // Added this line 🔥
    };
  }
}
