import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080/api/auth';
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String email, String motDePasse) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'motDePasse': motDePasse}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'jwt_token', value: data['token']);
      await storage.write(key: 'user_role', value: data['role']);

      if (data['stationId'] != null) {
        await storage.write(key: 'station_id', value: data['stationId'].toString());
        await storage.write(key: 'station_nom', value: data['stationNom'] ?? '');
      } else {
        await storage.delete(key: 'station_id');
        await storage.delete(key: 'station_nom');
      }

      return data;
    } else {
      throw Exception('Échec de la connexion');
    }
  }

  Future<void> register(String nom, String prenom, String email, String motDePasse) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'motDePasse': motDePasse,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Échec de la création du compte');
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  Future<String?> getRole() async {
    return await storage.read(key: 'user_role');
  }

  Future<String?> getStationNom() async {
    return await storage.read(key: 'station_nom');
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'user_role');
    await storage.delete(key: 'station_id');
    await storage.delete(key: 'station_nom');
  }
}