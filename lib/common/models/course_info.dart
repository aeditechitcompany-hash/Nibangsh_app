import 'package:flutter/material.dart';

class CourseInfo {
  final String name;
  final String level;
  final Color accentColor;

  const CourseInfo({
    required this.name,
    required this.level,
    required this.accentColor,
  });
}

class CourseCatalog {
  static int countFor(String university) => byUniversity[university]?.length ?? 0;

  static const Map<String, List<CourseInfo>> byUniversity = {
    'Konyang University': [
      CourseInfo(name: 'Nursing', level: "Bachelor's", accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Medicine (Pre-Medical Sciences)', level: "Bachelor's", accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Physical Therapy & Rehabilitation', level: "Bachelor's", accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Radiological Science', level: "Bachelor's", accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Medical IT Engineering', level: "Bachelor's", accentColor: Color(0xFFF59E0B)),
      CourseInfo(name: 'Taxation & Business Administration', level: "Bachelor's", accentColor: Color(0xFF7E46C5)),
    ],
    'Seoul Theological University': [
      CourseInfo(name: 'Theology', level: "Bachelor's", accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Christian Education', level: "Bachelor's", accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Church Music', level: "Bachelor's", accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Social Welfare', level: "Bachelor's", accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Missionary & Global Ministry', level: "Bachelor's", accentColor: Color(0xFFF59E0B)),
      CourseInfo(name: 'Child & Family Counseling', level: "Bachelor's", accentColor: Color(0xFF7E46C5)),
    ],
    'Ajou University': [
      CourseInfo(name: 'Mechanical Engineering', level: "Bachelor's", accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Industrial Engineering', level: "Bachelor's", accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Software & Computer Engineering', level: "Bachelor's", accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Business Administration', level: "Bachelor's", accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Medicine', level: "Bachelor's", accentColor: Color(0xFFF59E0B)),
      CourseInfo(name: 'Nursing', level: "Bachelor's", accentColor: Color(0xFF7E46C5)),
      CourseInfo(name: 'Law', level: "Bachelor's", accentColor: Color(0xFF2563EB)),
    ],
    'Sungkyul University': [
      CourseInfo(name: 'Theology', level: "Bachelor's", accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Music Composition', level: "Bachelor's", accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Social Welfare', level: "Bachelor's", accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Early Childhood Education', level: "Bachelor's", accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Information & Communication', level: "Bachelor's", accentColor: Color(0xFFF59E0B)),
      CourseInfo(name: 'Business Administration', level: "Bachelor's", accentColor: Color(0xFF7E46C5)),
    ],
    'Seojeong University': [
      CourseInfo(name: 'Emergency Rescue (Paramedic Science)', level: 'Associate', accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Beauty Design', level: 'Associate', accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Nursing Assistance & Health', level: 'Associate', accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Food & Nutrition', level: 'Associate', accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Civil Service Preparation', level: 'Associate', accentColor: Color(0xFFF59E0B)),
      CourseInfo(name: 'Broadcasting & Media', level: 'Associate', accentColor: Color(0xFF7E46C5)),
    ],
    'Daegu Arts University': [
      CourseInfo(name: 'Fine Arts (Painting)', level: "Bachelor's", accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Design', level: "Bachelor's", accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Music (Composition & Performance)', level: "Bachelor's", accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Multimedia Photography', level: "Bachelor's", accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Applied Arts & Crafts', level: "Bachelor's", accentColor: Color(0xFFF59E0B)),
    ],
    "Duksung Women's University": [
      CourseInfo(name: 'Software Engineering', level: "Bachelor's", accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Cybersecurity', level: "Bachelor's", accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Business Administration', level: "Bachelor's", accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Visual Design', level: "Bachelor's", accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Food & Nutrition', level: "Bachelor's", accentColor: Color(0xFFF59E0B)),
      CourseInfo(name: 'Psychology', level: "Bachelor's", accentColor: Color(0xFF7E46C5)),
      CourseInfo(name: 'Child & Family Studies', level: "Bachelor's", accentColor: Color(0xFF2563EB)),
    ],
    "Kyung-In Women's University": [
      CourseInfo(name: 'Nursing', level: 'Associate', accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Cosmetology (Beauty)', level: 'Associate', accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Early Childhood Education', level: 'Associate', accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Global Culinary Arts', level: 'Associate', accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Hotel & Tourism Service', level: 'Associate', accentColor: Color(0xFFF59E0B)),
      CourseInfo(name: 'Software Convergence', level: 'Associate', accentColor: Color(0xFF7E46C5)),
    ],
    'Ajou Motor College': [
      CourseInfo(name: 'Automotive Engineering', level: 'Associate', accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Automotive Design', level: 'Associate', accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Automotive Machinery Maintenance', level: 'Associate', accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Automotive Management', level: 'Associate', accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Internet & IT Information', level: 'Associate', accentColor: Color(0xFFF59E0B)),
    ],
    'Cheongam University': [
      CourseInfo(name: 'Nursing', level: 'Associate', accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Physical Therapy', level: 'Associate', accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Optical Science (Optometry)', level: 'Associate', accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Early Childhood Education', level: 'Associate', accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Fire & Safety Management', level: 'Associate', accentColor: Color(0xFFF59E0B)),
      CourseInfo(name: 'K-Hotel Tourism Management', level: 'Associate', accentColor: Color(0xFF7E46C5)),
    ],
    'Donggang University': [
      CourseInfo(name: 'Social Welfare', level: 'Associate', accentColor: Color(0xFF2563EB)),
      CourseInfo(name: 'Early Childhood Education', level: 'Associate', accentColor: Color(0xFF6B7280)),
      CourseInfo(name: 'Cosmetology & Beauty Care', level: 'Associate', accentColor: Color(0xFFDC2626)),
      CourseInfo(name: 'Tax & Accounting', level: 'Associate', accentColor: Color(0xFF16A34A)),
      CourseInfo(name: 'Computer Information', level: 'Associate', accentColor: Color(0xFFF59E0B)),
      CourseInfo(name: 'Culinary Arts', level: 'Associate', accentColor: Color(0xFF7E46C5)),
    ],
  };
}