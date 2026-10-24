import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class BackendService {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static Future<String> verifyCurrentPlayer() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Please sign in first.');
    }

    final token = await user.getIdToken();

    if (token == null) {
      throw Exception('Could not get your login token.');
    }

    final response = await http
        .get(
          Uri.parse('$baseUrl/auth/me'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception(
        'Backend authentication failed (${response.statusCode}). '
        'Check the backend terminal.',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final uid = data['uid'];

    if (uid is! String || uid != user.uid) {
      throw Exception('Backend returned an unexpected player ID.');
    }

    return uid;
  }
}
