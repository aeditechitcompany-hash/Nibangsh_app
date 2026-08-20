import 'package:flutter/material.dart';
import '../../../common/models/application_step_model.dart';
import '../../../common/models/required_document.dart';

enum StudentStatus { active, pending, approved, rejected }

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

class StudentRecord {
  final String id;
  final String name;
  final String email;
  final String phone;
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

  // Real per-document upload state (admin can attach/replace a file for
  // each required document). documentsUploaded/documentsTotal below are
  // derived from this so every screen that shows a count stays in sync.
  final List<RequiredDocument> documents;

  int get documentsUploaded => documents.where((d) => d.uploaded).length;
  int get documentsTotal => documents.length;

  // Step 4
  final DateTime? interviewDate;
  final String? interviewMode;
  final String? interviewResult;
  final String? interviewNotes;

  // Step 5
  final String? applicationRefNo;
  final DateTime? submissionDate;
  final String? confirmationFileName;

  // Step 6
  final String? offerFileName;
  final String? offerType;
  final DateTime? offerExpiryDate;

  // Step 7
  final String? locFileName;
  final bool locVerified;

  // Step 8
  final DateTime? courseCommencementDate;
  final String? scholarshipStatus;
  final String? finalSelectionNotes;
  final bool finalSelectionConfirmed;

  // Step 9
  final String? visaRefNo;
  final String? visaStatusUpdate;
  final String? visaApprovalLetterFileName;

  // Step 10
  final String? flightNumber;
  final String? airline;
  final String? departureAirport;
  final String? arrivalAirport;
  final DateTime? departureDateTime;
  final String? ticketFileName;

