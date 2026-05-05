import 'package:flutter/material.dart';

class AppBackground extends StatefulWidget {
  final Widget child;
  final double opacity; // 0.0 a 1.0 (más bajo = menos visible)
  final Alignment alignment; // por si quiere mover el patrón
  final EdgeInsets padding; // si quiere SafeArea interna

  const AppBackground({
    super.key,
    required this.child,
    this.opacity = 0.10, // suave por defecto
    this.alignment = Alignment.topCenter,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;

        return Stack(
          children: [
            // Efecto "caminadora": dos capas idénticas que se desplazan en bucle.
            Positioned.fill(
              child: Opacity(
                opacity: widget.opacity,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final shift = viewportWidth * _controller.value;

                    return Stack(
                      children: [
                        Positioned(
                          left: -shift,
                          top: 0,
                          bottom: 0,
                          width: viewportWidth,
                          child: _PawLayer(alignment: widget.alignment),
                        ),
                        Positioned(
                          left: viewportWidth - shift,
                          top: 0,
                          bottom: 0,
                          width: viewportWidth,
                          child: _PawLayer(alignment: widget.alignment),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(padding: widget.padding, child: widget.child),
          ],
        );
      },
    );
  }
}

class _PawLayer extends StatelessWidget {
  final Alignment alignment;

  const _PawLayer({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/bg_paws.png'),
          fit: BoxFit.cover,
          alignment: alignment,
        ),
      ),
    );
  }
}
