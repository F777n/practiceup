import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/common.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'Главная',
      showHome: false,
      body: PageBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.calculate_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Калькулятор и конвертер',
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Выберите раздел. Адрес в строке браузера меняется вместе с экраном.',
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => context.go('/calculator'),
              icon: const Icon(Icons.calculate),
              label: const Text('Калькулятор'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => context.go('/converter'),
              icon: const Icon(Icons.currency_exchange),
              label: const Text('Конвертер валют'),
            ),
            const SizedBox(height: 24),
            Text(
              'Адреса: /calculator и /converter',
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
