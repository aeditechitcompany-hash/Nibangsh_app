import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../books/views/student_books_screen.dart';
import '../../countries/views/countries_screen.dart';
import '../../home/views/home_screen.dart';
import '../../mcq/views/mcq_home_screen.dart';
import '../../profile/views/profile_screen.dart';

class MainNavigationController extends GetxController {
  final currentIndex = 0.obs;

  final List<Widget?> tabs = List<Widget?>.filled(
    5,
    null,
  );

  void setIndex(int index) {
    currentIndex.value = index;
  }

  Widget getTab(int index) {
    if (tabs[index] != null) {
      return tabs[index]!;
    }

    switch (index) {
      case 0:
        tabs[index] = const HomeScreen();
        break;

      case 1:
        tabs[index] = const CountriesScreen();
        break;

      case 2:
        tabs[index] = const McqHomeScreen();
        break;

      case 3:
        tabs[index] = const StudentBooksScreen();
        break;

      case 4:
        tabs[index] = const ProfileScreen();
        break;

      default:
        tabs[index] = const HomeScreen();
    }

    return tabs[index]!;
  }
}