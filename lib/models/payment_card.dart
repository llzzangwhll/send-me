import 'package:hive/hive.dart';

part 'payment_card.g.dart';

@HiveType(typeId: 0)
class PaymentCard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String bankName;

  @HiveField(2)
  final String accountNumber;

  @HiveField(3)
  final String holderName;

  @HiveField(4)
  final int? amount;

  @HiveField(5)
  final String? tossMeLink;

  @HiveField(6)
  final String? kakaoPayLink;

  @HiveField(7)
  final String? memo;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final int colorIndex;

  PaymentCard({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.holderName,
    this.amount,
    this.tossMeLink,
    this.kakaoPayLink,
    this.memo,
    required this.createdAt,
    this.colorIndex = 0,
  });

  PaymentCard copyWith({
    String? bankName,
    String? accountNumber,
    String? holderName,
    int? amount,
    bool clearAmount = false,
    String? tossMeLink,
    bool clearTossMeLink = false,
    String? kakaoPayLink,
    bool clearKakaoPayLink = false,
    String? memo,
    bool clearMemo = false,
    int? colorIndex,
  }) {
    return PaymentCard(
      id: id,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      holderName: holderName ?? this.holderName,
      amount: clearAmount ? null : (amount ?? this.amount),
      tossMeLink: clearTossMeLink ? null : (tossMeLink ?? this.tossMeLink),
      kakaoPayLink:
          clearKakaoPayLink ? null : (kakaoPayLink ?? this.kakaoPayLink),
      memo: clearMemo ? null : (memo ?? this.memo),
      createdAt: createdAt,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}
