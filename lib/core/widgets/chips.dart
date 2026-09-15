import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Rounded filter/tab chip used across Home/Memo/Info/AllReport for things
/// like "내 담당 8" / "전체" / "국내" etc.
class FilterPillChip extends StatelessWidget {
  const FilterPillChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor = AppColors.brand,
    this.selectedTextColor = Colors.white,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color selectedTextColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? selectedColor : AppColors.surface,
          border: selected ? null : Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? selectedTextColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Small icon+label badge like "해양환경 데이터 4종" / "현장 메모 7건" on Home.
class SourceBadgeChip extends StatelessWidget {
  const SourceBadgeChip({
    super.key,
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
  });

  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 5, 11, 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}
