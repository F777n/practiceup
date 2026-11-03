import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_scope.dart';
import '../logic/currency.dart';
import '../widgets/common.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _from = 'USD';
  String _to = 'EUR';
  var _restored = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_restored) {
      return;
    }
    final store = AppScope.of(context).currencyStore;
    _from = store.fromCode;
    _to = store.toCode;
    _restored = true;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _amountValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите сумму';
    }
    if (double.tryParse(value.trim().replaceAll(',', '.')) == null) {
      return 'Это не число';
    }
    return null;
  }

  void _persist() {
    AppScope.of(context).currencyStore.save(_from, _to);
  }

  void _swap() {
    setState(() {
      final previous = _from;
      _from = _to;
      _to = previous;
    });
    _persist();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _persist();
    final amount = _amountController.text.trim().replaceAll(',', '.');
    final location = Uri(
      path: '/converter/result',
      queryParameters: {
        'from': _from,
        'to': _to,
        'amount': amount,
      },
    ).toString();
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final from = currencyByCode(_from);
    final to = currencyByCode(_to);
    final rate = (from == null || to == null || to.rubPerUnit == 0)
        ? null
        : from.rubPerUnit / to.rubPerUnit;

    return AppScaffold(
      title: 'Конвертер валют',
      body: PageBody(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Курсы заданы константами в коде, в рублях за 1 единицу. Результат откроется по адресу /converter/result.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _from,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Из валюты'),
                items: [
                  for (final currency in currencies)
                    DropdownMenuItem(
                      value: currency.code,
                      child: Text('${currency.code} — ${currency.title}'),
                    ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _from = value);
                  _persist();
                },
              ),
              Align(
                child: IconButton(
                  tooltip: 'Поменять валюты местами',
                  onPressed: _swap,
                  icon: const Icon(Icons.swap_vert),
                ),
              ),
              DropdownButtonFormField<String>(
                value: _to,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'В валюту'),
                items: [
                  for (final currency in currencies)
                    DropdownMenuItem(
                      value: currency.code,
                      child: Text('${currency.code} — ${currency.title}'),
                    ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _to = value);
                  _persist();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Сумма'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                textInputAction: TextInputAction.done,
                validator: _amountValidator,
                onFieldSubmitted: (_) => _submit(),
              ),
              if (rate != null) ...[
                const SizedBox(height: 12),
                Text(
                  '1 $_from = ${formatRate(rate)} $_to',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                child: const Text('Конвертировать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
