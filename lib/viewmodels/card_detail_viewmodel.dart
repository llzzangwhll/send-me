import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/utils/formatters.dart';
import '../core/utils/qr_codec.dart';
import '../models/payment_card.dart';

class CardDetailViewModel extends GetxController {
  final PaymentCard card;
  final screenshotController = ScreenshotController();

  CardDetailViewModel(this.card);

  String get qrData => QrCodec.encode(card);

  String get accountInfoText {
    final buffer = StringBuffer();
    buffer.writeln('${card.bankName} ${card.accountNumber}');
    buffer.write('예금주: ${card.holderName}');
    if (card.amount != null && card.amount! > 0) {
      buffer.write('\n금액: ${AmountFormatter.formatAmount(card.amount!)}원');
    }
    if (card.memo != null && card.memo!.isNotEmpty) {
      buffer.write('\n${card.memo}');
    }
    return buffer.toString();
  }

  Future<void> copyAccountInfo() async {
    await Clipboard.setData(ClipboardData(text: accountInfoText));
    HapticFeedback.lightImpact();
    Get.snackbar(
      '복사 완료',
      '계좌 정보가 복사되었습니다',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> copyField(String label, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    HapticFeedback.lightImpact();
    Get.snackbar(
      '복사 완료',
      '$label이(가) 복사되었습니다',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> shareAsText() async {
    final text = StringBuffer();
    text.writeln('${card.holderName} ${card.bankName}');
    text.writeln('계좌번호: ${card.accountNumber}');
    if (card.amount != null && card.amount! > 0) {
      text.writeln('금액: ${AmountFormatter.formatAmount(card.amount!)}원');
    }
    if (card.memo != null && card.memo!.isNotEmpty) {
      text.writeln(card.memo);
    }
    if (card.tossMeLink != null && card.tossMeLink!.isNotEmpty) {
      final link = card.tossMeLink!;
      text.writeln(link.startsWith('http') ? link : 'https://$link');
    }

    await Share.share(
      text.toString().trimRight(),
      subject: 'Send Me - 계좌 정보',
    );
  }

  Future<void> shareAsImage(Widget qrWidget) async {
    final imageBytes = await screenshotController.captureFromLongWidget(
      qrWidget,
      pixelRatio: 3.0,
      delay: const Duration(milliseconds: 100),
    );

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/sendme_qr.png';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);

    await Share.shareXFiles(
      [XFile(filePath)],
      text: accountInfoText,
    );
  }

  Future<void> openTossLink() async {
    if (card.tossMeLink == null || card.tossMeLink!.isEmpty) return;
    final link = card.tossMeLink!;
    final url = Uri.parse(link.startsWith('http') ? link : 'https://$link');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openKakaoPayLink() async {
    if (card.kakaoPayLink == null || card.kakaoPayLink!.isEmpty) return;
    final url = Uri.parse(card.kakaoPayLink!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
