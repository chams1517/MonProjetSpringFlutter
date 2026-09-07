import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/station.dart';

class StationService {
  static const String baseUrl = 'http://localhost:8080/api/stations';
  final storage = const FlutterSecureStorage();

  Future<List<Station>> getAllStations() async {
    final token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Station.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de charger les stations');
    }
  }

  Future<void> createStation(String nom, String adresse, String ville) async {
    final token = await storage.read(key: 'jwt_token');
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nom': nom,
        'adresse': adresse,
        'ville': ville,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Impossible de créer la station');
    }
  }
}