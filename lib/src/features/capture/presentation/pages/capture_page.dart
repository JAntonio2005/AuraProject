import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> with WidgetsBindingObserver {
  // 0=Razas, 1=Cámara (esta), 2=Historial, 3=Perfil
  final int _navIndex = 1;

  CameraController? _controller;
  Future<void>? _initCameraFuture;
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;

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
    setState(() => _isScanning = true);
    _showSnack('Escaneando imagen...');
    // Simulación (reemplazar por llamada a backend/IA)
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isScanning = false);
    _showSnack('No se pudo escanear la imagen (demo).');
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
        Navigator.pushReplacementNamed(context, '/history');
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
                const SizedBox(width: 32),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Razas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera_outlined),
            label: 'Cámara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
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
