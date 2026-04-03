import '../../models/payment_card.dart';

class QrCodec {
  static const String _header = 'Send Me';

  static String encode(PaymentCard card) {
    final buffer = StringBuffer();
    buffer.writeln(_header);
    buffer.writeln('은행: ${card.bankName}');
    buffer.writeln('계좌: ${card.accountNumber}');
    buffer.writeln('예금주: ${card.holderName}');

    if (card.amount != null && card.amount! > 0) {
      buffer.writeln('금액: ${_formatAmount(card.amount!)}원');
    }

    if (card.memo != null && card.memo!.isNotEmpty) {
      buffer.writeln('메모: ${card.memo}');
    }

    if (card.tossMeLink != null && card.tossMeLink!.isNotEmpty) {
      buffer.writeln();
      final link = card.tossMeLink!;
      buffer.writeln(
        link.startsWith('http') ? link : 'https://$link',
      );
    }

    if (card.kakaoPayLink != null && card.kakaoPayLink!.isNotEmpty) {
      if (card.tossMeLink == null || card.tossMeLink!.isEmpty) {
        buffer.writeln();
      }
      buffer.writeln(card.kakaoPayLink);
    }

    return buffer.toString().trimRight();
  }

  static PaymentCard? decode(String payload) {
    final lines = payload.split('\n').map((l) => l.trim()).toList();

    if (lines.isEmpty || lines[0] != _header) return null;

    String? bankName;
    String? accountNumber;
    String? holderName;
    int? amount;
    String? memo;
    String? tossMeLink;
    String? kakaoPayLink;

    for (final line in lines.skip(1)) {
      if (line.startsWith('은행: ')) {
        bankName = line.substring(4);
      } else if (line.startsWith('계좌: ')) {
        accountNumber = line.substring(4);
      } else if (line.startsWith('예금주: ')) {
        holderName = line.substring(5);
      } else if (line.startsWith('금액: ')) {
        final amountStr =
            line.substring(4).replaceAll(RegExp(r'[^0-9]'), '');
        amount = int.tryParse(amountStr);
      } else if (line.startsWith('메모: ')) {
        memo = line.substring(4);
      } else if (line.contains('toss.me/')) {
        tossMeLink = line;
      } else if (line.contains('kakaopay') || line.contains('kakao')) {
        kakaoPayLink = line;
      }
    }

    if (bankName == null || accountNumber == null || holderName == null) {
      return null;
    }

    return PaymentCard(
      id: '',
      bankName: bankName,
      accountNumber: accountNumber,
      holderName: holderName,
      amount: amount,
      tossMeLink: tossMeLink,
      kakaoPayLink: kakaoPayLink,
      memo: memo,
      createdAt: DateTime.now(),
    );
  }

  static String _formatAmount(int amount) {
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
}
