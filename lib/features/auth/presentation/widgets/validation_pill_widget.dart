import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';

/// Premium animated validation feedback pill.
///
/// Features:
/// - Smooth fade + slide animation
/// - Rounded capsule design
/// - Warning icon
/// - Color-coded by error type
/// - Auto-hide when corrected
/// - Subtle shake animation for operator errors
///
/// Inspired by bKash/Nagad/Uber premium onboarding UX.
class ValidationPillWidget extends StatefulWidget {
  const ValidationPillWidget({
    super.key,
    required this.message,
    required this.isVisible,
  });

  final String? message;
  final bool isVisible;

  @override
  State<ValidationPillWidget> createState() => _ValidationPillWidgetState();
}

class _ValidationPillWidgetState extends State<ValidationPillWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shakeAnimation;

  String? _previousMessage;
  bool _shouldShake = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.02), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.02, end: 0.02), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.02, end: -0.02), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.02, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticIn),
    ));
  }

  @override
  void didUpdateWidget(ValidationPillWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isVisible && !oldWidget.isVisible) {
      // Show animation
      _controller.forward();

      // Check if this is an operator error for shake animation
      if (widget.message == 'Invalid operator.' &&
          _previousMessage != widget.message) {
        _shouldShake = true;
      } else {
        _shouldShake = false;
      }
    } else if (!widget.isVisible && oldWidget.isVisible) {
      // Hide animation
      _controller.reverse();
    }

    _previousMessage = widget.message;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (widget.message == 'Invalid operator.') {
      // Amber/orange for operator errors
      return Colors.amber.shade50;
    } else {
      // Soft red for number errors
      return Colors.red.shade50;
    }
  }

  Color _getBorderColor() {
    if (widget.message == 'Invalid operator.') {
      return Colors.amber.shade300;
    } else {
      return Colors.red.shade300;
    }
  }

  Color _getIconColor() {
    if (widget.message == 'Invalid operator.') {
      return Colors.amber.shade700;
    } else {
      return Colors.red.shade700;
    }
  }

  Color _getTextColor() {
    if (widget.message == 'Invalid operator.') {
      return Colors.amber.shade900;
    } else {
      return Colors.red.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || widget.message == null) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: _shouldShake
                  ? Offset(_shakeAnimation.value * 10, 0)
                  : Offset.zero,
              child: child,
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getBorderColor(),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _getBorderColor().withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: _getIconColor(),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    widget.message!,
                    style: AppTextStyles.caption.copyWith(
                      color: _getTextColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
