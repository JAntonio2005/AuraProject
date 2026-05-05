import 'package:flutter/material.dart';

import 'package:aura_pet/src/core/theme/design_tokens.dart';
import 'package:aura_pet/src/features/community/data/community_blocks_seed.dart';
import 'package:aura_pet/src/features/community/domain/community_content_block.dart';
import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/widgets/app_navigation_bar.dart';

class CommunityPage extends StatefulWidget {
  static const routeName = '/community';

  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  bool _showBanner = true;

  void _openShelterDetails(BuildContext context, _ShelterInfo shelter) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);

        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    Text(
                      'Detalle',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(DesignTokens.space16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radius18,
                        ),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shelter.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _DetailSection(
                            title: 'Descripción',
                            child: Text(
                              shelter.description,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                          const Divider(height: 24),
                          _DetailSection(
                            title: 'Localización',
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    shelter.location,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  style: IconButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary
                                        .withValues(alpha: 0.08),
                                  ),
                                  icon: Icon(
                                    Icons.place_outlined,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 24),
                          _DetailSection(
                            title: 'Cantidad de perros aprox.',
                            child: Text(
                              shelter.dogs,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                          const Divider(height: 24),
                          _DetailSection(
                            title: 'Correo',
                            child: Text(
                              shelter.email,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const Divider(height: 24),
                          _DetailSection(
                            title: 'Redes sociales',
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: shelter.socialNetworks
                                  .map(
                                    (network) => Chip(
                                      label: Text(network),
                                      side: BorderSide(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.24),
                                      ),
                                      backgroundColor: theme.colorScheme.primary
                                          .withValues(alpha: 0.04),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const Divider(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.06,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.12,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Perfil asociado en Aura',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage: AssetImage(
                                        shelter.profileImageAsset,
                                      ),
                                      backgroundColor:
                                          theme.colorScheme.surfaceVariant,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            shelter.profileName,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          Text(
                                            shelter.profileRole,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('Ver más imágenes/fotos'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 92,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: shelter.galleryImages.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    shelter.galleryImages[index],
                                    width: 116,
                                    height: 92,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

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
                if (_showBanner)
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.space16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radius18,
                      ),
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
                          'Explora recomendaciones, tips de cuidado y guías de la comunidad.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: DesignTokens.space12),
                        SizedBox(
                          width: double.infinity,
                          height: isCompact ? 44 : 48,
                          child: FilledButton.icon(
                            onPressed: () {
                              setState(() => _showBanner = false);
                              _onTapBlock(context, communityBlocksSeed.first);
                            },
                            icon: const Icon(Icons.explore_outlined),
                            label: const Text('Explorar bloque destacado'),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_showBanner) const SizedBox(height: DesignTokens.space16),
                Text(
                  'Apoya refugios',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: DesignTokens.space8),
                ..._buildShelterCards(context, theme),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 1),
    );
  }

  List<Widget> _buildShelterCards(BuildContext context, ThemeData theme) {
    final shelters = [
      _ShelterInfo(
        name: 'Hogar Temporal AURA',
        description:
            'Equipo comunitario para hogares de paso, traslados seguros y seguimiento de perros rescatados.',
        location: 'Coyoacan',
        dogs: '17',
        email: 'hogar.temporal@aura.app',
        profileName: 'Diego Salas',
        profileRole: 'Lider de voluntariado',
        profileImageAsset: 'assets/images/iconDog.png',
        socialNetworks: const ['Instagram', 'Facebook', 'TikTok'],
        galleryImages: const [
          'assets/images/bg_dogs.png',
          'assets/images/bg_dogs.png',
          'assets/images/bg_dogs.png',
        ],
      ),
      _ShelterInfo(
        name: 'Rescate Feliz',
        description:
            'Refugio especializado en rescate y rehabilitación de perros en situación de calle.',
        location: 'Roma',
        dogs: '23',
        email: 'rescate.feliz@aura.app',
        profileName: 'Mariana Cruz',
        profileRole: 'Gestora de movilidad',
        profileImageAsset: 'assets/images/iconDog.png',
        socialNetworks: const ['Instagram', 'Facebook', 'TikTok'],
        galleryImages: const [
          'assets/images/bg_dogs.png',
          'assets/images/bg_dogs.png',
          'assets/images/bg_dogs.png',
        ],
      ),
      _ShelterInfo(
        name: 'Patas Seguras',
        description:
            'Centro de adopción con programa de seguimiento post-adopción.',
        location: 'Polanco',
        dogs: '12',
        email: 'patas.seguras@aura.app',
        profileName: 'Ana Torres',
        profileRole: 'Coordinadora de adopciones',
        profileImageAsset: 'assets/images/iconDog.png',
        socialNetworks: const ['Instagram', 'Facebook', 'TikTok'],
        galleryImages: const [
          'assets/images/bg_dogs.png',
          'assets/images/bg_dogs.png',
          'assets/images/bg_dogs.png',
        ],
      ),
    ];

    return shelters.map((shelter) {
      return Padding(
        padding: const EdgeInsets.only(bottom: DesignTokens.space12),
        child: _ShelterCard(
          shelter: shelter,
          onTap: () {
            _openShelterDetails(context, shelter);
          },
        ),
      );
    }).toList();
  }
}

class _ShelterInfo {
  final String name;
  final String description;
  final String location;
  final String dogs;
  final String email;
  final String profileName;
  final String profileRole;
  final String profileImageAsset;
  final List<String> socialNetworks;
  final List<String> galleryImages;

  const _ShelterInfo({
    required this.name,
    required this.description,
    required this.location,
    required this.dogs,
    required this.email,
    required this.profileName,
    required this.profileRole,
    required this.profileImageAsset,
    required this.socialNetworks,
    required this.galleryImages,
  });
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ShelterCard extends StatelessWidget {
  final _ShelterInfo shelter;
  final VoidCallback onTap;

  const _ShelterCard({required this.shelter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radius16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        padding: const EdgeInsets.all(DesignTokens.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              shelter.name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: DesignTokens.space8),
            Text(
              shelter.description,
              style: theme.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: DesignTokens.space8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: DesignTokens.space4),
                Text(shelter.location, style: theme.textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: DesignTokens.space8),
            Text(
              'Perros aprox: ${shelter.dogs}',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.space8),
            Text(
              'Email: ${shelter.email}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: DesignTokens.space12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Ver más'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
