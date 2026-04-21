import 'package:flutter/material.dart';

import 'package:aura_pet/src/core/theme/design_tokens.dart';

class StatePanels {
  const StatePanels._();

  static Widget _panelShell({required Widget child}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.space16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: DesignTokens.statePanelMaxWidth,
          ),
          child: child,
        ),
      ),
    );
  }

  static Widget loading({String message = 'Cargando informacion...'}) =>
      _panelShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: DesignTokens.space12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      );

  static Widget error({
    required BuildContext context,
    required String message,
    required VoidCallback onRetry,
    String actionLabel = 'Reintentar',
  }) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final verticalGap = width < 380
        ? DesignTokens.space8
        : DesignTokens.space12;
    return _panelShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 28),
          const SizedBox(height: DesignTokens.space8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: verticalGap),
          FilledButton(onPressed: onRetry, child: Text(actionLabel)),
        ],
      ),
    );
  }

  static Widget empty({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final theme = Theme.of(context);
    return _panelShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            size: 30,
          ),
          const SizedBox(height: DesignTokens.space8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: DesignTokens.space12),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ],
      ),
    );
  }
}
