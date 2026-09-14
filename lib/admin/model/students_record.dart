import 'package:flutter/material.dart';

import '../../../common/models/application_step_model.dart';
import '../../../common/models/required_document.dart';

/// ============================================================
/// STUDENT STATUS
/// ============================================================

enum StudentStatus {
  active,
  pending,
  approved,
  rejected,
}

extension StudentStatusX on StudentStatus {
  String get label {
    switch (this) {
      case StudentStatus.active:
        return 'Active';

      case StudentStatus.pending:
        return 'Pending';

      case StudentStatus.approved:
        return 'Approved';

      case StudentStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case StudentStatus.active:
        return const Color(0xFF6995F6);

      case StudentStatus.pending:
        return const Color(0xFFF59E0B);

      case StudentStatus.approved:
        return const Color(0xFF16A34A);

      case StudentStatus.rejected:
        return const Color(0xFFDC2626);
    }
  }
}

/// ============================================================
/// ADMIN STUDENT RECORD
///
/// IMPORTANT:
/// This model is for ADMIN only.
///
/// Do not replace this with UbtStudent.
/// ============================================================

class StudentRecord {
  final String id;
  final String? processId;

  final String name;
  final String email;
  final String phone;
  final String role;

  final String countryCode;
  final String countryName;

  final String university;
  final String course;
  final String gpa;
  final String degree;
  final String passoutYear;

  final String languageTestName;
  final String languageTestScore;

  final String joinedDate;

  final String visaStatus;
  final String flightStatus;

  final int currentStep;
  final StudentStatus status;

  final bool processCompleted;
  final List<int> completedSteps;

  /// ==========================================================
  /// REAL BACKEND DOCUMENTS
  /// ==========================================================

  final List<RequiredDocument> documents;

  int get documentsUploaded {
    return documents
        .where((document) => document.uploaded)
        .length;
  }

  int get documentsTotal {
    return documents.length;
  }

  // ==========================================================
  // STEP 4
  // ==========================================================

  final DateTime? interviewDate;
  final String? interviewMode;
  final String? interviewResult;
  final String? interviewNotes;

  // ==========================================================
  // STEP 5
  // ==========================================================

  final String? applicationRefNo;
  final DateTime? submissionDate;
  final String? confirmationFileName;

  // ==========================================================
  // STEP 6
  // ==========================================================

  final String? offerFileName;
  final String? offerType;
  final DateTime? offerExpiryDate;

  // ==========================================================
  // STEP 7
  // ==========================================================

  final String? locFileName;
  final bool locVerified;

  // ==========================================================
  // STEP 8
  // ==========================================================

  final DateTime? courseCommencementDate;
  final String? scholarshipStatus;
  final String? finalSelectionNotes;
  final bool finalSelectionConfirmed;

  // ==========================================================
  // STEP 9
  // ==========================================================

  final String? visaRefNo;
  final String? visaStatusUpdate;
  final String? visaApprovalLetterFileName;

  // ==========================================================
  // STEP 10
  // ==========================================================

  final String? flightNumber;
  final String? airline;
  final String? departureAirport;
  final String? arrivalAirport;
  final DateTime? departureDateTime;
  final String? ticketFileName;

  // ==========================================================
  // CONSTRUCTOR
  // ==========================================================

  const StudentRecord({
    required this.id,
    required this.processId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.countryCode,
    required this.countryName,
    required this.university,
    required this.course,
    required this.gpa,
    required this.degree,
    required this.passoutYear,
    required this.languageTestName,
    required this.languageTestScore,
    required this.joinedDate,
    required this.visaStatus,
    required this.flightStatus,
    required this.currentStep,
    required this.status,

    this.documents = RequiredDocumentsCatalog.seed,

    this.interviewDate,
    this.interviewMode,
    this.interviewResult,
    this.interviewNotes,

    this.applicationRefNo,
    this.submissionDate,
    this.confirmationFileName,

    this.offerFileName,
    this.offerType,
    this.offerExpiryDate,

    this.locFileName,
    this.locVerified = false,

    this.courseCommencementDate,
    this.scholarshipStatus,
    this.finalSelectionNotes,
    this.finalSelectionConfirmed = false,

    this.visaRefNo,
    this.visaStatusUpdate,
    this.visaApprovalLetterFileName,

    this.flightNumber,
    this.airline,
    this.departureAirport,
    this.arrivalAirport,
    this.departureDateTime,
    this.ticketFileName,

    this.processCompleted = false,
    this.completedSteps = const [],
  });

