import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? token;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('${dotenv.get('BASE_URL')}login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data['data']['token'];

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token!);

      return true;
    } else {
      final errorData = jsonDecode(response.body);
      errorMessage = errorData['message'] ?? 'Gagal login';
      return false;
    }
  }

  Future<void> logout() async {
    if (token != null) {
      final response = await http.post(
        Uri.parse('${dotenv.get('BASE_URL')}logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        token = null;
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('token');
        notifyListeners();
      } else {
        print('Logout gagal: ${response.body}');
      }
    }
  }

  void setToken(String savedToken) {
    token = savedToken;
    notifyListeners();
  }

  String? getErrorMessage() {
    return errorMessage;
  }
}
