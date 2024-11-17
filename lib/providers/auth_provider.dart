import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _jwtToken;
  bool _isLoading = false;
  bool _isLoggedin = false;

  FlutterSecureStorage _storage = new FlutterSecureStorage();

  bool get isLoading => _isLoading;
  bool get isLoggedin => _isLoggedin;

  Map<String, dynamic>? get jwtToken => _jwtToken;

  void loading() {
    _isLoading = true;
    notifyListeners();
  }

  void setJwt(data) {
    _jwtToken = {
      "id_token": data["id_token"],
      "access_token": data["access_token"],
      "refresh_token": data["refresh_token"]
    };
  }

  Future<void> loggedIn() async {
    final jwt = await _storage.read(key: "jwtTokens");
    if (jwt != null) {
      final data = await jsonDecode(jwt);
      setJwt(data);
      print(data);
      _isLoggedin = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(Map<String, dynamic> data) async {
    // setJwt(data);
    final encodedData = await jsonEncode(data);
    await _storage.write(key: "jwtTokens", value: encodedData);
    // _isLoggedin=true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: "jwtTokens");
    _isLoggedin=false;
    _isLoading=false;
    notifyListeners();
  }
}
