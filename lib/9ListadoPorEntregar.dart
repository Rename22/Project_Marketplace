import 'package:flutter/material.dart';

class ListadoPorEntregar extends StatelessWidget {
  // Lista simulada de productos por entregar
  final List<Map<String, dynamic>> productos = [
    {'nombre': 'Arroz', 'estado': 'Pendiente', 'cantidad': 2, 'precio': 10.24},
    {
      'nombre': 'Manzanas',
      'estado': 'Entregado',
      'cantidad': 12,
      'precio': 8.13,
    },
    {
      'nombre': 'Limones',
      'estado': 'Pendiente',
      'cantidad': 1,
      'precio': 10.89,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pedidos por Entregar")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: productos.length,
          itemBuilder: (context, index) {
            final product = productos[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(product['nombre']!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Cantidad: ${product['cantidad']}"),
                    Text("Precio: \$${product['precio']}"),
                    Text("Estado: ${product['estado']}"),
                  ],
                ),
                trailing:
                    product['estado'] == 'Pendiente'
                        ? ElevatedButton(
                          onPressed: () {},
                          child: Text("Entregar"),
                        )
                        : null, // Si ya está entregado, no mostramos el botón
              ),
            );
          },
        ),
      ),
    );
  }
}
