import 'package:flutter/material.dart';
import '../services/tpe_service.dart';
import '../widgets/form_card.dart';

class CreerTpeScreen extends StatefulWidget {
  const CreerTpeScreen({super.key});

  @override
  State<CreerTpeScreen> createState() => _CreerTpeScreenState();
}

class _CreerTpeScreenState extends State<CreerTpeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tpeService = TpeService();
  final _numeroSerieController = TextEditingController();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  bool _isLoading = false;

  Future<void> _creer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _tpeService.createTpe(
        _numeroSerieController.text,
        _marqueController.text,
        _modeleController.text,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur : numéro de série déjà utilisé ?')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau TPE')),
      body: FormCard(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _numeroSerieController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de série',
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                  validator: (valeur) {
                    if (valeur == null || valeur.isEmpty) return 'Champ obligatoire';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _marqueController,
                  decoration: const InputDecoration(
                    labelText: 'Marque',
                    prefixIcon: Icon(Icons.branding_watermark_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _modeleController,
                  decoration: const InputDecoration(
                    labelText: 'Modèle',
                    prefixIcon: Icon(Icons.devices_other),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : ElevatedButton(
                    onPressed: _creer,
                    child: const Text('Créer'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}