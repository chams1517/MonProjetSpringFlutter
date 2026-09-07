import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 0.36,
          height: size * 0.36,
          decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(2)),
        ),
        SizedBox(width: size * 0.3),
        Text('GESTION TPE', style: AppTheme.mono(size: size * 0.42, weight: FontWeight.w600, color: theme.colorScheme.onSurface)),
      ],
    );
  }
}