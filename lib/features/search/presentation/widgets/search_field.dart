import 'package:flutter/material.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onSubmitted;

  const SearchField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      cursorColor: const Color(0x33FFFFFF),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: 'Search',
        hintStyle: const TextStyle(
          color: Color(0x33FFFFFF),
        ),
        filled: true,
        fillColor: const Color(0xff2B2B2B),
      ),
    );
  }
}
