import 'dart:async';
import 'dart:convert';
import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthService {
  final AuthProvider authProvider;
  final loginUrl =
      'https://5a1b1gq0ti.execute-api.ap-south-1.amazonaws.com/development/api/organisations/users';
  final getUserDetailsUrl =
      "https://5a1b1gq0ti.execute-api.ap-south-1.amazonaws.com/development/api/organisations/users";
  AuthService(this.authProvider);

  Future<void> isLoggedIn() async {
    authProvider.loading();
    await Future.delayed(Duration(seconds: 3));
    await authProvider.loggedIn();
    return;
  }

  Future<void> logout() async {
    authProvider.loading();
    await Future.delayed(Duration(seconds: 3));
    authProvider.logout();
  }

  Future<void> getUserDetails() async {
    // await Future.delayed(Duration(seconds:3));
    final url = Uri.parse(getUserDetailsUrl);
    final jwt = authProvider.jwtToken;

    final response = await http.get(
      url,
      headers: {
      'Content-Type': 'application/json',
      "Authorization": jwt?["access_token"],
      "x-id-token": jwt?["id_token"]
    },
    );
    final data = await json.decode(response.body) as Map<String, dynamic>;
    if (data["statusCode"] == 200) {
      await authProvider.getUserDetails(data["body"]);
    }
    print("DEBUG##PRINT: User Details Stored");
  
  }

  Future<bool> login(String username, String password) async {
    final url = Uri.parse(loginUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    final data = await json.decode(response.body) as Map<String, dynamic>;
    if (data["statusCode"] == 200) {
      await authProvider.login(data["body"]);
      return true;
    } else {
      print(data["body"]["message"]);
      return false;
    }
  }
}
