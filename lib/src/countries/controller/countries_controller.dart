import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/country_info.dart';

class CountriesController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  final selectedCountryName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      selectedCountryName.value = args['country']?.toString() ?? '';
    }
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
  }

  List<CountryInfo> get filteredCountries {
    if (searchQuery.value.isEmpty) return CountriesCatalog.popularDestinations;
    final query = searchQuery.value.toLowerCase();
    return CountriesCatalog.popularDestinations
        .where((c) => c.name.toLowerCase().contains(query))
        .toList();
  }

  void selectCountry(String name) => selectedCountryName.value = name;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}