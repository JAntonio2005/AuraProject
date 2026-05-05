import 'dart:io'; // 👈 NUEVO
import 'package:aura_pet/src/features/result/presentation/pages/prediction_detail_page.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/core/routes/app_destinations.dart';
import 'package:aura_pet/src/core/routes/services/predict_service.dart'; // 👈 NUEVO
import 'package:aura_pet/src/core/theme/design_tokens.dart';
import 'package:aura_pet/src/widgets/app_navigation_bar.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initCameraFuture;
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;

  final _predictService = PredictService(); // 👈 NUEVO

  static const int _maxImageSizeInMB = 5;
  static const int _maxImageBytes = _maxImageSizeInMB * 1024 * 1024;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cam = _controller;
    if (cam == null || !cam.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      cam.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  void _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final ctrl = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      setState(() {
        _controller = ctrl;
        _initCameraFuture = ctrl.initialize();
      });
    } catch (e) {
      _showSnack('No se pudo inicializar la cámara: $e');
    }
  }

  Future<void> _takePictureAndScan() async {
    final cam = _controller;
    if (cam == null || !cam.value.isInitialized || _isScanning) return;

    try {
      await _initCameraFuture;
      final file = await cam.takePicture(); // foto real
      await _scanFlow(file.path);
    } catch (e) {
      _showSnack('No se pudo tomar la foto: $e');
    }
  }

  Future<void> _pickFromGalleryAndScan() async {
    if (_isScanning) return;
    try {
      final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
      if (img == null) return;
      await _scanFlow(img.path);
    } catch (e) {
      _showSnack('No se pudo abrir la galería: $e');
    }
  }

  Future<void> _scanFlow(String imagePath) async {
    if (_isScanning) return;

    // 🔹 Validar tamaño máximo de la imagen antes de escanear
    try {
      final file = File(imagePath);
      final int sizeInBytes = await file.length();

      if (sizeInBytes > _maxImageBytes) {
        final sizeInMB = (sizeInBytes / (1024 * 1024)).toStringAsFixed(2);

        _showSnack(
          'La imagen es muy pesada ($sizeInMB MB). El máximo es $_maxImageSizeInMB MB.',
        );
        return;
      }

      setState(() => _isScanning = true);
      _showSnack('Escaneando imagen...');

      final result = await _predictService.predict(file);

      if (!mounted) return;

      Navigator.pushNamed(
        context,
        PredictionDetailPage.routeName,
        arguments: PredictionDetailArgs(
          imagePath: imagePath,
          prediction: result,
        ),
      );
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      _showSnack('No se pudo escanear la imagen: $msg');
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  void _showHelp() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.help_outline),
                const SizedBox(width: 8),
                const Text(
                  'Recomendaciones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('• Iluminación uniforme.'),
            const Text('• Perro centrado y enfocado.'),
            const Text('• Fondo simple.'),
            const Text('• Evita movimiento al disparar.'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final cam = _controller;
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 380;
    final isWide = width >= 900;
    final frameSize = isCompact ? 180.0 : (isWide ? 280.0 : 220.0);
    final shutterPadding = isCompact ? 12.0 : 16.0;
    final helperTextSize = isCompact ? 12.0 : 13.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Tomar foto')),
      // Fondo SOLO en body
      body: AppBackground(
        opacity: DesignTokens.surfaceOpacityMedium,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.space12),
                child: Stack(
                  children: [
                    // Preview de cámara o placeholder
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radius12,
                        ),
                        child: cam == null
                            ? _placeholder()
                            : FutureBuilder<void>(
                                future: _initCameraFuture,
                                builder: (context, snap) {
                                  if (snap.connectionState !=
                                      ConnectionState.done) {
                                    return _placeholder(
                                      text: 'Inicializando cámara...',
                                    );
                                  }
                                  if (!cam.value.isInitialized) {
                                    return _placeholder(
                                      text: 'Cámara no disponible',
                                    );
                                  }
                                  return CameraPreview(cam);
                                },
                              ),
                      ),
                    ),
                    // Botón de ayuda
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(Icons.help_outline),
                        onPressed: _showHelp,
                        tooltip: 'Ayuda',
                      ),
                    ),
                    // Marco visual
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Center(
                          child: Container(
                            width: frameSize,
                            height: frameSize,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white70,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radius12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.space16,
              ),
              child: Text(
                'Accion principal: tomar foto para escanear',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: helperTextSize,
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.space8),
            // Controles inferiores
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.space12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.image_outlined),
                    onPressed: _isScanning ? null : _pickFromGalleryAndScan,
                    tooltip: 'Subir desde galería',
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.all(shutterPadding),
                    ),
                    onPressed: _isScanning ? null : _takePictureAndScan,
                    child: Icon(
                      Icons.photo_camera_outlined,
                      size: isCompact ? 24 : 30,
                    ),
                  ),
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.history_outlined),
                    onPressed: _isScanning
                        ? null
                        : () => Navigator.pushNamed(
                            context,
                            AppDestinations.history,
                          ),
                    tooltip: 'Historial',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 2),
    );
  }

  Widget _placeholder({String text = 'Vista de cámara (demo)'}) {
    return Container(
      color: Colors.black12,
      child: Center(
        child: Text(text, style: const TextStyle(color: Colors.black54)),
      ),
    );
  }
}