  const StudentRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
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
  });

  static int get totalSteps => ApplicationStepsCatalog.definitions.length;

  String get currentStepTitle {
    final index = (currentStep - 1).clamp(
      0,
      ApplicationStepsCatalog.definitions.length - 1,
    );
    return ApplicationStepsCatalog.definitions[index]['title'] as String;
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  StudentRecord copyWith({
    String? name,
    String? email,
    String? phone,
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
  }) {
    return StudentRecord(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      university: university ?? this.university,
      course: course ?? this.course,
      gpa: gpa ?? this.gpa,
      degree: degree ?? this.degree,
      passoutYear: passoutYear ?? this.passoutYear,
      languageTestName: languageTestName ?? this.languageTestName,
      languageTestScore: languageTestScore ?? this.languageTestScore,
      joinedDate: joinedDate,
      visaStatus: visaStatus ?? this.visaStatus,
      flightStatus: flightStatus ?? this.flightStatus,
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      documents: documents ?? this.documents,
      interviewDate: interviewDate ?? this.interviewDate,
      interviewMode: interviewMode ?? this.interviewMode,
      interviewResult: interviewResult ?? this.interviewResult,
      interviewNotes: interviewNotes ?? this.interviewNotes,
      applicationRefNo: applicationRefNo ?? this.applicationRefNo,
      submissionDate: submissionDate ?? this.submissionDate,
      confirmationFileName: confirmationFileName ?? this.confirmationFileName,
      offerFileName: offerFileName ?? this.offerFileName,
      offerType: offerType ?? this.offerType,
      offerExpiryDate: offerExpiryDate ?? this.offerExpiryDate,
      locFileName: locFileName ?? this.locFileName,
      locVerified: locVerified ?? this.locVerified,
      courseCommencementDate:
          courseCommencementDate ?? this.courseCommencementDate,
      scholarshipStatus: scholarshipStatus ?? this.scholarshipStatus,
      finalSelectionNotes: finalSelectionNotes ?? this.finalSelectionNotes,
      finalSelectionConfirmed:
          finalSelectionConfirmed ?? this.finalSelectionConfirmed,
      visaRefNo: visaRefNo ?? this.visaRefNo,
      visaStatusUpdate: visaStatusUpdate ?? this.visaStatusUpdate,
      visaApprovalLetterFileName:
          visaApprovalLetterFileName ?? this.visaApprovalLetterFileName,
      flightNumber: flightNumber ?? this.flightNumber,
      airline: airline ?? this.airline,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      departureDateTime: departureDateTime ?? this.departureDateTime,
      ticketFileName: ticketFileName ?? this.ticketFileName,
    );
  }

  factory StudentRecord.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name'] ?? '';
    final lastName = json['last_name'] ?? '';

    final fullName = '$firstName $lastName'.trim();

    final isActive = json['is_active_student'] ?? true;

    return StudentRecord(
      id: json['id'].toString(),

      name: fullName.isNotEmpty
          ? fullName
          : (json['username'] ?? 'Unknown Student'),

      email: json['email'] ?? '',

      phone: json['phone_number'] ?? '',

      // These don't exist in accounts_user yet.
      countryCode: '',
      countryName: '',

      university: '',
      course: '',
      gpa: '',
      degree: '',
      passoutYear: '',

      languageTestName: '',
      languageTestScore: '',

      joinedDate: _formatJoinedDate(json['created_at']),

      visaStatus: 'Not Started',
      flightStatus: 'Not booked',

      currentStep: 1,

      status: isActive
          ? StudentStatus.active
          : StudentStatus.pending,

      documents: RequiredDocumentsCatalog.seed,

      interviewDate: null,
      interviewMode: null,
      interviewResult: null,
      interviewNotes: null,

      applicationRefNo: null,
      submissionDate: null,
      confirmationFileName: null,

      offerFileName: null,
      offerType: null,
      offerExpiryDate: null,

      locFileName: null,
      locVerified: false,

      courseCommencementDate: null,
      scholarshipStatus: null,
      finalSelectionNotes: null,
      finalSelectionConfirmed: false,

      visaRefNo: null,
      visaStatusUpdate: null,
      visaApprovalLetterFileName: null,

      flightNumber: null,
      airline: null,
      departureAirport: null,
      arrivalAirport: null,
      departureDateTime: null,
      ticketFileName: null,
    );
  }

  static String _formatJoinedDate(dynamic value) {
    if (value == null) return '';

    try {
      final date = DateTime.parse(value.toString());

      return '${_monthName(date.month)} '
          '${date.day.toString().padLeft(2, '0')}, '
          '${date.year}';
    } catch (_) {
      return value.toString();
    }
  }

  static String _monthName(int month) {
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

    return months[month - 1];
  }
}

// Builds a per-student copy of the required-documents catalog, marking the
// first [uploadedCount] of them as already uploaded (just for seed/demo
// data). Admin can then upload/replace any of these from the student
// profile screen, which is real per-document state from here on.

List<RequiredDocument> _seedDocs(int uploadedCount) {
  return RequiredDocumentsCatalog.seed
      .asMap()
      .entries
      .map((e) => e.value.copyWith(uploaded: e.key < uploadedCount))
      .toList();
}

class StudentsCatalog {
  StudentsCatalog._();

  static final List<StudentRecord> seed = [
    StudentRecord(
      id: 's1',
      name: 'Arjun Sharma',
      email: 'arjun.sharma@gmail.com',
      phone: '+977 9876543210',
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
      name: 'Meera Patel',
      email: 'meera.patel@gmail.com',
      phone: '+977 9123456780',
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
      name: 'Rahul Gupta',
      email: 'rahul.gupta@gmail.com',
      phone: '+977 9988766554',
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
      name: 'Sneha Shrestha',
      email: 'sneha.shrestha@gmail.com',
      phone: '+977 90909 12345',
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
      name: 'Karan Shah',
      email: 'karan.shah@gmail.com',
      phone: '+977 9345678901',
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
      name: 'Priya Nair',
      email: 'priya.nair@gmail.com',
      phone: '+977 9654321098',
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
