import 'package:flutter/material.dart';

class QuizOption {
  final String? id;
  final String text;

  final String? image;
  final String? audio;

  final int order;

  QuizOption({
    this.id,
    this.text = '',
    this.image,
    this.audio,
    this.order = 0,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id']?.toString(),
      text: (json['text'] ?? '').toString(),
      image: json['image']?.toString(),
      audio: json['audio']?.toString(),
      order: _toInt(json['order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'image': image,
      'audio': audio,
      'order': order,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class QuizQuestion {
  final String? id;

  final String? question;

  final List<String> options;

  // Used only by the old/local hard-coded quiz catalog.
  // Database quizzes intentionally do NOT need to provide this value.
  final int? correctIndex;

  final String? imageAsset;
  final List<String>? optionImages;

  final String? audioAsset;
  final List<String>? optionAudios;

  // Database-backed options.
  final List<QuizOption> quizOptions;

  QuizQuestion({
    this.id,
    this.question,
    this.options = const [],
    this.correctIndex,
    this.imageAsset,
    this.optionImages,
    this.audioAsset,
    this.optionAudios,
    this.quizOptions = const [],
  }) : assert(
          (question != null && question != '') ||
              (imageAsset != null && imageAsset != '') ||
              (audioAsset != null && audioAsset != ''),
          'A QuizQuestion needs at least one of: question text, imageAsset, '
          'or audioAsset — it cannot be entirely empty.',
        ),
        assert(
          options.length > 0 ||
              quizOptions.length > 0 ||
              (optionImages != null && optionImages.length > 0) ||
              (optionAudios != null && optionAudios.length > 0),
          'A QuizQuestion needs at least one choice, via options, '
          'quizOptions, optionImages, and/or optionAudios.',
        ),
        assert(
          optionImages == null ||
              options.length == 0 ||
              options.length == optionImages.length,
          'options and optionImages must be the same length when both '
          'are provided — leave options empty for fully image-only choices.',
        ),
        assert(
          optionAudios == null ||
              options.length == 0 ||
              options.length == optionAudios.length,
          'options and optionAudios must be the same length when both '
          'are provided — leave options empty for fully audio-only choices.',
        ),
        assert(
          optionImages == null ||
              optionAudios == null ||
              optionImages.length == optionAudios.length,
          'optionImages and optionAudios must be the same length when both '
          'are provided.',
        );

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];

    final parsedOptions = rawOptions is List
        ? rawOptions
            .whereType<Map>()
            .map(
              (option) => QuizOption.fromJson(
                Map<String, dynamic>.from(option),
              ),
            )
            .toList()
        : <QuizOption>[];

    return QuizQuestion(
      id: json['id']?.toString(),
      question: json['text']?.toString(),
      imageAsset: json['image']?.toString(),
      audioAsset: json['audio']?.toString(),
      quizOptions: parsedOptions,
    );
  }

  bool get hasDatabaseId => id != null && id!.isNotEmpty;

  bool get hasDatabaseOptions => quizOptions.isNotEmpty;

  bool get hasQuestionText =>
      question != null && question!.trim().isNotEmpty;

  bool get hasImage =>
      imageAsset != null && imageAsset!.trim().isNotEmpty;

  bool get hasAudio =>
      audioAsset != null && audioAsset!.trim().isNotEmpty;

  bool get hasOptionImages =>
      optionImages != null && optionImages!.isNotEmpty;

  bool get hasOptionAudios =>
      optionAudios != null && optionAudios!.isNotEmpty;

  int get optionCount {
    if (quizOptions.isNotEmpty) {
      return quizOptions.length;
    }

    if (options.isNotEmpty) {
      return options.length;
    }

    return optionImages?.length ??
        optionAudios?.length ??
        0;
  }

  bool hasOptionTextAt(int index) {
    if (quizOptions.isNotEmpty) {
      return index >= 0 &&
          index < quizOptions.length &&
          quizOptions[index].text.trim().isNotEmpty;
    }

    return index >= 0 &&
        index < options.length &&
        options[index].trim().isNotEmpty;
  }

  bool hasOptionImageAt(int index) {
    if (quizOptions.isNotEmpty) {
      final image = quizOptions[index].image;

      return index >= 0 &&
          index < quizOptions.length &&
          image != null &&
          image.trim().isNotEmpty;
    }

    return hasOptionImages &&
        index >= 0 &&
        index < optionImages!.length &&
        optionImages![index].trim().isNotEmpty;
  }

  bool hasOptionAudioAt(int index) {
    if (quizOptions.isNotEmpty) {
      final audio = quizOptions[index].audio;

      return index >= 0 &&
          index < quizOptions.length &&
          audio != null &&
          audio.trim().isNotEmpty;
    }

    return hasOptionAudios &&
        index >= 0 &&
        index < optionAudios!.length &&
        optionAudios![index].trim().isNotEmpty;
  }

  String? optionIdAt(int index) {
    if (quizOptions.isEmpty) {
      return null;
    }

    if (index < 0 || index >= quizOptions.length) {
      return null;
    }

    return quizOptions[index].id;
  }

  String displayOptionText(int index) {
    if (quizOptions.isNotEmpty) {
      if (index < 0 || index >= quizOptions.length) {
        return '';
      }

      return _stripLeadingMarker(
        quizOptions[index].text,
      );
    }

    if (index < 0 || index >= options.length) {
      return '';
    }

    return _stripLeadingMarker(
      options[index],
    );
  }

  bool hasMeaningfulTextAt(int index) {
    return displayOptionText(index).isNotEmpty;
  }

  String? optionImageAt(int index) {
    if (quizOptions.isNotEmpty) {
      if (index < 0 || index >= quizOptions.length) {
        return null;
      }

      return quizOptions[index].image;
    }

    if (!hasOptionImages ||
        index < 0 ||
        index >= optionImages!.length) {
      return null;
    }

    return optionImages![index];
  }

  String? optionAudioAt(int index) {
    if (quizOptions.isNotEmpty) {
      if (index < 0 || index >= quizOptions.length) {
        return null;
      }

      return quizOptions[index].audio;
    }

    if (!hasOptionAudios ||
        index < 0 ||
        index >= optionAudios!.length) {
      return null;
    }

    return optionAudios![index];
  }

  static final RegExp _leadingMarker = RegExp(
    r'^\s*(?:[①-⑳]|\(\d{1,2}\)|\d{1,2}[.):\-])\s*',
  );

  static String _stripLeadingMarker(String value) {
    return value
        .replaceFirst(_leadingMarker, '')
        .trim();
  }
}

class QuizSet {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<QuizQuestion> questions;

  QuizSet({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.questions,
  });

  int get totalQuestions => questions.length;

  bool get isDatabaseQuiz {
    return questions.isNotEmpty &&
        questions.any((question) => question.hasDatabaseId);
  }
}
