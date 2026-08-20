class McqQuestion {
  final String id;
  final String question;
  final List<String> options;

  // Backend students do NOT receive the correct answer.
  // This can remain null for backend questions.
  final int? correctOptionIndex;

  final String? audioFileName;
  final String? audioFilePath;
  final String? questionImagePath;
  final List<String>? optionImagePaths;
  final List<String>? optionAudioPaths;
  final String? setName;
  final DateTime createdAt;

  // Backend IDs for submitting answers.
  final String? questionSetId;
  final List<String>? optionIds;

  McqQuestion({
    required this.id,
    required this.question,
    required this.options,
    this.correctOptionIndex,
    this.audioFileName,
    this.audioFilePath,
    this.questionImagePath,
    this.optionImagePaths,
    this.optionAudioPaths,
    this.setName,
    required this.createdAt,
    this.questionSetId,
    this.optionIds,
  });

  bool get hasAudio =>
      audioFilePath != null &&
      audioFilePath!.trim().isNotEmpty;

  bool get hasQuestionImage =>
      questionImagePath != null &&
      questionImagePath!.trim().isNotEmpty;

  bool get hasOptionImages =>
      optionImagePaths != null &&
      optionImagePaths!.any(
        (p) => p.trim().isNotEmpty,
      );

  bool get hasOptionAudios =>
      optionAudioPaths != null &&
      optionAudioPaths!.any(
        (p) => p.trim().isNotEmpty,
      );

  bool hasOptionImageAt(int index) =>
      hasOptionImages &&
      index >= 0 &&
      index < (optionImagePaths?.length ?? 0) &&
      optionImagePaths![index].trim().isNotEmpty;

  bool hasOptionAudioAt(int index) =>
      hasOptionAudios &&
      index >= 0 &&
      index < (optionAudioPaths?.length ?? 0) &&
      optionAudioPaths![index].trim().isNotEmpty;

McqQuestion copyWith({
  String? id,
  String? question,
  List<String>? options,
  int? correctOptionIndex,
  String? audioFileName,
  String? audioFilePath,
  String? questionImagePath,
  List<String>? optionImagePaths,
  List<String>? optionAudioPaths,
  String? setName,
  DateTime? createdAt,
}) {
  return McqQuestion(
    id: id ?? this.id,
    question: question ?? this.question,
    options: options ?? this.options,
    correctOptionIndex:
        correctOptionIndex ?? this.correctOptionIndex,
    audioFileName:
        audioFileName ?? this.audioFileName,
    audioFilePath:
        audioFilePath ?? this.audioFilePath,
    questionImagePath:
        questionImagePath ?? this.questionImagePath,
    optionImagePaths:
        optionImagePaths ?? this.optionImagePaths,
    optionAudioPaths:
        optionAudioPaths ?? this.optionAudioPaths,
    setName:
        setName ?? this.setName,
    createdAt:
        createdAt ?? this.createdAt,
  );
}
}