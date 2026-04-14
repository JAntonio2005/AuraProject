import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  static const routeName = '/menu';

  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Menú')));
  }
}
