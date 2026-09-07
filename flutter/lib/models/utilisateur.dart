import 'station.dart';

class Utilisateur {
  final int? id;
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final Station? station;

  Utilisateur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.station,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'],
      role: json['role'],
      station: json['station'] != null ? Station.fromJson(json['station']) : null,
    );
  }

  /// Utilisé pour créer/modifier un utilisateur (le mot de passe est géré à part)
  Map<String, dynamic> toJson({String? motDePasse}) {
    final map = <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role,
    };
    if (motDePasse != null && motDePasse.isNotEmpty) {
      map['motDePasse'] = motDePasse;
    }
    if (station != null) {
      map['station'] = {'id': station!.id};
    }
    return map;
  }
}