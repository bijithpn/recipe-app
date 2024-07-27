import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/colors.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;

  const CategoryCard({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ColorPalette.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 35, color: Colors.white),
          const SizedBox(height: 12),
          Text(name,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
