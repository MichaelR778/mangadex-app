import 'package:flutter/material.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class MangaTags extends StatelessWidget {
  final List<String> tags;

  const MangaTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: tags.map(
        (tag) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            margin: const EdgeInsets.only(
              top: 2,
              bottom: 2,
              right: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.placeholder,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
