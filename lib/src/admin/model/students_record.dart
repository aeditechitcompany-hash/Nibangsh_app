import 'package:flutter/material.dart';
import '../../../common/models/application_step_model.dart';

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
        return const Color(0xFF78A0F8);
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
  final int documentsUploaded;
  final int documentsTotal;
  final StudentStatus status;

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
    required this.documentsUploaded,
    required this.documentsTotal,
    required this.status,
  });

  static int get totalSteps => ApplicationStepsCatalog.definitions.length;

  String get currentStepTitle {
    final index = (currentStep - 1).clamp(0, ApplicationStepsCatalog.definitions.length - 1);
    return ApplicationStepsCatalog.definitions[index]['title'] as String;
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}

class StudentsCatalog {
  StudentsCatalog._();

  static const List<StudentRecord> seed = [
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
      documentsUploaded: 4,
      documentsTotal: 6,
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
      documentsUploaded: 6,
      documentsTotal: 6,
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
      currentStep: 1,
      documentsUploaded: 2,
      documentsTotal: 6,
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
      documentsUploaded: 5,
      documentsTotal: 6,
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
      currentStep: 2,
      documentsUploaded: 3,
      documentsTotal: 6,
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
      documentsUploaded: 6,
      documentsTotal: 6,
      status: StudentStatus.active,
    ),
  ];
}