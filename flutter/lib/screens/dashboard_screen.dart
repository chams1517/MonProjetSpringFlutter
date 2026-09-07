import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dashboard_stats.dart';
import '../services/dashboard_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dashboardService = DashboardService();
  late Future<DashboardStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _dashboardService.getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: FutureBuilder<DashboardStats>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final stats = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _StatCard('Total TPE', stats.totalTpe, Icons.point_of_sale, const Color(0xFF4F46E5)),
                  _StatCard('En stock', stats.tpeEnStock, Icons.inventory_2, const Color(0xFF64748B)),
                  _StatCard('Affectés', stats.tpeAffecte, Icons.store, const Color(0xFF16A34A)),
                  _StatCard('En panne', stats.tpeEnPanne, Icons.report_problem, const Color(0xFFDC2626)),
                  _StatCard('En réparation', stats.tpeEnReparation, Icons.build, const Color(0xFFF59E0B)),
                  _StatCard('Réparés', stats.tpeRepare, Icons.check_circle, const Color(0xFF0D9488)),
                ],
              ),
              const SizedBox(height: 24),
              _SectionCard(
                titre: 'Répartition des TPE',
                enfant: SizedBox(
                  height: 200,
                  child: _RepartitionChart(stats: stats),
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                titre: 'TPE les plus en panne',
                enfant: Column(
                  children: stats.tpeLesPlusEnPanne.isEmpty
                      ? [const Text('Aucune donnée', style: TextStyle(color: Colors.grey))]
                      : stats.tpeLesPlusEnPanne.map((item) {
                    return _LigneClassement(
                      titre: item['numeroSerie'],
                      valeur: '${item['nombrePannes']} pannes',
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                titre: 'Types de panne fréquents',
                enfant: Column(
                  children: stats.typesPanneLesPlusFrequents.isEmpty
                      ? [const Text('Aucune donnée', style: TextStyle(color: Colors.grey))]
                      : stats.typesPanneLesPlusFrequents.map((item) {
                    return _LigneClassement(
                      titre: item['typePanne'],
                      valeur: '${item['nombre']} fois',
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int valeur;
  final IconData icone;
  final Color couleur;

  const _StatCard(this.label, this.valeur, this.icone, this.couleur);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: couleur.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icone, color: couleur, size: 20),
          ),
          const Spacer(),
          Text(
            '$valeur',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String titre;
  final Widget enfant;

  const _SectionCard({required this.titre, required this.enfant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          enfant,
        ],
      ),
    );
  }
}

class _LigneClassement extends StatelessWidget {
  final String titre;
  final String valeur;

  const _LigneClassement({required this.titre, required this.valeur});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(titre)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              valeur,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RepartitionChart extends StatelessWidget {
  final DashboardStats stats;

  const _RepartitionChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final donnees = [
      _Barre('Stock', stats.tpeEnStock, const Color(0xFF64748B)),
      _Barre('Affecté', stats.tpeAffecte, const Color(0xFF16A34A)),
      _Barre('Panne', stats.tpeEnPanne, const Color(0xFFDC2626)),
      _Barre('Répar.', stats.tpeEnReparation, const Color(0xFFF59E0B)),
      _Barre('Réparé', stats.tpeRepare, const Color(0xFF0D9488)),
    ];
    final maxY = donnees.map((b) => b.valeur).fold(0, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: (maxY == 0 ? 1 : maxY).toDouble() + 1,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= donnees.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(donnees[index].label, style: const TextStyle(fontSize: 11)),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(donnees.length, (index) {
          final barre = donnees[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: barre.valeur.toDouble(),
                color: barre.couleur,
                width: 22,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _Barre {
  final String label;
  final int valeur;
  final Color couleur;

  _Barre(this.label, this.valeur, this.couleur);
}