  // ==========================================================
  // TOTAL PROCESS STEPS
  // ==========================================================

  static int get totalSteps {
    return ApplicationStepsCatalog.definitions.length;
  }

  // ==========================================================
  // CURRENT STEP TITLE
  // ==========================================================

  String get currentStepTitle {
    final definitions =
        ApplicationStepsCatalog.definitions;

    if (definitions.isEmpty) {
      return '';
    }

    final index = (currentStep - 1).clamp(
      0,
      definitions.length - 1,
    );

    return definitions[index]['title'] as String;
  }

  // ==========================================================
  // INITIALS
  // ==========================================================

  String get initials {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return '?';
    }

    final parts =
    trimmedName.split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts.first
          .substring(0, 1)
          .toUpperCase();
    }

    return (
        parts.first.substring(0, 1) +
            parts.last.substring(0, 1)
    ).toUpperCase();
  }

  // ==========================================================
  // PROCESS HELPERS
  // ==========================================================

  bool isStepCompleted(int step) {
    return completedSteps.contains(step);
  }

  bool isCurrentStep(int step) {
    return currentStep == step;
  }

  // ==========================================================
  // COPY WITH
  // ==========================================================

  StudentRecord copyWith({
    String? processId,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? countryCode,
    String? countryName,
    String? university,
    String? course,
    String? gpa,
    String? degree,
    String? passoutYear,
    String? languageTestName,
    String? languageTestScore,
    int? currentStep,
    StudentStatus? status,
    List<RequiredDocument>? documents,
    String? visaStatus,
    String? flightStatus,

    DateTime? interviewDate,
    String? interviewMode,
    String? interviewResult,
    String? interviewNotes,

    String? applicationRefNo,
    DateTime? submissionDate,
    String? confirmationFileName,

    String? offerFileName,
    String? offerType,
    DateTime? offerExpiryDate,

    String? locFileName,
    bool? locVerified,

    DateTime? courseCommencementDate,
    String? scholarshipStatus,
    String? finalSelectionNotes,
    bool? finalSelectionConfirmed,

    String? visaRefNo,
    String? visaStatusUpdate,
    String? visaApprovalLetterFileName,

    String? flightNumber,
    String? airline,
    String? departureAirport,
    String? arrivalAirport,
    DateTime? departureDateTime,
    String? ticketFileName,

    bool? processCompleted,
    List<int>? completedSteps,
  }) {
    return StudentRecord(
      id: id,

      processId:
      processId ?? this.processId,

      name:
      name ?? this.name,

      email:
      email ?? this.email,

      phone:
      phone ?? this.phone,

      role:
      role ?? this.role,

      countryCode:
      countryCode ?? this.countryCode,

      countryName:
      countryName ?? this.countryName,

      university:
      university ?? this.university,

      course:
      course ?? this.course,

      gpa:
      gpa ?? this.gpa,

      degree:
      degree ?? this.degree,

      passoutYear:
      passoutYear ?? this.passoutYear,

      languageTestName:
      languageTestName ??
          this.languageTestName,

      languageTestScore:
      languageTestScore ??
          this.languageTestScore,

      joinedDate:
      this.joinedDate,

      visaStatus:
      visaStatus ??
          this.visaStatus,

      flightStatus:
      flightStatus ??
          this.flightStatus,

      currentStep:
      currentStep ??
          this.currentStep,

      status:
      status ??
          this.status,

      documents:
      documents ??
          this.documents,

      interviewDate:
      interviewDate ??
          this.interviewDate,

      interviewMode:
      interviewMode ??
          this.interviewMode,

      interviewResult:
      interviewResult ??
          this.interviewResult,

      interviewNotes:
      interviewNotes ??
          this.interviewNotes,

      applicationRefNo:
      applicationRefNo ??
          this.applicationRefNo,

      submissionDate:
      submissionDate ??
          this.submissionDate,

      confirmationFileName:
      confirmationFileName ??
          this.confirmationFileName,

      offerFileName:
      offerFileName ??
          this.offerFileName,

      offerType:
      offerType ??
          this.offerType,

      offerExpiryDate:
      offerExpiryDate ??
          this.offerExpiryDate,

      locFileName:
      locFileName ??
          this.locFileName,

      locVerified:
      locVerified ??
          this.locVerified,

      courseCommencementDate:
      courseCommencementDate ??
          this.courseCommencementDate,

      scholarshipStatus:
      scholarshipStatus ??
          this.scholarshipStatus,

      finalSelectionNotes:
      finalSelectionNotes ??
          this.finalSelectionNotes,

      finalSelectionConfirmed:
      finalSelectionConfirmed ??
          this.finalSelectionConfirmed,

      visaRefNo:
      visaRefNo ??
          this.visaRefNo,

      visaStatusUpdate:
      visaStatusUpdate ??
          this.visaStatusUpdate,

      visaApprovalLetterFileName:
      visaApprovalLetterFileName ??
          this.visaApprovalLetterFileName,

      flightNumber:
      flightNumber ??
          this.flightNumber,

      airline:
      airline ??
          this.airline,

      departureAirport:
      departureAirport ??
          this.departureAirport,

      arrivalAirport:
      arrivalAirport ??
          this.arrivalAirport,

      departureDateTime:
      departureDateTime ??
          this.departureDateTime,

      ticketFileName:
      ticketFileName ??
          this.ticketFileName,

      processCompleted:
      processCompleted ??
          this.processCompleted,

      completedSteps:
      completedSteps ??
          this.completedSteps,
    );
  }

  // ==========================================================
  // FROM JSON
  // ==========================================================

  factory StudentRecord.fromJson(
      Map<String, dynamic> json,
      ) {
    // ========================================================
    // USER OBJECT
    //
    // Supports both:
    //
    // {
    //   "first_name": "...",
    //   "last_name": "..."
    // }
    //
    // and:
    //
    // {
    //   "user": {
    //      "first_name": "...",
    //      "last_name": "..."
    //   }
    // }
    // ========================================================

    final userJson =
    json['user'] is Map
        ? Map<String, dynamic>.from(
      json['user'] as Map,
    )
        : <String, dynamic>{};

    // ========================================================
    // FIRST NAME
    // ========================================================

    final firstName =
    _firstNonEmpty([
      json['first_name'],
      userJson['first_name'],
    ]);

    // ========================================================
    // LAST NAME
    // ========================================================

    final lastName =
    _firstNonEmpty([
      json['last_name'],
      userJson['last_name'],
    ]);

    // ========================================================
    // FULL NAME
    // ========================================================

    final apiFullName =
    _firstNonEmpty([
      json['full_name'],
      userJson['full_name'],
    ]);

    final calculatedName =
    '$firstName $lastName'.trim();

    // ========================================================
    // USERNAME
    // ========================================================

    final username =
    _firstNonEmpty([
      json['username'],
      userJson['username'],
    ]);

    // ========================================================
    // FINAL NAME
    //
    // Priority:
    //
    // 1. full_name
    // 2. first_name + last_name
    // 3. username
    // 4. Unknown Student
    // ========================================================

    final resolvedName =
    apiFullName.isNotEmpty
        ? apiFullName
        : calculatedName.isNotEmpty
        ? calculatedName
        : username.isNotEmpty
        ? username
        : 'Unknown Student';

    // ========================================================
    // EMAIL
    // ========================================================

    final email =
    _firstNonEmpty([
      json['email'],
      userJson['email'],
    ]);

    // ========================================================
    // PHONE
    // ========================================================

    final phone =
    _firstNonEmpty([
      json['phone_number'],
      json['phone'],
      userJson['phone_number'],
      userJson['phone'],
    ]);

    // ========================================================
    // ROLE
    // ========================================================

    final role =
    _firstNonEmpty([
      json['role'],
      userJson['role'],
    ]).isNotEmpty
        ? _firstNonEmpty([
      json['role'],
      userJson['role'],
    ]).trim().toLowerCase()
        : 'student';

    // ========================================================
    // COMPLETED PROCESS STEPS
    // ========================================================

    final rawCompleted =
    json['completed_process_steps'];

    final completedSteps =
    rawCompleted is List
        ? rawCompleted
        .map(
          (value) =>
          int.tryParse(
            value.toString(),
          ),
    )
        .whereType<int>()
        .toList()
        : <int>[];

    // ========================================================
    // REAL BACKEND DOCUMENTS
    //
    // Expected:
    //
    // "documents": [
    //   {
    //     "name": "Transcript",
    //     "field": "transcript_file",
    //     "url": "https://..."
    //   }
    // ]
    // ========================================================

    final documentsJson =
    json['documents'];

    final documents =
    <RequiredDocument>[];

    if (documentsJson is List) {
      for (final item in documentsJson) {
        if (item is Map) {
          try {
            final document =
            RequiredDocument.fromBackendJson(
              Map<String, dynamic>.from(item),
            );

            if (document.filePath != null &&
                document.filePath!
                    .trim()
                    .isNotEmpty) {
              documents.add(document);
            }
          } catch (e) {
            debugPrint(
              'DOCUMENT PARSE ERROR: $e',
            );
          }
        }
      }
    }

    // ========================================================
    // DEBUG DOCUMENT RESPONSE
    // ========================================================

    debugPrint(
      '===========================================',
    );

    debugPrint(
      'STUDENT: $resolvedName',
    );

    debugPrint(
      'DOCUMENTS FROM BACKEND: '
          '${documents.length}',
    );

    for (final document in documents) {
      debugPrint(
        'DOCUMENT: '
            '${document.title} -> '
            '${document.filePath}',
      );
    }

    debugPrint(
      '===========================================',
    );

    // ========================================================
    // ACTIVE STATUS
    // ========================================================

    final isActive =
        json['is_active_student'] ??
            json['is_active'] ??
            true;

    // ========================================================
    // CURRENT PROCESS STEP
    // ========================================================

    final currentStep =
        int.tryParse(
          json['current_process_step']
              ?.toString() ??
              '',
        ) ??
            1;

    // ========================================================
    // RETURN STUDENT
    // ========================================================

    return StudentRecord(
      id:
      json['id']?.toString() ?? '',

      processId:
      json['process_id']?.toString(),

      name:
      resolvedName,

      email:
      email,

      phone:
      phone,

      role:
      role,

      // ======================================================
      // ACADEMIC / COUNTRY DATA
      // ======================================================

      countryCode:
      _firstNonEmpty([
        json['country_code'],
        json['country'],
      ]),

      countryName:
      _firstNonEmpty([
        json['country_name'],
        json['country'],
      ]),

      university:
      _firstNonEmpty([
        json['university'],
        json['university_name'],
      ]),

      course:
      _firstNonEmpty([
        json['course'],
        json['course_name'],
      ]),

      gpa:
      json['gpa']?.toString() ?? '',

      degree:
      _firstNonEmpty([
        json['degree'],
        json['degree_name'],
      ]),

      passoutYear:
      _firstNonEmpty([
        json['passout_year'],
        json['graduation_year'],
        json['passoutYear'],
      ]),

      // ======================================================
      // LANGUAGE TEST
      // ======================================================

      languageTestName:
      _firstNonEmpty([
        json['language_test_name'],
        json['language_test'],
      ]),

      languageTestScore:
      _firstNonEmpty([
        json['language_test_score'],
        json['language_score'],
      ]),

      // ======================================================
      // JOINED DATE
      // ======================================================

      joinedDate:
      _formatJoinedDate(
        json['created_at'],
      ),

      // ======================================================
      // VISA / FLIGHT
      // ======================================================

      visaStatus:
      _firstNonEmpty([
        json['visa_status'],
        json['visa_status_update'],
      ]).isNotEmpty
          ? _firstNonEmpty([
        json['visa_status'],
        json['visa_status_update'],
      ])
          : 'Not Started',

      flightStatus:
      _firstNonEmpty([
        json['flight_status'],
        json['ticket_status'],
      ]).isNotEmpty
          ? _firstNonEmpty([
        json['flight_status'],
        json['ticket_status'],
      ])
          : 'Not booked',

      // ======================================================
      // PROCESS
      // ======================================================

      currentStep:
      currentStep,

      completedSteps:
      completedSteps,

      status:
      isActive == true
          ? StudentStatus.active
          : StudentStatus.pending,

      processCompleted:
      json['process_completed'] == true,

      // ======================================================
      // IMPORTANT:
      // USE REAL BACKEND DOCUMENTS
      // ======================================================

      documents:
      documents,

      // ======================================================
      // STEP 4
      // ======================================================

      interviewDate:
      _parseDate(
        json['interview_date'],
      ),

      interviewMode:
      json['interview_mode']
          ?.toString(),

      interviewResult:
      json['interview_result']
          ?.toString(),

      interviewNotes:
      json['interview_notes']
          ?.toString(),

      // ======================================================
      // STEP 5
      // ======================================================

      applicationRefNo:
      json['application_ref_no']
          ?.toString(),

      submissionDate:
      _parseDate(
        json['submission_date'],
      ),

      confirmationFileName:
      json['confirmation_file']
          ?.toString(),

      // ======================================================
      // STEP 6
      // ======================================================

      offerFileName:
      json['offer_file']
          ?.toString(),

      offerType:
      json['offer_type']
          ?.toString(),

      offerExpiryDate:
      _parseDate(
        json['offer_expiry_date'],
      ),

      // ======================================================
      // STEP 7
      // ======================================================

      locFileName:
      json['loc_file']
          ?.toString(),

      locVerified:
      json['loc_verified'] == true,

      // ======================================================
      // STEP 8
      // ======================================================

      courseCommencementDate:
      _parseDate(
        json['course_commencement_date'],
      ),

      scholarshipStatus:
      json['scholarship_status']
          ?.toString(),

      finalSelectionNotes:
      json['final_selection_notes']
          ?.toString(),

      finalSelectionConfirmed:
      json['final_selection_confirmed'] ==
          true,

      // ======================================================
      // STEP 9
      // ======================================================

      visaRefNo:
      json['visa_ref_no']
          ?.toString(),

      visaStatusUpdate:
      json['visa_status_update']
          ?.toString(),

      visaApprovalLetterFileName:
      json['visa_approval_letter_file']
          ?.toString(),

      // ======================================================
      // STEP 10
      // ======================================================

      flightNumber:
      json['flight_number']
          ?.toString(),

      airline:
      json['airline']
          ?.toString(),

      departureAirport:
      json['departure_airport']
          ?.toString(),

      arrivalAirport:
      json['arrival_airport']
          ?.toString(),

      departureDateTime:
      _parseDate(
        json['departure_date_time'],
      ),

      ticketFileName:
      json['ticket_file']
          ?.toString(),
    );
  }

  // ==========================================================
  // FIRST NON-EMPTY VALUE
  // ==========================================================

  static String _firstNonEmpty(
      List<dynamic> values,
      ) {
    for (final value in values) {
      if (value == null) {
        continue;
      }

      final text =
      value.toString().trim();

      if (text.isNotEmpty) {
        return text;
      }
    }

    return '';
  }

  // ==========================================================
  // DATE PARSER
  // ==========================================================

  static DateTime? _parseDate(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final text =
    value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return DateTime.tryParse(text);
  }

  // ==========================================================
  // JOINED DATE FORMAT
  // ==========================================================

  static String _formatJoinedDate(
      dynamic value,
      ) {
    if (value == null) {
      return '';
    }

    try {
      final date =
      DateTime.parse(
        value.toString(),
      );

      return '${_monthName(date.month)} '
          '${date.day.toString().padLeft(2, '0')}, '
          '${date.year}';
    } catch (_) {
      return value.toString();
    }
  }

  // ==========================================================
  // MONTH NAME
  // ==========================================================

  static String _monthName(
      int month,
      ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (month < 1 ||
        month > 12) {
      return '';
    }

    return months[month - 1];
  }
}

