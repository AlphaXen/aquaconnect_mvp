import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// 7-day temperature sparkline — a direct port of the SVG polyline used in
/// every `.dc.html` design (`<polyline points="0,28 54,25 ...">`).
class TempSparkline extends StatelessWidget {
  const TempSparkline({super.key, required this.values, this.height = 48, this.color = AppColors.danger});

  final List<double> values;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _SparklinePainter(values: values, color: color)),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final baselineY = size.height - 8;
    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      Paint()
        ..color = const Color(0xFFEDF1F5)
        ..strokeWidth = 1,
    );

    if (values.length < 2) return;

    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs() < 0.001 ? 1.0 : maxV - minV;
    final top = 6.0;
    final usableHeight = baselineY - top;

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final normalized = (values[i] - minV) / range;
      final y = top + usableHeight * (1 - normalized);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

/// 7-day mortality bar chart, matching the bar-height design pattern
/// (later days rendered darker/taller when trending up).
class MortalityBarChart extends StatelessWidget {
  const MortalityBarChart({super.key, required this.values, this.height = 52});

  final List<double> values;
  final double height;

  @override
  Widget build(BuildContext context) {
    final maxV = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    final safeMax = maxV <= 0 ? 1.0 : maxV;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final ratio = values[i] / safeMax;
          final isLast = i == values.length - 1;
          final isNearLast = i == values.length - 2;
          final color = isLast
              ? AppColors.danger
              : isNearLast
                  ? const Color(0xFFF0BBA5)
                  : AppColors.brandTint;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i == values.length - 1 ? 0 : 8),
              height: (height * ratio).clamp(4, height),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
            ),
          );
        }),
      ),
    );
  }
}

class ChartDayLabels extends StatelessWidget {
  const ChartDayLabels({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map((l) => Text(l, style: const TextStyle(fontSize: 10, color: AppColors.textFaint)))
          .toList(),
    );
  }
}
