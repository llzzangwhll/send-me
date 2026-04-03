import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/qr_codec.dart';
import '../../../models/payment_card.dart';


class QrShareCard extends StatelessWidget {
  final PaymentCard card;

  const QrShareCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final cardColor = AppConstants.cardColors[
        card.colorIndex.clamp(0, AppConstants.cardColors.length - 1)];

    return Container(
      width: 360,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '보내줘',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: cardColor,
            ),
          ),
          const SizedBox(height: 20),
          QrImageView(
            data: QrCodec.encode(card),
            version: QrVersions.auto,
            size: 200,
            gapless: true,
            errorCorrectionLevel: QrErrorCorrectLevel.M,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  card.bankName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  card.accountNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  card.holderName,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                if (card.amount != null && card.amount! > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${AmountFormatter.formatAmount(card.amount!)}원',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cardColor,
                    ),
                  ),
                ],
                if (card.memo != null && card.memo!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    card.memo!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
