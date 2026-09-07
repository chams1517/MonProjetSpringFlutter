import 'package:flutter/material.dart';
import '../models/panne_simple.dart';
import '../models/type_intervention.dart';
import '../services/intervention_service.dart';
import '../services/type_intervention_service.dart';

class CreerInterventionScreen extends StatefulWidget {
  const CreerInterventionScreen({super.key});

  @override
  State<CreerInterventionScreen> createState() => _CreerInterventionScreenState();
}

class _CreerInterventionScreenState extends State<CreerInterventionScreen> {
  final _interventionService = InterventionService();
  final _typeInterventionService = TypeInterventionService();
  final _observationsController = TextEditingController();

  List<PanneSimple> _pannes = [];
  List<TypeIntervention> _typesIntervention = [];
  PanneSimple? _panneSelectionnee;
  TypeIntervention? _typeSelectionne;
  String _resultat = 'REUSSIE';
  bool _isLoading = false;

  final List<String> _resultats = ['REUSSIE', 'ECHOUEE', 'EN_ATTENTE_PIECE'];

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    final pannes = await _interventionService.getAllPannes();
    final types = await _typeInterventionService.getAllTypesIntervention();
    setState(() {
      _pannes = pannes;
      _typesIntervention = types;
    });
  }

  Future<void> _creer() async {
    if (_panneSelectionnee == null || _typeSelectionne == null) return;

    setState(() => _isLoading = true);
    try {
      await _interventionService.creerIntervention(
        _panneSelectionnee!.id,
        _typeSelectionne!.id,
        _observationsController.text,
        _resultat,
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
      appBar: AppBar(title: const Text('Créer une intervention')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<PanneSimple>(
              initialValue: _panneSelectionnee,
              decoration: const InputDecoration(labelText: 'Panne'),
              items: _pannes.map((panne) {
                return DropdownMenuItem(
                  value: panne,
                  child: Text('${panne.numeroSerieTpe} (${panne.statut})'),
                );
              }).toList(),
              onChanged: (valeur) => setState(() => _panneSelectionnee = valeur),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TypeIntervention>(
              initialValue: _typeSelectionne,
              decoration: const InputDecoration(labelText: 'Type d\'intervention'),
              items: _typesIntervention.map((type) {
                return DropdownMenuItem(value: type, child: Text(type.libelle));
              }).toList(),
              onChanged: (valeur) => setState(() => _typeSelectionne = valeur),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _resultat,
              decoration: const InputDecoration(labelText: 'Résultat'),
              items: _resultats.map((r) {
                return DropdownMenuItem(value: r, child: Text(r));
              }).toList(),
              onChanged: (valeur) => setState(() => _resultat = valeur!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _observationsController,
              decoration: const InputDecoration(labelText: 'Observations'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _creer,
              child: const Text('Créer l\'intervention'),
            ),
          ],
        ),
      ),
    );
  }
}