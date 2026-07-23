import 'package:flutter/material.dart';

enum StepStatus { done, active, pending }
enum StepOwner { user, admin }

class ApplicationStepModel {
  final int id;
  final String title;
  final String subtitle;
  final IconData icon;
  final StepOwner owner;
  final StepStatus status;

  const ApplicationStepModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.owner,
    required this.status,
  });

  ApplicationStepModel copyWith({String? subtitle, StepStatus? status}) {
    return ApplicationStepModel(
      id: id,
      title: title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon,
      owner: owner,
      status: status ?? this.status,
    );
  }
}

class ApplicationStepsCatalog {
  ApplicationStepsCatalog._();

  static const List<Map<String, dynamic>> definitions = [
    {
      'id': 1,
      'title': 'Transcript Upload',
      'subtitle': 'Marksheet / Transcript',
      'icon': Icons.upload_file_outlined,
      'owner': StepOwner.user,
    },
    {
      'id': 2,
      'title': 'Language Test',
      'subtitle': 'Select IELTS, Basic IELTS or TOPIK',
      'icon': Icons.menu_book_outlined,
      'owner': StepOwner.user,
    },
    {
      'id': 3,
      'title': 'All Documents Upload',
      'subtitle': 'Passport, certificates & other documents',
      'icon': Icons.folder_copy_outlined,
      'owner': StepOwner.user,
    },
    {
      'id': 4,
      'title': 'Interview',
      'subtitle': 'Consultation interview with our team',
      'icon': Icons.groups_outlined,
      'owner': StepOwner.admin,
    },
    {
      'id': 5,
      'title': 'Apply to University',
      'subtitle': 'Application submitted to your chosen university',
      'icon': Icons.account_balance_outlined,
      'owner': StepOwner.admin,
    },
    {
      'id': 6,
      'title': 'Offer Letter',
      'subtitle': 'Awaiting offer letter from the university',
      'icon': Icons.mail_outline_rounded,
      'owner': StepOwner.admin,
    },
    {
      'id': 7,
      'title': 'LOC Verify',
      'subtitle': 'Letter of confirmation verification',
      'icon': Icons.verified_outlined,
      'owner': StepOwner.admin,
    },
    {
      'id': 8,
      'title': 'Final Selection',
      'subtitle': 'Final confirmation of your admission',
      'icon': Icons.checklist_rtl_rounded,
      'owner': StepOwner.admin,
    },
    {
      'id': 9,
      'title': 'Visa Approval',
      'subtitle': 'Visa application & approval',
      'icon': Icons.badge_outlined,
      'owner': StepOwner.admin,
    },
    {
      'id': 10,
      'title': 'Flight Ticket',
      'subtitle': 'Book your flight and you\'re set to go',
      'icon': Icons.flight_takeoff_outlined,
      'owner': StepOwner.admin,
    },
  ];
}