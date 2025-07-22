import 'package:flutter/material.dart';
import '../../entities/usuario_entity.dart';
import '../../repositories/usuario_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro"), backgroundColor: const Color.fromARGB(255, 97, 117, 150),),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usuarioController,
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'El campo Usuario es obligatorio'
                      : null;
                },
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  prefixIcon: Icon(Icons.person),
                  prefixIconColor: Color.fromARGB(255, 97, 117, 150),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'La contraseña es obligatoria'
                      : null;
                },
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  prefixIconColor: Color.fromARGB(255, 97, 117, 150),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nombreController,
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'El campo Nombre es obligatorio'
                      : null;
                },
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person_outline),
                  prefixIconColor: Color.fromARGB(255, 97, 117, 150),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'El campo Correo es obligatorio'
                      : null;
                },
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                  prefixIconColor: Color.fromARGB(255, 97, 117, 150),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _telefonoController,
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'El campo Teléfono es obligatorio'
                      : null;
                },
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                  prefixIconColor: Color.fromARGB(255, 97, 117, 150),
                  border: OutlineInputBorder(),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 184, 184),
                ),
                child: const Text("Registrarse", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (formKey.currentState!.validate()) {
      final newUsuario = Usuario(
        usuario: _usuarioController.text,
        password: _passwordController.text,
        nombre: _nombreController.text,
        email: _emailController.text,
        telefono: _telefonoController.text,
        rol: 'cliente',
      );

      try {
        await UsuarioRepository.insert(newUsuario);
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _errorMessage = "Error al registrar usuario: $e";
        });
      }
    }
  }
}