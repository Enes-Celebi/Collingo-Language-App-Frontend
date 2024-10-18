class UserModel {
  final int id;
  final String email;
  final String name;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      isVerified: json['isverified'],
    );
  }
}
