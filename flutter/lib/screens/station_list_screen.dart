import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/station.dart';
import '../providers/auth_provider.dart';
import '../services/station_service.dart';
import '../widgets/data_row_tile.dart';
import '../widgets/filter_search_bar.dart';
import 'creer_station_screen.dart';

class StationListScreen extends StatefulWidget {
  const StationListScreen({super.key});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  final _stationService = StationService();
  List<Station> _toutes = [];
  List<Station> _filtrees = [];
  bool _loading = true;
  String? _erreur;
  String _recherche = '';
  String? _statutSelectionne;

  static const _statuts = ['Active', 'Inactive'];

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
      final data = await _stationService.getAllStations();
      setState(() {
        _toutes = data;
        _appliquerFiltres();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erreur = 'Impossible de charger les stations';
        _loading = false;
      });
    }
  }

  void _appliquerFiltres() {
    _filtrees = _toutes.where((s) {
      final texte = '${s.nom} ${s.ville ?? ''}'.toLowerCase();
      final correspondRecherche = _recherche.isEmpty || texte.contains(_recherche.toLowerCase());
      final correspondStatut = _statutSelectionne == null ||
          (_statutSelectionne == 'Active' && s.actif) ||
          (_statutSelectionne == 'Inactive' && !s.actif);
      return correspondRecherche && correspondStatut;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Stations')),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        onPressed: () async {
          final resultat = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreerStationScreen()),
          );
          if (resultat == true) _charger();
        },
        child: const Icon(Icons.add),
      )
          : null,
      body: Column(
        children: [
          FilterSearchBar(
            hintText: 'Rechercher une station ou une ville…',
            onSearchChanged: (v) => setState(() {
              _recherche = v;
              _appliquerFiltres();
            }),
            filterOptions: _statuts,
            selectedFilter: _statutSelectionne,
            onFilterChanged: (v) => setState(() {
              _statutSelectionne = v;
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
                ? const Center(child: Text('Aucune station'))
                : ListView.builder(
              itemCount: _filtrees.length,
              itemBuilder: (context, index) {
                final s = _filtrees[index];
                final couleur = s.actif ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;
                return DataRowTile(
                  accentColor: couleur,
                  title: s.nom,
                  monoSubtitle: s.ville ?? s.adresse ?? '—',
                  trailing: Icon(
                    s.actif ? Icons.check_circle_outline : Icons.cancel_outlined,
                    color: couleur,
                    size: 20,
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