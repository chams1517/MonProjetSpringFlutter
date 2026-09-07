import 'package:flutter/material.dart';
import '../theme/app_colors_ext.dart';
import '../theme/app_theme.dart';
import '../widgets/data_row_tile.dart';
import 'station_list_screen.dart';
import 'type_panne_list_screen.dart';
import 'type_intervention_list_screen.dart';
import 'utilisateur_list_screen.dart';

class ParametrageScreen extends StatelessWidget {
  const ParametrageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = context.appColors;

    final sections = [
      _Section(
        titre: 'Stations',
        items: [
          _Item(theme.colorScheme.primary, 'Stations', 'Créer, modifier, désactiver', const StationListScreen()),
        ],
      ),
      _Section(
        titre: 'Catégories',
        items: [
          _Item(c.etatPanne, 'Types de panne', 'Catégories de pannes', const TypePanneListScreen()),
          _Item(theme.colorScheme.secondary, 'Types d\'intervention', 'Catégories d\'interventions', const TypeInterventionListScreen()),
        ],
      ),
      _Section(
        titre: 'Accès',
        items: [
          _Item(theme.colorScheme.onSurfaceVariant, 'Utilisateurs', 'Comptes admin, technicien, station', const UtilisateurListScreen()),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Paramétrage avancé')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          for (final section in sections) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                section.titre,
                style: AppTheme.mono(size: 12, weight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            ...section.items.map(
                  (item) => DataRowTile(
                accentColor: item.couleur,
                title: item.titre,
                monoSubtitle: item.description,
                trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.ecran)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Section {
  final String titre;
  final List<_Item> items;
  _Section({required this.titre, required this.items});
}

class _Item {
  final Color couleur;
  final String titre;
  final String description;
  final Widget ecran;
  _Item(this.couleur, this.titre, this.description, this.ecran);
}