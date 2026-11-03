import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/common.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'Не найдено',
      body: PageBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.travel_explore,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Страница не найдена',
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Такого адреса в приложении нет.',
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  location,
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    fontFamily: 'Consolas',
                    fontFamilyFallback: const ['Courier New', 'monospace'],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home_outlined),
              label: const Text('На главную'),
            ),
          ],
        ),
      ),
    );
  }
}
