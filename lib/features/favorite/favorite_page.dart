import 'package:flutter/material.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Favorites',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '.',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
