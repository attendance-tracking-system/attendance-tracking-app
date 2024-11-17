import 'dart:math';

import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:attendance_tracking_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  void logout(){
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final AuthService authService = AuthService(authProvider);
    authService.logout();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(onPressed: logout, child: Text("logout")),
      ),
    );
  }
}
