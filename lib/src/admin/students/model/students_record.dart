import 'package:flutter/material.dart';

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
        return const Color(0xFF2563EB);
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
  final String countryCode;
  final String countryName;
  final String gpa;
  final String degree;
  final String passoutYear;
  final int currentStep;
  final int totalSteps;
  final int documentsUploaded;
  final int documentsTotal;
  final StudentStatus status;

  const StudentRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.countryName,
    required this.gpa,
    required this.degree,
    required this.passoutYear,
    required this.currentStep,
    required this.totalSteps,
    required this.documentsUploaded,
    required this.documentsTotal,
    required this.status,
  });

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
      countryCode: 'AU',
      countryName: 'Australia',
      gpa: '3.7',
      degree: 'Masters',
      passoutYear: '2023',
      currentStep: 3,
      totalSteps: 10,
      documentsUploaded: 4,
      documentsTotal: 6,
      status: StudentStatus.rejected,
    ),
    StudentRecord(
      id: 's2',
      name: 'Meera Patel',
      email: 'meera.patel@gmail.com',
      countryCode: 'GB',
      countryName: 'United Kingdom',
      gpa: '3.9',
      degree: 'Bachelors',
      passoutYear: '2024',
      currentStep: 6,
      totalSteps: 10,
      documentsUploaded: 6,
      documentsTotal: 6,
      status: StudentStatus.approved,
    ),
    StudentRecord(
      id: 's3',
      name: 'Rahul Gupta',
      email: 'rahul.gupta@gmail.com',
      countryCode: 'CA',
      countryName: 'Canada',
      gpa: '3.5',
      degree: 'Masters',
      passoutYear: '2022',
      currentStep: 1,
      totalSteps: 10,
      documentsUploaded: 2,
      documentsTotal: 6,
      status: StudentStatus.pending,
    ),
    StudentRecord(
      id: 's4',
      name: 'Anjali Singh',
      email: 'anjali.singh@gmail.com',
      countryCode: 'US',
      countryName: 'United States',
      gpa: '3.8',
      degree: 'PHD',
      passoutYear: '2023',
      currentStep: 4,
      totalSteps: 10,
      documentsUploaded: 5,
      documentsTotal: 6,
      status: StudentStatus.active,
    ),
    StudentRecord(
      id: 's5',
      name: 'Karan Mehta',
      email: 'karan.mehta@gmail.com',
      countryCode: 'KR',
      countryName: 'South Korea',
      gpa: '3.4',
      degree: 'Bachelors',
      passoutYear: '2024',
      currentStep: 2,
      totalSteps: 10,
      documentsUploaded: 3,
      documentsTotal: 6,
      status: StudentStatus.rejected,
    ),
    StudentRecord(
      id: 's6',
      name: 'Priya Nair',
      email: 'priya.nair@gmail.com',
      countryCode: 'JP',
      countryName: 'Japan',
      gpa: '3.6',
      degree: 'Masters',
      passoutYear: '2023',
      currentStep: 5,
      totalSteps: 10,
      documentsUploaded: 6,
      documentsTotal: 6,
      status: StudentStatus.active,
    ),
  ];
}