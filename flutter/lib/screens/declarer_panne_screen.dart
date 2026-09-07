import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tpe.dart';
import '../models/type_panne.dart';
import '../models/affectation.dart';
import '../providers/auth_provider.dart';
import '../services/tpe_service.dart';
import '../services/panne_service.dart';
import '../services/type_panne_service.dart';
import '../services/affectation_service.dart';

class DeclarerPanneScreen extends StatefulWidget {
  const DeclarerPanneScreen({super.key});

  @override
  State<DeclarerPanneScreen> createState() => _DeclarerPanneScreenState();
}

class _DeclarerPanneScreenState extends State<DeclarerPanneScreen> {
  final _tpeService = TpeService();
  final _typePanneService = TypePanneService();
  final _panneService = PanneService();
  final _affectationService = AffectationService();
  final _descriptionController = TextEditingController();

  List<Tpe> _tpes = [];
  List<TypePanne> _typesPanne = [];
  List<Affectation> _affectationsActives = [];
  String? _stationSelectionnee;
  Tpe? _tpeSelectionne;
  TypePanne? _typePanneSelectionne;
  bool _isLoading = false;
  bool _isLoadingDonnees = true;
  String? _erreurChargement;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    setState(() {
      _isLoadingDonnees = true;
      _erreurChargement = null;
    });
    try {
      final estUser = context.read<AuthProvider>().isUser;
      final typesPanne = await _typePanneService.getAllTypesPanne();

      if (estUser) {
        // USER : déjà scopé à sa station côté backend, pas besoin de sélecteur de station.
        final tpes = await _tpeService.getTpePourDeclaration();
        setState(() {
          _tpes = tpes;
          _typesPanne = typesPanne;
          _isLoadingDonnees = false;
        });
      } else {
        // ADMIN / TECHNICIEN : on charge les affectations actives pour construire le filtre par station.
        final affectations = await _affectationService.getAffectationsActives();
        setState(() {
          _affectationsActives = affectations;
          _typesPanne = typesPanne;
          _isLoadingDonnees = false;
        });
      }
    } catch (e) {
      setState(() {
        _erreurChargement = 'Impossible de charger les terminaux disponibles';
        _isLoadingDonnees = false;
      });
    }
  }

  List<Tpe> get _tpesFiltresParStation {
    if (_stationSelectionnee == null) return [];
    return _affectationsActives
        .where((a) => a.station.nom == _stationSelectionnee)
        .map((a) => a.tpe)
        .toList();
  }

  Future<void> _declarer() async {
    if (_tpeSelectionne == null || _typePanneSelectionne == null) return;

    setState(() => _isLoading = true);
    try {
      await _panneService.declarerPanne(
        _tpeSelectionne!.id,
        _typePanneSelectionne!.id,
        _descriptionController.text,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estUser = context.watch<AuthProvider>().isUser;
    final stationsUniques = _affectationsActives.map((a) => a.station.nom).toSet().toList();
    final listeTpeAffichee = estUser ? _tpes : _tpesFiltresParStation;

    return Scaffold(
      appBar: AppBar(title: const Text('Déclarer une panne')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoadingDonnees
            ? const Center(child: CircularProgressIndicator())
            : _erreurChargement != null
            ? Center(child: Text(_erreurChargement!))
            : Column(
          children: [
            if (!estUser) ...[
              DropdownButtonFormField<String>(
                initialValue: _stationSelectionnee,
                decoration: const InputDecoration(labelText: 'Station'),
                items: stationsUniques.map((nom) {
                  return DropdownMenuItem(value: nom, child: Text(nom));
                }).toList(),
                onChanged: (valeur) => setState(() {
                  _stationSelectionnee = valeur;
                  _tpeSelectionne = null;
                }),
              ),
              const SizedBox(height: 16),
            ],
            if (!estUser && _stationSelectionnee == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('Choisissez une station pour voir ses terminaux'),
              )
            else if (listeTpeAffichee.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('Aucun terminal disponible'),
              )
            else ...[
                DropdownButtonFormField<Tpe>(
                  initialValue: _tpeSelectionne,
                  decoration: const InputDecoration(labelText: 'TPE'),
                  items: listeTpeAffichee.map((tpe) {
                    return DropdownMenuItem(value: tpe, child: Text(tpe.numeroSerie));
                  }).toList(),
                  onChanged: (valeur) => setState(() => _tpeSelectionne = valeur),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TypePanne>(
                  initialValue: _typePanneSelectionne,
                  decoration: const InputDecoration(labelText: 'Type de panne'),
                  items: _typesPanne.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type.libelle));
                  }).toList(),
                  onChanged: (valeur) => setState(() => _typePanneSelectionne = valeur),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(onPressed: _declarer, child: const Text('Déclarer')),
              ],
          ],
        ),
      ),
    );
  }
}