/// ============================================================
/// ADMIN DEMO / FALLBACK DOCUMENT DATA
/// ============================================================

List<RequiredDocument> _seedDocs(
    int uploadedCount,
    ) {
  return RequiredDocumentsCatalog.seed
      .asMap()
      .entries
      .map(
        (entry) => entry.value.copyWith(
      uploaded:
      entry.key < uploadedCount,
    ),
  )
      .toList();
}

/// ============================================================
/// ADMIN STUDENTS CATALOG
///
/// Kept because existing Admin screens/controllers may still
/// reference StudentsCatalog.seed.
/// ============================================================

class StudentsCatalog {
  StudentsCatalog._();

  static final List<StudentRecord> seed = [
    StudentRecord(
      id: 's1',
      processId: null,
      name: 'Arjun Sharma',
      email: 'arjun.sharma@gmail.com',
      phone: '+977 9876543210',
      role: 'student',
      countryCode: 'AU',
      countryName: 'Australia',
      university: 'Univ. of Melbourne',
      course: 'Data Science & AI',
      gpa: '3.7',
      degree: 'Masters',
      passoutYear: '2023',
      languageTestName: 'IELTS',
      languageTestScore: '7.0',
      joinedDate: 'Jan 12, 2024',
      visaStatus: 'Not Started',
      flightStatus: 'Not booked',
      currentStep: 5,
      documents: _seedDocs(4),
      status: StudentStatus.active,
    ),

    StudentRecord(
      id: 's2',
      processId: null,
      name: 'Meera Patel',
      email: 'meera.patel@gmail.com',
      phone: '+977 9123456780',
      role: 'student',
      countryCode: 'GB',
      countryName: 'United Kingdom',
      university: 'University of Leeds',
      course: 'International Business',
      gpa: '3.9',
      degree: 'Bachelors',
      passoutYear: '2024',
      languageTestName: 'IELTS',
      languageTestScore: '7.5',
      joinedDate: 'Nov 03, 2023',
      visaStatus: 'Approved',
      flightStatus: 'Booked',
      currentStep: 9,
      documents: _seedDocs(6),
      status: StudentStatus.approved,
    ),

    StudentRecord(
      id: 's3',
      processId: null,
      name: 'Rahul Gupta',
      email: 'rahul.gupta@gmail.com',
      phone: '+977 9988766554',
      role: 'student',
      countryCode: 'CA',
      countryName: 'Canada',
      university: 'University of Toronto',
      course: 'Computer Science',
      gpa: '3.5',
      degree: 'Masters',
      passoutYear: '2022',
      languageTestName: 'IELTS',
      languageTestScore: '6.5',
      joinedDate: 'Feb 20, 2024',
      visaStatus: 'Not Started',
      flightStatus: 'Not booked',
      currentStep: 4,
      documents: _seedDocs(2),
      status: StudentStatus.pending,
    ),

    StudentRecord(
      id: 's4',
      processId: null,
      name: 'Sneha Shrestha',
      email: 'sneha.shrestha@gmail.com',
      phone: '+977 90909 12345',
      role: 'student',
      countryCode: 'KR',
      countryName: 'South Korea',
      university: 'SNU',
      course: 'Mechanical Engineering',
      gpa: '3.6',
      degree: 'Masters',
      passoutYear: '2023',
      languageTestName: 'TOPIK',
      languageTestScore: '5',
      joinedDate: 'Dec 15, 2023',
      visaStatus: 'Processing',
      flightStatus: 'Not booked',
      currentStep: 6,
      documents: _seedDocs(5),
      status: StudentStatus.active,
    ),

    StudentRecord(
      id: 's5',
      processId: null,
      name: 'Karan Shah',
      email: 'karan.shah@gmail.com',
      phone: '+977 9345678901',
      role: 'student',
      countryCode: 'US',
      countryName: 'United States',
      university: 'Northeastern Univ.',
      course: 'Data Analytics',
      gpa: '3.4',
      degree: 'Bachelors',
      passoutYear: '2024',
      languageTestName: 'IELTS',
      languageTestScore: '6.0',
      joinedDate: 'Jan 28, 2024',
      visaStatus: 'Not Started',
      flightStatus: 'Not booked',
      currentStep: 7,
      documents: _seedDocs(3),
      status: StudentStatus.rejected,
    ),

    StudentRecord(
      id: 's6',
      processId: null,
      name: 'Priya Nair',
      email: 'priya.nair@gmail.com',
      phone: '+977 9654321098',
      role: 'student',
      countryCode: 'JP',
      countryName: 'Japan',
      university: 'Kyoto University',
      course: 'Environmental Science',
      gpa: '3.6',
      degree: 'Masters',
      passoutYear: '2023',
      languageTestName: 'IELTS',
      languageTestScore: '7.0',
      joinedDate: 'Sep 14, 2023',
      visaStatus: 'Approved',
      flightStatus: 'Booked',
      currentStep: 8,
      documents: _seedDocs(6),
      status: StudentStatus.active,
    ),
  ];
}

