import 'user_model.dart';

class AuthResponse {
  final String access;
  final String refresh;
  final UserModel user;

  AuthResponse({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      access: json["access"],
      refresh: json["refresh"],
      user: UserModel.fromJson(json["user"]),
    );
  }
}