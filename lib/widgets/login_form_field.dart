import 'package:attendance_tracking_app/themes/colors.dart';
import 'package:attendance_tracking_app/themes/styles.dart';
import 'package:attendance_tracking_app/widgets/app_text_button.dart';
import 'package:attendance_tracking_app/widgets/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailAndPasswordForm extends StatefulWidget {
  const EmailAndPasswordForm({super.key});

  @override
  State<EmailAndPasswordForm> createState() => _EmailAndPasswordFormState();
}

class _EmailAndPasswordFormState extends State<EmailAndPasswordForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscureText = true;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          emailField(),
          SizedBox(
            height: 50.h,
          ),
          passwordField(),
          SizedBox(
            height: 50.h,
          ),
          loginButton()
        ],
      ),
    );
  }

  AppTextFormField emailField() {
    return AppTextFormField(
        hint: 'Email',
        validator: (value) {
          String username = (value ?? '').trim();
          usernameController.text = username;
        });
  }

  AppTextFormField passwordField() {
    return AppTextFormField(
        hint: 'Password',
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              if (isObscureText) {
                isObscureText = false;
              } else {
                isObscureText = true;
              }
            });
          },
          child: Icon(
            isObscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
        isObscureText: isObscureText,
        validator: (value) {
          String password = (value ?? '').trim();
          passwordController.text = password;
        });
  }

  AppTextButton loginButton() {
    return AppTextButton(
        buttonText: "Login",
        textStyle: TextStyles.font16White600Weight,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            usernameController.clear();
            passwordController.clear();

            print("loggedin");
          }
        });
  }
}
