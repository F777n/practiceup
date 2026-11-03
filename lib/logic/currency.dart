
class Currency {
  const Currency({
    required this.code,
    required this.title,
    required this.rubPerUnit,
  });

  final String code;
  final String title;
  final double rubPerUnit;
}

const currencies = <Currency>[
  Currency(code: 'RUB', title: 'Российский рубль', rubPerUnit: 1),
  Currency(code: 'USD', title: 'Доллар США', rubPerUnit: 90),
  Currency(code: 'EUR', title: 'Евро', rubPerUnit: 100),
  Currency(code: 'GBP', title: 'Фунт стерлингов', rubPerUnit: 115),
  Currency(code: 'CNY', title: 'Китайский юань', rubPerUnit: 12.5),
  Currency(code: 'JPY', title: 'Японская иена', rubPerUnit: 0.6),
];

Currency? currencyByCode(String? code) {
  if (code == null) {
    return null;
  }
  final normalized = code.trim().toUpperCase();
  for (final currency in currencies) {
    if (currency.code == normalized) {
      return currency;
    }
  }
  return null;
}

sealed class ConvertResult {
  const ConvertResult();
}

class ConvertSuccess extends ConvertResult {
  const ConvertSuccess({
    required this.amount,
    required this.from,
    required this.to,
    required this.value,
    required this.rate,
  });

  final double amount;
  final String from;
  final String to;
  final double value;

  final double rate;
}

class ConvertFailure extends ConvertResult {
  const ConvertFailure(this.message);

  final String message;
}


ConvertResult convertCurrency(
    String? rawFrom, String? rawTo, String? rawAmount) {
  if (rawFrom == null ||
      rawFrom.trim().isEmpty ||
      rawTo == null ||
      rawTo.trim().isEmpty) {
    return const ConvertFailure('В адресе не указана валюта');
  }
  if (rawAmount == null || rawAmount.trim().isEmpty) {
    return const ConvertFailure('В адресе не указана сумма');
  }

  final from = currencyByCode(rawFrom);
  final to = currencyByCode(rawTo);
  if (from == null || to == null) {
    return const ConvertFailure('Неизвестная валюта');
  }

  final amount = double.tryParse(rawAmount.trim().replaceAll(',', '.'));
  if (amount == null) {
    return const ConvertFailure('В адресе передана нечисловая сумма');
  }
  if (to.rubPerUnit == 0) {
    return const ConvertFailure('Некорректный курс валюты');
  }

  final rate = from.rubPerUnit / to.rubPerUnit;
  return ConvertSuccess(
    amount: amount,
    from: from.code,
    to: to.code,
    value: amount * rate,
    rate: rate,
  );
}

String formatMoney(double value) {
  if (value.isNaN || !value.isFinite) {
    return '—';
  }
  final negative = value < 0;
  final cents = (value.abs() * 100).round();
  final whole = cents ~/ 100;
  final fraction = (cents % 100).toString().padLeft(2, '0');
  final text = '$whole.$fraction';
  return negative ? '-$text' : text;
}

String formatRate(double value) {
  if (value.isNaN || !value.isFinite) {
    return '—';
  }
  var text = value.toStringAsFixed(4);
  if (text.contains('.')) {
    text = text.replaceFirst(RegExp(r'0+$'), '');
    text = text.replaceFirst(RegExp(r'\.$'), '');
  }
  if (text == '-0') {
    return '0';
  }
  return text;
}
