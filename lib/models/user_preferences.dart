class UserPreferences {
  final String petType;
  final String petAge;

  UserPreferences({required this.petType, required this.petAge});

  Map<String, dynamic> toMap() {
    return {
      'petType': petType,
      'petAge': petAge,
    };
  }

  static UserPreferences fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      petType: map['petType'],
      petAge: map['petAge'],
    );
  }
}
