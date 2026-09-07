import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/panne.dart';

class PanneService {
  static const String baseUrl = 'http://localhost:8080/api/pannes';
  final storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: 'jwt_token');
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Panne>> getAllPannes() async {
    final response = await http.get(Uri.parse(baseUrl), headers: await _headers());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Panne.fromJson(json)).toList();
    }
    throw Exception('Impossible de charger les déclarations');
  }

  Future<void> declarerPanne(int tpeId, int typePanneId, String description) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _headers(),
      body: jsonEncode({
        'tpe': {'id': tpeId},
        'typePanne': {'id': typePanneId},
        'description': description,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Impossible de déclarer la panne');
    }
  }
}