import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/constants.dart';
import '../../core/utils/formatters.dart';
import '../../models/payment_card.dart';
import '../../viewmodels/card_detail_viewmodel.dart';
import '../../views/card_detail/widgets/qr_share_card.dart';
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
        title: const Text('송금 요청'),
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
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Amount & memo input
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '받을 금액',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: vm.amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [AmountFormatter()],
                    onChanged: vm.onAmountChanged,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[300],
                      ),
                      suffixText: '원',
                      suffixStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  TextField(
                    controller: vm.memoController,
                    onChanged: vm.onMemoChanged,
                    decoration: InputDecoration(
                      hintText: '메모 (선택)',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(
                        Icons.note_outlined,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // QR Code - reactive
            Obx(() {
              // Access reactive values to trigger rebuild
              vm.amount.value;
              vm.memo.value;
              return Container(
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
                    if (vm.amount.value != null && vm.amount.value! > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${AmountFormatter.formatAmount(vm.amount.value!)}원',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: cardColor,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Quick actions
            Obx(() {
              vm.amount.value;
              vm.memo.value;
              return Row(
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
                        QrShareCard(
                          card: card,
                          amount: vm.amount.value,
                          memo: vm.memo.value.isEmpty ? null : vm.memo.value,
                        ),
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
              );
            }),

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
              if (card.tossMeLink != null && card.tossMeLink!.isNotEmpty)
                _PaymentLinkButton(
                  label: '토스로 보내기',
                  subtitle: card.tossMeLink!,
                  color: const Color(0xFF3182F6),
                  onTap: vm.openTossLink,
                ),
              if (card.kakaoPayLink != null && card.kakaoPayLink!.isNotEmpty)
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
