import 'package:flutter/material.dart';

class Pendientes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pendientes")),
      body: Center(
        child: Column(
          children: [
            Text("Listado de Pendientes"),
            SizedBox(height: 80),
            Row(
              children: [
                SizedBox(width: 100),
                Text("Ana Pérez"),
                SizedBox(width: 30),
                Text("televisor marca sony"),
                SizedBox(width: 30),
                Icon(Icons.edit, color: const Color.fromARGB(255, 14, 47, 50)),
                SizedBox(width: 30),
                Icon(
                  Icons.delete,
                  color: const Color.fromARGB(255, 223, 25, 25),
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                SizedBox(width: 100),
                Text("Luis Gómez"),
                SizedBox(width: 30),
                Text("Celular  IPhone 16"),
                SizedBox(width: 30),
                Icon(Icons.edit, color: const Color.fromARGB(255, 14, 47, 50)),
                SizedBox(width: 30),
                Icon(
                  Icons.delete,
                  color: const Color.fromARGB(255, 223, 25, 25),
                ),
                SizedBox(width: 30),
              ],
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
        shape: CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 89, 192, 226),
        child: Icon(Icons.add),
      ),
    );
  }
}
