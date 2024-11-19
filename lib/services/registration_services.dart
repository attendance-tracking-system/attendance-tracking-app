import 'dart:convert';
import 'dart:typed_data';

import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class RegistrationServices {
  final registerUrl = "https://5a1b1gq0ti.execute-api.ap-south-1.amazonaws.com/development/api/organisations/users/biometric";
  final AuthProvider authProvider;

  RegistrationServices(this.authProvider);
  
  Future<bool> registerBiometric(Uint8List image) async{
    print("DEBUG##PRINT: In register function");

    final url = Uri.parse(registerUrl); 
    String base64img = base64Encode(image);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'image': base64img, 'jwt_tokens': authProvider.jwtToken}),
    );

    final data = await json.decode(response.body) as Map<String, dynamic>;
    print(data);
    return true;
  }
}