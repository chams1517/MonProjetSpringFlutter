import 'package:flutter/material.dart';
import '../models/tpe.dart';
import '../models/station.dart';
import '../services/tpe_service.dart';
import '../services/station_service.dart';
import '../services/affectation_service.dart';

class AffecterTpeScreen extends StatefulWidget {
  const AffecterTpeScreen({super.key});

  @override
  State<AffecterTpeScreen> createState() => _AffecterTpeScreenState();
}

class _AffecterTpeScreenState extends State<AffecterTpeScreen> {
  final _tpeService = TpeService();
  final _stationService = StationService();
  final _affectationService = AffectationService();

  List<Tpe> _tpes = [];
  List<Station> _stations = [];
  Tpe? _tpeSelectionne;
  Station? _stationSelectionnee;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    final tpes = await _tpeService.getAllTpe();
    final stations = await _stationService.getAllStations();
    setState(() {
      _tpes = tpes;
      _stations = stations;
    });
  }

  Future<void> _affecter() async {
    if (_tpeSelectionne == null || _stationSelectionnee == null) return;

    setState(() => _isLoading = true);
    try {
      await _affectationService.affecterTpe(_tpeSelectionne!.id, _stationSelectionnee!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('TPE affecté avec succès')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'affectation')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _desaffecter() async {
    if (_tpeSelectionne == null) return;

    setState(() => _isLoading = true);
    try {
      await _affectationService.desaffecterTpe(_tpeSelectionne!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('TPE désaffecté avec succès')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur : TPE non affecté actuellement')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Affecter / Désaffecter un TPE')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Tpe>(
              initialValue: _tpeSelectionne,
              decoration: const InputDecoration(labelText: 'TPE'),
              items: _tpes.map((tpe) {
                return DropdownMenuItem(
                  value: tpe,
                  child: Text('${tpe.numeroSerie} (${tpe.etat})'),
                );
              }).toList(),
              onChanged: (valeur) => setState(() => _tpeSelectionne = valeur),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Station>(
              initialValue: _stationSelectionnee,
              decoration: const InputDecoration(labelText: 'Station (pour affecter)'),
              items: _stations.map((station) {
                return DropdownMenuItem(value: station, child: Text(station.nom));
              }).toList(),
              onChanged: (valeur) => setState(() => _stationSelectionnee = valeur),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _affecter,
                    child: const Text('Affecter'),
                  ),
                  ElevatedButton(
                    onPressed: _desaffecter,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Désaffecter'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}