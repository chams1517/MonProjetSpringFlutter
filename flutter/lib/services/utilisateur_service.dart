import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/utilisateur.dart';

class UtilisateurService {
  static const String baseUrl = 'http://localhost:8080/api/utilisateurs';
  final storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Utilisateur>> getAllUtilisateurs() async {
    final response = await http.get(Uri.parse(baseUrl), headers: await _headers());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Utilisateur.fromJson(json)).toList();
    }
    throw Exception('Impossible de charger les utilisateurs');
  }

  Future<void> creerUtilisateur(Utilisateur utilisateur, String motDePasse) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _headers(),
      body: jsonEncode(utilisateur.toJson(motDePasse: motDePasse)),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Impossible de créer l\'utilisateur');
    }
  }

  Future<void> updateUtilisateur(int id, Utilisateur utilisateur, {String? motDePasse}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: await _headers(),
      body: jsonEncode(utilisateur.toJson(motDePasse: motDePasse)),
    );
    if (response.statusCode != 200) {
      throw Exception('Impossible de modifier l\'utilisateur');
    }
  }

  Future<void> deleteUtilisateur(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'), headers: await _headers());
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Impossible de supprimer l\'utilisateur');
    }
  }
}