/// ============================================================
/// UBT STUDENT DOCUMENT
/// ============================================================

class StudentDocument {
  final String name;
  final String field;
  final String url;

  const StudentDocument({
    required this.name,
    required this.field,
    required this.url,
  });

  factory StudentDocument.fromJson(
      Map<String, dynamic> json,
      ) {
    return StudentDocument(
      name:
      json['name']?.toString() ??
          'Document',

      field:
      json['field']?.toString() ??
          '',

      url:
      json['url']?.toString() ??
          '',
    );
  }

  bool get isAvailable {
    return url.trim().isNotEmpty;
  }
}

/// ============================================================
/// UBT STUDENT
///
/// This model is ONLY for UBT student management.
///
/// Do not use this in Admin StudentsController.
/// ============================================================

class UbtStudent {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final List<StudentDocument> documents;

  const UbtStudent({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    this.documents = const [],
  });

  factory UbtStudent.fromJson(
      Map<String, dynamic> json,
      ) {
    // ========================================================
    // USER DATA
    // ========================================================

    final userJson =
    json['user'] is Map
        ? Map<String, dynamic>.from(
      json['user'] as Map,
    )
        : <String, dynamic>{};

    // ========================================================
    // FIRST NAME
    // ========================================================

    final firstName =
    _firstNonEmptyStatic([
      json['first_name'],
      userJson['first_name'],
    ]);

    // ========================================================
    // LAST NAME
    // ========================================================

    final lastName =
    _firstNonEmptyStatic([
      json['last_name'],
      userJson['last_name'],
    ]);

    // ========================================================
    // API FULL NAME
    // ========================================================

    final apiFullName =
    _firstNonEmptyStatic([
      json['full_name'],
      userJson['full_name'],
    ]);

    final calculatedName =
    '$firstName $lastName'.trim();

    // ========================================================
    // DOCUMENTS
    // ========================================================

    final documentsJson =
    json['documents'];

    final documents =
    <StudentDocument>[];

    if (documentsJson is List) {
      for (final item in documentsJson) {
        if (item is Map) {
          final document =
          StudentDocument.fromJson(
            Map<String, dynamic>.from(item),
          );

          if (document.url
              .trim()
              .isNotEmpty) {
            documents.add(document);
          }
        }
      }
    }

    // ========================================================
    // RETURN
    // ========================================================

    return UbtStudent(
      id:
      json['id']?.toString() ??
          '',

      fullName:
      apiFullName.isNotEmpty
          ? apiFullName
          : calculatedName.isNotEmpty
          ? calculatedName
          : _firstNonEmptyStatic([
        json['username'],
        userJson['username'],
      ]),

      phone:
      _firstNonEmptyStatic([
        json['phone_number'],
        json['phone'],
        userJson['phone_number'],
        userJson['phone'],
      ]),

      email:
      _firstNonEmptyStatic([
        json['email'],
        userJson['email'],
      ]),

      documents:
      documents,
    );
  }

  UbtStudent copyWith({
    String? fullName,
    String? phone,
    String? email,
    List<StudentDocument>? documents,
  }) {
    return UbtStudent(
      id: id,

      fullName:
      fullName ??
          this.fullName,

      phone:
      phone ??
          this.phone,

      email:
      email ??
          this.email,

      documents:
      documents ??
          this.documents,
    );
  }

  // ==========================================================
  // INITIALS
  // ==========================================================

  String get initials {
    final name =
    fullName.trim();

    if (name.isEmpty) {
      return '?';
    }

    final parts =
    name.split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts.first
          .substring(
        0,
        parts.first.length >= 2
            ? 2
            : 1,
      )
          .toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'
        .toUpperCase();
  }
}

/// ============================================================
/// STATIC HELPER FOR UBT STUDENT
/// ============================================================

String _firstNonEmptyStatic(
    List<dynamic> values,
    ) {
  for (final value in values) {
    if (value == null) {
      continue;
    }

    final text =
    value.toString().trim();

    if (text.isNotEmpty) {
      return text;
    }
  }

  return '';
}