import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("marketplace")),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 200),
              Text("INICIO DE SESSION"),
              SizedBox(height: 10),
              Row(children: [Text("usuario:")]),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              Row(children: [Text("Contraseña:")]),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/menu_cliente');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 160, 9),
                ),
                child: Text(
                  "Iniciar sesion cliente",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/menu');
                  print("a presionado el botonde inicio de sesion");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 160, 9),
                ),
                child: Text(
                  "iniciar sesion de admin",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
