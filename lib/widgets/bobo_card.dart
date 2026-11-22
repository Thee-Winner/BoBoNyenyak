import 'package:flutter/material.dart';
import '../config/bobo_colors.dart';

/// Reusable Card Container supporting dynamic Dark & Light modes.
class BoboCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Border? border;

  const BoboCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 18,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BoboColors.of(context);
    final effectiveBg = backgroundColor ?? colors.cardBg;
    final effectiveBorder = border ?? (colors.isDark ? null : Border.all(color: colors.border, width: 1));

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: effectiveBorder,
        boxShadow: colors.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );
  }
}
