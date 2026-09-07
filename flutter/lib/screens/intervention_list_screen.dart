import 'package:flutter/material.dart';
import '../models/intervention.dart';
import '../services/intervention_service.dart';
import '../widgets/data_row_tile.dart';
import '../widgets/filter_search_bar.dart';
import '../widgets/status_chip.dart';

class InterventionListScreen extends StatefulWidget {
  const InterventionListScreen({super.key});

  @override
  State<InterventionListScreen> createState() => _InterventionListScreenState();
}

class _InterventionListScreenState extends State<InterventionListScreen> {
  final _interventionService = InterventionService();
  List<Intervention> _toutes = [];
  List<Intervention> _filtrees = [];
  bool _loading = true;
  String? _erreur;
  String _recherche = '';
  String? _resultatSelectionne;

  static const _resultats = ['REUSSIE', 'ECHOUEE', 'EN_ATTENTE_PIECE'];

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() {
      _loading = true;
      _erreur = null;
    });
    try {
      final data = await _interventionService.getAllInterventions();
      setState(() {
        _toutes = data;
        _appliquerFiltres();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erreur = 'Impossible de charger les interventions';
        _loading = false;
      });
    }
  }

  void _appliquerFiltres() {
    _filtrees = _toutes.where((i) {
      final texte = '${i.panne.tpe.numeroSerie} ${i.typeIntervention.libelle}'.toLowerCase();
      final correspondRecherche = _recherche.isEmpty || texte.contains(_recherche.toLowerCase());
      final correspondResultat = _resultatSelectionne == null || i.resultat == _resultatSelectionne;
      return correspondRecherche && correspondResultat;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interventions')),
      body: Column(
        children: [
          FilterSearchBar(
            hintText: 'Rechercher un numéro de série…',
            onSearchChanged: (v) => setState(() {
              _recherche = v;
              _appliquerFiltres();
            }),
            filterOptions: _resultats.map((r) => resultatInterventionInfo(r).label).toList(),
            selectedFilter: _resultatSelectionne != null ? resultatInterventionInfo(_resultatSelectionne!).label : null,
            onFilterChanged: (label) => setState(() {
              _resultatSelectionne = label == null
                  ? null
                  : _resultats.firstWhere((r) => resultatInterventionInfo(r).label == label);
              _appliquerFiltres();
            }),
          ),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _erreur != null
                ? Center(child: Text(_erreur!))
                : _filtrees.isEmpty
                ? const Center(child: Text('Aucune intervention'))
                : ListView.builder(
              itemCount: _filtrees.length,
              itemBuilder: (context, index) {
                final i = _filtrees[index];
                final status = resultatInterventionInfo(i.resultat);
                return DataRowTile(
                  accentColor: status.color(context),
                  title: i.typeIntervention.libelle,
                  monoSubtitle: '${i.panne.tpe.numeroSerie} · ${i.panne.tpe.modele ?? ''}',
                  trailing: StatusChip(status: status),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}