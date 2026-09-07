import 'package:flutter/material.dart';
import '../models/station.dart';
import '../models/utilisateur.dart';
import '../services/station_service.dart';
import '../services/utilisateur_service.dart';
import '../theme/app_colors_ext.dart';
import '../theme/app_theme.dart';

class UtilisateurFormScreen extends StatefulWidget {
  final Utilisateur? utilisateur;
  const UtilisateurFormScreen({super.key, this.utilisateur});

  @override
  State<UtilisateurFormScreen> createState() => _UtilisateurFormScreenState();
}

class _UtilisateurFormScreenState extends State<UtilisateurFormScreen> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _utilisateurService = UtilisateurService();
  final _stationService = StationService();

  String _role = 'TECHNICIEN';
  Station? _stationSelectionnee;
  List<Station> _stations = [];
  bool _isLoading = false;
  bool _loadingStations = true;
  String? _erreur;

  bool get _modeEdition => widget.utilisateur != null;

  @override
  void initState() {
    super.initState();
    if (_modeEdition) {
      final u = widget.utilisateur!;
      _nomController.text = u.nom;
      _prenomController.text = u.prenom;
      _emailController.text = u.email;
      _role = u.role;
      _stationSelectionnee = u.station;
    }
    _chargerStations();
  }

  Future<void> _chargerStations() async {
    try {
      final stations = await _stationService.getAllStations();
      setState(() {
        _stations = stations;
        _loadingStations = false;
      });
    } catch (e) {
      setState(() => _loadingStations = false);
    }
  }

  Future<void> _enregistrer() async {
    if (_nomController.text.isEmpty || _prenomController.text.isEmpty || _emailController.text.isEmpty) {
      setState(() => _erreur = 'Tous les champs sont obligatoires');
      return;
    }
    if (!_modeEdition && _motDePasseController.text.isEmpty) {
      setState(() => _erreur = 'Le mot de passe est obligatoire à la création');
      return;
    }
    if (_role == 'USER' && _stationSelectionnee == null) {
      setState(() => _erreur = 'Une station est obligatoire pour un compte station');
      return;
    }

    setState(() {
      _isLoading = true;
      _erreur = null;
    });

    final utilisateur = Utilisateur(
      id: widget.utilisateur?.id,
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
      role: _role,
      station: _role == 'USER' ? _stationSelectionnee : null,
    );

    try {
      if (_modeEdition) {
        await _utilisateurService.updateUtilisateur(
          widget.utilisateur!.id!,
          utilisateur,
          motDePasse: _motDePasseController.text.isEmpty ? null : _motDePasseController.text,
        );
      } else {
        await _utilisateurService.creerUtilisateur(utilisateur, _motDePasseController.text);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _erreur = 'Échec de l\'enregistrement');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(title: Text(_modeEdition ? 'Modifier l\'utilisateur' : 'Nouvel utilisateur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _prenomController, decoration: const InputDecoration(labelText: 'Prénom')),
            const SizedBox(height: 14),
            TextField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nom')),
            const SizedBox(height: 14),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _motDePasseController,
              decoration: InputDecoration(
                labelText: _modeEdition ? 'Nouveau mot de passe (optionnel)' : 'Mot de passe',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Text('Rôle', style: AppTheme.mono(size: 12, weight: FontWeight.w600, color: mutedColor)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'ADMIN', label: Text('Admin')),
                ButtonSegment(value: 'TECHNICIEN', label: Text('Technicien')),
                ButtonSegment(value: 'USER', label: Text('Station')),
              ],
              selected: {_role},
              onSelectionChanged: (selection) => setState(() {
                _role = selection.first;
                if (_role != 'USER') _stationSelectionnee = null;
              }),
            ),
            if (_role == 'USER') ...[
              const SizedBox(height: 20),
              Text('Station rattachée', style: AppTheme.mono(size: 12, weight: FontWeight.w600, color: mutedColor)),
              const SizedBox(height: 8),
              _loadingStations
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<Station>(
                initialValue: _stationSelectionnee,
                hint: const Text('Choisir une station'),
                items: _stations
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.nom)))
                    .toList(),
                onChanged: (s) => setState(() => _stationSelectionnee = s),
              ),
            ],
            if (_erreur != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.appColors.etatPanne.withValues(alpha: 0.08),
                  border: Border.all(color: context.appColors.etatPanne.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(_erreur!, style: TextStyle(color: context.appColors.etatPanne, fontSize: 13)),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _enregistrer,
              child: _isLoading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_modeEdition ? 'Enregistrer' : 'Créer l\'utilisateur'),
            ),
          ],
        ),
      ),
    );
  }
}