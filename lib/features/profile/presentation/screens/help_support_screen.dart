import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../widgets/setting_tile_widget.dart';

/// A static FAQ item model.
class _FaqItem {
  const _FaqItem({required this.question, required this.answer});
  final String question;
  final String answer;
}

/// Help & Support screen — static FAQ and contact info.
/// (Requirements 18.8)
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'How do I place an order?',
      answer:
          'Browse products, add items to your cart, and tap "Checkout". '
          'Follow the steps to confirm your delivery address and payment.',
    ),
    _FaqItem(
      question: 'How can I track my delivery?',
      answer:
          'Once your order is confirmed, go to "My Orders" and tap the active '
          'order to see real-time tracking on the map.',
    ),
    _FaqItem(
      question: 'What payment methods are accepted?',
      answer:
          'We accept bKash, Nagad, Rocket, and major debit/credit cards. '
          'Cash on delivery is also available in selected areas.',
    ),
    _FaqItem(
      question: 'Can I cancel or modify my order?',
      answer:
          'You can cancel an order within 2 minutes of placing it. '
          'After that, please contact our support team for assistance.',
    ),
    _FaqItem(
      question: 'What if I receive a wrong or damaged item?',
      answer:
          'Tap "Report an Issue" on the order detail screen within 24 hours '
          'of delivery. Our team will review and process a refund or replacement.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          // ── Contact Info ─────────────────────────────────────────────────
          const SizedBox(height: 16),
          SettingSection(
            label: 'Contact Us',
            tiles: [
              SettingTileWidget(
                icon: Icons.phone_outlined,
                title: '16xxx (Hotline)',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () {
                  // TODO: launch phone dialer when url_launcher is added
                },
              ),
              SettingTileWidget(
                icon: Icons.email_outlined,
                title: 'support@deliveryapp.com',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () {
                  // TODO: launch email client when url_launcher is added
                },
              ),
              SettingTileWidget(
                icon: Icons.chat_bubble_outline,
                title: 'Live Chat',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () {
                  // TODO: open live chat when chat feature is implemented
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── FAQ ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'FREQUENTLY ASKED QUESTIONS',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              color: AppColors.surface,
              child: Column(
                children: [
                  for (int i = 0; i < _faqs.length; i++) ...[
                    _FaqTile(item: _faqs[i]),
                    if (i < _faqs.length - 1)
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: AppColors.divider,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private: Expandable FAQ tile
// ---------------------------------------------------------------------------

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.item});

  final _FaqItem item;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      iconColor: AppColors.primary,
      collapsedIconColor: AppColors.textSecondary,
      title: Text(
        item.question,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
      ),
      children: [
        Text(
          item.answer,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
