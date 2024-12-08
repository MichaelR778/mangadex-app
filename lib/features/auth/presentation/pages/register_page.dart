import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_button_cubit.dart';
import 'package:mangadex_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class RegisterPage extends StatefulWidget {
  final void Function() togglePage;
  const RegisterPage({super.key, required this.togglePage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  void register() {
    // textfield empty
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the textfield')),
      );
    }

    // password doesn't match
    else if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password does not match')),
      );
    }

    // register
    else {
      context.read<AuthButtonCubit>().register(
            emailController.text,
            passwordController.text,
          );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // login text
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register',
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

            const SizedBox(height: 10),

            TextField(
              controller: emailController,
              cursorColor: const Color(0x33FFFFFF),
              decoration: const InputDecoration(hintText: 'Email'),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: passwordController,
              cursorColor: const Color(0x33FFFFFF),
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: confirmController,
              cursorColor: const Color(0x33FFFFFF),
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Confirm password'),
            ),

            const SizedBox(height: 10),

            AuthButton(
              text: 'Register',
              onTap: register,
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                GestureDetector(
                  onTap: widget.togglePage,
                  child: Text(
                    'Log in.',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
