import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// Reusable BoboNyenyak logo widget using dart:math for accurate trigonometry.
///
/// Built entirely with Flutter widgets — no external image dependency.
class BoboLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool lightMode;

  const BoboLogo({
    super.key,
    this.size = 80,
    this.showText = true,
    this.lightMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = lightMode ? Colors.white : AppTheme.midnightBlue;
    final taglineColor = lightMode
        ? Colors.white.withValues(alpha: 0.8)
        : AppTheme.textSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo icon
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _MoonStarPainter(
              moonColor:
                  lightMode ? AppTheme.accentGold : AppTheme.midnightBlue,
              starColor: AppTheme.accentGold,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          Text(
            'BoboNyenyak',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Temani setiap waktu tidur si kecil',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: taglineColor,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ],
    );
  }
}

/// Custom painter that draws a crescent moon with stars.
class _MoonStarPainter extends CustomPainter {
  final Color moonColor;
  final Color starColor;

  _MoonStarPainter({
    required this.moonColor,
    required this.starColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    // Draw crescent moon
    final moonPaint = Paint()
      ..color = moonColor
      ..style = PaintingStyle.fill;

    final moonPath = Path();
    moonPath.addOval(
      Rect.fromCircle(center: center, radius: radius),
    );

    // Cut out inner circle to create crescent
    final cutoutCenter = Offset(
      center.dx + radius * 0.4,
      center.dy - radius * 0.15,
    );
    final cutoutPath = Path();
    cutoutPath.addOval(
      Rect.fromCircle(center: cutoutCenter, radius: radius * 0.8),
    );

    final crescentPath = Path.combine(
      PathOperation.difference,
      moonPath,
      cutoutPath,
    );

    canvas.drawPath(crescentPath, moonPaint);

    // Draw stars
    final starPaint = Paint()
      ..color = starColor
      ..style = PaintingStyle.fill;

    // Large star
    _drawStar(
      canvas,
      Offset(center.dx + radius * 0.65, center.dy - radius * 0.65),
      radius * 0.15,
      starPaint,
    );

    // Small star
    _drawStar(
      canvas,
      Offset(center.dx + radius * 0.95, center.dy - radius * 0.2),
      radius * 0.09,
      starPaint,
    );

    // Tiny star
    _drawStar(
      canvas,
      Offset(center.dx + radius * 0.45, center.dy - radius * 1.0),
      radius * 0.06,
      starPaint,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 4;
    const innerRatio = 0.4;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final r = i.isEven ? radius : radius * innerRatio;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
