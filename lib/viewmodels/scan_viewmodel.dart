import 'package:get/get.dart';

import '../core/utils/qr_codec.dart';
import '../models/payment_card.dart';

class ScanViewModel extends GetxController {
  final scannedCard = Rxn<PaymentCard>();
  final rawText = ''.obs;
  final isProcessing = false.obs;

  void processBarcode(String data) {
    if (isProcessing.value) return;
    isProcessing.value = true;

    rawText.value = data;
    final card = QrCodec.decode(data);
    scannedCard.value = card;

    isProcessing.value = false;
  }

  bool get hasValidCard => scannedCard.value != null;

  bool get hasTossLink {
    return rawText.value.contains('toss.me/');
  }

  bool get hasKakaoPayLink {
    return rawText.value.contains('kakaopay') ||
        rawText.value.contains('kakao');
  }

  String? get extractedUrl {
    final lines = rawText.value.split('\n');
    for (final line in lines) {
      if (line.trim().startsWith('http')) return line.trim();
    }
    return null;
  }

  void reset() {
    scannedCard.value = null;
    rawText.value = '';
    isProcessing.value = false;
  }
}
