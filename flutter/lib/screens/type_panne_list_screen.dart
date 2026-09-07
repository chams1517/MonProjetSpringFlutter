import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/type_panne.dart';
import '../providers/auth_provider.dart';
import '../services/type_panne_service.dart';
import '../theme/app_colors_ext.dart';
import '../widgets/data_row_tile.dart';
import '../widgets/filter_search_bar.dart';

class TypePanneListScreen extends StatefulWidget {
  const TypePanneListScreen({super.key});

  @override
  State<TypePanneListScreen> createState() => _TypePanneListScreenState();
}

class _TypePanneListScreenState extends State<TypePanneListScreen> {
  final _service = TypePanneService();
  List<TypePanne> _tous = [];
  List<TypePanne> _filtres = [];
  bool _loading = true;
  String? _erreur;

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
      final data = await _service.getAllTypesPanne();
      setState(() {
        _tous = data;
        _filtres = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erreur = 'Impossible de charger les types de panne';
        _loading = false;
      });
    }
  }

  Future<void> _ajouter() async {
    final controller = TextEditingController();
    final descController = TextEditingController();
    final libelle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau type de panne'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: controller, decoration: const InputDecoration(labelText: 'Libellé')),
            const SizedBox(height: 10),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description (optionnel)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Créer')),
        ],
      ),
    );

    if (libelle != null && libelle.isNotEmpty) {
      try {
        await _service.creerTypePanne(libelle, descController.text.isEmpty ? null : descController.text);
        _charger();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
  }

  Future<void> _supprimer(TypePanne type) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce type ?'),
        content: Text('"${type.libelle}" sera définitivement supprimé.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Supprimer', style: TextStyle(color: context.appColors.etatPanne)),
          ),
        ],
      ),
    );
    if (confirme == true) {
      try {
        await _service.deleteTypePanne(type.id);
        _charger();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Scaffold(
      appBar: AppBar(title: const Text('Types de panne')),
      floatingActionButton: isAdmin ? FloatingActionButton(onPressed: _ajouter, child: const Icon(Icons.add)) : null,
      body: Column(
        children: [
          FilterSearchBar(
            hintText: 'Rechercher un type…',
            onSearchChanged: (v) => setState(() {
              _filtres = _tous.where((t) => t.libelle.toLowerCase().contains(v.toLowerCase())).toList();
            }),
            filterOptions: const [],
            selectedFilter: null,
            onFilterChanged: (_) {},
          ),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _erreur != null
                ? Center(child: Text(_erreur!))
                : ListView.builder(
              itemCount: _filtres.length,
              itemBuilder: (context, index) {
                final t = _filtres[index];
                return DataRowTile(
                  accentColor: context.appColors.etatPanne,
                  title: t.libelle,
                  monoSubtitle: t.description,
                  trailing: isAdmin
                      ? IconButton(
                    icon: Icon(Icons.delete_outline, color: context.appColors.etatPanne),
                    onPressed: () => _supprimer(t),
                  )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}