import 'package:flutter/material.dart';
import '../theme/app_colors_ext.dart';

enum EtatKind { stock, affecte, panne, reparation, repare, horsService, inconnu }

class StatusInfo {
  final String label;
  final EtatKind kind;
  const StatusInfo(this.label, this.kind);

  Color color(BuildContext context) {
    final c = context.appColors;
    switch (kind) {
      case EtatKind.stock:
        return c.etatStock;
      case EtatKind.affecte:
        return c.etatAffecte;
      case EtatKind.panne:
        return c.etatPanne;
      case EtatKind.reparation:
        return c.etatReparation;
      case EtatKind.repare:
        return c.etatRepare;
      case EtatKind.horsService:
        return c.etatHorsService;
      case EtatKind.inconnu:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }
}

StatusInfo etatTpeInfo(String etat) {
  switch (etat) {
    case 'EN_STOCK':
      return const StatusInfo('En stock', EtatKind.stock);
    case 'AFFECTE':
      return const StatusInfo('Affecté', EtatKind.affecte);
    case 'EN_PANNE':
      return const StatusInfo('En panne', EtatKind.panne);
    case 'EN_REPARATION':
      return const StatusInfo('En réparation', EtatKind.reparation);
    case 'REPARE':
      return const StatusInfo('Réparé', EtatKind.repare);
    case 'HORS_SERVICE':
      return const StatusInfo('Hors service', EtatKind.horsService);
    default:
      return const StatusInfo('—', EtatKind.inconnu);
  }
}

StatusInfo statutPanneInfo(String statut) {
  switch (statut) {
    case 'DECLAREE':
      return const StatusInfo('Déclarée', EtatKind.panne);
    case 'EN_COURS':
      return const StatusInfo('En cours', EtatKind.reparation);
    case 'RESOLUE':
      return const StatusInfo('Résolue', EtatKind.repare);
    default:
      return const StatusInfo('—', EtatKind.inconnu);
  }
}

StatusInfo resultatInterventionInfo(String? resultat) {
  switch (resultat) {
    case 'REUSSIE':
      return const StatusInfo('Réussie', EtatKind.repare);
    case 'ECHOUEE':
      return const StatusInfo('Échouée', EtatKind.panne);
    case 'EN_ATTENTE_PIECE':
      return const StatusInfo('Attente pièce', EtatKind.reparation);
    default:
      return const StatusInfo('En attente', EtatKind.inconnu);
  }
}

class StatusChip extends StatelessWidget {
  final StatusInfo status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(status.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}