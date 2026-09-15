import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The approved designs are mobile-first (390px). On a wide browser window
/// we center that column instead of stretching it edge-to-edge, which
/// keeps line lengths and card proportions matching the mockups exactly.
class ResponsiveMobileFrame extends StatelessWidget {
  const ResponsiveMobileFrame({super.key, required this.child, this.maxWidth = 480});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= maxWidth) return child;

    return ColoredBox(
      color: AppColors.divider,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.background,
              boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 24)],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
