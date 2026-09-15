import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import 'responsive_mobile_frame.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: '홈'),
    (icon: Icons.edit_note_outlined, activeIcon: Icons.edit_note, label: '메모'),
    (icon: Icons.info_outline, activeIcon: Icons.info, label: '정보'),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: '마이페이지'),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveMobileFrame(
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 9, bottom: 4),
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final tab = _tabs[i];
                  final selected = i == navigationShell.currentIndex;
                  final color = selected ? AppColors.brand : AppColors.textMuted;
                  return Expanded(
                    child: InkWell(
                      onTap: () => navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(selected ? tab.activeIcon : tab.icon, size: 21, color: color),
                          const SizedBox(height: 4),
                          Text(
                            tab.label,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
