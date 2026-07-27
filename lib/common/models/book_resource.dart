class BookResource {
  final String id;
  final String title;
  final String description;
  final String fileName;
  final String filePath;
  final String fileSizeLabel;
  final DateTime uploadedAt;

  BookResource({
    required this.id,
    required this.title,
    required this.description,
    required this.fileName,
    required this.filePath,
    required this.fileSizeLabel,
    required this.uploadedAt,
  });

  BookResource copyWith({
    String? title,
    String? description,
    String? fileName,
    String? filePath,
    String? fileSizeLabel,
  }) {
    return BookResource(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileSizeLabel: fileSizeLabel ?? this.fileSizeLabel,
      uploadedAt: uploadedAt,
    );
  }
}