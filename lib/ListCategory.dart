import 'package:flutter/material.dart';

class ListCategory extends StatefulWidget {
  @override
  _ListCategoryState createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory> {
  // Lista simulada de categorías
  List<Map<String, dynamic>> categorias = [
    {'id_categoria': 1, 'nombre': 'Alimentos'},
    {'id_categoria': 2, 'nombre': 'Frutas'},
    {'id_categoria': 3, 'nombre': 'Bebidas'},
    {'id_categoria': 4, 'nombre': 'Lácteos'},
  ];

  void _loadCategories() {
    print("Categorías recargadas...");
    setState(() {});
  }

  void _navegarACrearCategoria() {
    Navigator.pushNamed(context, '/CrearCate').then((_) {
      _loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Categorías"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: _navegarACrearCategoria,
          ),
        ],
      ),
      body: categorias.isEmpty
          ? Center(child: Text("No hay categorías disponibles."))
          : ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: ListTile(
                    leading: Icon(Icons.category),
                    title: Text(categoria['nombre']),
                    subtitle: Text("ID: ${categoria['id_categoria']}"),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarACrearCategoria,
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
