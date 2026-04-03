import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/constants.dart';
import '../../models/payment_card.dart';
import '../../viewmodels/card_editor_viewmodel.dart';

class CardEditorScreen extends StatelessWidget {
  final PaymentCard? editCard;

  const CardEditorScreen({super.key, this.editCard});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(CardEditorViewModel());
    if (editCard != null) {
      vm.initForEdit(editCard!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vm.isEditing ? '계좌 수정' : '계좌 추가'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: vm.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('은행 선택 *'),
              const SizedBox(height: 8),
              _buildBankSelector(vm),
              const SizedBox(height: 20),
              _buildSectionLabel('계좌번호 *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: vm.accountNumber,
                decoration: const InputDecoration(
                  hintText: '계좌번호를 입력하세요',
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '계좌번호를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildSectionLabel('예금주 *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: vm.holderName,
                decoration: const InputDecoration(
                  hintText: '예금주명을 입력하세요',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '예금주명을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildSectionLabel('토스 링크 (선택)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: vm.tossMeLink,
                decoration: const InputDecoration(
                  hintText: 'toss.me/닉네임',
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !value.contains('toss.me/')) {
                    return 'toss.me/닉네임 형태로 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildSectionLabel('카카오페이 링크 (선택)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: vm.kakaoPayLink,
                decoration: const InputDecoration(
                  hintText: 'https://qr.kakaopay.com/...',
                  prefixIcon: Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionLabel('카드 색상'),
              const SizedBox(height: 12),
              _buildColorPicker(vm),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () async {
                    final success = await vm.save();
                    if (success) {
                      Get.back();
                    }
                  },
                  child: Text(
                    vm.isEditing ? '수정 완료' : '저장',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildBankSelector(CardEditorViewModel vm) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: vm.bankName.value.isEmpty ? null : vm.bankName.value,
        decoration: const InputDecoration(
          hintText: '은행을 선택하세요',
          prefixIcon: Icon(Icons.account_balance),
        ),
        items: AppConstants.bankList
            .map(
              (bank) => DropdownMenuItem(value: bank, child: Text(bank)),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) vm.bankName.value = value;
        },
      ),
    );
  }

  Widget _buildColorPicker(CardEditorViewModel vm) {
    return Obx(
      () => Row(
        children: List.generate(
          AppConstants.cardColors.length,
          (index) {
            final color = AppConstants.cardColors[index];
            final isSelected = vm.colorIndex.value == index;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => vm.colorIndex.value = index,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.black87, width: 3)
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
