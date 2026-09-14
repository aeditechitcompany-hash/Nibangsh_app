import 'package:flutter/material.dart';

class RequiredDocument {
  final String id;
  final String title;
  final IconData icon;
  final Color accentColor;
  final bool uploaded;
  final bool required;
  final String? filePath;

  factory RequiredDocument.fromBackendJson(
      Map<String, dynamic> json,
      ) {
    final field = json['field']?.toString() ?? '';
    final url = json['url']?.toString();

    switch (field) {
      case 'step1_photo':
        return RequiredDocument(
          id: 'photo',
          title: 'Passport Photo',
          icon: Icons.badge_outlined,
          accentColor: const Color(0xFF2563EB),
          uploaded: url != null && url.isNotEmpty,
          required: true,
          filePath: url,
        );

      case 'transcript_file':
        return RequiredDocument(
          id: 'transcript',
          title: 'Transcript',
          icon: Icons.picture_as_pdf_outlined,
          accentColor: const Color(0xFFDC2626),
          uploaded: url != null && url.isNotEmpty,
          required: true,
          filePath: url,
        );

      case 'confirmation_file':
        return RequiredDocument(
          id: 'confirmation',
          title: 'Confirmation File',
          icon: Icons.description_outlined,
          accentColor: const Color(0xFF16A34A),
          uploaded: url != null && url.isNotEmpty,
          required: false,
          filePath: url,
        );

      case 'offer_file':
        return RequiredDocument(
          id: 'offer',
          title: 'Offer Letter',
          icon: Icons.school_outlined,
          accentColor: const Color(0xFFF59E0B),
          uploaded: url != null && url.isNotEmpty,
          required: false,
          filePath: url,
        );

      case 'loc_file':
        return RequiredDocument(
          id: 'loc',
          title: 'Letter of Confirmation',
          icon: Icons.mark_email_read_outlined,
          accentColor: const Color(0xFF7C3AED),
          uploaded: url != null && url.isNotEmpty,
          required: false,
          filePath: url,
        );

      case 'visa_approval_letter_file':
        return RequiredDocument(
          id: 'visa',
          title: 'Visa Approval Letter',
          icon: Icons.airplane_ticket_outlined,
          accentColor: const Color(0xFF2563EB),
          uploaded: url != null && url.isNotEmpty,
          required: false,
          filePath: url,
        );

      case 'ticket_file':
        return RequiredDocument(
          id: 'ticket',
          title: 'Flight Ticket',
          icon: Icons.flight_takeoff_outlined,
          accentColor: const Color(0xFF0891B2),
          uploaded: url != null && url.isNotEmpty,
          required: false,
          filePath: url,
        );

      default:
        return RequiredDocument(
          id: field,
          title: json['name']?.toString() ?? field,
          icon: Icons.insert_drive_file_outlined,
          accentColor: const Color(0xFF64748B),
          uploaded: url != null && url.isNotEmpty,
          required: false,
          filePath: url,
        );
    }
  }

  const RequiredDocument({
    required this.id,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.uploaded,
    required this.required,
    this.filePath,
  });

  RequiredDocument copyWith({
    bool? uploaded,
    String? filePath,
    bool clearFilePath = false,
  }) {
    return RequiredDocument(
      id: id,
      title: title,
      icon: icon,
      accentColor: accentColor,
      uploaded: uploaded ?? this.uploaded,
      required: required,
      filePath: clearFilePath
          ? null
          : (filePath ?? this.filePath),
    );
  }

  String get fileName {
    switch (id) {
      case 'photo':
        return 'Passport Photo';

      case 'confirmation':
        return 'Confirmation File';

      case 'offer':
        return 'Offer Letter';

      case 'loc':
        return 'Letter of Confirmation';

      case 'visa':
        return 'Visa Approval Letter';

      case 'ticket':
        return 'Flight Ticket';

      default:
        return '$id.pdf';
    }
  }
}

class RequiredDocumentsCatalog {
  RequiredDocumentsCatalog._();

  static const List<RequiredDocument> seed = [
    RequiredDocument(
      id: 'photo',
      title: 'Passport Photo',
      icon: Icons.badge_outlined,
      accentColor: Color(0xFF2563EB),
      uploaded: false,
      required: true,
    ),

    RequiredDocument(
      id: 'confirmation',
      title: 'Confirmation File',
      icon: Icons.description_outlined,
      accentColor: Color(0xFF16A34A),
      uploaded: false,
      required: false,
    ),

    RequiredDocument(
      id: 'offer',
      title: 'Offer Letter',
      icon: Icons.school_outlined,
      accentColor: Color(0xFFF59E0B),
      uploaded: false,
      required: false,
    ),

    RequiredDocument(
      id: 'loc',
      title: 'Letter of Confirmation',
      icon: Icons.mark_email_read_outlined,
      accentColor: Color(0xFF7C3AED),
      uploaded: false,
      required: false,
    ),

    RequiredDocument(
      id: 'visa',
      title: 'Visa Approval Letter',
      icon: Icons.airplane_ticket_outlined,
      accentColor: Color(0xFF2563EB),
      uploaded: false,
      required: false,
    ),

    RequiredDocument(
      id: 'ticket',
      title: 'Flight Ticket',
      icon: Icons.flight_takeoff_outlined,
      accentColor: Color(0xFF0891B2),
      uploaded: false,
      required: false,
    ),
  ];
}