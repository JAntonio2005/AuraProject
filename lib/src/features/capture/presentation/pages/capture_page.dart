import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

import 'package:aura_pet/src/core/models/predict_response.dart';
import 'package:aura_pet/src/core/routes/services/api_client.dart';
import 'package:aura_pet/src/features/result/presentation/pages/prediction_detail_page.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> with WidgetsBindingObserver {
  // 0=Razas, 1=Cámara (esta), 2=Instituciones, 3=Perfil
  final int _navIndex = 1;
  static const int _maxImageSizeInMB = 8;
  static const int _maxImageBytes = _maxImageSizeInMB * 1024 * 1024;

  CameraController? _controller;
  Future<void>? _initCameraFuture;
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;
  final _PredictService _predictService = _PredictService();

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

  // Pausar/reanudar cámara según el ciclo de vida
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
      if (img == null) return; // usuario canceló
      await _scanFlow(img.path);
    } catch (e) {
      _showSnack('No se pudo abrir la galería: $e');
    }
  }

  Future<void> _scanFlow(String imagePath) async {
    if (_isScanning) return;

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

      if (result.top1.score < 0.65) {
        _showConfidenceErrorDialog();
        return;
      }

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
            const Text('• Evite movimiento al disparar.'),
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

  void _showConfidenceErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 48),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      'Lo vuelva a intentar',
                      textAlign: TextAlign.center,
                      style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'No hay un perro o la foto no es de buena calidad',
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _onTapNav(int i) {
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/collection');
        break;
      case 1:
        // Ya estamos en /capture
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/institutions');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cam = _controller;

    return Scaffold(
      appBar: AppBar(title: const Text('Tomar foto')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Stack(
                children: [
                  // Preview real de cámara (o placeholder mientras inicia)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
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
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white70, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Controles inferiores
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
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
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: _isScanning ? null : _takePictureAndScan,
                  child: const Icon(Icons.photo_camera_outlined, size: 28),
                ),
                IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    Navigator.pushNamed(context, '/history');
                  },
                  tooltip: 'Historial',
                ),
              ],
            ),
          ),
        ],
      ),
      // Barra inferior fija
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTapNav,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Razas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera_outlined),
            label: 'Cámara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Instituciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
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

class _PredictService {
  final ApiClient _apiClient = ApiClient();

  Future<PredictResponse> predict(File file) async {
    final dio = _apiClient.dio;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.isNotEmpty
            ? file.uri.pathSegments.last
            : 'image.jpg',
      ),
    });

    final response = await dio.post('/predict', data: formData);
    final data = response.data;

    if (data is Map<String, dynamic>) {
      return PredictResponse.fromJson(data);
    }

    if (data is Map) {
      return PredictResponse.fromJson(Map<String, dynamic>.from(data));
    }

    throw Exception('Respuesta inválida del servidor');
  }
}
