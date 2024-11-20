import 'dart:typed_data';

import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:attendance_tracking_app/services/auth_service.dart';
import 'package:attendance_tracking_app/services/registration_services.dart';
import 'package:attendance_tracking_app/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var faceSdk = FaceSDK.instance;
  late Uint8List image;
  late AuthProvider authProvider;
  bool _isProgressVisible = false;
  bool _isAuthenticated = false;
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Visibility(
            visible: !_isProgressVisible,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: Center(
                    child: Text(
                      "Biometric Registration",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Image.asset(
                    'assets/face_scan.gif',
                    height: 200,
                    width: 200,
                  ),
                ),
                Text(
                  "Please register your face to continue using the app",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                MyButton(
                    onTap: () {
                      handleContinue();
                    },
                    text: "Continue")
              ],
            ),
          ),
          Visibility(visible: _isProgressVisible, child: Center(child: handleDialog()))
        ],
      ),
    );
  }

  Future<void> initialize() async {
    await faceSdk.initialize();
  }

  Future<void> cropImage(Uint8List og_img) async {
    // Decode image for processing
    final originalImage = img.decodeImage(og_img);
    if (originalImage == null) return;

    // Calculate crop area (center of the image)
    final int cropWidth = (originalImage.width / 2).toInt();
    final int cropHeight = (originalImage.height / 2).toInt();
    final int startX = (originalImage.width - cropWidth) ~/ 2;
    final int startY = (originalImage.height - cropHeight) ~/ 2;

    // Crop the image
    final croppedImage = img.copyCrop(
      originalImage,
      x: startX,
      y: startY,
      width: cropWidth,
      height: cropHeight,
    );

    final croppedBytes = Uint8List.fromList(img.encodeJpg(croppedImage));
    setState(() {
      image = croppedBytes;
    });
  }

  Future<bool> handleCapture() async {
    final config = FaceCaptureConfig(copyright: false);
    var response = await faceSdk.startFaceCapture(config: config);
    if (response.error == null) {
      await cropImage(response.image!.image);

      faceSdk.deinitialize();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> _showDialog(Function handleFunc,
      {required String title,
      required String content,
      required String buttonName}) async {
    bool retry = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(content),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              retry = false;
              Navigator.pop(context);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              retry = true;
              Navigator.pop(context);
              handleFunc();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: Text(
              buttonName,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
    return retry;
  }

  Future<void> handleContinue() async {
    await initialize();
    bool faceCaptured = false;
    while (!faceCaptured) {
      faceCaptured = await handleCapture();

      if (!faceCaptured) {
        bool retry = await _showDialog(
            title: "Registration",
            content:
                "We failed to capture your face for registration. Please try again.",
            buttonName: "Recapture",
            () {});

        if (!retry) {
          print("User Cancelled");
          // Navigator.pop(context);
          return;
        }
      }
    }

    // if(image.isNotEmpty){
    // Call register service
    setState(() {
      _isProgressVisible = true;
    });
    RegistrationServices register = RegistrationServices(authProvider);
    final res = await register.registerBiometric(image);
    if (res) {
      setState(() {
        _isloading = false;
        _isAuthenticated = true;
      });
    }
    print("DEBUG##PRINT: Registered Biometric");
    await Future.delayed(Duration(seconds: 3));
    context.go('/');
    // }
  }

  Widget handleDialog() {
    if (_isloading) {
      return loadDialog("Registration in progress. Please wait.",
          CircularProgressIndicator(color: Colors.black));
    } else if (_isAuthenticated) {
      return loadDialog(
          "Successfully registered.",
          Icon(
            Icons.check,
            size: 25,
          ));
    } else {
      return loadDialog(
          "Registration",
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
}
