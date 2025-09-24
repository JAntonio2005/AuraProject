import 'package:flutter/material.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});
  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final TextEditingController _search = TextEditingController();
  // Índices: 0=Razas (principal, icono casa), 1=Cámara, 2=Historial, 3=Perfil
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Colección de Razas')),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: (_) {}, // TODO: conectar a repo cuando haya backend
            ),
          ),
          // Lista placeholder
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: 8,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('img', style: TextStyle(fontSize: 12)),
                    ),
                    title: const Text('Nombre de la raza'),
                    subtitle: const Text('Descripción'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {}, // TODO: ir a detalle
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Barra inferior fija (4 íconos)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),  label: 'Razas'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera_outlined), label: 'Cámara'),
          BottomNavigationBarItem(icon: Icon(Icons.history),        label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
        onTap: (i) {
          if (i == _navIndex) return;
          setState(() => _navIndex = i);
          // TODO: cuando estén las rutas reales, navegue según i:
          // if (i == 0) Navigator.pushNamed(context, '/collection'); // Razas (esta)
          // if (i == 1) Navigator.pushNamed(context, '/capture');
          // if (i == 2) Navigator.pushNamed(context, '/history');
          // if (i == 3) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}
