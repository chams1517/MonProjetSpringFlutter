import 'package:flutter/material.dart';
import '../services/station_service.dart';

class CreerStationScreen extends StatefulWidget {
  const CreerStationScreen({super.key});

  @override
  State<CreerStationScreen> createState() => _CreerStationScreenState();
}

class _CreerStationScreenState extends State<CreerStationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stationService = StationService();
  final _nomController = TextEditingController();
  final _adresseController = TextEditingController();
  final _villeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _creer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _stationService.createStation(
        _nomController.text,
        _adresseController.text,
        _villeController.text,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la création')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle Station')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (valeur) {
                  if (valeur == null || valeur.isEmpty) return 'Champ obligatoire';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(labelText: 'Adresse'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _villeController,
                decoration: const InputDecoration(labelText: 'Ville'),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _creer,
                child: const Text('Créer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}