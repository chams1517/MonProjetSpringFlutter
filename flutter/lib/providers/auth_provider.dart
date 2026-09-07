import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  String? _role;
  String? _stationNom;

  bool get isAuthenticated => _isAuthenticated;
  String? get role => _role;
  String? get stationNom => _stationNom;
  bool get isAdmin => _role == 'ADMIN';
  bool get isTechnicien => _role == 'TECHNICIEN';
  bool get isUser => _role == 'USER';

  Future<void> checkAuth() async {
    final token = await _authService.getToken();
    _role = await _authService.getRole();
    _stationNom = await _authService.getStationNom();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> setAuthenticated(String role, {String? stationNom}) async {
    _isAuthenticated = true;
    _role = role;
    _stationNom = stationNom;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _role = null;
    _stationNom = null;
    notifyListeners();
  }
}