import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.25, letterSpacing: -0.5);
  static const TextStyle heading1 = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3, letterSpacing: -0.3);
  static const TextStyle heading2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.3, letterSpacing: -0.2);
  static const TextStyle heading3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.35);
  static const TextStyle body = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.5);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.5);
  static const TextStyle bodySecondary = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.5);
  static const TextStyle label = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4);
  static const TextStyle caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.4);
  static const TextStyle overline = TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary, height: 1.4, letterSpacing: 0.8);
  static const TextStyle button = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textOnPrimary, letterSpacing: 0.3, height: 1.0);
  static const TextStyle buttonSmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary, letterSpacing: 0.2, height: 1.0);
  static const TextStyle price = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary, height: 1.2);
  static const TextStyle priceStrike = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textHint, height: 1.2, decoration: TextDecoration.lineThrough);
}
