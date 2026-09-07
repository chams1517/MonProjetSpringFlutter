import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/affectation.dart';

class AffectationService {
  static const String baseUrl = 'http://localhost:8080/api/affectations';
  final storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: 'jwt_token');
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Affectation>> getAffectationsActives() async {
    final response = await http.get(Uri.parse('$baseUrl/actives'), headers: await _headers());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Affectation.fromJson(json)).toList();
    }
    throw Exception('Impossible de charger les affectations');
  }

  Future<void> affecterTpe(int tpeId, int stationId) async {
    final token = await storage.read(key: 'jwt_token');
    final response = await http.post(
      Uri.parse('$baseUrl/affecter?tpeId=$tpeId&stationId=$stationId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Impossible d\'affecter le TPE');
    }
  }

  Future<void> desaffecterTpe(int tpeId) async {
    final token = await storage.read(key: 'jwt_token');
    final response = await http.post(
      Uri.parse('$baseUrl/desaffecter?tpeId=$tpeId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Impossible de désaffecter le TPE');
    }
  }
}