import 'package:flutter/material.dart';

import 'package:aura_pet/src/core/theme/design_tokens.dart';
import 'package:aura_pet/src/features/community/data/community_blocks_seed.dart';
import 'package:aura_pet/src/features/community/domain/community_content_block.dart';
import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/widgets/app_navigation_bar.dart';

class CommunityPage extends StatelessWidget {
  static const routeName = '/community';

  const CommunityPage({super.key});

  void _onTapBlock(BuildContext context, CommunityContentBlock block) {
    switch (block.actionType) {
      case CommunityActionType.navigate:
        Navigator.pushNamed(context, block.actionTarget);
        break;
      case CommunityActionType.external:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acción externa pendiente de integración'),
          ),
        );
        break;
      case CommunityActionType.placeholder:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${block.title}: funcionalidad próximamente')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 380;
    final maxWidth = width >= 900 ? 900.0 : 640.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Comunidad'),
      ),
      body: AppBackground(
        opacity: DesignTokens.surfaceOpacityLow,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                isCompact ? DesignTokens.space12 : DesignTokens.space16,
                DesignTokens.space16,
                isCompact ? DesignTokens.space12 : DesignTokens.space16,
                DesignTokens.space20,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(DesignTokens.space16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(DesignTokens.radius18),
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withValues(
                          alpha: DesignTokens.surfaceOpacityHigh,
                        ),
                        theme.colorScheme.secondary.withValues(
                          alpha: DesignTokens.surfaceOpacityMedium,
                        ),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comparte y aprende con otros amantes de los perros',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space8),
                      Text(
                        'Explora recomendaciones, tips de cuidado y próximos eventos.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: DesignTokens.space12),
                      SizedBox(
                        width: double.infinity,
                        height: isCompact ? 44 : 48,
                        child: FilledButton.icon(
                          onPressed: () =>
                              _onTapBlock(context, communityBlocksSeed.first),
                          icon: const Icon(Icons.explore_outlined),
                          label: const Text('Explorar bloque destacado'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.space16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Accion principal: abrir un bloque de comunidad',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.space8),
                ...communityBlocksSeed.map(
                  (block) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: DesignTokens.space12,
                    ),
                    child: _CommunityCard(
                      icon: block.icon,
                      title: block.title,
                      subtitle: block.subtitle,
                      onTap: () => _onTapBlock(context, block),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 2),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CommunityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: DesignTokens.elevation0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: DesignTokens.space8,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(DesignTokens.radius12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
