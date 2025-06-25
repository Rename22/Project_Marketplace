import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu")),
      body: Center(
        child: Column(
          children: [
            Text("Menu"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list_category');
              },
              child: Row(
                children: [
                  Icon(Icons.category),
                  SizedBox(width: 25),
                  Text("Categorias"),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/listProduct');
              },
              child: Row(
                children: [
                  Icon(Icons.local_grocery_store),
                  SizedBox(width: 25),
                  Text("Producto"),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pedidos');
              },
              child: Row(
                children: [
                  Icon(Icons.person_add_rounded),
                  SizedBox(width: 25),
                  Text("Pedidos"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
