import 'package:flutter/material.dart';

class DataRowTile extends StatelessWidget {
  final Color accentColor;
  final String title;
  final String? monoSubtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final IconData? leadingIcon;

  const DataRowTile({
    super.key,
    required this.accentColor,
    required this.title,
    this.monoSubtitle,
    this.trailing,
    this.onTap,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: leadingIcon == null
                ? Border(
              left: BorderSide(color: accentColor, width: 3),
              bottom: BorderSide(color: theme.colorScheme.outlineVariant),
            )
                : Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(leadingIcon, size: 18, color: accentColor),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    if (monoSubtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        monoSubtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'IBM Plex Mono'),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}