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
  bool _isProgressVisible = false;
  bool _isAuthenticated = false;
  bool _isloading = true;

  Future<void> signUserIn() async {
    setState(() {
      _isProgressVisible = true;
      _isloading = true;
    });
    final username = emailController.text;
    final password = passwordController.text;

    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final AuthService authService = AuthService(authProvider);
    final isAuthenticated = await authService.login(username, password);
    setState(() {
      _isloading = false;
    });
    if (isAuthenticated) {
      setState(() {
        _isAuthenticated = true;
      });
      // await authService.isLoggedIn();
      await Future.delayed(Duration(seconds: 3));
      context.go('/');
    } else {
      print("Not Authenticated");
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        _isProgressVisible = false;
      });
      context.go('/login');
    }
  }

  Widget handleDialog() {
    if (_isloading) {
      return loadDialog("Authentication in progress. Please wait.",
          CircularProgressIndicator(color: Colors.black));
    } else if (_isAuthenticated) {
      return loadDialog(
          "Successfully logged in.",
          Icon(
            Icons.check,
            size: 25,
          ));
    } else {
      return loadDialog(
          "Incorrect username or password",
          Icon(
            Icons.close,
            size: 25,
          ));
    }
  }

  Widget loadDialog(String text, Widget widget) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget,
              SizedBox(height: 50),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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
        child: Stack(
          children: [
            Visibility(
              visible: !_isProgressVisible,
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
            Visibility(visible: _isProgressVisible, child: handleDialog())
          ],
        ),
      ),
    );
  }
}
