import 'package:flutter/material.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class MangaCoverCard extends StatelessWidget {
  final String imageUrl;

  const MangaCoverCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.width / 3,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              color: AppColors.placeholder,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              color: AppColors.placeholder,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}
