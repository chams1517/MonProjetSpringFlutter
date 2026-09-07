import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/intervention.dart';
import '../models/panne_simple.dart';

class InterventionService {
  static const String baseUrl = 'http://localhost:8080/api/interventions';
  static const String panneUrl = 'http://localhost:8080/api/pannes';
  final storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: 'jwt_token');
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<Intervention>> getAllInterventions() async {
    final response = await http.get(Uri.parse(baseUrl), headers: await _headers());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Intervention.fromJson(json)).toList();
    }
    throw Exception('Impossible de charger les interventions');
  }

  /// Utilisé pour peupler le sélecteur de panne à l'écran de création d'intervention.
  Future<List<PanneSimple>> getAllPannes() async {
    final response = await http.get(Uri.parse(panneUrl), headers: await _headers());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PanneSimple.fromJson(json)).toList();
    }
    throw Exception('Impossible de charger les pannes');
  }

  Future<void> creerIntervention(int panneId, int typeInterventionId, String observations, String resultat) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _headers(),
      body: jsonEncode({
        'panne': {'id': panneId},
        'typeIntervention': {'id': typeInterventionId},
        'observations': observations,
        'resultat': resultat,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Impossible de créer l\'intervention');
    }
  }
}