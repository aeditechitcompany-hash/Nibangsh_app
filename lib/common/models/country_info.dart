import 'package:flutter/material.dart';

class CountryInfo {
  final String code;
  final String name;
  final int universityCount;
  final List<String> topUniversities;
  final Color accentColor;

  const CountryInfo({
    required this.code,
    required this.name,
    required this.universityCount,
    required this.topUniversities,
    required this.accentColor,
  });
}

class CountriesCatalog {
  CountriesCatalog._();

  static const List<CountryInfo> popularDestinations = [
    CountryInfo(
      code: 'KR',
      name: 'South Korea',
      universityCount: 11,
      topUniversities: ['Konyang', 'Ajou'],
      accentColor: Color(0xFF2563EB),
    ),
    CountryInfo(
      code: 'UK',
      name: 'United Kingdom',
      universityCount: 14,
      topUniversities: ['Oxford', 'Cambridge'],
      accentColor: Color(0xFF6B7280),
    ),
    CountryInfo(
      code: 'US',
      name: 'United States',
      universityCount: 20,
      topUniversities: ['MIT', 'Harvard'],
      accentColor: Color(0xFFDC2626),
    ),
    CountryInfo(
      code: 'AU',
      name: 'Australia',
      universityCount: 19,
      topUniversities: ['ANU', 'Melbourne'],
      accentColor: Color(0xFF16A34A),
    ),
    CountryInfo(
      code: 'CA',
      name: 'Canada',
      universityCount: 16,
      topUniversities: ['Toronto', 'UBC'],
      accentColor: Color(0xFFF59E0B),
    ),
    CountryInfo(
      code: 'JP',
      name: 'Japan',
      universityCount: 18,
      topUniversities: ['Todai', 'Osaka'],
      accentColor: Color(0xFF6B7280),
    ),
  ];
}