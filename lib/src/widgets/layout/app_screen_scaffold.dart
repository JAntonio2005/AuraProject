import 'package:flutter/material.dart';

import 'package:aura_pet/src/core/theme/design_tokens.dart';

class AppScreenScaffold extends StatelessWidget {
  final Widget? header;
  final Widget body;
  final Widget? footer;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const AppScreenScaffold({
    super.key,
    this.header,
    required this.body,
    this.footer,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < DesignTokens.compactWidth;
    final effectivePadding =
        padding ??
        EdgeInsets.fromLTRB(
          isCompact ? DesignTokens.space12 : DesignTokens.space16,
          DesignTokens.space12,
          isCompact ? DesignTokens.space12 : DesignTokens.space16,
          DesignTokens.space16,
        );

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth ?? 960),
          child: Padding(
            padding: effectivePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null) ...[
                  header!,
                  const SizedBox(height: DesignTokens.space12),
                ],
                Expanded(child: body),
                if (footer != null) ...[
                  const SizedBox(height: DesignTokens.space12),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
