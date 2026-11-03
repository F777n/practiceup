
sealed class CalcResult {
  const CalcResult();
}

class CalcSuccess extends CalcResult {
  const CalcSuccess(this.value);

  final double value;
}

class CalcFailure extends CalcResult {
  const CalcFailure(this.message);

  final String message;
}

CalcResult calculate(String? rawA, String? rawOp, String? rawB) {
  if (rawA == null ||
      rawA.trim().isEmpty ||
      rawB == null ||
      rawB.trim().isEmpty) {
    return const CalcFailure('В адресе не хватает числа');
  }
  if (rawOp == null || rawOp.trim().isEmpty) {
    return const CalcFailure('В адресе не указана операция');
  }

  final a = double.tryParse(rawA.trim().replaceAll(',', '.'));
  final b = double.tryParse(rawB.trim().replaceAll(',', '.'));
  if (a == null || b == null) {
    return const CalcFailure('В адресе переданы не числа');
  }

  return switch (rawOp) {
    '+' => CalcSuccess(a + b),
    '-' => CalcSuccess(a - b),
    '*' => CalcSuccess(a * b),
    '/' => b == 0
        ? const CalcFailure('Деление на ноль невозможно')
        : CalcSuccess(a / b),
    _ => const CalcFailure('Неизвестная операция'),
  };
}


String formatCalc(double value) {
  if (value.isNaN) {
    return 'Не число';
  }
  if (!value.isFinite) {
    return 'Бесконечность';
  }

  var text = value.toStringAsFixed(6);
  if (text.contains('.')) {
    text = text.replaceFirst(RegExp(r'0+$'), '');
    text = text.replaceFirst(RegExp(r'\.$'), '');
  }
  if (text == '-0') {
    return '0';
  }
  return text;
}
