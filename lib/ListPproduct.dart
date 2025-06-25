import 'package:flutter/material.dart';

class ListProduct extends StatefulWidget {
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  // Lista simulada de productos
  List<Map<String, dynamic>> productos = [
    {
      'id_producto': 1,
      'nombre': 'Arroz Integral',
      'descripcion': 'Bolsa de 1kg',
      'precio': 2.5,
      'stock': 50,
      'imagen': 'icono',
      'fk_id_vendedor': 101,
      'fk_id_categoria': 1,
      
    },
    {
      'id_producto': 2,
      'nombre': 'Manzana Roja',
      'descripcion': 'Caja con 10 unidades',
      'precio': 4.99,
      'stock': 30,
      'imagen': 'icono',
      'fk_id_vendedor': 102,
      'fk_id_categoria': 2,
    },
    {
      'id_producto': 3,
      'nombre': 'Leche Entera',
      'descripcion': 'Tetra Pak 1L',
      'precio': 1.25,
      'stock': 100,
      'imagen': 'icono',
      'fk_id_vendedor': 103,
      'fk_id_categoria': 4,
    },
  ];

  void _loadProducts() {
    print("Productos recargados...");
    setState(() {});
  }

  void _navegarACrearProducto() {
    Navigator.pushNamed(context, '/CrearProduct').then((_) {
      _loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Productos"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: _navegarACrearProducto,
          ),
        ],
      ),
      body: productos.isEmpty
          ? Center(child: Text("No hay productos disponibles."))
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: ListTile(
                    leading: Icon(Icons.shopping_bag),
                    title: Text(producto['nombre']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID: ${producto['id_producto']}"),
                        Text("Descripción: ${producto['descripcion']}"),
                        Text("Precio: \$${producto['precio']}"),
                        Text("Stock: ${producto['stock']} unidades"),
                        Text("ID Vendedor: ${producto['fk_id_vendedor']}"),
                        Text("ID Categoría: ${producto['fk_id_categoria']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarACrearProducto,
        shape: CircleBorder(),
        backgroundColor: Color.fromARGB(255, 96, 154, 170),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
