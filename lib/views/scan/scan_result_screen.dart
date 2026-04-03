import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/formatters.dart';
import '../../viewmodels/scan_viewmodel.dart';

class ScanResultScreen extends StatelessWidget {
  final ScanViewModel vm;

  const ScanResultScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final card = vm.scannedCard.value!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('스캔 결과'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Account info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        '계좌 정보',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildField('은행', card.bankName),
                  _buildField('계좌번호', card.accountNumber),
                  _buildField('예금주', card.holderName),
                  if (card.amount != null && card.amount! > 0)
                    _buildField(
                        '금액', '${AmountFormatter.formatAmount(card.amount!)}원'),
                  if (card.memo != null && card.memo!.isNotEmpty)
                    _buildField('메모', card.memo!),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Copy all button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () => _copyAll(context),
                icon: const Icon(Icons.copy),
                label: const Text('전체 복사', style: TextStyle(fontSize: 16)),
              ),
            ),

            // Payment links
            if (vm.hasTossLink || vm.hasKakaoPayLink) ...[
              const SizedBox(height: 20),
              if (vm.hasTossLink)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => _openUrl(vm.extractedUrl),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('토스로 보내기'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF3182F6),
                    ),
                  ),
                ),
              if (vm.hasKakaoPayLink) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => _openUrl(vm.extractedUrl),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('카카오페이로 보내기'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: const Color(0xFFFEE500).withValues(alpha: 0.15),
                    ),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              HapticFeedback.lightImpact();
              Get.snackbar('복사 완료', '$label이(가) 복사되었습니다',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2));
            },
            child: Icon(Icons.copy_outlined, size: 18, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  void _copyAll(BuildContext context) {
    final card = vm.scannedCard.value!;
    final text = '${card.bankName} ${card.accountNumber}\n예금주: ${card.holderName}';
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    Get.snackbar('복사 완료', '계좌 정보가 복사되었습니다',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2));
  }

  Future<void> _openUrl(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
