import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final double opacity;           // 0.0 a 1.0 (más bajo = menos visible)
  final Alignment alignment;      // por si quiere mover el patrón
  final EdgeInsets padding;       // si quiere SafeArea interna

  const AppBackground({
    super.key,
    required this.child,
    this.opacity = 0.10,          // suave por defecto
    this.alignment = Alignment.topCenter,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo con imagen
        Positioned.fill(
          child: Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/bg_paws.png'),
                  fit: BoxFit.cover,
                  alignment: alignment,
                ),
              ),
            ),
          ),
        ),
        // Contenido de la página
        Padding(padding: padding, child: child),
      ],
    );
  }
}
