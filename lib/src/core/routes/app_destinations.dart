import 'package:flutter/material.dart';

import 'package:aura_pet/src/core/models/navigation_destination.dart';

class AppDestinations {
  const AppDestinations._();

  static const String home = '/home';
  static const String collection = '/collection';
  static const String capture = '/capture';
  static const String community = '/community';
  static const String history = '/history';
  static const String profile = '/profile';

  static const List<AppNavigationDestination> mainNav = [
    AppNavigationDestination(
      position: 0,
      key: 'breeds',
      label: 'Razas',
      icon: Icons.pets_outlined,
      selectedIcon: Icons.pets,
      routeName: collection,
    ),
    AppNavigationDestination(
      position: 1,
      key: 'community',
      label: 'Comunidad',
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups,
      routeName: community,
    ),
    AppNavigationDestination(
      position: 2,
      key: 'camera',
      label: 'Cámara',
      icon: Icons.photo_camera_outlined,
      selectedIcon: Icons.photo_camera,
      routeName: capture,
    ),
    AppNavigationDestination(
      position: 3,
      key: 'profile',
      label: 'Perfil',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      routeName: profile,
    ),
  ];
}
