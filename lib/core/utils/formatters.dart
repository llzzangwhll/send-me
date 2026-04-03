import 'package:flutter/services.dart';

class AmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue();

    final number = int.tryParse(digits);
    if (number == null) return oldValue;

    final formatted = formatAmount(number);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String formatAmount(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  static int? parseAmount(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits);
  }
}

String maskAccountNumber(String account) {
  if (account.length <= 4) return account;
  final visible = account.substring(account.length - 4);
  final masked = account.substring(0, account.length - 4);
  return '${masked.replaceAll(RegExp(r'[0-9]'), '*')}$visible';
}
