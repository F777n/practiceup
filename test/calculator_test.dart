import 'package:calc_web/logic/calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('сложение', () {
    final result = calculate('2', '+', '3');
    expect(result, isA<CalcSuccess>());
    expect((result as CalcSuccess).value, 5);
  });

  test('вычитание', () {
    final result = calculate('10', '-', '4') as CalcSuccess;
    expect(result.value, 6);
  });

  test('умножение', () {
    final result = calculate('6', '*', '7') as CalcSuccess;
    expect(result.value, 42);
  });

  test('деление', () {
    final result = calculate('10', '/', '4') as CalcSuccess;
    expect(result.value, 2.5);
  });

  test('деление на ноль возвращает ошибку', () {
    final result = calculate('1', '/', '0');
    expect(result, isA<CalcFailure>());
    expect((result as CalcFailure).message, 'Деление на ноль невозможно');
  });

  test('нечисловой ввод возвращает ошибку', () {
    final result = calculate('abc', '+', '1');
    expect(result, isA<CalcFailure>());
    expect((result as CalcFailure).message, 'В адресе переданы не числа');
  });

  test('неизвестная операция', () {
    final result = calculate('1', 'pow', '2') as CalcFailure;
    expect(result.message, 'Неизвестная операция');
  });

  test('отсутствует обязательный параметр', () {
    expect(calculate(null, '+', '1'), isA<CalcFailure>());
    expect(calculate('1', null, '2'), isA<CalcFailure>());
    expect(calculate('1', '+', ''), isA<CalcFailure>());
  });

  test('запятая принимается как десятичный разделитель', () {
    final result = calculate('1,5', '+', '2,5') as CalcSuccess;
    expect(result.value, 4);
  });

  test('результат деления округляется и не печатает длинный хвост', () {
    final result = calculate('1', '/', '3') as CalcSuccess;
    expect(result.value.toString(), contains('3333333333'));
    expect(formatCalc(result.value), '0.333333');
  });

  test('двоичная погрешность не попадает в текст результата', () {
    final result = calculate('0.1', '+', '0.2') as CalcSuccess;
    expect(formatCalc(result.value), '0.3');
  });
}
