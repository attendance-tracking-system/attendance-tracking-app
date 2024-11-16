import 'package:attendance_tracking_app/screens/loading_screen.dart';
import 'package:attendance_tracking_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading? const LoadingScreen() : LoginScreen();
  }
}

