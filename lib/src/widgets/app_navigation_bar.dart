import 'package:flutter/material.dart';

import 'package:aura_pet/src/core/routes/app_destinations.dart';
import 'package:aura_pet/src/core/theme/design_tokens.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppNavigationBar({super.key, required this.currentIndex});

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == currentIndex) return;
    final destination = AppDestinations.mainNav[index];
    Navigator.pushReplacementNamed(context, destination.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 380;
    final navHeight = isCompact ? 72.0 : 80.0;
    final iconSize = isCompact ? 22.0 : 24.0;
    final labelSize = isCompact ? 11.0 : 12.0;
    const backgroundColor = Color(0xFFCBD9FF);
    const indicatorColor = Color(0x4D7FA2F3);
    final selectedOutline = Theme.of(
      context,
    ).colorScheme.primary.withValues(alpha: 0.18);

    return NavigationBar(
      height: navHeight,
      backgroundColor: backgroundColor,
      indicatorColor: indicatorColor,
      selectedIndex: currentIndex,
      labelBehavior: DesignTokens.navLabelBehavior,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: labelSize,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        );
      }),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      destinations: AppDestinations.mainNav
          .map(
            (d) => NavigationDestination(
              icon: Icon(d.icon, size: iconSize, color: Colors.black87),
              selectedIcon: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: selectedOutline, width: 1.2),
                ),
                child: Icon(
                  d.selectedIcon,
                  size: iconSize + 2,
                  color: Colors.black,
                ),
              ),
              label: d.label,
              tooltip: d.label,
            ),
          )
          .toList(growable: false),
    );
  }
}
