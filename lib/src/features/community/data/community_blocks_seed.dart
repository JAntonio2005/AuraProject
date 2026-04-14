import 'package:flutter/material.dart';

import 'package:aura_pet/src/features/community/domain/community_content_block.dart';

const List<CommunityContentBlock> communityBlocksSeed = [
  CommunityContentBlock(
    id: 'forum',
    title: 'Foro Aura',
    subtitle: 'Preguntas y respuestas de la comunidad',
    icon: Icons.forum_outlined,
    actionType: CommunityActionType.placeholder,
    actionTarget: 'forum',
  ),
  CommunityContentBlock(
    id: 'events',
    title: 'Eventos cercanos',
    subtitle: 'Encuentros, adopciones y jornadas de vacunacion',
    icon: Icons.event_outlined,
    actionType: CommunityActionType.placeholder,
    actionTarget: 'events',
  ),
  CommunityContentBlock(
    id: 'shelters',
    title: 'Apoya refugios',
    subtitle: 'Conoce instituciones y formas de colaborar',
    icon: Icons.volunteer_activism_outlined,
    actionType: CommunityActionType.placeholder,
    actionTarget: 'shelters',
  ),
];
