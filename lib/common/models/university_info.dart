import 'package:flutter/material.dart';

class UniversityInfo {
  final String name;
  final String city;
  final int founded;
  final String type;
  final Color accentColor;

  const UniversityInfo({
    required this.name,
    required this.city,
    required this.founded,
    required this.type,
    required this.accentColor,
  });
}

class UniversityCatalog {
  static const Map<String, List<UniversityInfo>> byCountry = {
    'South Korea': southKoreaUniversities,
  };

  static const List<UniversityInfo> southKoreaUniversities = [
    UniversityInfo(name: 'Konyang University', city: 'Nonsan / Daejeon', founded: 1991, type: 'University', accentColor: Color(0xFF2563EB)),
    UniversityInfo(name: 'Seoul Theological University', city: 'Bucheon', founded: 1911, type: 'University', accentColor: Color(0xFF6B7280)),
    UniversityInfo(name: 'Ajou University', city: 'Suwon', founded: 1973, type: 'University', accentColor: Color(0xFFDC2626)),
    UniversityInfo(name: 'Sungkyul University', city: 'Anyang', founded: 1962, type: 'University', accentColor: Color(0xFF16A34A)),
    UniversityInfo(name: 'Seojeong University', city: 'Yangju', founded: 2003, type: 'Junior College', accentColor: Color(0xFFF59E0B)),
    UniversityInfo(name: 'Daegu Arts University', city: 'Chilgok', founded: 1996, type: 'University', accentColor: Color(0xFF2563EB)),
    UniversityInfo(name: "Duksung Women's University", city: 'Seoul', founded: 1920, type: 'University', accentColor: Color(0xFF6B7280)),
    UniversityInfo(name: "Kyung-In Women's University", city: 'Incheon', founded: 1954, type: 'Junior College', accentColor: Color(0xFFDC2626)),
    UniversityInfo(name: 'Ajou Motor College', city: 'Boryeong', founded: 1995, type: 'Junior College', accentColor: Color(0xFF16A34A)),
    UniversityInfo(name: 'Cheongam University', city: 'Suncheon', founded: 1954, type: 'Junior College', accentColor: Color(0xFFF59E0B)),
    UniversityInfo(name: 'Donggang University', city: 'Gwangju', founded: 1976, type: 'Junior College', accentColor: Color(0xFF2563EB)),
  ];
}