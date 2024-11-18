import 'dart:convert';

import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:attendance_tracking_app/services/attendance_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

class FaceScreen extends StatefulWidget {
  const FaceScreen({super.key});

  @override
  State<FaceScreen> createState() => _FaceScreenState();
}

class _FaceScreenState extends State<FaceScreen> {
  var lattitude;
  var longitude;
  late Map<String, dynamic> current_location;
  var faceSdk = FaceSDK.instance;
  var image;
  bool _isFaceCaptureLoading = true;
  bool _isLocationCaptureLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runVerification();
    });
  }

  Future<void> runVerification() async {
    await initialize();
    bool faceCaptured = false;
    while (!faceCaptured) {
      faceCaptured = await handleCapture();

      if (!faceCaptured) {
        bool retry = await _showDialog(
            title: "Face Capture",
            content:
                "We failed to capture your face for verification. Please try again.",
            buttonName: "Recapture",
            () {});

        if (!retry) {
          print("User Cancelled");
          Navigator.pop(context);
          return;
        }
      }
    }

    final pos = await _determinePosition();
    if (pos != null) {
      print("Location: $pos");

      setState(() {
        _isLocationCaptureLoading = false;
        current_location = {
          "latitude": "${pos.latitude}",
          "longitude": "${pos.longitude}"
        };
      });
    }
    if (_isFaceCaptureLoading == false && _isLocationCaptureLoading == false) {
      final AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      final AttendanceService attendanceService =
          AttendanceService(authProvider);
      await attendanceService.recordAttendance(image, current_location);
    }
    return;
  }

  Future<void> initialize() async {
    await faceSdk.initialize();
  }

  Future<bool> isLoactionServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceEnabled;
  }

  // Future<Position> _determinePosition() async {
  //   // Check if location services are enabled
  //   bool serviceEnabled = await isLoactionServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled return an error message
  //     await Geolocator.openLocationSettings();
  //     await Future.delayed(Duration(seconds: 5));
  //     serviceEnabled = await isLoactionServiceEnabled();
  //     if (!serviceEnabled) {
  //       return Future.error('Location services are disabled.');
  //     }
  //   }

  //   // Check location permissions
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     await Geolocator.openAppSettings();
  //     await Future.delayed(Duration(seconds: 5));
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.deniedForever ||
  //         permission == LocationPermission.denied) {
  //       return Future.error(
  //           'Location permissions are permanently denied, we cannot request permissions.');
  //     }
  //   }
  //   final LocationSettings locationSettings = LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 100,
  //   );

  //   // If permissions are granted, return the current location
  //   return await Geolocator.getCurrentPosition(
  //       locationSettings: locationSettings);
  // }

  Future<Position?> _determinePosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _showDialog(
          title: "Location Services Disabled",
          content:
              "Location services are required to proceed. Please enable them in your settings.",
          buttonName: "Open",
          () async {
            await Geolocator.openLocationSettings();
          },
        );

        int attempts = 0;
        while (!serviceEnabled && attempts < 5) {
          print("checking location serivces");
          attempts++;
          await Future.delayed(const Duration(seconds: 3));
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
        }

        // Recheck after user enables location services
        if (!serviceEnabled) {
          throw Exception("Location services are still disabled.");
        }
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await _showDialog(
          title: "Permission Denied",
          content:
              "Location permission is required to proceed. Please allow access.",
          buttonName: "Open",
          () async {
            permission = await Geolocator.requestPermission();
          },
        );
        // Recheck permissions
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await _showDialog(
            title: 'Permission Denied Permanently',
            content:
                'Location permissions are permanently denied. Please enable them in your app settings to proceed.',
            buttonName: 'Open', () async {
          await Geolocator.openAppSettings();
        });

        // Recheck permissions after settings
        int attempts = 0;
        while (!serviceEnabled && attempts < 5) {
          print("checking location permissions");
          attempts++;
          await Future.delayed(const Duration(seconds: 3));
          permission = await Geolocator.checkPermission();
        }

        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          throw Exception("Location permissions are permanently denied.");
        }
      }

      // If permissions and services are enabled, return the current location
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print("Error occurred: $e");

      // await _showDialog(
      //   title: "Error",
      //   content: e.toString(),
      // );
      return null; // Return null if location couldn't be fetched
    }
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

    // Convert the cropped image back to Uint8List
    final croppedBytes = Uint8List.fromList(img.encodeJpg(croppedImage));
    // print("****************************************************");
    // print(croppedImage.lengthInBytes/1024);
    // print("****************************************************");
    setState(() {
      image = croppedBytes;
    });
  }

  Future<bool> handleCapture() async {
    final config = FaceCaptureConfig(copyright: false);
    var response = await faceSdk.startFaceCapture(config: config);
    if (response.error == null) {
      await cropImage(response.image!.image);
      setState(() {
        _isFaceCaptureLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 25),
            child: Text(
              "Verification",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
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
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(50, 0, 0, 25),
            child: Row(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  child: (_isFaceCaptureLoading)
                      ? CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : Icon(Icons.check_circle_outlined),
                ),
                SizedBox(
                  width: 20,
                ),
                Center(
                  child: Text(
                    "Face Verification",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(50, 0, 0, 25),
            child: Row(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  child: (_isLocationCaptureLoading)
                      ? CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : Icon(Icons.check_circle_outlined),
                ),
                SizedBox(
                  width: 20,
                ),
                Center(
                  child: Text(
                    "Geoloaction Verification",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          // Center(
          //   child: TextButton(
          //       onPressed: handleCapture,
          //       child: (image != null) ? Image.memory(image) : Text("Capture")),
          // ),
          // (image != null)
          //     ? ClipRRect(
          //         borderRadius: BorderRadius.circular(120),
          //         child: Image.memory(
          //           image,
          //           fit: BoxFit.fill,
          //           width: 120,
          //           height: 120,
          //         ),
          //       )
          //     : Text("No Image")
        ],
      ),
    ));
  }
}
