import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = '보내줘';
  static const String hiveBoxName = 'payment_cards';

  static const List<String> bankList = [
    '카카오뱅크',
    '토스뱅크',
    '신한은행',
    '국민은행',
    'NH농협은행',
    '우리은행',
    '하나은행',
    'IBK기업은행',
    '새마을금고',
    '신협',
    '우체국',
    '케이뱅크',
    'SC제일은행',
    '대구은행',
    '부산은행',
    '경남은행',
    '광주은행',
    '전북은행',
    '제주은행',
    '수협은행',
  ];

  static const List<Color> cardColors = [
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFF8B5CF6), // Purple
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF6B7280), // Gray
  ];
}
