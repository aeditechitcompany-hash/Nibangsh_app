import 'api_constants.dart';
import 'api_service.dart';

class McqAccessService {
  final ApiService _apiService = const ApiService();

  Future<bool> hasMcqAccess() async {
    final response = await _apiService.get(
      url: ApiConstants.myStudentProfile,
    );

    if (response is! Map<String, dynamic>) {
      return false;
    }

    return response["mcq_access"] == true;
  }
}