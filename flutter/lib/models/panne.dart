import 'tpe.dart';
import 'type_panne.dart';
import 'station.dart';

class Panne {
  final int id;
  final Tpe tpe;
  final TypePanne typePanne;
  final Station? station;
  final String? description;
  final String statut;
  final String dateDeclaration;

  Panne({
    required this.id,
    required this.tpe,
    required this.typePanne,
    this.station,
    this.description,
    required this.statut,
    required this.dateDeclaration,
  });

  factory Panne.fromJson(Map<String, dynamic> json) {
    return Panne(
      id: json['id'],
      tpe: Tpe.fromJson(json['tpe']),
      typePanne: TypePanne.fromJson(json['typePanne']),
      station: json['station'] != null ? Station.fromJson(json['station']) : null,
      description: json['description'],
      statut: json['statut'] ?? 'DECLAREE',
      dateDeclaration: json['dateDeclaration'] ?? '',
    );
  }
}