import 'package:flutter/material.dart';

class CrearProduct extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController imagenController = TextEditingController();
  final TextEditingController vendedorController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Producto")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'ID del producto'),
                validator: (value) => value!.isEmpty ? 'Ingrese el ID' : null,
              ),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre del producto'),
                validator: (value) => value!.isEmpty ? 'Ingrese el nombre' : null,
              ),
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.isEmpty ? 'Ingrese la descripción' : null,
              ),
              TextFormField(
                controller: precioController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Precio'),
                validator: (value) => value!.isEmpty ? 'Ingrese el precio' : null,
              ),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stock'),
                validator: (value) => value!.isEmpty ? 'Ingrese el stock' : null,
              ),
              TextFormField(
                controller: imagenController,
                decoration: InputDecoration(labelText: 'Imagen (URL o nombre)'),
                validator: (value) => value!.isEmpty ? 'Ingrese la imagen' : null,
              ),
              TextFormField(
                controller: vendedorController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'ID del Vendedor'),
                validator: (value) => value!.isEmpty ? 'Ingrese el ID del vendedor' : null,
              ),
              TextFormField(
                controller: categoriaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'ID de la Categoría'),
                validator: (value) => value!.isEmpty ? 'Ingrese el ID de la categoría' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Guardar"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí iría la lógica para guardar el producto
                    print("Producto guardado:");
                    print("ID: ${idController.text}");
                    print("Nombre: ${nombreController.text}");
                    print("Descripción: ${descripcionController.text}");
                    print("Precio: ${precioController.text}");
                    print("Stock: ${stockController.text}");
                    print("Imagen: ${imagenController.text}");
                    print("ID Vendedor: ${vendedorController.text}");
                    print("ID Categoría: ${categoriaController.text}");

                    Navigator.pop(context); // Regresar a la lista
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
