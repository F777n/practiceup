import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_scope.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showHome = true,
  });

  final String title;
  final Widget body;
  final bool showHome;

  @override
  Widget build(BuildContext context) {
    final theme = AppScope.of(context).theme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (showHome)
            IconButton(
              tooltip: 'На главную',
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home_outlined),
            ),
          IconButton(
            tooltip: dark ? 'Светлая тема' : 'Тёмная тема',
            onPressed: theme.toggle,
            icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: body,
    );
  }
}

/// Форма по центру, не шире [maxWidth]. На узком окне прокручивается.
class PageBody extends StatelessWidget {
  const PageBody({
    super.key,
    required this.child,
    this.maxWidth = 440,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final minHeight =
              maxHeight.isFinite && maxHeight > 48 ? maxHeight - 48 : 0.0;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
