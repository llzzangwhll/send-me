import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants.dart';
import '../../core/utils/formatters.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../card_detail/card_detail_screen.dart';
import '../card_editor/card_editor_screen.dart';
import '../scan/scan_screen.dart';

class HomeScreen extends GetView<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Me',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'QR 스캔',
            onPressed: () async {
              await Get.to(() => const ScanScreen());
              controller.loadCards();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.cards.isEmpty) {
          return _buildEmptyState();
        }
        return _buildCardList();
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Get.to(() => const CardEditorScreen());
          controller.loadCards();
        },
        icon: const Icon(Icons.add),
        label: const Text('계좌 추가'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '계좌 정보를 추가해보세요',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'QR 코드로 쉽게 계좌를 공유할 수 있어요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCardList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: controller.cards.length,
      itemBuilder: (context, index) {
        final card = controller.cards[index];
        final cardColor = AppConstants.cardColors[
            card.colorIndex.clamp(0, AppConstants.cardColors.length - 1)];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () async {
                await Get.to(() => CardDetailScreen(card: card));
                controller.loadCards();
              },
              onLongPress: () => _showDeleteDialog(card.id, card.holderName),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: cardColor, width: 4),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: cardColor.withValues(alpha: 0.15),
                      child: Text(
                        card.bankName.substring(0, 1),
                        style: TextStyle(
                          color: cardColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.bankName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${maskAccountNumber(card.accountNumber)} · ${card.holderName}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          if (card.memo != null && card.memo!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                card.memo!,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(String id, String name) {
    Get.defaultDialog(
      title: '삭제',
      middleText: '$name 계좌를 삭제하시겠습니까?',
      textCancel: '취소',
      textConfirm: '삭제',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteCard(id);
        Get.back();
      },
    );
  }
}
