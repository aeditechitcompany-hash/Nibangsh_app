import 'package:flutter/material.dart';

class RequiredDocument {
  final String id;
  final String title;
  final IconData icon;
  final Color accentColor;
  final bool uploaded;
  final bool required;

  /// Local file path selected on the device.
  final String? filePath;

  /// Remote URL returned by Django/Supabase.
  final String? fileUrl;

  const RequiredDocument({
    required this.id,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.uploaded,
    required this.required,
    this.filePath,
    this.fileUrl,
  });

  factory RequiredDocument.fromBackendJson(
      Map<String, dynamic> json,
      ) {
    final field = json['field']?.toString() ?? '';
    final url = json['url']?.toString().trim();

    final hasUrl = url != null && url.isNotEmpty;

    RequiredDocument build({
      required String id,
      required String title,
      required IconData icon,
      required Color accentColor,
      required bool required,
    }) {
      return RequiredDocument(
        id: id,
        title: title,
        icon: icon,
        accentColor: accentColor,
        uploaded: hasUrl,
        required: required,
        fileUrl: hasUrl ? url : null,
      );
    }

    switch (field) {
      case 'step1_photo':
        return build(
          id: 'photo',
          title: 'Passport Photo',
          icon: Icons.badge_outlined,
          accentColor: const Color(0xFF2563EB),
          required: true,
        );

      case 'transcript_file':
        return build(
          id: 'transcript',
          title: 'Transcript',
          icon: Icons.picture_as_pdf_outlined,
          accentColor: const Color(0xFFDC2626),
          required: true,
        );

      case 'confirmation_file':
        return build(
          id: 'confirmation',
          title: 'Confirmation File',
          icon: Icons.description_outlined,
          accentColor: const Color(0xFF16A34A),
          required: false,
        );

      case 'offer_file':
        return build(
          id: 'offer',
          title: 'Offer Letter',
          icon: Icons.school_outlined,
          accentColor: const Color(0xFFF59E0B),
          required: false,
        );

      case 'loc_file':
        return build(
          id: 'loc',
          title: 'Letter of Confirmation',
          icon: Icons.mark_email_read_outlined,
          accentColor: const Color(0xFF7C3AED),
          required: false,
        );

      case 'visa_approval_letter_file':
        return build(
          id: 'visa',
          title: 'Visa Approval Letter',
          icon: Icons.airplane_ticket_outlined,
          accentColor: const Color(0xFF2563EB),
          required: false,
        );

      case 'ticket_file':
        return build(
          id: 'ticket',
          title: 'Flight Ticket',
          icon: Icons.flight_takeoff_outlined,
          accentColor: const Color(0xFF0891B2),
          required: false,
        );

      default:
        return RequiredDocument(
          id: field,
          title: json['name']?.toString() ?? field,
          icon: Icons.insert_drive_file_outlined,
          accentColor: const Color(0xFF64748B),
          uploaded: hasUrl,
          required: false,
          fileUrl: hasUrl ? url : null,
        );
    }
  }

  RequiredDocument copyWith({
    bool? uploaded,
    String? filePath,
    String? fileUrl,
    bool clearFilePath = false,
    bool clearFileUrl = false,
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
      fileUrl: clearFileUrl
          ? null
          : (fileUrl ?? this.fileUrl),
    );
  }

  bool get hasRemoteFile {
    return fileUrl != null && fileUrl!.trim().isNotEmpty;
  }

  bool get hasLocalFile {
    return filePath != null && filePath!.trim().isNotEmpty;
  }

  String get fileName {
    switch (id) {
      case 'photo':
        return 'Passport Photo';
      case 'transcript':
        return 'Transcript';
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
      id: 'transcript',
      title: 'Transcript',
      icon: Icons.picture_as_pdf_outlined,
      accentColor: Color(0xFFDC2626),
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