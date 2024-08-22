import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:attendance_tracking_app/screens/login_screen.dart';
import 'package:attendance_tracking_app/screens/home_screen.dart';

class AppRouter {
   Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(
            builder: (context) => LoginScreen(), maintainState: false);
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
    }

    return null;
  }
}
