import 'package:flutter/material.dart';
import '../models/panne.dart';
import '../services/panne_service.dart';
import '../theme/app_theme.dart';
import '../widgets/filter_search_bar.dart';
import '../widgets/status_chip.dart';

class PanneListScreen extends StatefulWidget {
  const PanneListScreen({super.key});

  @override
  State<PanneListScreen> createState() => _PanneListScreenState();
}

class _PanneListScreenState extends State<PanneListScreen> {
  final _panneService = PanneService();
  List<Panne> _toutes = [];
  List<Panne> _filtrees = [];
  bool _loading = true;
  String? _erreur;
  String _recherche = '';
  String? _statutSelectionne;

  static const _statuts = ['DECLAREE', 'EN_COURS', 'RESOLUE'];

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
      final data = await _panneService.getAllPannes();
      setState(() {
        _toutes = data;
        _appliquerFiltres();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erreur = 'Impossible de charger les déclarations';
        _loading = false;
      });
    }
  }

  void _appliquerFiltres() {
    _filtrees = _toutes.where((p) {
      final texte = '${p.tpe.numeroSerie} ${p.typePanne.libelle} ${p.station?.nom ?? ''}'.toLowerCase();
      final correspondRecherche = _recherche.isEmpty || texte.contains(_recherche.toLowerCase());
      final correspondStatut = _statutSelectionne == null || p.statut == _statutSelectionne;
      return correspondRecherche && correspondStatut;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Déclarations')),
      body: Column(
        children: [
          FilterSearchBar(
            hintText: 'Rechercher un numéro de série…',
            onSearchChanged: (v) => setState(() {
              _recherche = v;
              _appliquerFiltres();
            }),
            filterOptions: _statuts.map((s) => statutPanneInfo(s).label).toList(),
            selectedFilter: _statutSelectionne != null ? statutPanneInfo(_statutSelectionne!).label : null,
            onFilterChanged: (label) => setState(() {
              _statutSelectionne = label == null ? null : _statuts.firstWhere((s) => statutPanneInfo(s).label == label);
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
                ? const Center(child: Text('Aucune déclaration'))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(theme.scaffoldBackgroundColor),
                  headingTextStyle: AppTheme.mono(size: 12, weight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant),
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 56,
                  columns: const [
                    DataColumn(label: Text('TPE')),
                    DataColumn(label: Text('Modèle')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Station')),
                    DataColumn(label: Text('Statut')),
                  ],
                  rows: _filtrees.map((p) {
                    return DataRow(cells: [
                      DataCell(Text(p.tpe.numeroSerie, style: AppTheme.mono(size: 13, color: theme.colorScheme.onSurface))),
                      DataCell(Text(p.tpe.modele ?? '—')),
                      DataCell(Text(p.typePanne.libelle)),
                      DataCell(Text(p.station?.nom ?? '—')),
                      DataCell(StatusChip(status: statutPanneInfo(p.statut))),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}