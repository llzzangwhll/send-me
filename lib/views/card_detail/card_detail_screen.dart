import 'package:SendMe/views/card_detail/widgets/qr_share_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/constants.dart';
import '../../core/utils/formatters.dart';
import '../../models/payment_card.dart';
import '../../viewmodels/card_detail_viewmodel.dart';
import '../card_editor/card_editor_screen.dart';

class CardDetailScreen extends StatelessWidget {
  final PaymentCard card;

  const CardDetailScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(CardDetailViewModel(card));
    final cardColor = AppConstants.cardColors[
        card.colorIndex.clamp(0, AppConstants.cardColors.length - 1)];

    return Scaffold(
      appBar: AppBar(
        title: const Text('계좌 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Get.to(() => CardEditorScreen(editCard: card)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Account card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cardColor, cardColor.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: cardColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.bankName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    card.accountNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.holderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  if (card.amount != null && card.amount! > 0) ...[
                    const SizedBox(height: 12),
                    Text(
                      '${AmountFormatter.formatAmount(card.amount!)}원',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  if (card.memo != null && card.memo!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      card.memo!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // QR Code
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  QrImageView(
                    data: vm.qrData,
                    version: QrVersions.auto,
                    size: 200,
                    gapless: true,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${card.bankName} · ${card.holderName}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.copy,
                    label: '계좌 복사',
                    onTap: vm.copyAccountInfo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.image_outlined,
                    label: 'QR 공유',
                    onTap: () => vm.shareAsImage(
                      QrShareCard(card: card),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.share_outlined,
                    label: '텍스트 공유',
                    onTap: vm.shareAsText,
                  ),
                ),
              ],
            ),

            // Payment links
            if (card.tossMeLink != null || card.kakaoPayLink != null) ...[
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '간편 송금',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (card.tossMeLink != null &&
                  card.tossMeLink!.isNotEmpty)
                _PaymentLinkButton(
                  label: '토스로 보내기',
                  subtitle: card.tossMeLink!,
                  color: const Color(0xFF3182F6),
                  onTap: vm.openTossLink,
                ),
              if (card.kakaoPayLink != null &&
                  card.kakaoPayLink!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _PaymentLinkButton(
                    label: '카카오페이로 보내기',
                    subtitle: '카카오페이 송금',
                    color: const Color(0xFFFEE500),
                    textColor: Colors.black87,
                    onTap: vm.openKakaoPayLink,
                  ),
                ),
            ],

            const SizedBox(height: 24),

            // Detailed info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '상세 정보',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    label: '은행',
                    value: card.bankName,
                    onCopy: () => vm.copyField('은행명', card.bankName),
                  ),
                  _InfoRow(
                    label: '계좌번호',
                    value: card.accountNumber,
                    onCopy: () =>
                        vm.copyField('계좌번호', card.accountNumber),
                  ),
                  _InfoRow(
                    label: '예금주',
                    value: card.holderName,
                    onCopy: () => vm.copyField('예금주', card.holderName),
                  ),
                  if (card.amount != null && card.amount! > 0)
                    _InfoRow(
                      label: '금액',
                      value:
                          '${AmountFormatter.formatAmount(card.amount!)}원',
                      onCopy: () => vm.copyField(
                          '금액', '${card.amount}'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentLinkButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _PaymentLinkButton({
    required this.label,
    required this.subtitle,
    required this.color,
    this.textColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new, color: textColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: onCopy,
            child: Icon(
              Icons.copy_outlined,
              size: 18,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
