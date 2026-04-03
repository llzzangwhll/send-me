

import '../data/hive_boxes.dart';
import '../models/payment_card.dart';

class PaymentCardService {
  List<PaymentCard> getAll() {
    return HiveBoxes.paymentCards.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  PaymentCard? getById(String id) {
    try {
      return HiveBoxes.paymentCards.values.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(PaymentCard card) async {
    await HiveBoxes.paymentCards.put(card.id, card);
  }

  Future<void> delete(String id) async {
    await HiveBoxes.paymentCards.delete(id);
  }
}
