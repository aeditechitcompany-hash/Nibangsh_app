import 'package:nibangsh_consultancy/common/api_services/api_constants.dart';
import 'package:nibangsh_consultancy/common/api_services/api_service.dart';

import '../../../common/api_models/leaderboard_model.dart';

class LeaderboardService {
  final ApiService _apiService = const ApiService();

  Future<List<LeaderboardEntry>> getLeaderboard() async {
    final response = await _apiService.get(
      url:
      '${ApiConstants.baseUrl}/mcq/attempts/leaderboard/',
    );

    print('LEADERBOARD RESPONSE: $response');

    if (response is! Map<String, dynamic>) {
      return [];
    }

    final rawResults = response['results'];

    if  (rawResults is! List) {
      return [];
    }

    final List<LeaderboardEntry> entries = [];

    for (final item in rawResults) {
      if (item is Map) {
        try {
          final json = Map<String, dynamic>.from(item);

          entries.add(
            LeaderboardEntry.fromJson(json),
          );
        } catch (e) {
          print(
            'LEADERBOARD ITEM PARSE ERROR: $e',
          );
          print(
            'BAD ITEM: $item',
          );
        }
      }
    }

    return entries;
  }
}