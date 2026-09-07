import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors_ext.dart';
import '../services/auth_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/theme_toggle_button.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _seConnecter() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await _authService.login(_emailController.text, _passwordController.text);
      if (mounted) {
        context.read<AuthProvider>().setAuthenticated(data['role'], stationNom: data['stationNom']);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Identifiants incorrects');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
return Scaffold(
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(horizontal: 28),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Align(alignment: Alignment.topRight, child: const ThemeToggleButton()),
const SizedBox(height: 12),
const AppLogo(size: 24),
const SizedBox(height: 40),
Text('Connexion', style: theme.textTheme.headlineSmall),
const SizedBox(height: 24),
TextField(
controller: _emailController,
decoration: const InputDecoration(labelText: 'Email'),
keyboardType: TextInputType.emailAddress,
),
const SizedBox(height: 14),
TextField(
controller: _passwordController,
decoration: const InputDecoration(labelText: 'Mot de passe'),
obscureText: true,
),
if (_errorMessage != null) ...[
const SizedBox(height: 14),
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: context.appColors.etatPanne.withValues(alpha: 0.1),
border: Border.all(color: context.appColors.etatPanne.withValues(alpha: 0.3)),
borderRadius: BorderRadius.circular(6),
),
child: Text(_errorMessage!, style: TextStyle(color: context.appColors.etatPanne, fontSize: 13)),
),
],
const SizedBox(height: 20),
ElevatedButton(
onPressed: _isLoading ? null : _seConnecter,
child: _isLoading
? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
: const Text('Se connecter'),
),
const SizedBox(height: 12),
TextButton(
onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
child: const Text('Pas encore de compte ? Créer un compte'),
),
],
),
),
),
),
);
}}