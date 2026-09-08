class LeaderboardEntry {
  final int rank;
  final String name;
  final String email;
  final double score;
  final int completedQuizzes;
  final int questionsSolved;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.email,
    required this.score,
    required this.completedQuizzes,
    required this.questionsSolved,
  });

  factory LeaderboardEntry.fromJson(
      Map<String, dynamic> json,
      ) {
    return LeaderboardEntry(
      rank: _toInt(json['rank']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      score: _toDouble(json['score']),
      completedQuizzes: _toInt(
        json['completed_quizzes'],
      ),
      questionsSolved: _toInt(
        json['questions_solved'],
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    ) ??
        0.0;
  }
}