import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/tpe.dart';

class TpeService {
  static const String baseUrl = 'http://localhost:8080/api/tpe';
  final storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: 'jwt_token');
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Tpe>> getAllTpe() async {
    final response = await http.get(Uri.parse(baseUrl), headers: await _headers());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Tpe.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de charger les TPE');
    }
  }

  /// TPE disponibles pour déclarer une panne.
  /// - USER : uniquement les TPE actuellement affectés à sa station (filtré côté backend)
  /// - ADMIN / TECHNICIEN : tous les TPE
  Future<List<Tpe>> getTpePourDeclaration() async {
    final response = await http.get(Uri.parse('$baseUrl/pour-declaration'), headers: await _headers());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Tpe.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de charger les TPE disponibles');
    }
  }

  Future<void> createTpe(String numeroSerie, String marque, String modele) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _headers(),
      body: jsonEncode({
        'numeroSerie': numeroSerie,
        'marque': marque,
        'modele': modele,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Impossible de créer le TPE');
    }
  }
}