import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  static const routeName = '/history';
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    // TODO: reemplazar por datos reales (local DB / API)
    final items = List.generate(8, (i) {
      return (
        title: 'Resultado #${i + 1}: Raza detectada',
        subtitle: '12/09/2025 18:${10 + i} • Confidencia ${(90 - i)}%',
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: SafeArea(
        child: items.isEmpty
            ? Center(
                child: Text(
                  'Aún no hay resultados',
                  style: t.textTheme.titleMedium?.copyWith(
                    color: t.colorScheme.onSurface.withValues(alpha: .7),
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final it = items[i];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.pets)),
                    title: Text(it.title),
                    subtitle: Text(it.subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Detalle pendiente')),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
