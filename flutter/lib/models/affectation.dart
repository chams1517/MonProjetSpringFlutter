import 'tpe.dart';
import 'station.dart';

class Affectation {
  final int id;
  final Tpe tpe;
  final Station station;
  final String dateDebut;
  final String? dateFin;

  Affectation({
    required this.id,
    required this.tpe,
    required this.station,
    required this.dateDebut,
    this.dateFin,
  });

  factory Affectation.fromJson(Map<String, dynamic> json) {
    return Affectation(
      id: json['id'],
      tpe: Tpe.fromJson(json['tpe']),
      station: Station.fromJson(json['station']),
      dateDebut: json['dateDebut'] ?? '',
      dateFin: json['dateFin'],
    );
  }
}