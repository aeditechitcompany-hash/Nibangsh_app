import '../../src/notifications/model/student_notification.dart';
import 'api_constants.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _api = const ApiService();

  Future<List<StudentNotification>> getMyNotifications() async {
    final response = await _api.get(
      url: '${ApiConstants.baseUrl}/notifications/',
    );

    print('========== NOTIFICATION RESPONSE ==========');
    print('TYPE: ${response.runtimeType}');
    print('DATA: $response');
    print('============================================');

    List<dynamic> items;

    if (response is List) {
      items = response;
    } else if (response is Map<String, dynamic> &&
        response['results'] is List) {
      items = response['results'] as List;
    } else {
      throw Exception(
        'Invalid notifications response: ${response.runtimeType}',
      );
    }

    return items
        .map(
          (item) => StudentNotification.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _api.post(
      url:
      '${ApiConstants.baseUrl}/notifications/'
          '$notificationId/mark_read/',
      body: {},
      authenticated: true,
    );
  }

  Future<Map<String, dynamic>> publishNotification({
    required String title,
    required String message,
    required String notificationType,
    List<String> userIds = const [],
    bool sendToAllStudents = false,
  }) async {
    final response = await _api.post(
      url: '${ApiConstants.baseUrl}/notifications/publish/',
      body: {
        'user_ids': userIds,
        'send_to_all_students': sendToAllStudents,
        'title': title,
        'message': message,
        'notification_type': notificationType,
      },
      authenticated: true,
    );

    print('========== PUBLISH NOTIFICATION ==========');
    print('RESPONSE: $response');
    print('===========================================');

    if (response is! Map) {
      throw Exception(
        'Invalid publish notification response.',
      );
    }

    return Map<String, dynamic>.from(response);
  }
}