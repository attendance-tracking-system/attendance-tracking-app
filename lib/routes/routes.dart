import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:attendance_tracking_app/screens/auth_page.dart';
import 'package:attendance_tracking_app/screens/dashboard_screen.dart';
import 'package:attendance_tracking_app/screens/face_screen.dart';
import 'package:attendance_tracking_app/screens/home.dart';
import 'package:attendance_tracking_app/screens/loading_screen.dart';
import 'package:attendance_tracking_app/screens/login_screen.dart';
import 'package:attendance_tracking_app/screens/register_screen.dart';
import 'package:attendance_tracking_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

// GoRouter configuration
class Routes {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name:
            'home', // Optional, add name to your routes. Allows you navigate by name instead of path
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        name:
            'dashboard', // Optional, add name to your routes. Allows you navigate by name instead of path
        path: '/dashboard',
        builder: (context, state) => DashboardScreen(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
          name: 'facecapture',
          path: '/facecapture',
          builder: (context, state) => FaceScreen())
    ],
    // redirect: (BuildContext context, GoRouterState state) {
    //   // final AuthProvider authProvider =
    //   //     Provider.of<AuthProvider>(context, listen: true);
    //   // if (authProvider.isLoading) {
    //   //   return '/';
    //   // } else if (authProvider.isLoggedin) {
    //   //   return '/home';
    //   // } else if (!authProvider.isLoggedin) {
    //   //   return '/login';
    //   // }

    //   return '/home';

    //   return null;
    // },
  );
}
