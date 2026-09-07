import 'package:flutter/material.dart';
import '../models/tpe.dart';

class TpeDetailScreen extends StatelessWidget {
  final Tpe tpe;

  const TpeDetailScreen({super.key, required this.tpe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tpe.numeroSerie)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ligneInfo('Numéro de série', tpe.numeroSerie),
            _ligneInfo('Marque', tpe.marque ?? 'Non renseignée'),
            _ligneInfo('Modèle', tpe.modele ?? 'Non renseigné'),
            _ligneInfo('État', tpe.etat),
          ],
        ),
      ),
    );
  }

  Widget _ligneInfo(String label, String valeur) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(valeur)),
        ],
      ),
    );
  }
}