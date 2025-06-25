import 'package:flutter/material.dart';

class CrearCategoria extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController idCategoriaController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Categoría")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: idCategoriaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'ID de la Categoría'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el ID' : null,
              ),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre de la Categoría'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el nombre' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Guardar"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí iría la lógica para guardar la categoría
                    print("Categoría guardada:");
                    print("ID: ${idCategoriaController.text}");
                    print("Nombre: ${nombreController.text}");

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
