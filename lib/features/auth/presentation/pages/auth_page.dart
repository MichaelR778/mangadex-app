import 'package:flutter/material.dart';
import 'package:mangadex_app/features/auth/presentation/pages/login_page.dart';
import 'package:mangadex_app/features/auth/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool loginPage = true;

  void togglePage() {
    setState(() {
      loginPage = !loginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loginPage
        ? LoginPage(togglePage: togglePage)
        : RegisterPage(togglePage: togglePage);
  }
}
