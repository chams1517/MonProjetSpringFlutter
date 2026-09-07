import 'package:flutter/material.dart';
import '../models/type_intervention.dart';
import '../services/type_intervention_service.dart';

class TypeInterventionListScreen extends StatefulWidget {
  const TypeInterventionListScreen({super.key});

  @override
  State<TypeInterventionListScreen> createState() => _TypeInterventionListScreenState();
}

class _TypeInterventionListScreenState extends State<TypeInterventionListScreen> {
  final _service = TypeInterventionService();
  late Future<List<TypeIntervention>> _future;
  final _libelleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rafraichir();
  }

  void _rafraichir() {
    setState(() {
      _future = _service.getAllTypesIntervention();
    });
  }

  void _afficherFormulaireAjout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Nouveau type d\'intervention'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _libelleController,
              decoration: const InputDecoration(labelText: 'Libellé'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _service.createTypeIntervention(
                _libelleController.text,
                _descriptionController.text,
              );
              _libelleController.clear();
              _descriptionController.clear();
              if (mounted) Navigator.pop(context);
              _rafraichir();
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Types d\'intervention')),
      floatingActionButton: FloatingActionButton(
        onPressed: _afficherFormulaireAjout,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<TypeIntervention>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final types = snapshot.data ?? [];
          if (types.isEmpty) {
            return const Center(child: Text('Aucun type d\'intervention'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: types.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.build, color: colorScheme.primary, size: 20),
                  ),
                  title: Text(
                    types[index].libelle,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}