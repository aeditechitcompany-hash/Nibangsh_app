class ApiConstants {
  // BASE URL

  static const String baseUrl =
      'https://backend-1-mltk.onrender.com/api';
  static const String deviceToken =
      '$baseUrl/notifications/device-token/';
  static const String serverUrl =
      'https://backend-1-mltk.onrender.com';

  // AUTH

  static const String register =
      '$baseUrl/accounts/auth/register/';

  static const String login =
      '$baseUrl/accounts/auth/login/';

  static const String refresh =
      '$baseUrl/accounts/auth/token/refresh/';

  // USERS / STUDENTS

  static const String students =
      '$baseUrl/accounts/users/';
  static const String mcqQuestions =
      '$baseUrl/mcq/questions/';

  static const String mcqOptions =
      '$baseUrl/mcq/options/';

  static String mcqQuestion(String id) =>
      '$mcqQuestions$id/';

  static String mcqOption(String id) =>
      '$mcqOptions$id/';

  static const String studentProfiles =
      '$baseUrl/students/profiles/';

  static const String myStudentProfile =
      '$baseUrl/students/profiles/me/';

  static const String education =
      '$baseUrl/students/education/';

  static const String countries =
      '$baseUrl/countries/';

  static const String myEducationStatus =
      '$baseUrl/students/education/my-status/';

  static const String myAcademicDetails =
      '$baseUrl/students/education/my-status/';

  // BOOKS
   static const String books =
      '$baseUrl/books/';

  // MCQ QUESTION SETS
  static const String questionSets =
      '$baseUrl/mcq/question-sets/';

  static const String myMcqAccess =
      '$baseUrl/students/profiles/my-mcq-access/';

  // MCQ ATTEMPTS

  static const String attempts =
      '$baseUrl/mcq/attempts/';

  static String questionSetTake(String id) {
    return '$questionSets$id/';
  }

  static String attemptAnswer(String attemptId) {
    return '$attempts$attemptId/answer/';
  }

  static String attemptFinish(String attemptId) {
    return '$attempts$attemptId/finish/';
  }

  // MEDIA URL

  /// Converts a Django media path into a complete URL.
  ///
  /// Examples:
  ///
  /// /media/mcq/image.jpg
  /// -> http://192.168.101.8:8000/media/mcq/image.jpg
  ///
  /// media/mcq/image.jpg
  /// -> http://192.168.101.8:8000/media/mcq/image.jpg
  ///
  /// http://example.com/image.jpg
  /// -> unchanged
  static String mediaUrl(String? path) {
    if (path == null || path.trim().isEmpty) {
      return '';
    }

    final value = path.trim();

    // Already a complete URL.
    if (value.startsWith('http://') ||
        value.startsWith('https://')) {
      return value;
    }

    // Django absolute media path.
    if (value.startsWith('/')) {
      return '$serverUrl$value';
    }

    // Relative media path.
    return '$serverUrl/$value';
  }
}