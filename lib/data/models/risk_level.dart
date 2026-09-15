import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Farm / report risk tier shown as the colored pill badge throughout the
/// designs ("위험" / "주의" / "양호").
enum RiskLevel {
  danger,
  warning,
  good;

  static RiskLevel fromKey(String key) {
    switch (key) {
      case 'danger':
        return RiskLevel.danger;
      case 'warning':
        return RiskLevel.warning;
      default:
        return RiskLevel.good;
    }
  }

  String get key => switch (this) {
        RiskLevel.danger => 'danger',
        RiskLevel.warning => 'warning',
        RiskLevel.good => 'good',
      };

  String get label => switch (this) {
        RiskLevel.danger => '위험',
        RiskLevel.warning => '주의',
        RiskLevel.good => '양호',
      };

  Color get fg => switch (this) {
        RiskLevel.danger => Colors.white,
        RiskLevel.warning => AppColors.warningDark,
        RiskLevel.good => AppColors.good,
      };

  Color get bg => switch (this) {
        RiskLevel.danger => AppColors.danger,
        RiskLevel.warning => AppColors.warningTint,
        RiskLevel.good => AppColors.goodTint,
      };

  Color get accent => switch (this) {
        RiskLevel.danger => AppColors.danger,
        RiskLevel.warning => AppColors.warningDark,
        RiskLevel.good => AppColors.good,
      };
}
