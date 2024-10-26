class UserModel {
  final int id;
  final String email;
  final String name;
  final bool isVerified;
  final String? code; // Make this field nullable

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.isVerified,
    this.code, // Make this nullable in the constructor too
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      isVerified: json['isverified'],
      code: json['reset_code'], // This will allow null values without errors
    );
  }
}
