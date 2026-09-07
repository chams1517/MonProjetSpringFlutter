class TypePanne {
  final int id;
  final String libelle;
  final String? description;

  TypePanne({required this.id, required this.libelle, this.description});

  factory TypePanne.fromJson(Map<String, dynamic> json) {
    return TypePanne(id: json['id'], libelle: json['libelle'], description: json['description']);
  }
}