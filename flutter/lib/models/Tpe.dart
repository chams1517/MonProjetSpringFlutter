class Tpe {
  final int id;
  final String numeroSerie;
  final String? modele;
  final String? marque;
  final String etat;

  Tpe({
    required this.id,
    required this.numeroSerie,
    this.modele,
    this.marque,
    required this.etat,
  });

  factory Tpe.fromJson(Map<String, dynamic> json) {
    return Tpe(
      id: json['id'],
      numeroSerie: json['numeroSerie'],
      modele: json['modele'],
      marque: json['marque'],
      etat: json['etat'],
    );
  }
}