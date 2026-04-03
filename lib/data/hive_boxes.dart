import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants.dart';
import '../models/payment_card.dart';

class HiveBoxes {
  static late Box<PaymentCard> paymentCards;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PaymentCardAdapter());
    paymentCards = await Hive.openBox<PaymentCard>(AppConstants.hiveBoxName);
  }
}
