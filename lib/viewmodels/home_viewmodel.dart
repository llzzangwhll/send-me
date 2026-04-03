import 'package:get/get.dart';

import '../models/payment_card.dart';
import '../services/payment_card_service.dart';


class HomeViewModel extends GetxController {
  final PaymentCardService _service = PaymentCardService();

  final cards = <PaymentCard>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCards();
  }

  void loadCards() {
    cards.value = _service.getAll();
  }

  Future<void> deleteCard(String id) async {
    await _service.delete(id);
    loadCards();
  }
}
