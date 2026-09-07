import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/type_panne.dart';

class TypePanneService {
  static const String baseUrl = 'http://localhost:8080/api/types-panne';
  final storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: 'jwt_token');
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<TypePanne>> getAllTypesPanne() async {
    final response = await http.get(Uri.parse(baseUrl), headers: await _headers());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TypePanne.fromJson(json)).toList();
    }
    throw Exception('Impossible de charger les types de panne');
  }

  Future<void> creerTypePanne(String libelle, String? description) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _headers(),
      body: jsonEncode({'libelle': libelle, 'description': description}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Impossible de créer le type de panne');
    }
  }

  Future<void> deleteTypePanne(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'), headers: await _headers());
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Impossible de supprimer le type de panne');
    }
  }
}