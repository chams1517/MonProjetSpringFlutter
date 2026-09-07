import 'panne.dart';
import 'type_intervention.dart';

class Intervention {
  final int id;
  final Panne panne;
  final TypeIntervention typeIntervention;
  final String? observations;
  final String? resultat;
  final String dateIntervention;

  Intervention({
    required this.id,
    required this.panne,
    required this.typeIntervention,
    this.observations,
    this.resultat,
    required this.dateIntervention,
  });

  factory Intervention.fromJson(Map<String, dynamic> json) {
    return Intervention(
      id: json['id'],
      panne: Panne.fromJson(json['panne']),
      typeIntervention: TypeIntervention.fromJson(json['typeIntervention']),
      observations: json['observations'],
      resultat: json['resultat'],
      dateIntervention: json['dateIntervention'] ?? '',
    );
  }
}