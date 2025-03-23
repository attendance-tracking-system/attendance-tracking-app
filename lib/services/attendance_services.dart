import 'dart:convert';
import 'dart:typed_data';

import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AttendanceService {
  final AuthProvider authProvider;
  final punchUrl =
      "https://5a1b1gq0ti.execute-api.ap-south-1.amazonaws.com/development/api/organisations/attendance";

  AttendanceService(this.authProvider);

  Future<Map<String, dynamic>> recordAttendance(
      Uint8List image, Map<String, dynamic> currentLocation) async {
    // Future<void> recordAttendance()async{
    print("**********************************************************");

    final url = Uri.parse(punchUrl);
    Map<String, dynamic>? jwt = authProvider.jwtToken;
    String base64img = base64Encode(image);
    print(jwt);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "jwt_tokens": jwt,
        "img-1": base64img,
        "current_location": currentLocation
      }),
    );

    final data = await json.decode(response.body) as Map<String, dynamic>;
    print(data);
    return data;
  }
}
