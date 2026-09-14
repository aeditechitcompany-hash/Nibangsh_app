enum StudentNotificationType {
  success,
  info,
  warning,
  alert,
}

class StudentNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final StudentNotificationType type;
  final bool isRead;

  const StudentNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.type,
    required this.isRead,
  });

  factory StudentNotification.fromJson(
      Map<String, dynamic> json,
      ) {
    return StudentNotification(
      id: json['id'].toString(),
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt: DateTime.tryParse(
        json['created_at']?.toString() ?? '',
      ) ??
          DateTime.now(),
      type: _parseType(
        json['notification_type']?.toString(),
      ),
      isRead: json['is_read'] == true,
    );
  }

  static StudentNotificationType _parseType(
      String? value,
      ) {
    switch (value) {
      case 'success':
        return StudentNotificationType.success;
      case 'warning':
        return StudentNotificationType.warning;
      case 'alert':
        return StudentNotificationType.alert;
      case 'info':
      default:
        return StudentNotificationType.info;
    }
  }

  StudentNotification copyWith({
    bool? isRead,
  }) {
    return StudentNotification(
      id: id,
      title: title,
      message: message,
      createdAt: createdAt,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}