import 'package:flutter/material.dart';

class MenuCliente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Marketplace")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Fila superior con botones
            Row(
              children: [
                Expanded(child: Text("")),
                TextButton.icon(
                  onPressed: () {
                    //Navigator.pushNamed(context, '/AddCliente');
                    print("has precionado el boton de pedido:");
                  },
                  icon: Icon(Icons.car_repair_sharp),
                  label: Text("pedido"),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 167, 170, 174),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigator.pushNamed(context, '/AddCliente');
                    print("Ha presionado el botón de carrito");
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: Text("Carrito"),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 228, 255, 73),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Image.network(
                  'data:image/jpeg;base64,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',
                  fit: BoxFit.cover,
                  height: 100,
                ),

                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "stock: 15                                                       precio:20",
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  child: Text(
                    "anadir carrito",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Image.network(
                  'data:image/jpeg;base64,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',
                  fit: BoxFit.cover,
                  height: 100,
                ),

                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "stock: 15                                                       precio:20",
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  child: Text(
                    "anadir carrito",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Image.network(
                  'data:image/jpeg;base64,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',
                  fit: BoxFit.cover,
                  height: 100,
                ),

                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "stock: 15                                                       precio:20",
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  child: Text(
                    "anadir acrriro",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
