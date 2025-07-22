import 'package:flutter/material.dart';
import '../../entities/usuario_entity.dart';
import '../../repositories/usuario_repository.dart';

class RegisterVendedorFormScreen extends StatefulWidget {
  final Usuario? vendedorExistente;

  const RegisterVendedorFormScreen({super.key, this.vendedorExistente});

  @override
  _RegisterVendedorFormScreenState createState() =>
      _RegisterVendedorFormScreenState();
}

class _RegisterVendedorFormScreenState extends State<RegisterVendedorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Si estamos editando, prellenamos los campos
    if (widget.vendedorExistente != null) {
      final v = widget.vendedorExistente!;
      _usuarioController.text = v.usuario;
      _nombreController.text = v.nombre;
      _emailController.text = v.email;
      _telefonoController.text = v.telefono ?? '';
      _passwordController.text = v.password;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 97, 117, 150),
        title: Text(widget.vendedorExistente == null 
            ? "Registrar Vendedor" 
            : "Editar Vendedor",style: const TextStyle(color: Colors.white),),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usuarioController,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'El campo Usuario es obligatorio' : null,
                        decoration: const InputDecoration(
                          labelText: 'Usuario',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'La contraseña es obligatoria' : null,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nombreController,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'El campo Nombre es obligatorio' : null,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'El campo Correo es obligatorio' : null,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _telefonoController,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'El campo Teléfono es obligatorio' : null,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _guardarVendedor,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: const Color.fromARGB(255, 255, 184, 184),
                        ),
                        child: Text(widget.vendedorExistente == null 
                            ? "Registrar Vendedor" 
                            : "Actualizar Vendedor",style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _guardarVendedor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final vendedor = Usuario(
          id: widget.vendedorExistente?.id,
          usuario: _usuarioController.text,
          password: _passwordController.text,
          nombre: _nombreController.text,
          email: _emailController.text,
          telefono: _telefonoController.text,
          rol: 'vendedor',
        );

        if (widget.vendedorExistente == null) {
          await UsuarioRepository.insert(vendedor);
        } else {
          await UsuarioRepository.update(vendedor);
        }

        Navigator.pop(context);
      } catch (e) {
        setState(() => _errorMessage = "Error: $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}