import 'dart:math';
import 'dart:async';
import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:attendance_tracking_app/screens/auth_page.dart';
import 'package:attendance_tracking_app/screens/register_screen.dart';
import 'package:attendance_tracking_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  late Map<String, dynamic> _userDetails;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      fetchUserDetails();
    });
  }

  Future<void> fetchUserDetails() async {
    AuthService authService = AuthService(authProvider);
    await authService.isLoggedIn();
    if(authProvider.isLoggedin){
      await authService.getUserDetails();
    }else{
      context.go('/login');
      return;
    }
    

    setState(() {
      _isLoading = false;
      _userDetails = authProvider.user!;
    });


    if (_userDetails["isBiometricRegistered"]) {
      context.go('/dashboard');
    } else {
      context.go('/register');
    }
    return;
  }

  Widget StaggeredLoading() {
    return Scaffold(
        body: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 100,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredLoading();
  }
}
