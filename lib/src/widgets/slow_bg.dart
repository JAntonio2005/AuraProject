import 'dart:async';
import 'package:flutter/material.dart';

/// Fondo con paneo lento (izq<->der) y crossfade opcional entre imágenes.
/// - Si pasa 1 imagen: hace paneo infinito (sin cambios de imagen).
/// - Si pasa 2+ imágenes: además hace crossfade cada [swapInterval].
class SlowBackground extends StatefulWidget {
  final List<ImageProvider> images;
  final Duration panDuration;     // tiempo de ida o vuelta del paneo
  final Duration swapInterval;    // cada cuánto cambia de imagen (si hay varias)
  final double dimOpacity;        // capa blanca para no opacar el contenido (0..1)

  const SlowBackground({
    super.key,
    required this.images,
    this.panDuration = const Duration(seconds: 18),
    this.swapInterval = const Duration(seconds: 22),
    this.dimOpacity = 0.28,
  });

  @override
  State<SlowBackground> createState() => _SlowBackgroundState();
}

class _SlowBackgroundState extends State<SlowBackground>
    with TickerProviderStateMixin {
  late final AnimationController _pan;
  late final Animation<Alignment> _align; // izquierda <-> derecha

  int _current = 0;
  int _next = 1;
  Timer? _swapTimer;
  bool _fading = false;

  @override
  void initState() {
    super.initState();

    // Paneo infinito: izquierda -> derecha -> izquierda -> ...
    _pan = AnimationController(vsync: this, duration: widget.panDuration);
    _align = AlignmentTween(
      begin: const Alignment(-0.8, 0.0), // ligeramente a la izquierda
      end:   const Alignment( 0.8, 0.0), // ligeramente a la derecha
    ).animate(CurvedAnimation(parent: _pan, curve: Curves.linear))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          _pan.reverse(); // regresar
        } else if (s == AnimationStatus.dismissed) {
          _pan.forward(); // ir de nuevo
        }
      });
    _pan.forward();

    // Si hay más de una imagen, programe crossfade periódico
    if (widget.images.length > 1) {
      _swapTimer = Timer.periodic(widget.swapInterval, (_) {
        if (!mounted) return;
        setState(() => _fading = true);
        // espere un poco el fade y cambie índices
        Future.delayed(const Duration(milliseconds: 650), () {
          if (!mounted) return;
          setState(() {
            _current = _next;
            _next = (_next + 1) % widget.images.length;
            _fading = false;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _swapTimer?.cancel();
    _pan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imgs = widget.images;

    // Capa base: imagen actual con paneo
    Widget base = AnimatedBuilder(
      animation: _align,
      builder: (_, __) {
        return Container(
          alignment: _align.value,
          child: SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image(image: imgs[_current]),
            ),
          ),
        );
      },
    );

    // Si hay próxima imagen, superponga con FadeTransition
    Widget faded = imgs.length < 2
        ? const SizedBox.shrink()
        : AnimatedOpacity(
            opacity: _fading ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOut,
            child: Container(
              alignment: Alignment.center,
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image(image: imgs[_next]),
                ),
              ),
            ),
          );

    return Stack(
      children: [
        Positioned.fill(child: base),
        Positioned.fill(child: faded),
        // Atenuación para que el contenido sea legible
        Positioned.fill(
          child: Container(color: Colors.white.withOpacity(widget.dimOpacity)),
        ),
        // Gradiente muy sutil para botones/textos
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.06),
                    Colors.white.withOpacity(0.18),
                    Colors.white.withOpacity(0.30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
