class AcademicConstants {
  AcademicConstants._();
  static const List<String> countries = [
    'South Korea',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Japan',
  ];

  static const Map<String, String> countryFlags = {
    'South Korea': '🇰🇷',
    'United States': '🇺🇸',
    'United Kingdom': '🇬🇧',
    'Canada': '🇨🇦',
    'Australia': '🇦🇺',
    'Japan': '🇯🇵',
  };

  static const List<String> degrees = [
    'Bachelors',
    'Masters',
    'PHD',
  ];

  static const List<String> languageTests = [
    'IELTS',
    'Basic IELTS',
    'TOPIK',
  ];

  static List<String> get passoutYears {
    final current = DateTime.now().year;
    final start = current > 2026 ? current : 2026;
    return List.generate(start - 2000 + 1, (i) => (start - i).toString());
  }
}