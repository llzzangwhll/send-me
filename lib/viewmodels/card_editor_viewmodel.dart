import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/payment_card.dart';
import '../services/payment_card_service.dart';

class CardEditorViewModel extends GetxController {
  final PaymentCardService _service = PaymentCardService();

  final formKey = GlobalKey<FormState>();
  final bankName = ''.obs;
  final accountNumber = TextEditingController();
  final holderName = TextEditingController();
  final amount = TextEditingController();
  final tossMeLink = TextEditingController();
  final kakaoPayLink = TextEditingController();
  final memo = TextEditingController();
  final colorIndex = 0.obs;

  PaymentCard? _editingCard;
  bool get isEditing => _editingCard != null;

  void initForEdit(PaymentCard card) {
    _editingCard = card;
    bankName.value = card.bankName;
    accountNumber.text = card.accountNumber;
    holderName.text = card.holderName;
    if (card.amount != null) {
      amount.text = card.amount.toString();
    }
    tossMeLink.text = card.tossMeLink ?? '';
    kakaoPayLink.text = card.kakaoPayLink ?? '';
    memo.text = card.memo ?? '';
    colorIndex.value = card.colorIndex;
  }

  Future<bool> save() async {
    if (!formKey.currentState!.validate()) return false;
    if (bankName.value.isEmpty) {
      Get.snackbar('오류', '은행을 선택해주세요',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    final amountValue = amount.text.isNotEmpty
        ? int.tryParse(amount.text.replaceAll(RegExp(r'[^0-9]'), ''))
        : null;

    final card = PaymentCard(
      id: _editingCard?.id ?? const Uuid().v4(),
      bankName: bankName.value,
      accountNumber: accountNumber.text.trim(),
      holderName: holderName.text.trim(),
      amount: amountValue,
      tossMeLink:
          tossMeLink.text.trim().isEmpty ? null : tossMeLink.text.trim(),
      kakaoPayLink:
          kakaoPayLink.text.trim().isEmpty ? null : kakaoPayLink.text.trim(),
      memo: memo.text.trim().isEmpty ? null : memo.text.trim(),
      createdAt: _editingCard?.createdAt ?? DateTime.now(),
      colorIndex: colorIndex.value,
    );

    await _service.save(card);
    return true;
  }

  @override
  void onClose() {
    accountNumber.dispose();
    holderName.dispose();
    amount.dispose();
    tossMeLink.dispose();
    kakaoPayLink.dispose();
    memo.dispose();
    super.onClose();
  }
}
