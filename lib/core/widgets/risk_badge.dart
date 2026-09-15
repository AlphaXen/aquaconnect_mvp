import 'package:flutter/material.dart';

import '../../data/models/risk_level.dart';

class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key, required this.level, this.dense = false});

  final RiskLevel level;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 8 : 10, vertical: dense ? 2 : 4),
      decoration: BoxDecoration(color: level.bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        level.label,
        style: TextStyle(
          fontSize: dense ? 10.5 : 11.5,
          fontWeight: FontWeight.w800,
          color: level.fg,
        ),
      ),
    );
  }
}
