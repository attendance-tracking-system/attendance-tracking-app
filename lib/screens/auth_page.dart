import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:attendance_tracking_app/screens/loading_screen.dart';
import 'package:attendance_tracking_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  Widget staggeredLoading(BuildContext context) {
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
    return Scaffold(body: Text("hello"),
      // body: Consumer<AuthProvider>(builder: (context, auth, child){
      //     if(auth.isLoading){
      //       return staggeredLoading(context);
      //     }else if(auth.isLoggedin){
      //       return context.push('/home');
      //     }
      //     else{
      //       return context.push('/login');
      //     }
      //   },)
        );
  }
}

// home: Consumer<AuthProvider>(builder: (context, auth, child){
//           if(auth.isLoading){
//             return staggeredLoading(context);
//           }else if(auth.isLoggedin){
//             return HomeScreen();
//           }
//           else{
//             return LoginScreen();
//           }
//         },)

