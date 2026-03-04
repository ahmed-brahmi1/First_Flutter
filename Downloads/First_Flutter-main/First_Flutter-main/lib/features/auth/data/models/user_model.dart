import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.phoneNumber,
    super.profileImageUrl,
  });

  /// Parse la réponse de l'API login :
  /// { "id": 1, "message": "Login successful", "email": "user@example.com" }
  factory UserModel.fromLoginJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['email'] as String, // l'API ne retourne pas de name, on utilise l'email
    );
  }

  /// Pour les réponses complètes (register, profil, etc.)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: (json['name'] ?? json['email']) as String,
      phoneNumber: json['phone_number'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
    };
  }
}
