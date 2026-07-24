class McqQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? audioFileName;
  final String? audioFilePath;
  final DateTime createdAt;

  McqQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.audioFileName,
    this.audioFilePath,
    required this.createdAt,
  });

  bool get hasAudio =>
      audioFilePath != null && audioFilePath!.trim().isNotEmpty;
}
