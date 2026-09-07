import 'package:flutter/material.dart';

class ElegantAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;

  const ElegantAppBar({super.key, required this.title, this.actions, this.leading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: AppBar(title: title, actions: actions, leading: leading),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}