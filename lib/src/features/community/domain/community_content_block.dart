import 'package:flutter/material.dart';

enum CommunityActionType { navigate, external, placeholder }

class CommunityContentBlock {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final CommunityActionType actionType;
  final String actionTarget;

  const CommunityContentBlock({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actionType,
    required this.actionTarget,
  });
}
