import 'package:flutter/material.dart';

class RequiredDocument {
  final String id;
  final String title;
  final IconData icon;
  final Color accentColor;
  final bool uploaded;
  final String? filePath;

  const RequiredDocument({
    required this.id,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.uploaded,
    this.filePath,
  });

  RequiredDocument copyWith({bool? uploaded, String? filePath}) {
    return RequiredDocument(
      id: id,
      title: title,
      icon: icon,
      accentColor: accentColor,
      uploaded: uploaded ?? this.uploaded,
      filePath: filePath ?? this.filePath,
    );
  }

  String get fileName => '${id}.pdf';
}

class RequiredDocumentsCatalog {
  RequiredDocumentsCatalog._();

  static const List<RequiredDocument> seed = [
    RequiredDocument(
      id: 'passport',
      title: 'Passport',
      icon: Icons.badge_outlined,
      accentColor: Color(0xFF2563EB),
      uploaded: true,
    ),
    RequiredDocument(
      id: 'academic_certificate',
      title: 'Academic Certificate',
      icon: Icons.school_outlined,
      accentColor: Color(0xFF6B7280),
      uploaded: true,
    ),
    RequiredDocument(
      id: 'transcript',
      title: 'Transcript',
      icon: Icons.description_outlined,
      accentColor: Color(0xFF6B7280),
      uploaded: false,
    ),
    RequiredDocument(
      id: 'language_certificate',
      title: 'Language Certificate',
      icon: Icons.public_outlined,
      accentColor: Color(0xFF2563EB),
      uploaded: true,
    ),
    RequiredDocument(
      id: 'statement_of_purpose',
      title: 'Statement of Purpose',
      icon: Icons.edit_note_outlined,
      accentColor: Color(0xFFF59E0B),
      uploaded: false,
    ),
    RequiredDocument(
      id: 'recommendation_letter',
      title: 'Recommendation Letter',
      icon: Icons.mail_outline_rounded,
      accentColor: Color(0xFFDC2626),
      uploaded: false,
    ),
  ];
}