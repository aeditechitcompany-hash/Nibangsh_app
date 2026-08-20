import '../api_services/api_constants.dart';

class BookResource {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final String pdfUrl;
  final String fileName;
  final String fileSizeLabel;
  final DateTime uploadedAt;

  BookResource({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.pdfUrl,
    required this.fileName,
    required this.fileSizeLabel,
    required this.uploadedAt,
  });

  factory BookResource.fromJson(
    Map<String, dynamic> json,
  ) {
    final pdf =
        json['pdf']?.toString() ?? '';

    final cover =
        json['cover']?.toString() ?? '';

    return BookResource(
      id: json['id']?.toString() ?? '',

      title:
          json['title']?.toString() ?? '',

      author:
          json['author']?.toString() ?? '',

      description:
          json['description']?.toString() ?? '',

      coverUrl:
          ApiConstants.mediaUrl(cover),

      pdfUrl:
          ApiConstants.mediaUrl(pdf),

      fileName: pdf.isNotEmpty
          ? pdf.split('/').last
          : '',

      fileSizeLabel: '',

      uploadedAt:
          DateTime.tryParse(
                json['created_at']
                    ?.toString() ??
                    '',
              ) ??
              DateTime.now(),
    );
  }

  BookResource copyWith({
    String? title,
    String? author,
    String? description,
    String? coverUrl,
    String? pdfUrl,
    String? fileName,
    String? fileSizeLabel,
  }) {
    return BookResource(
      id: id,

      title:
          title ?? this.title,

      author:
          author ?? this.author,

      description:
          description ?? this.description,

      coverUrl:
          coverUrl ?? this.coverUrl,

      pdfUrl:
          pdfUrl ?? this.pdfUrl,

      fileName:
          fileName ?? this.fileName,

      fileSizeLabel:
          fileSizeLabel ??
              this.fileSizeLabel,

      uploadedAt: uploadedAt,
    );
  }
}