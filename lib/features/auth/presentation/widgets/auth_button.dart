import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_button_cubit.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_button_state.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const AuthButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthButtonCubit, AuthButtonState>(
      builder: (context, state) {
        if (state is AuthButtonLoading) {
          return Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: AppColors.placeholder,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AuthButtonError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthButtonSuccess) {
          context.read<AuthCubit>().authenticate();
        }
      },
    );
  }
}
