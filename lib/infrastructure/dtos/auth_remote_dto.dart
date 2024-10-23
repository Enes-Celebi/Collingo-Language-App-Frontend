import 'package:collingo/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/models/user_model.dart';

class AuthRemoteDTO {
  final http.Client client;

  AuthRemoteDTO({required this.client});

  Future<UserModel> register(String email, String name, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'name': name,
          'password': password,
        }),
      );

      print('Register Request:');
      print('URL: ${response.request?.url}');
      print('Body: ${jsonEncode({'email': email, 'name': name, 'password': password})}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body)['user']);
      } else if (response.statusCode == 409) {
        throw Exception('User already exists');
      } else {
        throw Exception('Unexpected error');
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Login Request:');
      print('URL: ${response.request?.url}');
      print('Body: ${jsonEncode({'email': email, 'password': password})}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(jsonDecode(response.body)['user']);
        
        if (!user.isVerified) {
          throw Exception('Email not verified!');
        }

        return user; 
      } else if (response.statusCode == 403) {
        throw Exception('Invalid password!');
      } else if (response.statusCode == 404) {
        throw Exception('Invalid user!');
      } else if (response.statusCode == 401) {
        throw Exception('Please Verify your Email first!');
      } else {
        throw Exception('Unexpected error!');
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  Future<UserModel> signInWithGoogle(String token) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}/api/auth/google/callback'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      print('Google Sign-In Request:');
      print('URL: ${response.request?.url}');
      print('Body: ${jsonEncode({'token': token})}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body)['user']);
      } else {
        throw Exception('Google Sign-In failed: ${response.body}');
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}/api/auth/resend-verification'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print('Resend Verification Request:');
      print('URL: ${response.request?.url}');
      print('Body: ${jsonEncode({'email': email})}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Verification email resent successfully');
      } else {
        throw Exception('Failed to resend verification email: ${response.body}');
      }
    } catch (e) {
      print('Error resending verification email: $e');
      rethrow;
    }
  }

  Future<void> requestPasswordChange(String email) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}/api/auth/request-reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        print('Verification code sent successfully');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid email format');
      } else {
        throw Exception('Failed to send verification code: ${response.body}');
      }
    } catch (e) {
      print('Error sending verification code: $e');
      rethrow;
    }
  }

  Future<void> verifyResetCode(String email, String code) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}/api/auth/verify-reset-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code
        }),
      );

      if (response.statusCode == 200) {
        print('Code verified successfully');
      } else if (response.statusCode == 400) {
        throw Exception('Invalid or expired code');
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to verify code: ${response.body}');
      }
    } catch (e) {
      print('Error verifying code: $e');
      rethrow;
    }
  }
}

