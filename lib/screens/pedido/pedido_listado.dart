import 'package:flutter/material.dart';

import '../base_layout.dart';

class PedidoListadoScreen extends StatelessWidget {
  const PedidoListadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 2, // selecciona el ícono de "lista" en la barra inferior
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Listado de Pedidos'),
        ),
        body: ListView(
          children: const [
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('Pedido #001'),
              subtitle: Text('Cliente: Juan - Estado: pendiente'),
            ),
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('Pedido #002'),
              subtitle: Text('Cliente: Ana - Estado: entregado'),
            ),
          ],
        ),
      ),
    );
  }
}
