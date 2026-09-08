import '../api_models/auth_response.dart';
import 'api_constants.dart';
import 'api_service.dart';
import 'token_storage_service.dart';

class AuthService {
  final ApiService _api = const ApiService();

  Future<AuthResponse> register({
    required String role,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String address,
    required String district,
    required String province,
  }) async {
    final username = email.split('@').first;

    final names = fullName.trim().split(RegExp(r'\s+'));

    final firstName = names.isNotEmpty ? names.first : '';
    final lastName =
    names.length > 1 ? names.sublist(1).join(' ') : '';

    final normalizedRole = role.trim().toLowerCase();

    if (normalizedRole != 'student' && normalizedRole != 'ubt') {
      throw Exception('Invalid account type.');
    }

    await _api.post(
      url: ApiConstants.register,
      body: {
        "username": username,
        "email": email,
        "phone_number": phone,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "role": normalizedRole,
        "street_address":
        normalizedRole == 'student' ? address : '',
        "district":
        normalizedRole == 'student' ? district : '',
        "province":
        normalizedRole == 'student' ? province : '',
      },
    );

    return login(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      url: ApiConstants.login,
      body: {
        "email": email,
        "password": password,
      },
    );

    print("========== LOGIN RESPONSE ==========");
    print(response);
    print("====================================");

    final auth = AuthResponse.fromJson(response);

    await TokenStorageService.saveTokens(
      accessToken: auth.access,
      refreshToken: auth.refresh,
    );

    return auth;
  }

  Future<void> logout() async {
    await TokenStorageService.clearStorage();
  }
}