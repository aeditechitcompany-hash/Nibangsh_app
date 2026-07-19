import 'package:flutter/material.dart';
import '../util/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.public_rounded, 'label': 'Countries'},
    {'icon': Icons.description_rounded, 'label': 'Docs'},
    {'icon': Icons.menu_book_rounded, 'label': 'Books'},
    {'icon': Icons.person_rounded, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -3)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final selected = currentIndex == index;
              return GestureDetector(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _items[index]['icon'] as IconData,
                      color: selected ? AppColors.darkBlue : AppColors.textGrey,
                      size: 24,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        color: selected ? AppColors.darkBlue : AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}