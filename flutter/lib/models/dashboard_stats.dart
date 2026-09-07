class DashboardStats {
  final int totalTpe;
  final int tpeEnStock;
  final int tpeAffecte;
  final int tpeEnPanne;
  final int tpeEnReparation;
  final int tpeRepare;
  final int tpeHorsService;
  final int interventionsCeMois;
  final List<dynamic> tpeLesPlusEnPanne;
  final List<dynamic> typesPanneLesPlusFrequents;

  DashboardStats({
    required this.totalTpe,
    required this.tpeEnStock,
    required this.tpeAffecte,
    required this.tpeEnPanne,
    required this.tpeEnReparation,
    required this.tpeRepare,
    required this.tpeHorsService,
    required this.interventionsCeMois,
    required this.tpeLesPlusEnPanne,
    required this.typesPanneLesPlusFrequents,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalTpe: json['totalTpe'],
      tpeEnStock: json['tpeEnStock'],
      tpeAffecte: json['tpeAffecte'],
      tpeEnPanne: json['tpeEnPanne'],
      tpeEnReparation: json['tpeEnReparation'],
      tpeRepare: json['tpeRepare'],
      tpeHorsService: json['tpeHorsService'],
      interventionsCeMois: json['interventionsCeMois'],
      tpeLesPlusEnPanne: json['tpeLesPlusEnPanne'] ?? [],
      typesPanneLesPlusFrequents: json['typesPanneLesPlusFrequents'] ?? [],
    );
  }
}