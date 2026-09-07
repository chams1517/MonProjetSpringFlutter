class Station {
  final int id;
  final String nom;
  final String? adresse;
  final String? ville;
  final bool actif;

  Station({
    required this.id,
    required this.nom,
    this.adresse,
    this.ville,
    required this.actif,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      nom: json['nom'],
      adresse: json['adresse'],
      ville: json['ville'],
      actif: json['actif'],
    );
  }
}