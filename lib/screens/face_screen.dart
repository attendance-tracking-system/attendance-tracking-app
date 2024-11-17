import 'package:flutter/material.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;

class FaceScreen extends StatefulWidget {
  const FaceScreen({super.key});

  @override
  State<FaceScreen> createState() => _FaceScreenState();
}

class _FaceScreenState extends State<FaceScreen> {
  var faceSdk = FaceSDK.instance;
  var image;

  @override
  void initState() {
    super.initState();
    faceSdk.initialize();
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
    print("****************************************************");
    print(croppedImage.lengthInBytes/1024);
    print("****************************************************");
    setState(() {
      image = croppedBytes;
    });
  }

  Future<void> handleCapture() async {
    final config = FaceCaptureConfig(copyright: false);
    var response = await faceSdk.startFaceCapture(config: config);
    await cropImage(response.image!.image);
    print("****************************************************");
    print(response.image!.image.lengthInBytes/1024);
    print("****************************************************");
    // setState(() {
    //   image = Image.memory(response.image!.image);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: TextButton(
                onPressed: handleCapture,
                child: (image != null) ? Image.memory(image) : Text("Capture")),
          ),
          (image != null)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: Image.memory(
                    image,
                    fit: BoxFit.fill,
                    width: 120,
                    height: 120,
                  ),
                )
              : Text("No IMage")
        ],
      ),
    ));
  }
}



// class FaceScreen extends StatefulWidget {
//   @override
//   _FaceScreenState createState() => _FaceScreenState();
// }

// class _FaceScreenState extends State<FaceScreen> {
//   File? _selectedImage;
//   Uint8List? _croppedImage;

//   Future<void> _pickAndCropImage(Uint8List og_img) async {
//       final imageBytes = og_img;

//       // Decode image for processing
//       final originalImage = img.decodeImage(imageBytes);
//       if (originalImage == null) return;

//       // Calculate crop area (center of the image)
//       final int cropWidth = (originalImage.width / 2).toInt();
//       final int cropHeight = (originalImage.height / 2).toInt();
//       final int startX = (originalImage.width - cropWidth) ~/ 2;
//       final int startY = (originalImage.height - cropHeight) ~/ 2;

//       // Crop the image
//       final croppedImage = img.copyCrop(
//         originalImage,
//         x: startX,
//         y: startY,
//         width: cropWidth,
//         height: cropHeight,
//       );

//       // Convert the cropped image back to Uint8List
//       final croppedBytes = Uint8List.fromList(img.encodeJpg(croppedImage));

//       setState(() {
//         _croppedImage = croppedBytes;
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Center Crop Example")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_croppedImage != null)
//               Column(
//                 children: [
//                   Text("Cropped Center Image"),
//                   Image.memory(_croppedImage!),
//                 ],
//               ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickAndCropImage,
//               child: Text("Capture and Crop Center"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
