import 'package:flutter/material.dart';

import 'package:aura_pet/src/features/community/domain/community_content_block.dart';

const List<CommunityContentBlock> communityBlocksSeed = [
  CommunityContentBlock(
    id: 'shelters',
    title: 'Apoya refugios',
    subtitle: 'Conoce instituciones y formas de colaborar',
    icon: Icons.volunteer_activism_outlined,
    actionType: CommunityActionType.placeholder,
    actionTarget: 'shelters',
  ),
];
