import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class BackendService {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static Future<Map<String, dynamic>> _request(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Please sign in first.');
    }

    final token = await user.getIdToken();

    if (token == null) {
      throw Exception('Could not get your login token.');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse('$baseUrl$path');

    final response =
        await (body == null
                ? http.get(uri, headers: headers)
                : http.post(uri, headers: headers, body: jsonEncode(body)))
            .timeout(const Duration(seconds: 40));

    Map<String, dynamic>? data;

    try {
      data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Unexpected backend response (${response.statusCode}).');
    }

    if (response.statusCode != 200) {
      throw Exception(
        data['detail']?.toString() ??
            'Request failed (${response.statusCode}).',
      );
    }

    return data;
  }

  static Future<String> verifyCurrentPlayer() async {
    final data = await _request('/auth/me');
    final uid = data['uid'];

    if (uid is! String || uid != FirebaseAuth.instance.currentUser?.uid) {
      throw Exception('Unexpected player ID.');
    }

    return uid;
  }

  static Future<void> startQuiz(String code) async {
    await _request('/arena/$code/start', body: {});
  }

  static Future<Map<String, dynamic>> getQuestions(String code) {
    return _request('/arena/$code/questions');
  }

  static Future<Map<String, dynamic>> submitAnswers(
    String code,
    Map<String, int> answers,
  ) {
    return _request('/arena/$code/submit', body: {'answers': answers});
  }

  static Future<Map<String, dynamic>> getLeaderboard(String code) {
    return _request('/arena/$code/leaderboard');
  }

  static Future<Map<String, dynamic>> saveAnswers(
    String code,
    Map<String, int> answers,
  ) {
    return _request('/arena/$code/answers', body: {'answers': answers});
  }
}
