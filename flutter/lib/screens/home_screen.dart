import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors_ext.dart';
import '../widgets/app_logo.dart';
import '../widgets/data_row_tile.dart';
import '../widgets/theme_toggle_button.dart';
import 'tpe_list_screen.dart';
import 'station_list_screen.dart';
import 'declarer_panne_screen.dart';
import 'panne_list_screen.dart';
import 'creer_intervention_screen.dart';
import 'intervention_list_screen.dart';
import 'affecter_tpe_screen.dart';
import 'affectation_list_screen.dart';
import 'dashboard_screen.dart';
import 'parametrage_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.role;

    return Scaffold(
      appBar: AppBar(
        title: role == 'USER'
            ? Text(auth.stationNom ?? 'Station')
            : const AppLogo(size: 20),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
          ),
        ],
      ),
      body: switch (role) {
        'USER' => const _AccueilUser(),
        'TECHNICIEN' => const _AccueilTechnicien(),
        _ => const _AccueilAdmin(),
      },
    );
  }
}

/// USER (station) : un seul geste possible, pas de menu à parcourir.
class _AccueilUser extends StatelessWidget {
  const _AccueilUser();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.report_problem_outlined, size: 34, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 20),
            Text('Signaler une panne', style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Déclarez un problème sur un terminal de votre station.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeclarerPanneScreen())),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('Déclarer une panne'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// TECHNICIEN : vue globale, liste console.
class _AccueilTechnicien extends StatelessWidget {
  const _AccueilTechnicien();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    final items = [
      (c.etatPanne, 'Déclarations', 'Toutes stations', Icons.warning_amber_rounded, const PanneListScreen()),
      (c.etatReparation, 'Créer une déclaration', 'Signaler une panne', Icons.add_alert_outlined, const DeclarerPanneScreen()),
      (secondary, 'Interventions', 'Historique des réparations', Icons.build_outlined, const InterventionListScreen()),
      (primary, 'Créer une intervention', 'Réparer un terminal', Icons.handyman_outlined, const CreerInterventionScreen()),
      (c.etatStock, 'Terminaux', 'Numéro, modèle, état', Icons.point_of_sale_outlined, const TpeListScreen()),
      (primary, 'Stations', 'Liste des points de vente', Icons.store_outlined, const StationListScreen()),
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 8),
      children: items
          .map((e) => DataRowTile(
        accentColor: e.$1,
        title: e.$2,
        monoSubtitle: e.$3,
        leadingIcon: e.$4,
        trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => e.$5)),
      ))
          .toList(),
    );
  }
}

/// ADMIN : accès complet, y compris paramétrage avancé.
class _AccueilAdmin extends StatelessWidget {
  const _AccueilAdmin();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    final items = [
      (c.etatStock, 'Terminaux', 'Numéro, modèle, état', Icons.point_of_sale_outlined, const TpeListScreen()),
      (primary, 'Stations', 'Points de vente', Icons.store_outlined, const StationListScreen()),
      (c.etatPanne, 'Déclarations', 'Toutes les pannes', Icons.warning_amber_rounded, const PanneListScreen()),
      (secondary, 'Interventions', 'Réparations', Icons.build_outlined, const InterventionListScreen()),
      (c.etatAffecte, 'Affecter un TPE', 'Assigner à une station', Icons.swap_horiz, const AffecterTpeScreen()),
      (c.etatReparation, 'TPE affectés', 'Consulter, désaffecter', Icons.assignment_outlined, const AffectationListScreen()),
      (c.etatRepare, 'Tableau de bord', 'Statistiques', Icons.bar_chart_outlined, const DashboardScreen()),
      (muted, 'Paramétrage avancé', 'Types, utilisateurs, stations', Icons.settings_outlined, const ParametrageScreen()),
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 8),
      children: items
          .map((e) => DataRowTile(
        accentColor: e.$1,
        title: e.$2,
        monoSubtitle: e.$3,
        leadingIcon: e.$4,
        trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => e.$5)),
      ))
          .toList(),
    );
  }
}