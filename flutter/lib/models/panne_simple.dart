class PanneSimple {
  final int id;
  final String numeroSerieTpe;
  final String statut;

  PanneSimple({required this.id, required this.numeroSerieTpe, required this.statut});

  factory PanneSimple.fromJson(Map<String, dynamic> json) {
    return PanneSimple(
      id: json['id'],
      numeroSerieTpe: json['tpe']['numeroSerie'],
      statut: json['statut'],
    );
  }
}