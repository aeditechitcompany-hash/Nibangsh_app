import '../../../admin/model/students_record.dart';

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
    final firstName =
        json['first_name']?.toString().trim() ?? '';

    final lastName =
        json['last_name']?.toString().trim() ?? '';

    final apiFullName =
        json['full_name']?.toString().trim() ?? '';

    final calculatedName =
    '$firstName $lastName'.trim();

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

          if (document.url.trim().isNotEmpty) {
            documents.add(document);
          }
        }
      }
    }

    return UbtStudent(
      id: json['id']?.toString() ?? '',
      fullName: apiFullName.isNotEmpty
          ? apiFullName
          : calculatedName,
      phone:
      json['phone_number']?.toString().trim() ?? '',
      email:
      json['email']?.toString().trim() ?? '',
      documents: documents,
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
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      documents: documents ?? this.documents,
    );
  }

  String get initials {
    final name = fullName.trim();

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