import 'dart:convert';

import 'package:http/http.dart' as http;

class OTPService {
  static Future<void> sendResetCode(String email) async {
    final url = Uri.parse('https://adminzaindev.zaindev.com.sa/send-reset-code');
    final response = await http.post(url,headers: {
      'Content-Type':'application/json; charset=utf-8'
    }, body: jsonEncode({'email': email}));

    if (response.statusCode == 200) {
      print('Reset code sent successfully');
    } else {
      throw Exception('Failed to send reset code');
    }
  }

  static Future<void> verifyResetCode(String email, String code) async {
    final url = Uri.parse('https://adminzaindev.zaindev.com.sa/verify-reset-code');
    final response = await http.post(url,headers: {
      'Content-Type':'application/json; charset=utf-8'
    }, body: jsonEncode({'email': email, 'code': code}));

    if (response.statusCode == 200) {
      print('Reset code verified successfully');
    } else if (response.statusCode == 404) {
      throw Exception('Invalid reset code');
    } else {
      throw Exception('Failed to verify reset code');
    }
  }

  static Future<void> changePassword(String email, String newPassword) async {
    final url = Uri.parse('https://adminzaindev.zaindev.com.sa/change-password');
    final response = await http.post(url,headers: {
      'Content-Type':'application/json; charset=utf-8'
    }, body: jsonEncode({'email': email, 'newPassword': newPassword}));

    if (response.statusCode == 200) {
      print('Password changed successfully');
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to change password');
    }
  }
}
