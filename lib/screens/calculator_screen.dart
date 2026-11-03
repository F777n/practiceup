import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/common.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  String _operation = '+';

  static const _operations = <(String, String)>[
    ('+', 'сложение'),
    ('-', 'вычитание'),
    ('*', 'умножение'),
    ('/', 'деление'),
  ];

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите число';
    }
    if (double.tryParse(value.trim().replaceAll(',', '.')) == null) {
      return 'Это не число';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final a = _aController.text.trim().replaceAll(',', '.');
    final b = _bController.text.trim().replaceAll(',', '.');
    
    final location = Uri(
      path: '/calculator/result',
      queryParameters: {
        'a': a,
        'op': _operation,
        'b': b,
      },
    ).toString();
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Калькулятор',
      body: PageBody(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Введите два числа и операцию. Результат откроется на отдельном экране, данные уйдут в адрес.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _aController,
                decoration: const InputDecoration(labelText: 'Первое число'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                textInputAction: TextInputAction.next,
                validator: _numberValidator,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _operation,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Операция'),
                items: [
                  for (final op in _operations)
                    DropdownMenuItem(
                      value: op.$1,
                      child: Text('${op.$1}  ${op.$2}'),
                    ),
                ],
                onChanged: (value) {
                  setState(() => _operation = value ?? '+');
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bController,
                decoration: const InputDecoration(labelText: 'Второе число'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                textInputAction: TextInputAction.done,
                validator: _numberValidator,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                child: const Text('Вычислить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
