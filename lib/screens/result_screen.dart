import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';
import '../logic/currency.dart';
import '../widgets/common.dart';


class CalcResultScreen extends StatelessWidget {
  const CalcResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final params = GoRouterState.of(context).uri.queryParameters;
    final a = params['a'];
    final op = params['op'];
    final b = params['b'];
    final result = calculate(a, op, b);

    final (success, error) = switch (result) {
      CalcSuccess(:final value) => (formatCalc(value), null),
      CalcFailure(:final message) => (null, message),
    };

    return _ResultPage(
      title: 'Результат',
      heading: 'Результат вычисления',
      expression: '${_show(a)} ${_show(op)} ${_show(b)}',
      successText: success,
      errorText: error,
      lines: [
        'a = ${_show(a)}',
        'op = ${_show(op)}',
        'b = ${_show(b)}',
      ],
      backPath: '/calculator',
      backLabel: 'К калькулятору',
    );
  }
}

class ConvertResultScreen extends StatelessWidget {
  const ConvertResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final params = GoRouterState.of(context).uri.queryParameters;
    final from = params['from'];
    final to = params['to'];
    final amount = params['amount'];
    final result = convertCurrency(from, to, amount);

    final (expression, success, error) = switch (result) {
      ConvertSuccess(:final amount, :final from, :final to, :final value) => (
          '${formatMoney(amount)} $from = ${formatMoney(value)} $to',
          '${formatMoney(value)} $to',
          null,
        ),
      ConvertFailure(:final message) => (
          '${_show(amount)} ${_show(from)} → ${_show(to)}',
          null,
          message,
        ),
    };

    final rateLine = switch (result) {
      ConvertSuccess(:final from, :final to, :final rate) =>
        'Курс: 1 $from = ${formatRate(rate)} $to',
      ConvertFailure() => null,
    };

    return _ResultPage(
      title: 'Результат',
      heading: 'Результат конвертации',
      expression: expression,
      successText: success,
      errorText: error,
      lines: [
        'from = ${_show(from)}',
        'to = ${_show(to)}',
        'amount = ${_show(amount)}',
        if (rateLine != null) rateLine,
      ],
      backPath: '/converter',
      backLabel: 'К конвертеру',
    );
  }
}

String _show(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'отсутствует';
  }
  return value;
}

class _ResultPage extends StatelessWidget {
  const _ResultPage({
    required this.title,
    required this.heading,
    required this.expression,
    required this.successText,
    required this.errorText,
    required this.lines,
    required this.backPath,
    required this.backLabel,
  });

  final String title;
  final String heading;
  final String expression;
  final String? successText;
  final String? errorText;
  final List<String> lines;
  final String backPath;
  final String backLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final failed = successText == null;
    final uri = GoRouterState.of(context).uri;

    return AppScaffold(
      title: title,
      body: PageBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(heading,
                style: textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(expression,
                style: textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Card(
              color: failed ? scheme.errorContainer : scheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: failed
                    ? Text(
                        errorText ?? 'Не удалось разобрать адрес',
                        style: textTheme.titleMedium?.copyWith(
                          color: scheme.onErrorContainer,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          successText!,
                          style: textTheme.displaySmall?.copyWith(
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Параметры адреса', style: textTheme.titleSmall),
                    const SizedBox(height: 8),
                    for (final line in lines) Text(line),
                    const SizedBox(height: 8),
                    SelectableText(
                      uri.toString(),
                      style: textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Consolas',
                        fontFamilyFallback: const ['Courier New', 'monospace'],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go(backPath),
              icon: const Icon(Icons.arrow_back),
              label: Text(backLabel),
            ),
          ],
        ),
      ),
    );
  }
}
