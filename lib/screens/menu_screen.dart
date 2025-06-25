import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Principal')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Gestion de Productos'),
            leading: Icon(Icons.inventory),
            onTap: () {
              print("Has pulsado el boton de producto");
              Navigator.pushNamed(context, '/products');
            },
          ),
          ListTile(
            title: const Text('Gestion de Clientes'),
            leading: Icon(Icons.person),
            onTap: () {
              print("Has pulsado el boton de clientes");
              Navigator.pushNamed(context, '/clients');
            },
          ),
          ListTile(
            title: const Text('Gestion de Vendedores'),
            leading: Icon(Icons.production_quantity_limits),
            onTap: () {
              print("Has pulsado el boton de vendedores");
              Navigator.pushNamed(context, '/sellers');
            },
          ),
        ],
      ),
    );
  }
}
