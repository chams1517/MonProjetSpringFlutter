import 'package:flutter/material.dart';
import '../models/tpe.dart';
import '../services/tpe_service.dart';
import '../widgets/data_row_tile.dart';
import '../widgets/filter_search_bar.dart';
import '../widgets/status_chip.dart';

class TpeListScreen extends StatefulWidget {
  const TpeListScreen({super.key});

  @override
  State<TpeListScreen> createState() => _TpeListScreenState();
}

class _TpeListScreenState extends State<TpeListScreen> {
  final _tpeService = TpeService();
  List<Tpe> _tous = [];
  List<Tpe> _filtres = [];
  bool _loading = true;
  String? _erreur;
  String _recherche = '';
  String? _etatSelectionne;

  static const _etatsFiltre = ['EN_STOCK', 'AFFECTE', 'EN_PANNE', 'EN_REPARATION', 'REPARE', 'HORS_SERVICE'];

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
      final data = await _tpeService.getAllTpe();
      setState(() {
        _tous = data;
        _appliquerFiltres();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erreur = 'Impossible de charger les terminaux';
        _loading = false;
      });
    }
  }

  void _appliquerFiltres() {
    _filtres = _tous.where((t) {
      final correspondRecherche = _recherche.isEmpty ||
          t.numeroSerie.toLowerCase().contains(_recherche.toLowerCase()) ||
          (t.modele ?? '').toLowerCase().contains(_recherche.toLowerCase());
      final correspondEtat = _etatSelectionne == null || t.etat == _etatSelectionne;
      return correspondRecherche && correspondEtat;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terminaux')),
      body: Column(
        children: [
          FilterSearchBar(
            hintText: 'Rechercher un numéro de série…',
            onSearchChanged: (v) => setState(() {
              _recherche = v;
              _appliquerFiltres();
            }),
            filterOptions: _etatsFiltre.map((e) => etatTpeInfo(e).label).toList(),
            selectedFilter: _etatSelectionne != null ? etatTpeInfo(_etatSelectionne!).label : null,
            onFilterChanged: (label) => setState(() {
              _etatSelectionne = label == null ? null : _etatsFiltre.firstWhere((e) => etatTpeInfo(e).label == label);
              _appliquerFiltres();
            }),
          ),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _erreur != null
                ? Center(child: Text(_erreur!))
                : _filtres.isEmpty
                ? Center(
              child: Text('Aucun terminal', style: Theme.of(context).textTheme.bodySmall),
            )
                : ListView.builder(
              itemCount: _filtres.length,
              itemBuilder: (context, index) {
                final tpe = _filtres[index];
                final status = etatTpeInfo(tpe.etat);
                return DataRowTile(
                  accentColor: status.color(context),
                  title: tpe.modele ?? tpe.marque ?? 'Terminal',
                  monoSubtitle: tpe.numeroSerie,
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