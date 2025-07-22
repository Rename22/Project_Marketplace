import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../entities/usuario_entity.dart';
import '../../repositories/usuario_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 97, 117, 150),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Nombre de la tienda
            const Text(
              'Tienda del Barrio', // Aquí coloca el nombre de tu tienda
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/tienda1.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            
            
            const SizedBox(height: 20),

            // Formulario de login
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Campo de usuario
                  TextFormField(
                    controller: _usuarioController,
                    validator: (value) {
                      return value == null || value.isEmpty
                          ? 'El campo Usuario es obligatorio'
                          : null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Campo de contraseña
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      return value == null || value.isEmpty
                          ? 'La contraseña es obligatoria'
                          : null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Mensaje de error
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  // Botón de iniciar sesión
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: const Color.fromARGB(255, 241, 155, 155),
                    ),
                    child: const Text("Iniciar sesión", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Enlace para registrarse
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("¿No tienes cuenta? Regístrate aquí"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (formKey.currentState!.validate()) {
      String usuario = _usuarioController.text;
      String password = _passwordController.text;

      Usuario? usuarioEncontrado = await UsuarioRepository.getByCredentials(usuario, password);

      if (usuarioEncontrado != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userRole', usuarioEncontrado.rol);
        await prefs.setInt('userId', usuarioEncontrado.id!);

        setState(() {
          _errorMessage = null;
        });

        if (usuarioEncontrado.rol == 'cliente') {
          Navigator.pushReplacementNamed(context, '/listado_productos_cliente');
        } else if (usuarioEncontrado.rol == 'vendedor') {
          Navigator.pushReplacementNamed(context, '/listado_productos_vendedor');
        } else if (usuarioEncontrado.rol == 'admin') {
          Navigator.pushReplacementNamed(context, '/listado_productos_vendedor');
        }
      } else {
        setState(() {
          _errorMessage = "Usuario o contraseña incorrectos.";
        });
      }
    }
  }
}
