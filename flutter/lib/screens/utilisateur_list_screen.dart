import 'package:flutter/material.dart';
import '../models/utilisateur.dart';
import '../services/utilisateur_service.dart';
import '../theme/app_colors_ext.dart';
import '../widgets/data_row_tile.dart';
import '../widgets/filter_search_bar.dart';
import 'utilisateur_form_screen.dart';

class UtilisateurListScreen extends StatefulWidget {
  const UtilisateurListScreen({super.key});

  @override
  State<UtilisateurListScreen> createState() => _UtilisateurListScreenState();
}

class _UtilisateurListScreenState extends State<UtilisateurListScreen> {
  final _service = UtilisateurService();
  List<Utilisateur> _tous = [];
  List<Utilisateur> _filtres = [];
  bool _loading = true;
  String? _erreur;
  String _recherche = '';
  String? _roleSelectionne;

  static const _roles = ['ADMIN', 'TECHNICIEN', 'USER'];

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
      final data = await _service.getAllUtilisateurs();
      setState(() {
        _tous = data;
        _appliquerFiltres();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erreur = 'Impossible de charger les utilisateurs';
        _loading = false;
      });
    }
  }

  void _appliquerFiltres() {
    _filtres = _tous.where((u) {
      final texte = '${u.prenom} ${u.nom} ${u.email}'.toLowerCase();
      final correspondRecherche = _recherche.isEmpty || texte.contains(_recherche.toLowerCase());
      final correspondRole = _roleSelectionne == null || u.role == _roleSelectionne;
      return correspondRecherche && correspondRole;
    }).toList();
  }

  Color _couleurRole(BuildContext context, String role) {
    final theme = Theme.of(context);
    switch (role) {
      case 'ADMIN':
        return theme.colorScheme.secondary;
      case 'TECHNICIEN':
        return theme.colorScheme.primary;
      case 'USER':
        return context.appColors.etatStock;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  Future<void> _confirmerSuppression(Utilisateur utilisateur) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cet utilisateur ?'),
        content: Text('${utilisateur.prenom} ${utilisateur.nom} sera définitivement supprimé.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Supprimer', style: TextStyle(color: context.appColors.etatPanne)),
          ),
        ],
      ),
    );

    if (confirme == true && utilisateur.id != null) {
      try {
        await _service.deleteUtilisateur(utilisateur.id!);
        _charger();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Utilisateurs')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultat = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UtilisateurFormScreen()),
          );
          if (resultat == true) _charger();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          FilterSearchBar(
            hintText: 'Rechercher un nom ou un email…',
            onSearchChanged: (v) => setState(() {
              _recherche = v;
              _appliquerFiltres();
            }),
            filterOptions: _roles,
            selectedFilter: _roleSelectionne,
            onFilterChanged: (v) => setState(() {
              _roleSelectionne = v;
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
                ? const Center(child: Text('Aucun utilisateur'))
                : ListView.builder(
              itemCount: _filtres.length,
              itemBuilder: (context, index) {
                final u = _filtres[index];
                final sousTitre = u.role == 'USER' && u.station != null
                    ? '${u.email} · ${u.station!.nom}'
                    : u.email;
                return DataRowTile(
                  accentColor: _couleurRole(context, u.role),
                  title: '${u.prenom} ${u.nom}',
                  monoSubtitle: sousTitre,
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: context.appColors.etatPanne),
                    onPressed: () => _confirmerSuppression(u),
                  ),
                  onTap: () async {
                    final resultat = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => UtilisateurFormScreen(utilisateur: u)),
                    );
                    if (resultat == true) _charger();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}