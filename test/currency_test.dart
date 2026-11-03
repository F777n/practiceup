import 'package:calc_web/logic/currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('100 USD конвертируются в 90 EUR', () {
    final result = convertCurrency('USD', 'EUR', '100') as ConvertSuccess;
    expect(result.value, closeTo(90, 1e-9));
    expect(formatMoney(result.value), '90.00');
  });

  test('одинаковая валюта возвращает ту же сумму', () {
    final result = convertCurrency('RUB', 'RUB', '15') as ConvertSuccess;
    expect(result.value, 15);
    expect(result.rate, 1);
  });

  test('неизвестная валюта', () {
    final result = convertCurrency('USD', 'ABC', '10') as ConvertFailure;
    expect(result.message, 'Неизвестная валюта');
  });

  test('нечисловая сумма', () {
    final result = convertCurrency('USD', 'EUR', 'десять') as ConvertFailure;
    expect(result.message, 'В адресе передана нечисловая сумма');
  });

  test('отсутствует сумма', () {
    expect(convertCurrency('USD', 'EUR', null), isA<ConvertFailure>());
    expect(convertCurrency('USD', 'EUR', '  '), isA<ConvertFailure>());
  });

  test('отсутствует валюта', () {
    final result = convertCurrency(null, 'EUR', '10') as ConvertFailure;
    expect(result.message, 'В адресе не указана валюта');
  });

  test('запятая в сумме и строчные коды валют', () {
    final result = convertCurrency('usd', 'eur', '1,5') as ConvertSuccess;
    expect(result.from, 'USD');
    expect(result.to, 'EUR');
    expect(result.value, closeTo(1.35, 1e-9));
  });

  test('иена конвертируется по константному курсу', () {
    final result = convertCurrency('JPY', 'USD', '1000') as ConvertSuccess;
    expect(result.value, closeTo(1000 * 0.6 / 90, 1e-9));
    expect(formatMoney(result.value), '6.67');
  });
}
