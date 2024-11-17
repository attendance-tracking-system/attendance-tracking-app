import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:attendance_tracking_app/screens/auth_page.dart';
import 'package:attendance_tracking_app/screens/loading_screen.dart';
import 'package:attendance_tracking_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:attendance_tracking_app/widgets/my_button.dart';
import 'package:attendance_tracking_app/widgets/my_textfield.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    final username = emailController.text;
    final password = passwordController.text;
    
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final AuthService authService = AuthService(authProvider);
    final isAuthenticated = await authService.login(username, password);
    if(isAuthenticated){
      authService.isLoggedIn();
    }else{
      print("Not Authenticated");
    }

    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return const Center(
    //         child: LoadingScreen(),
    //       );
    //     });
  }

  void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // backgroundColor: Colors.white,//Color.fromARGB(255, 243, 243, 243),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                //logo
                const Icon(
                  Icons.lock_person,
                  size: 150,
                ),
                const SizedBox(height: 10),
                //welcome back you been missed

                Text(
                  'Welcome back you\'ve been missed',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 25),

                //username
                MyTextField(
                  controller: emailController,
                  hintText: 'Username or email',
                  obscureText: false,
                ),

                const SizedBox(height: 15),
                //password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                //sign in button
                MyButton(
                  onTap: signUserIn,
                  text: 'Sign In',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
