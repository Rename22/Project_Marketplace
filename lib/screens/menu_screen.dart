import 'package:flutter/material.dart';
import 'base_layout.dart'; // Asegúrate de importar tu layout base

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 0, // Para que se resalte el ícono de inicio en la barra
      body: ListView(
        children: [
          ListTile(
            title: const Text('Gestion de Productos'),
            leading: const Icon(Icons.inventory),
            onTap: () {
              print("Has pulsado el botón de producto");
              Navigator.pushNamed(context, '/products');
            },
          ),
          ListTile(
            title: const Text('Gestion de Clientes'),
            leading: const Icon(Icons.person),
            onTap: () {
              print("Has pulsado el botón de clientes");
              Navigator.pushNamed(context, '/clients');
            },
          ),
          ListTile(
            title: const Text('Gestion de Vendedores'),
            leading: const Icon(Icons.people),
            onTap: () {
              print("Has pulsado el botón de vendedores");
              Navigator.pushNamed(context, '/sellers');
            },
          ),
          ListTile(
            title: const Text('Gestion de Pedidos'),
            leading: const Icon(Icons.receipt_long),
            onTap: () {
              print("Has pulsado el botón de pedidos");
              Navigator.pushNamed(context, '/pedidos');
            },
          ),
        ],
      ),
    );
  }
}
