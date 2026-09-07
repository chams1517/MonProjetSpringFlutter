import 'package:flutter/material.dart';
import '../models/affectation.dart';
import '../services/affectation_service.dart';
import '../theme/app_colors_ext.dart';
import '../widgets/data_row_tile.dart';
import '../widgets/filter_search_bar.dart';

class AffectationListScreen extends StatefulWidget {
  const AffectationListScreen({super.key});

  @override
  State<AffectationListScreen> createState() => _AffectationListScreenState();
}

class _AffectationListScreenState extends State<AffectationListScreen> {
  final _service = AffectationService();
  List<Affectation> _toutes = [];
  List<Affectation> _filtrees = [];
  bool _loading = true;
  String? _erreur;
  String _recherche = '';
  String? _stationSelectionnee;

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
      final data = await _service.getAffectationsActives();
      setState(() {
        _toutes = data;
        _appliquerFiltres();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erreur = 'Impossible de charger les affectations';
        _loading = false;
      });
    }
  }

  void _appliquerFiltres() {
    _filtrees = _toutes.where((a) {
      final texte = '${a.tpe.numeroSerie} ${a.tpe.modele ?? ''}'.toLowerCase();
      final correspondRecherche = _recherche.isEmpty || texte.contains(_recherche.toLowerCase());
      final correspondStation = _stationSelectionnee == null || a.station.nom == _stationSelectionnee;
      return correspondRecherche && correspondStation;
    }).toList();
  }

  Future<void> _desaffecter(Affectation affectation) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Désaffecter ce TPE ?'),
        content: Text('${affectation.tpe.numeroSerie} sera retiré de ${affectation.station.nom}.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Désaffecter')),
        ],
      ),
    );
    if (confirme == true) {
      try {
        await _service.desaffecterTpe(affectation.tpe.id);
        _charger();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stationsUniques = _toutes.map((a) => a.station.nom).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text('TPE affectés')),
      body: Column(
        children: [
          FilterSearchBar(
            hintText: 'Rechercher un numéro de série…',
            onSearchChanged: (v) => setState(() {
              _recherche = v;
              _appliquerFiltres();
            }),
            filterOptions: stationsUniques,
            selectedFilter: _stationSelectionnee,
            onFilterChanged: (v) => setState(() {
              _stationSelectionnee = v;
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
                ? const Center(child: Text('Aucun TPE affecté'))
                : ListView.builder(
              itemCount: _filtrees.length,
              itemBuilder: (context, index) {
                final a = _filtrees[index];
                return DataRowTile(
                  accentColor: context.appColors.etatAffecte,
                  title: a.tpe.numeroSerie,
                  monoSubtitle: '${a.tpe.modele ?? ''} · ${a.station.nom}',
                  trailing: TextButton(
                    onPressed: () => _desaffecter(a),
                    child: const Text('Désaffecter'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}