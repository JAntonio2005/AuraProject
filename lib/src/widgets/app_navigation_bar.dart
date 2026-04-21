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
    if (AppDestinations.mainNav.isEmpty) {
      return const SizedBox.shrink();
    }

    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < DesignTokens.compactWidth;
    final navHeight = isCompact ? 72.0 : 80.0;
    final iconSize = isCompact ? 22.0 : 24.0;
    final labelSize = isCompact ? 11.0 : 12.0;
    final boundedIndex =
        currentIndex.clamp(0, AppDestinations.mainNav.length - 1) as int;

    return SafeArea(
      top: false,
      child: NavigationBar(
        height: navHeight,
        selectedIndex: boundedIndex,
        labelBehavior: DesignTokens.navLabelBehavior,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: labelSize,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
        destinations: AppDestinations.mainNav
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon, size: iconSize),
                selectedIcon: Icon(d.selectedIcon, size: iconSize),
                label: d.label,
                tooltip: d.label,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
