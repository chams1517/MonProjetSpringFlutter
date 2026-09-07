import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.light_mode_outlined, size: 16, color: isDark ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.primary),
          Switch(
            value: isDark,
            onChanged: (_) => context.read<ThemeProvider>().basculer(),
            activeThumbColor: theme.colorScheme.primary,
            activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.3),
            inactiveThumbColor: theme.colorScheme.onSurfaceVariant,
            inactiveTrackColor: theme.colorScheme.outlineVariant,
          ),
          Icon(Icons.dark_mode_outlined, size: 16, color: isDark ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}