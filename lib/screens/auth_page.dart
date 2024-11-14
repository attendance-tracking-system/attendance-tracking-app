import 'package:attendance_tracking_app/screens/loading_screen.dart';
import 'package:attendance_tracking_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return isLoading? LoadingScreen() : LoginScreen();
  }
}

