import 'api_constants.dart';
import 'api_service.dart';

class McqAccessService {
  final ApiService _apiService = const ApiService();

  Future<bool> hasMcqAccess() async {
    final response = await _apiService.get(
      url: ApiConstants.myMcqAccess,
    );

    print('========== MCQ ACCESS RESPONSE ==========');
    print(response);
    print('=========================================');

    if (response is! Map) {
      return false;
    }

    return response['mcq_access'] == true;
  }
}