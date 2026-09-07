import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/dashboard_stats.dart';

class DashboardService {
  static const String baseUrl = 'http://localhost:8080/api/dashboard';
  final storage = const FlutterSecureStorage();

  Future<DashboardStats> getStats() async {
    final token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return DashboardStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Impossible de charger le dashboard');
    }
  }
}