import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/university_info.dart';

class UniversitiesController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedUniversityName = ''.obs;
  late final String countryName;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    countryName = (args is Map ? args['country']?.toString() : null) ?? 'South Korea';
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
  }

  List<UniversityInfo> get filteredUniversities {
    final all = UniversityCatalog.byCountry[countryName] ?? [];
    if (searchQuery.value.isEmpty) return all;
    final query = searchQuery.value.toLowerCase();
    return all.where((u) => u.name.toLowerCase().contains(query)).toList();
  }

  void selectUniversity(String name) => selectedUniversityName.value = name;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}