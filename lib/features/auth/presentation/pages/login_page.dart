import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_button_cubit.dart';
import 'package:mangadex_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  final void Function() togglePage;

  const LoginPage({super.key, required this.togglePage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    // textfield empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the textfield')),
      );
    }

    // login
    else {
      context.read<AuthButtonCubit>().login(
            emailController.text,
            passwordController.text,
          );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                  'Login',
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

            AuthButton(
              text: 'Log in',
              onTap: login,
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                GestureDetector(
                  onTap: widget.togglePage,
                  child: Text(
                    'Register.',
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
