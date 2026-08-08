class McqQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? audioFileName;
  final String? audioFilePath;
  final String? questionImagePath;
  final List<String>? optionImagePaths;
  final List<String>? optionAudioPaths;
  final String? setName;
  final DateTime createdAt;

  McqQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.audioFileName,
    this.audioFilePath,
    this.questionImagePath,
    this.optionImagePaths,
    this.optionAudioPaths,
    this.setName,
    required this.createdAt,
  });

  bool get hasAudio =>
      audioFilePath != null && audioFilePath!.trim().isNotEmpty;
  bool get hasQuestionImage =>
      questionImagePath != null && questionImagePath!.trim().isNotEmpty;
  bool get hasOptionImages =>
      optionImagePaths != null && optionImagePaths!.any((p) => p.trim().isNotEmpty);
  bool get hasOptionAudios =>
      optionAudioPaths != null && optionAudioPaths!.any((p) => p.trim().isNotEmpty);

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
    String? question,
    List<String>? options,
    int? correctOptionIndex,
    String? audioFileName,
    String? audioFilePath,
    String? questionImagePath,
    List<String>? optionImagePaths,
    List<String>? optionAudioPaths,
    String? setName,
    bool clearAudio = false,
  }) {
    return McqQuestion(
      id: id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      audioFileName: clearAudio ? null : (audioFileName ?? this.audioFileName),
      audioFilePath: clearAudio ? null : (audioFilePath ?? this.audioFilePath),
      questionImagePath: questionImagePath ?? this.questionImagePath,
      optionImagePaths: optionImagePaths ?? this.optionImagePaths,
      optionAudioPaths: optionAudioPaths ?? this.optionAudioPaths,
      setName: setName ?? this.setName,
      createdAt: createdAt,
    );
  }
}