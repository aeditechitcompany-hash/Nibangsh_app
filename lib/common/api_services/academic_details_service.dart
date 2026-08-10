import 'api_constants.dart';
import 'api_service.dart';

/// Maps the labels shown in Flutter to Education.DegreeLevel choices in Django.
const Map<String, String> kDegreeLevelApiValues = {
  'Bachelors': 'bachelor',
  'Masters': 'master',
  'PHD': 'phd',
};

class AcademicDetailsService {
  final ApiService _api = const ApiService();

  List<dynamic> _asList(dynamic response) {
    if (response is List) return response;
    if (response is Map && response['results'] is List) {
      return response['results'] as List;
    }
    return [];
  }

  /// Finds the country row used by students_education.country_id and returns
  /// its database ID.
  Future<String?> findCountryId(String countryName) async {
    if (countryName.trim().isEmpty) return null;

    final response = await _api.get(
      url: '${ApiConstants.countries}?search=${Uri.encodeQueryComponent(countryName)}',
    );

    final results = _asList(response);
    for (final item in results) {
      final name = (item['name'] ?? '').toString();
      if (name.toLowerCase() == countryName.toLowerCase()) {
        return item['id'].toString();
      }
    }

    if (results.isNotEmpty) {
      return results.first['id'].toString();
    }

    return null;
  }

  /// Gets or creates the StudentProfile belonging to the authenticated user.
  /// accounts_user.id -> students_studentprofile.user_id
  Future<String> ensureStudentProfile({
    required String userId,
    String? countryId,
  }) async {
    final response = await _api.get(
      url: '${ApiConstants.studentProfiles}?user=$userId',
    );

    final existing = _asList(response);

    if (existing.isNotEmpty) {
      final profile = Map<String, dynamic>.from(existing.first);
      final profileId = profile['id'].toString();

      if (countryId != null && profile['country']?.toString() != countryId) {
        await _api.patch(
          url: '${ApiConstants.studentProfiles}$profileId/',
          body: {'country': countryId},
          authenticated: true,
        );
      }

      return profileId;
    }

    final created = await _api.post(
      url: ApiConstants.studentProfiles,
      body: {
        'user': userId,
        if (countryId != null) 'country': countryId,
      },
      authenticated: true,
    );

    return created['id'].toString();
  }

  /// Returns true when the backend already has an education record for the
  /// currently authenticated user.
  Future<bool> hasAcademicDetails() async {
    final response = await _api.get(
      url: ApiConstants.myEducationStatus,
    );

    return response is Map &&
        response['has_academic_details'] == true;
  }

  /// Creates or updates the student's education record.
  /// The backend derives student_id from the JWT, so Flutter does not have
  /// to choose or trust a StudentProfile ID.
  Future<void> upsertEducation({
    required String degreeLevel,
    required String gpa,
    required String passoutYear,
    required String countryId,
  }) async {
    final apiDegreeLevel =
        kDegreeLevelApiValues[degreeLevel] ?? 'bachelor';

    final statusResponse = await _api.get(
      url: ApiConstants.myEducationStatus,
    );

    final existing = _asList(
      statusResponse is Map ? statusResponse['education'] : null,
    );

    final body = {
      'degree_level': apiDegreeLevel,
      // The current Flutter screen does not collect institution name.
      // The backend currently requires this field, so keep a temporary value.
      'institution_name': 'Not specified',
      'gpa': gpa,
      'gpa_scale': '4.0',
      'grade': gpa,
      'passout_year': int.tryParse(passoutYear),
      'country': int.tryParse(countryId),
      'is_completed': true,
    };

    if (existing.isNotEmpty) {
      final educationId = existing.first['id'].toString();

      await _api.patch(
        url: '${ApiConstants.education}$educationId/',
        body: body,
        authenticated: true,
      );
    } else {
      await _api.post(
        url: ApiConstants.education,
        body: body,
        authenticated: true,
      );
    }
  }

  Future<void> submitAcademicDetails({
    required String userId,
    required String country,
    required String gpa,
    required String passoutYear,
    required String degree,
  }) async {
    final countryId = await findCountryId(country);

    if (countryId == null) {
      throw Exception(
        'The selected country was not found in the countries table.',
      );
    }

    // This creates/updates:
    // accounts_user -> students_studentprofile -> students_education
    await ensureStudentProfile(
      userId: userId,
      countryId: countryId,
    );

    await upsertEducation(
      degreeLevel: degree,
      gpa: gpa,
      passoutYear: passoutYear,
      countryId: countryId,
    );
  }
}
