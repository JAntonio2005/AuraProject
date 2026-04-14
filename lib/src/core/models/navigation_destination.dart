import 'package:flutter/material.dart';

class AppNavigationDestination {
  final int position;
  final String key;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String routeName;

  const AppNavigationDestination({
    required this.position,
    required this.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.routeName,
  });
}
