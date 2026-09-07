class TypeIntervention {
  final int id;
  final String libelle;
  final String? description;

  TypeIntervention({required this.id, required this.libelle, this.description});

  factory TypeIntervention.fromJson(Map<String, dynamic> json) {
    return TypeIntervention(id: json['id'], libelle: json['libelle'], description: json['description']);
  }
}